################################################################################
# @file         libFile.sh
# @brief        Source variables and functions to treat files on file system.
# @author:      Leandro D. Huff
# @copyright:   https://creativecommons.org/licenses/by/4.0/
# @sintaxe:     source libFile.sh
################################################################################

# Must be sourced not running
[[ "${BASH_SOURCE[0]}" == "${0}" ]] && { echo -e "\033[91merror\033[0m: $(basename $0) must be sourced not running." ; exit 1 ; }

declare     libFile=''

declare     reFS='(btrfs|ext2|ext3|ext4)'
declare     reCryptFS='(crypto_LUKS)'

function getIDNumber()
{
    local err=0 distro
    case "$1" in
    fedora|toolbx)               distro=0 ;;
    silverblue|kinoite)          distro=1 ;;
    debian|ubuntu|mint)          distro=2 ;;
    slackware)                   distro=3 ;;
    arch|manjaro)                distro=4 ;;
    SUSE|openSUSE|suse|opensuse) distro=5 ;;
    *) err=1 ;;
    esac
    echo -n $distro
    return $err
}

function _isNum() { if echo -n "${1}" | grep -aoP '^[-+]?(\d+\.?\d*|\d*\.\d+)$' > /dev/null 2>&1 ; then true ; else false ; fi ; }
function _isInt() { if echo -n "${1}" | grep -aoP '^[+-]?\d+$' > /dev/null 2>&1 ; then true ; else false ; fi ; }
function _isNot() { case "$1" in [nN] | [nN][oO] | [nN][oO][tT]) true ;; *) false ;; esac ; }
function _isYes() { case "$1" in [yY] | [yY][eE][sS])            true ;; *) false ;; esac ; }
function _isArg() { if [ -n "$1" ] ; then case $1 in -*) false ;; *) true ;; esac ; else false ; fi ; }

function getScriptName() { echo -n "$(basename "$0")" ; }
function getFileName()   { echo -n "$(basename "$1")" ; }
function getName()       { local file="$(basename "$1")" ; echo -n "${file%.*}" ; }
function getExt()        { local file="$(basename "$1")" ; echo -n "${file##*.}" ; }
function getPath()       { echo -n "${1%/*}" ; }
function isLink()        { if [ -L "$1" ] ; then true ; else false ; fi ; }
function isFile()        { if [ -f "$1" ] ; then true ; else false ; fi ; }
function isDir()         { if [ -d "$1" ] ; then true ; else false ; fi ; }
function isBlockDevice() { if [ -b "$1" ] ; then true ; else false ; fi ; }
function getTempDir()    { [ -d '/tmp' ] && echo -n '/tmp' || echo "$HOME/tmp" ; }

function followLink()
{
    local target=''
    local err=1
    if [ -L "$1" ]
    then
        target="$(readlink -e "$1")"
        err=$?
    fi
    echo -n "${target}"
    return $err
}

function linkTargetExist()
{
    local target
    target="$(readlink -e "$1")"
    if [ $? -eq 0 ] && [ -n "${target}" ] && [ -e "${target}" ]
    then
        true
    else
        false
    fi
}

function itExist()
{
    if [ -e "$1" ]
    then
        if [ -L "$1" ]
        then
            if [ -e "$(readlink -e "$1")" ]
            then
                true
            else
                false
            fi
        else
            true
        fi
    else
        false
    fi
}

function getMountDir()
{
    if   [ -d /media     ] ; then echo -n "/media/${USER}"
    elif [ -d /run/media ] ; then echo -n "/run/media/${USER}"
    else                          echo -n '/mnt'
    fi
}

function getMapperDir() { echo -n '/dev/mapper' ; }

function isLuksFS() { if sudo cryptsetup isLuks "${1}"; then true; else false; fi; }

function getFS()
{
    if [ -b "${1}" ]
    then
        echo -n $(lsblk -o FSTYPE "${1}" 2> /dev/null | grep -aoP "${reFS}")
    else
        echo -n $(df --output=fstype "${1}" 2> /dev/null | grep -aoP "${reFS}")
    fi
}

function getCryptFS()
{
    if [ -b "${1}" ]
    then
        echo -n $(lsblk -o FSTYPE "${1}" 2> /dev/null | grep -aoP "${reCryptFS}")
    else
        echo -n $(df --output=fstype "${1}" 2> /dev/null | grep -aoP "${reCryptFS}")
    fi
}

function isFsValid() { if echo -n "${1}" | grep -aoP "${reFS}" > /dev/null 2>&1; then true; else false; fi; }

function hasFS()
{
    local re="$([ -n "$2" ] && echo -n "${2}" || echo -n "${reFS}")"

    if [ -b "${1}" ]
    then
        if lsblk -f "${1}" 2> /dev/null | grep -aoP "${re}" > /dev/null 1> /dev/null
        then
            true
        else
            false
        fi
    else
        if df --output=fstype "${1}" 2> /dev/null | grep -aoP "${re}" > /dev/null 1> /dev/null
        then
            true
        else
            false
        fi
    fi
}

function tryRun()
{
    local res=''
    declare -i err=1
    declare -i try=1
    declare    enTryDebug=false
    declare    enPrintRes=false
    function tryDebug() { if $enTryDebug; then echo -e "\033[32m  debug\033[0m: $*"; fi; }
    while [ -n "$1" ]
    do
        case "$1" in
        -r|--retry) shift; try=$1 ;;
        -v|--verbose) enPrintRes=true ;;
        -g|--debug) enTryDebug=true ;;
        -*) res=''; err=1; break ;;
         *) while [ $try -gt 0 ] && [ $err -ne 0 ]
            do
                tryDebug "eval $* 2> /dev/null"
                res="$(eval "$*" 2> /dev/null)"
                err=$?
                let try--
            done
            break
            ;;
        esac
        shift
    done
    tryDebug "${res}"
    if $enPrintRes ; then echo "${res}" ; fi
    return $err
}

function _askToContinue()
{
    local ans=''
    read -r -s -N 1 -n 1 $([ ${1:-0} -gt 0 ] && echo -n "-t ${1}") -p "${2:-'Continue [y|Y]? '}" ans
    if _isYes "${ans}" ; then return 0 ; else return 1 ; fi
}

function installFromFile()
{
    function _usage()
    {
        printf "\
    Tweaks adjusts for user profile.
    Syntax:
    $(basename $0) [-h | --help]
    $(basename $0) [options]
    Options:
    -d | --distro <NAME>  Set distro ID Name.
    -y | --force          Assume yes for any question.
    -i | --input          Source file to run install from.
        --               Separate parameters to others.
    "
    }

    function _error()       { echo -e "\033[31merror\033[0m  : $*" >&2; }
    function hasCommentIn() { if echo -n "$1" | grep -aoP '^ *#' > /dev/null 2>&1; then true; else false; fi; }
    function _isConnected() { if ping '8.8.8.8' -q -t $1 -c $2   > /dev/null 2>&1; then true; else false; fi; }

    declare     distroNAME=''
    declare     sourceFILE=''
    declare     flagFORCE=false

    declare -i  iGROUP=0
    declare -i  iINSTALL=1
    declare -i  iCHECK=2
    declare -i  iUPDATE=3
    declare -i  iUPGRADE=4
    declare -i  iRPM=5
    declare -i  iDEB=6
    declare -i  iMAX_CMD=7

    declare -a  installTABLE=(\
'dnf group install -y' 'dnf install -y' 'dnf info' 'dnf upgdate' 'dnf upgrade' 'rpm -i' 'dpkg -i' \
'' 'rpm-ostree install -y' 'rpm-ostree status -b | grep -c -F' 'rpm-ostree update' 'rpm-ostree upgrade' 'rpm-ostree install -y' 'rpm-ostree install -y' \
'' 'apt-get install -y' 'apt-get show' 'apt-get update' 'apt-get upgrade' 'rmp -i' 'dpkg -i' \
'' '' '' '' '' '' '' \
'' '' '' '' '' '' '' \
'' '' '' '' '' '' '')

    local line tag err distroName count sourceFile cmdInstall cmdCheck cmdUpdate cmdUpgrade cmdRPM cmdDEB distroIndex id

    [ -f /etc/os-release ] && . /etc/os-release || return 1
    distroName="${VARIANT_ID:-$ID}"
    distroName="${distroNAME:-$distroName}"
    distroIndex="$(getIDNumber ${distroName})" || return 2
    id=$((distroIndex * iMAX_CMD))
    err=0
    count=0
    sourceFile="${sourceFILE:-$distroName.run}"
      cmdGroup="${installTABLE[$id+$iGROUP  ]}"
    cmdInstall="${installTABLE[$id+$iINSTALL]}"
      cmdCheck="${installTABLE[$id+$iCHECK  ]}"
     cmdUpdate="${installTABLE[$id+$iUPDATE ]}"
    cmdUpgrade="${installTABLE[$id+$iUPGRADE]}"
        cmdRPM="${installTABLE[$id+$iRPM    ]}"
        cmdDEB="${installTABLE[$id+$iDEB    ]}"

    # variables
    declare -a libLIST=(Log Regex Time)
    declare -a libLOADED=()
    declare    libDIR='~/dev/libShell'

    for file in "${libLIST[@]}"
    do
        source "${libDIR}/lib${file}.sh"
        if [ $? -eq 0 ]
        then
            libLOADED+=(${file})
        else
            _error "Load lib${file}.sh"
            return 3
        fi
    done

    logInit -d -f

    while [ -n "$1" ]
    do
        case "$1" in
            -h|--help) _usage ; return 0 ;;
            -y|--force) flagFORCE=true ;;
            -d|--distro) shift ; distroNAME="$1";;
            -i|--input) shift ; sourceFILE="$1" ;;
            --) break ;;
            -*) logSetup "$1" ;;
             *) logE "Invalid value ($1)." ; return 4 ;;
        esac
        shift
    done

    logD "Distro : ${distroName}"
    logD "Index  : ${distroIndex}"
    logD "ID     : ${id}"
    logD "File   : ${sourceFile}"
    logD "Group  : ${cmdGroup}"
    logD "Install: ${cmdInstall}"
    logD "Check  : ${cmdCheck}"
    logD "Update : ${cmdUpdate}"
    logD "Upgrade: ${cmdUpgrade}"
    logD "RPM    : ${cmdRPM}"
    logD "DEB    : ${cmdDEB}"

    while read -e line
    do
        count=$((count+1))
        # skip empty lines
        [ -n "${line}" ] || continue
        # skip commented lines
        if hasCommentIn "${line}" ; then continue ; fi
        # check line for tags
        case "${line}" in
        \[*COMMENT*\]) tag='nothing' ;;
        \[*UPDATE*\])  tag='update'  ;;
        \[*UPGRADE*\]) tag='upgrade' ;;
        \[*GROUP*\])   tag='group'   ;;
        \[*INSTALL*\]) tag='install' ;;
        \[*DOWNLOAD*\])tag='download';;
        \[*PACKAGE*\]) tag='package' ;;
        \[*RUN*\])     tag='run'     ;;
        \[*\])         tag="${line}" ;;
        *)
            # not a tag, run a command.
            case "${tag}" in
            nothing) # Do nothing and wait until next [ TAG ]
                ;;
            update)
                if _isConnected
                then
                    logD "sudo ${cmdUpdate}"
                    tryRun sudo "${cmdUpdate}"
                else
                    tag=nothing
                fi
                ;;
            upgrade)
                if _isConnected
                then
                    logD "sudo ${cmdUpgrade}"
                    tryRun sudo "${cmdUpgrade}"
                else
                    tag=nothing
                fi
                ;;
            group)
                [ -n "${cmdGroup}" ] || continue
                if _isConnected
                then
                    #logD "sudo ${cmdCheck} ${line}"
                    #tryRun sudo "${cmdCheck}" "${line}"
                    logD "sudo ${cmdGroup} ${line}"
                    tryRun sudo "${cmdGroup}" "${line}"
                    ret=$?
                    if [ $ret -ne 0 ]
                    then
                        _error "Install group package ( ${line} )"
                    fi
                else
                    tag=nothing
                fi
                ;;
            install)
                if _isConnected
                then
                    #logD "sudo ${cmdCheck} ${line}"
                    #tryRun sudo "${cmdCheck}" "${line}"
                    logD "sudo ${cmdInstall} ${line}"
                    tryRun sudo "${cmdInstall}" "${line}"
                    ret=$?
                    if [ $ret -ne 0 ]
                    then
                        _error "Install package ( ${line} )"
                    fi
                else
                    tag=nothing
                fi
                ;;
            download)
                if _isConnected
                then
                    local wgetFile="/tmp/$(basename ${line})"
                    if [ -f "${wgetFile}" ]
                    then
                        logD "WGET file ( ${wgetFile} ) already exist."
                    else
                        logD "eval wget ${line} -O ${wgetFile}"
                        $(tryRun wget "${line}" -O "${wgetFile}") || err=$?
                    fi
                else
                    tag=nothing
                fi
                ;;
            package)
                local packageFile="${line}"
                if [ -f "${packageFile}" ]
                then
                    case "${packageFile}" in
                    # DEB
                    *.deb)
                        logD "eval ${cmdDEB} ${packageFile}"
                        $(tryRun "${cmdDEB}" "${packageFile}") || err=$?
                        ;;
                    # RPM
                    *.rpm)
                        logD "eval ${cmdRPM} ${packageFile}"
                        $(tryRun "${cmdRPM}" "${packageFile}") || err=$?
                        ;;
                    # SH
                    *.sh)
                        logD "chmod u+x ${packageFile}"
                        chmod u+x "${packageFile}"
                        logD "eval ${packageFile}"
                        tryRun "${packageFile}"
                        ;;
                    # UNKNOWN
                    *)
                        _error "Unknown package ( ${packageFile} )"
                        ;;
                    esac
                fi
                ;;
            run)
                logD "eval ${line}"
                tryRun "${line}"
                err=$?
                if [ $err -ne 0 ] ; then
                    _error "Run command ( ${line} ) from file ( ${sourceFile} )"
                    break
                fi
                ;;
            *)  _error "Unknown tag ( ${tag} ) at line ( $count ) from file ( ${sourceFile} )"
                err=1
                break
                ;;
            esac
            ;;
        esac
    done < "${sourceFile}"

    local message="Install Softwares from file ( $sourceFile )"
    [ $err -eq 0 ] && logS "${message}" || _error "${message}"

    logR
    logStop
    for file in "${libLOADED[@]}"; do "lib${file}Exit" || _error "Call lib${file}Exit()"; done

    return $err
}

function cryptCreate()
{
    function _usage()
    {
        printf "\
Create or open and mount an encrypted Luks2 device.
Usage:
$(basename $0) -h|--help
$(basename $0) </path/drive> ['key filename']
$(basename $0) -i|--drive </path/drive> [-k|--key 'key filename'] [--fs <btrfs|ext3|ext4(default)>] [-y|--force]
Options:
-h|--help                   Show help information.
-i|--drive </path/drive>    Drive to encrypt|open|mount.
                                Ex.: /dev/sd[a-z]
                            Device's name as 'luks_drive'
   --fs <format>            File system to format.
                                btrfs
                                ext3
                                ext4 (default)
-k|--key <'key filename'>   Read the key for a new slot from a file.
-y|--force                  Force run each erase|encrypt|format command without ask to confirm.
-g|--debug                  Enable debug messages.

\033[93mATTENTION\033[0m: Parameter -y|--force will let \033[93m erase \033[0mall data stored in device and can not be rescued later.
"
    }

    function _error() { echo -e "\033[31merror\033[0m  : $*" >&2; }

    # variables
    declare -a libLIST=(Log Regex Time)
    declare -a libLOADED=()
    declare    libDIR='~/dev/libShell'

    for file in "${libLIST[@]}"
    do
        source "${libDIR}/lib${file}.sh"
        if [ $? -eq 0 ]
        then
            libLOADED+=(${file})
        else
            _error "Load lib${file}.sh"
            return 1
        fi
    done

    unset -v file

    logInit -d -f

    declare -a fsLIST=(btrfs ext3 ext4)
    declare keyfile=''
    declare drive=''
    declare device=''
    declare fsTYPE='ext4'
    declare force=false
    declare mapperDIR=$(getMapperDir)
    declare mountDIR=$(getMountDir)

    declare -a listCMD=(\
"if [ -b ${drive} ] && ! isLuksFS ${drive} || $force ; then sudo cryptsetup --type=luks2 --verify-passphrase luksFormat ${keyfile} ${drive} ; else echo -e \"\033[37m   info\033[0m: Drive ${drive} already encrypted.\" ; fi" \
"if ! [ -b ${mapperDIR}/${device} ] ; then sudo cryptsetup luksOpen ${keyfile} ${drive} ${device} ; else echo -e \"\033[37minfo\033[0m   : Device '${mapperDIR}/${device}' already opened.\" ; fi" \
"if ! hasFS ${mapperDIR}/${device} || $force ; then sudo mkfs.${fsTYPE} ${mapperDIR}/${device} ; else echo -e \"Device ${mapperDIR}/${device} already has a FS(`getFS ${mapperDIR}/${device}`).\" ; fi" \
"if ! [ -d ${mountDIR}/${device}/${USER}_success ] && ! hasFS ${mountDIR}/${device} ${fsTYPE} ; then sudo mount -m -i -n --onlyonce --make-private ${mapperDIR}/${device} ${mountDIR}/${device} ; else echo -e \"\033[31merror\033[0m  : Mount block device ${device} from ${mapperDIR}/${device} on ${mountDIR}/${device}\" ; fi" \
"if [ -d ${mountDIR}/${device} ] && hasFS ${mountDIR}/${device} ; then sudo chown -R $USER:$USER ${mountDIR}/${device} ; else false ; fi" \
"if ! [ -d ${mountDIR}/${device}/${USER}_success ] ; then mkdir ${mountDIR}/${device}/${USER}_success ; fi" \
"if [ -d ${mountDIR}/${device}/${USER}_success ] ; then echo '1' > ${mountDIR}/${device}/${USER}_success/ok ; else false ; fi")

    declare -a listERR=(\
"Create encrypted device ${drive}." \
"Open encrypted device ${drive} as ${device}" \
"Create fs ${fsTYPE} on device ${device}" \
"Mount ${device} from ${mapperDIR}/${device} into ${mountDIR}/${device}" \
"Change owner of ${mountDIR}/${device}" \
"Make directory ${mountDIR}/${device}/${USER}_success" \
"Access ${mountDIR}/${device}/${USER}_success not available.")

    declare -i listLEN=${#listCMD[@]}
    declare -i err=0
    declare    run=true

    while [ $err -eq 0 ] && $run
    do
        # parse command line parameters and arguments.
        while [ $# -gt 0 ] && [ -n "$1" ] && [ $err -eq 0 ] && $run
        do
            case "$1" in
            -h|--help)
                _usage
                run=false
                break
                ;;
            -i|--drive)
                shift
                if [ -b "$1" ] || [ -f "$1" ]
                then
                    drive="$1"
                    device="luks_$(basename "${1}")"
                else
                    logE "Invalid drive option ($1)."
                    err=1
                    break
                fi
                ;;
            --fs)
                shift
                if [[ "${fsLIST[@]}" =~ "$1" ]]
                then
                    fsTYPE="$1"
                else
                    logE "Invalid file system option ($1)."
                    err=2
                    break
                fi
                ;;
            -y|--force)
                logW "Force to erase, encrypt and format device data [y|Y]? "
                if askToContinue
                then
                    force=true
                fi
                ;;
            -k|--key)
                if isArg "${2}"
                then
                    shift
                    if [ -f "${1}" ]
                    then
                        keyfile="--key-file=${1}"
                    else
                        logE "Invalid key file ($1) or not found."
                        err=1
                        break
                    fi
                else
                    logE "Empty value for parameter -k|--key <keyfile>"
                    err=1
                    break
                fi
                ;;
            -*) logSetup "$1" ;;
             *)
                if [ -z "${drive}" ]
                then
                    if [ -b "$1" ] || [ -f "$1" ]
                    then
                        drive="$1"
                        device="luks_$(basename "${1}")"
                    else
                        logE "Invalid command line argument ($1)."
                        err=4
                        break
                    fi
                elif [ -z "$keyfile" ]
                then
                    if [ -f "$1" ]
                    then
                        keyfile="--key-file=${1}"
                    else
                        logE "Invalid filename for command line -k|--key $1"
                        err=5
                        break
                    fi
                else
                    logE "Invalid value [$1]."
                    err=6
                    break
                fi
                ;;
            esac
            shift
        done

        [ $err -eq 0 ] || break

        # check empty parameters from command line.
        if [ -z "${drive}" ] || [ -z "${device}" ]
        then
            logE "Empty drive parameter from command line."
            err=7
            break
        fi

        for ((i=0 ; i < listLEN; i++))
        do
            logD "${listCMD[$i]}"
            eval "${listCMD[$i]}"
            err=$?
            if [ $err -ne 0 ]
            then
                logE "${listERR[$i]}"
                break
            fi
        done

        # format and show a message for success or error
        msg="Encrypt drive '${drive}' as luks2"
        if [ $err -eq 0 ]; then logS "${msg}"; else logE "${msg}"; fi

        run=false
    done

    logR
    logStop
    for file in "${libLOADED[@]}"; do "lib${file}Exit" || _error "Call lib${file}Exit()"; done

    return $err
}

##
# @param    $1=attrib   >   new sha256sum file.
#                       >>  add to sha256sum file.
# @param    $2=hash     path/sha256sum file.
# @param    $3=target   path[/] source file path.
#                       path    calculate all files together.
#                       path/   calculate individual files.
# @param    $4=files    *.ext|file.ext  individual file or group (wildcard *.ext) of files.
function buildFindCmd()
{
    local err=0
    local cmd='Invalid parameter to buildFindCmd'
    local attrib="${1}"
    local hash="${2}"
    local target="${3}"
    local files="${4}"

    if [ -d "${target}" ]
    then
        if [ -n "${files}" ]
        then
            cmd="find ${target} -name ${files}"
        else
            cmd="find ${target} -type f"
        fi
        cmd+=" -not -path '.git' -exec sha256sum {} + $(if echo -n ${target} | grep -aoP '/$' > /dev/null 2>&1 ; then echo -n '>' ; else echo -n '|' ; fi) sha256sum ${attrib} ${hash}"
    else
        err=1
    fi

    echo -n "${cmd}"
    return $err
}

##
# @param    $1=hash     path/sha256sum file.
# @param    $2=target   path[/] source file path.
#                       path    calculate all files together.
#                       path/   calculate individual files.
# @param    $3=files    *.ext|file.ext  individual file or group (wildcard *.ext) of files.
function calcChecksum()
{
    local err=0
    local cmd="$(buildFindCmd '>' "$1" "$2" "$3")"
    [ $? -eq 0 ] || return $?
    eval "${cmd}" || err=$?
    return $err
}

##
# @param    $1=hash     path/sha256sum file.
# @param    $2=target   path[/] source file path.
#                       path    calculate all files together.
#                       path/   calculate individual files.
# @param    $3=files    *.ext|file.ext  individual file or group (wildcard *.ext) of files.
function addChecksum()
{
    local err=0
    local cmd="$(buildFindCmd '>>' "$1" "$2" "$3")"
    [ $? -eq 0 ] || return $?
    eval "${cmd}" || err=$?
    return $err
}

##
# @param    $1=hash     path/sha256sum file.
# @param    $2=target   path[/] source file path.
#                       path    verify all files together.
#                       path/   verify individual files.
function verifyChecksum()
{
    local err=0
    cmd=''
    local hash="$1"
    local target="$2"

    if [ -d "${target}" ]
    then
        if [ -f "${hash}" ]
        then
            if echo -n "${target}" | grep -aoP '/$' > /dev/null 2>&1
            then
                cmd="sha256sum --status -c ${hash}"
            else
                cmd="find ${target} -type f -not -path '.git' -exec sha256sum {} + | sha256sum --status -c ${hash}"
            fi
            eval "${cmd}" || err=$?
        else
            err=2
        fi
    else
        err=1
    fi

    return $err
}

function libFileExit()
{
    # unset variables
    unset -v libFile
    unset -v reFS
    unset -v reCryptFS
    # unset functions
    unset -f getIDNumber
    unset -f _isNum
    unset -f _isInt
    unset -f _isNot
    unset -f _isYes
    unset -f _isArg
    unset -f getScriptName
    unset -f getFileName
    unset -f getName
    unset -f getExt
    unset -f getPath
    unset -f isLink
    unset -f isFile
    unset -f isDir
    unset -f isBlockDevice
    unset -f getTempDir
    unset -f followLink
    unset -f linkTargetExist
    unset -f itExist
    unset -f getMountDir
    unset -f getMapperDir
    unset -f isLuksFS
    unset -f getFS
    unset -f getCryptFS
    unset -f isFsValid
    unset -f hasFS
    unset -f tryRun
    unset -f _askToContinue
    unset -f installFromFile
    unset -f cryptCreate
    unset -v libFileExit
    return 0
}

libFile='loaded'

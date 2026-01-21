################################################################################
# @file         libFile.sh
# @brief        Source variables and functions to treat files on file system.
# @author:      Leandro D. Huff
# @copyright:   https://creativecommons.org/licenses/by/4.0/
# @sintaxe:     source libFile.sh
################################################################################

# Must be sourced not running
[[ "${BASH_SOURCE[0]}" == "${0}" ]] && exit 1

declare     distroNAME=''
declare     sourceFILE=''
declare     flagFORCE=false
declare     flagDEBUG=false

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
'' '' '' '' '' '' ''\
)

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
    *) err=1 ; break ;;
    esac
    echo -n $distro
    return $err
}
function _debug() { if $flagDEBUG; then echo -e "\033[32m  debug\033[0m: $*"; fi; }
function _error() { echo -e "\033[31m  error\033[0m: $*" >&2; }
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
    if   [ -d /media     ] ; then echo -n "/media"
    elif [ -d /run/media ] ; then echo -n "/run/media"
    else                          echo -n "/mnt"
    fi
}

function tryRun()
{
    local res=''
    declare -i err=1
    declare -i try=1
    declare    _debug=false
    function tryDebug() { if $_debug; then echo -e "\033[32m  debug\033[0m: $*"; fi; }
    while [ -n "$1" ]
    do
        case "$1" in
        -r|--retry) shift; try=$1 ;;
        -g|--debug) _debug=true ;;
        -*) _error "Invalid parameter ($1)"; break ;;
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
    return $err
}

################################################################################

function ask()
{
    local ret ans=''
    read -r -s -N 1 -n 1 $([ $1 -gt 0 ] && echo -n "-t $1") -p "${2}" ans
    ret=$?
    echo -n "${ans}"
    return $ret
}

function libInstallAskToContinue()
{
    local ret answer err=1
    answer=$(ask $1 "$2")
    ret=$?
    echo
    if [ $ret -eq 0 ] && _isYes $answer ; then err=0 ; fi
    return $err
}

function libInstallHelp()
{
cat << EOT
Tweaks adjusts for user profile.
Syntax: ${WHITE}$(basename $0)${NC} [${CYAN}-h | --help${NC}]
        ${WHITE}$(basename $0)${NC} [${CYAN}options${NC}]
Options:
 -d | --distro <NAME>   Set distro ID Name.
 -y | --force           Assume yes for any question.
 -i | --input           Source file to run install from.
 --                     Separate parameters to others.
EOT
}

function libInstallSetup()
{
    while [ -n "$1" ]
    do
        case "$1" in
            -h|--help) printHelp ; return 0 ;;
            -y|--force) flagFORCE=true ;;
            -d|--distro) shift ; distroNAME="$1";;
            -i|--input) shift ; sourceFILE="$1" ;;
            -g|--debug) flagDEBUG=true ;;
            --) break ;;
            -*) _error "libInstall invalid option ($1)."; return 1 ;;
             *) _error "libInstall invalid value ($1)." ; return 2 ;;
        esac
        shift
    done
}

function installFromFile()
{
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

    _debug "Distro : ${distroName}"
    _debug "Index  : ${distroIndex}"
    _debug "ID     : ${id}"
    _debug "File   : ${sourceFile}"
    _debug "Group  : ${cmdGroup}"
    _debug "Install: ${cmdInstall}"
    _debug "Check  : ${cmdCheck}"
    _debug "Update : ${cmdUpdate}"
    _debug "Upgrade: ${cmdUpgrade}"
    _debug "RPM    : ${cmdRPM}"
    _debug "DEB    : ${cmdDEB}"

    function hasCommentIn() { if echo -n "$1" | grep -aoP '^ *#' > /dev/null 2>&1; then true; else false; fi; }
    function _isConnected() { if ping '8.8.8.8' -q -t $1 -c $2   > /dev/null 2>&1; then true; else false; fi; }

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
                    _debug "sudo ${cmdUpdate}"
                    tryRun sudo "${cmdUpdate}"
                else
                    tag=nothing
                fi
                ;;
            upgrade)
                if _isConnected
                then
                    _debug "sudo ${cmdUpgrade}"
                    tryRun sudo "${cmdUpgrade}"
                else
                    tag=nothing
                fi
                ;;
            group)
                [ -n "${cmdGroup}" ] || continue
                if _isConnected
                then
                    #_debug "sudo ${cmdCheck} ${line}"
                    #tryRun sudo "${cmdCheck}" "${line}"
                    _debug "sudo ${cmdGroup} ${line}"
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
                    #_debug "sudo ${cmdCheck} ${line}"
                    #tryRun sudo "${cmdCheck}" "${line}"
                    _debug "sudo ${cmdInstall} ${line}"
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
                        _debug "WGET file ( ${wgetFile} ) already exist."
                    else
                        _debug "eval wget ${line} -O ${wgetFile}"
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
                        _debug "eval ${cmdDEB} ${packageFile}"
                        $(tryRun "${cmdDEB}" "${packageFile}") || err=$?
                        ;;
                    # RPM
                    *.rpm)
                        _debug "eval ${cmdRPM} ${packageFile}"
                        $(tryRun "${cmdRPM}" "${packageFile}") || err=$?
                        ;;
                    # SH
                    *.sh)
                        _debug "chmod u+x ${packageFile}"
                        chmod u+x "${packageFile}"
                        _debug "eval ${packageFile}"
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
                _debug "eval ${line}"
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
    unset -v sourceFile
    unset -v tag
    unset -v line
    unset -v count

    return $err
}

################################################################################

function libFileExit()
{
    # unset variables
    unset -v distroNAME
    unset -v iGROUP
    unset -v iINSTALL
    unset -v iCHECK
    unset -v iUPDATE
    unset -v iUPGRADE
    unset -v iRPM
    unset -v iDEB
    unset -v iMAX_CMD
    # unset functions
    unset -f _isNum
    unset -f _isInt
    unset -f _isNot
    unset -f _isYes
    unset -f _isArg
    unset -f _error
    unset -f _debug
    unset -f wait
    unset -f libInstallAskToContinue
    unset -f libInstallExit
    unset -f libInstallSetup
    unset -f libInstallUsage
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
    unset -f tryRun
    unset -f libFileExit
    return 0
}

################################################################################
# @file         libFile.sh
# @brief        Source variables and functions to treat files on file system.
# @author:      Leandro D. Huff
# @copyright:   https://creativecommons.org/licenses/by/4.0/
# @sintaxe:     source libFile.sh
################################################################################

# Must be sourced not running
[[ "${BASH_SOURCE[0]}" == "${0}" ]] && { echo -e "\033[91mfailure\033[0m: $(basename $0) must be sourced not running." ; exit 1 ; }

declare     reFS='(btrfs|ext2|ext3|ext4)'
declare     reCryptFS='(crypto_LUKS)'

## @brief   Validate numbers as integer and float not exponential.
function _isNumber() { if echo -n "${1}" | grep -aoP '^[-+]?(\d+\.?\d*|\d*\.\d+)$' > /dev/null 2>&1 ; then true ; else false ; fi ; }

## @brief   Validate only integer numbers.
function _isInteger() { if echo -n "${1}" | grep -aoP '^[+-]?\d+$' > /dev/null 2>&1 ; then true ; else false ; fi ; }

## @brief   Validate negative answer.
function _isNot() { case "$1" in [nN] | [nN][oO] | [nN][oO][tT]) true ;; *) false ;; esac ; }

## @brief   Validate positive answer.
function _isYes() { case "$1" in [yY] | [yY][eE][sS]) true ;; *) false ;; esac ; }

## @brief   Check for argument parameters.
function _isArg()
{ 
    if [ -n "$1" ]
    then
        case $1 in
        -*) false ;;
         *) true  ;; 
        esac
    else
        false
    fi
}

## @brief   Ask user to continue.
function _askToContinue()
{
    local ans=''
    read -r -s -N 1 -n 1 -t ${1:-1} -p "${2:-'Continue [y|Y]? '}" ans
    if _isYes "${ans}" ; then return 0 ; else return 1 ; fi
}

## @brief   Get a distro ID number from ID name.
function getIDNumber()
{
    local err=0 distro
    case "$1" in
    fedora|rhel|toolbx)          distro=0 ;;
    silverblue|kinoite)          distro=1 ;;
    debian|ubuntu|mint)          distro=2 ;;
    arch|manjaro)                distro=3 ;;
    SUSE|openSUSE|suse|opensuse) distro=4 ;;
    slackware)                   distro=5 ;;
    *) err=1 ;;
    esac
    echo -n $distro
    return $err
}

## @brief   Get main script name.
function getScriptName() { echo -n "$(basename "$0")" ; }

## @brief   Get filename (name + extension).
function getFileName() { echo -n "$(basename "$1")" ; }

## @brief   Get file name only.
function getName() { local file="$(basename "$1")" ; echo -n "${file%.*}" ; }

## @brief   Get file extension only.
function getExt() { local file="$(basename "$1")" ; echo -n "${file##*.}" ; }

## @brief   Get path from filename.
function getPath() { echo -n "${1%/*}" ; }

## @brief   Strip punctuation caracters from filename.
function stripPunct() { echo -n "$(basename ${1})" | tr -d '[:punct:]' ; }

## @brief   Check if parameter is a link.
function isLink() { if [ -L "$1" ] ; then true ; else false ; fi ; }

## @brief   Check if parameter is a file.
function isFile() { if [ -f "$1" ] ; then true ; else false ; fi ; }

## @brief   Check if parameter is a directory.
function isDir() { if [ -d "$1" ] ; then true ; else false ; fi ; }

# @brief    Check if parameter is a block device.
function isBlockDevice() { if [ -b "$1" ] ; then true ; else false ; fi ; }

## @brief   Get temp directory.
function getTempDir() { [ -d '/tmp' ] && echo -n '/tmp' || echo "$HOME/tmp" ; }

## @brief   Check device for luks file system.
function isLuksFS() { if sudo cryptsetup isLuks "${1}"; then true; else false; fi; }

## @brief   Get mapper directory
function getMapperDir() { echo -n '/dev/mapper' ; }

## @brief   Follow link parameter and print the target.
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

## @brief   Check if link target is valid and exist.
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

## @brief   Check if parameter exist, follow link if needed.
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

## @brief   Get mount base directory.
function getMountDir()
{
    declare -a list=('/media' '/run/media' '/mnt')
    local target=''

    for dir in "${list[@]}"
    do
        if linkTargetExist ${dir}
        then
            target=$(followLink ${dir})
            if [ -d "${target}" ]
            then
                echo -n "${target}/$USER"
                return 0
            fi
        fi
    done
    return 1
}

## @brief   Get device file system.
function getFS()
{
    if [ -b "${1}" ]
    then
        echo -n $(lsblk -o FSTYPE "${1}" 2> /dev/null | grep -qaoP "${reFS}")
    else
        echo -n $(df --output=fstype "${1}" 2> /dev/null | grep -qaoP "${reFS}")
    fi
}

## @brief   Get device encrypted file system.
function getCryptFS()
{
    if [ -b "${1}" ]
    then
        echo -n $(lsblk -o FSTYPE "${1}" 2> /dev/null | grep -qaoP "${reCryptFS}")
    else
        echo -n $(df --output=fstype "${1}" 2> /dev/null | grep -qaoP "${reCryptFS}")
    fi
}

## @bruef   Check if device has a valid file system according list.
function isFsValid()
{ 
    if echo -n "${1}" | grep -qaoP "${reFS}" > /dev/null 2>&1
    then
        true
    else
        false
    fi
}

## @brief   Check if device has a file system on it.
function hasFS()
{
    local re="$([ -n "$2" ] && echo -n "${2}" || echo -n "${reFS}")"

    if [ -b "${1}" ]
    then
        if lsblk -f "${1}" 2> /dev/null | grep -qaoP "${re}" > /dev/null 1> /dev/null
        then
            true
        else
            false
        fi
    else
        if df --output=fstype "${1}" 2> /dev/null | grep -qaoP "${re}" > /dev/null 1> /dev/null
        then
            true
        else
            false
        fi
    fi
}

##
# @brief    Execute and external program for n times.
# @param    -r|--retry      Retry n times, default 1.
# @param    -v|--verbose    Print result at the end, default false.
# @param    -g|--debug      Print debug messages on terminal, default false.
# @param    $*              Program name and its extra parameters.
# @result   string          Program result, if verbose enabled.
# @return   0               Success
#           N               Error code from external program.
function tryRun()
{
    declare    res=''
    declare -i err=1
    declare -i retry=1
    declare    enableDebug=false
    declare    echoRes=false
    function tryDebug() { if $enableDebug; then echo -e "\033[92m  debug\033[0m: $*"; fi; }
    while [ -n "$1" ]
    do
        case "$1" in
        -r|--retry) shift; retry=$1 ;;
        -v|--verbose) echoRes=true ;;
        -g|--debug) enableDebug=true ;;
        -*) res=''; err=1; break ;;
         *) while [ $retry -gt 0 ] && [ $err -ne 0 ]
            do
                tryDebug "eval $* 2> /dev/null"
                res="$(eval "$*" 2> /dev/null)"
                err=$?
                ((retry--))
            done
            break
            ;;
        esac
        shift
    done
    tryDebug "${res}"
    if $echoRes ; then echo "${res}" ; fi
    return $err
}

##
# @brief    Find files into directory and wildcard to make a list of files to calculate sha256sum of them.
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
        cmd+=" -not -path '.git' -exec sha256sum {} + $(if echo -n ${target} | grep -qaoP '/$' > /dev/null 2>&1 ; then echo -n '>' ; else echo -n '|' ; fi) sha256sum ${attrib} ${hash}"
    else
        err=1
    fi

    echo -n "${cmd}"
    return $err
}

##
# @brief    Calculate a new checksum sha256sum from directory/files|wildcard
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
# @brief    Calculate and add a checksum sha256sum from directory/files|wildcard
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
# @brief    Verify checksum sha256sum from sha256file and directory/files|wildcard
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
            if echo -n "${target}" | grep -qaoP '/$' > /dev/null 2>&1
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

##
# @brief    Check for checksum sha256sum changes.
# @param    $1=hash     path/sha256sum file.
# @param    $2=source   path[/] source is a path.
#                       path    verify all files as *.*
#                       path/   verify individual files.
# @return   true        if checksum file (hash file) not found.
#                       if checksum is Ok.
#           false       if checksum is not Ok.
function haveChanges()
{
    local hash=${1}
    local source=${2}
    if [ -f ${hash} ]
    then
        if verifyChecksum ${hash} ${source}
        then
            false
        else
            true
        fi
    else
        true
    fi
}

## @brief   Exit from libFile, unload all variables and functions.
function libFileExit()
{
    # unset variables
    unset -v libFile
    unset -v reFS
    unset -v reCryptFS
    # unset functions
    unset -f getIDNumber
    unset -f _isNumber
    unset -f _isInteger
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
    unset -f calcChecksum
    unset -f addChecksum
    unset -f haveChanges
    unset -f libFileExit
    return 0
}

## @brief   Declare a variable to verify if libFile is loaded.
declare libFile='loaded'

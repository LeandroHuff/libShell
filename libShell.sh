################################################################################
#/D # libShell
#/D
#/D **Description**: Shell Script Library.
#/D        **File**: libShell.sh
#/D      **Author**: Leandro - leandrohuff@programmer.net
#/D        **Date**: 2025-09-10
#/D     **Version**: 2.2.3
#/D   **Copyright**: CC01 1.0 Universal
#/D
#/D Save formatted markdown lines from source code into destine file.
#/D Read source code line-by-line and save prefixed lines by "/D" to a file,
#/D these lines are previously formatted by markdown tags, send each line
#/D to a documentation file will automatically generate a auto document from
#/D source code. C/C++ source code lines start with '//D' tag and Shell Script
#/D lines start with '#/D' tags. Only lines started with apropriate tags are
#/D sent to respective documentation files.
################################################################################

################################################################################
#/D
#/D ## Constants

#/D
#/D *integer* **libSTARTIME** = *timeseconds*
declare -i libSTARTIME=$(( $(date +%s%N) / 1000000 ))
#/D *integer*[] **libVERSION** = *(2 2 3)*
declare -a -i libVERSION=(2 2 4)
#/D *integer*[] **libDATE** = *(2025 9 10)*
declare -a -i libDATE=(2025 9 18)
#/D *integer* **logQUIET** = *0*
declare -i    logQUIET=0
#/D *integer* **logDEFAULT** = *1*
declare -i    logDEFAULT=1
#/D *integer* **logVERBOSE** = *2*
declare -i    logVERBOSE=2
#/D *integer* **logFULL** = *3*
declare -i    logFULL=3
#/D *integer* **logTOSCREEN** = *16*
declare -i    logTOSCREEN=16
#/D *integer* **logTOFILE** = *32*
declare -i    logTOFILE=32
#/D *string*[] **typeRANDOM** = *(alpha digit alnum lowhex uphex mixhex random space date)*
declare -a    typeRANDOM=(alpha digit alnum lowhex uphex mixhex random space date)

################################################################################
#/D
#/D ## Color Codes

#/D
#/D *string* **NC** = *'\033[0m'*
declare NC='\033[0m'
#/D *string* **BLACK** = *'\033[30m'*
declare BLACK='\033[30m'
#/D *string* **RED** = *'\033[31m'*
declare RED='\033[31m'
#/D *string* **GREEN** = *'\033[32m'*
declare GREEN='\033[32m'
#/D *string* **YELLOW** = *'\033[33m'*
declare YELLOW='\033[33m'
#/D *string* **BLUE** = *'\033[34m'*
declare BLUE='\033[34m'
#/D *string* **MAGENTA** = *'\033[35m'*
declare MAGENTA='\033[35m'
#/D *strng* **CYAN** = *'\033[36m'*
declare CYAN='\033[36m'
#/D *string* **GRAY** = *'\033[37m'*
declare GRAY='\033[37m'
#/D *string* **DGRAY** = *'\033[90m'*
declare DGRAY='\033[90m'
#/D *string* **HRED** = *'\033[91m'*
declare HRED='\033[91m'
#/D *string* **HGREEN** = *'\033[92m'*
declare HGREEN='\033[92m'
#/D *string* **HYELLOW** = *'\033[93m'*
declare HYELLOW='\033[93m'
#/D *string* **HBLUE** = *'\033[94m'*
declare HBLUE='\033[94m'
#/D *string* **HMAGENTA** = *'\033[95m'*
declare HMAGENTA='\033[95m'
#/D *string* **HCYAN** = *'\033[96m'*
declare HCYAN='\033[96m'
#/D *string* **WHITE** = *'\033[97m'*
declare WHITE='\033[97m'

################################################################################
#/D
#/D ## Variables

#/D
#/D *boolean* **flagDEBUG** = *false*
declare flagDEBUG=false
#/D *boolean* **flagTRACE** = *false*
declare flagTRACE=false
#/D *integer* **logTARGET** = *logQUIET*
declare -i logTARGET=$logQUIET
#/D *integer* **logLEVEL** = *logQUIET*
declare -i logLEVEL=$logQUIET
#/D *string* **libTMP** = *''*
declare libTMP=''
#/D *string* **logFILE** = *''*
declare logFILE=''
#/D *integer* **libTIMEOUT** = *10*
declare libTIMEOUT=10

################################################################################
#/D
#/D ## Functions

################################################################################
#/D
#/D ### Shell

#/D
#/D #### kbHit()
#/D
#/D **Function**:
#/D *char* **kbHit**( *none* ) : *boolean*
#/D Check for keyboard pressed key.
#/D **Parameter**:
#/D *none*
#/D **Result**:
#/D *boolean*    **true**:  Keyboard key was pressed.
#/D *boolean*   **false**:  Keyboard key was not pressed.
#/D **Return**:
#/D *char*      'key'       Pressed Ansi keycode.
function kbHit()
{
    local
    if key=$(bin/kbhit)
    then
        echo -n ${key}
        true
    else
       false
    fi
}

#/D
#/D #### isYes()
#/D
#/D **Function**:
#/D *none* **isYes**( *string* ) : *boolean*
#/D Check for affirmative parameter.
#/D **Parameter**:
#/D *string*    Value to check.
#/D **Result**:
#/D *boolean*    **true**: Is an affirmative parameter value.
#/D *boolean*   **false**: Is not an affirmative parameter value.
#/D **Return**:
#/D *none*
function isYes() { case "$1" in [yY] | [yY][eE][sS]) true ;; *) false ;; esac ; }

#/D
#/D #### isNot()
#/D
#/D **Function**:
#/D *none* **isNot**( *string* ) : *boolean*
#/D Check for negative parameter.
#/D **Parameter**:
#/D *string*    Value to check.
#/D **Result**:
#/D *boolean*    **true**: Is an negative parameter value.
#/D *boolean*   **false**: Is not an negative parameter value.
#/D **Return**:
#/D *none*
function isNot() { case "$1" in [nN] | [nN][oO] | [nN][oO][tT]) true ;; *) false ;; esac ; }

#/D
#/D #### isEmpty()
#/D
#/D **Function**:
#/D *none* **isEmpty**( *string* ) : *boolean*
#/D Check empty parameter.
#/D **Parameter**:
#/D *string*    Value to check.
#/D **Result**:
#/D *boolean*    **true**: Is empty.
#/D *boolean*   **false**: Is not empty.
#/D **Return**:
#/D *none*
function isEmpty() { if [ -n "$1" ] ; then false ; else true ; fi ; }

#/D
#/D #### notEmpty()
#/D
#/D **Function**:
#/D *none* **notEmpty**( *string* ) : *boolean*
#/D Check not empty parameter.
#/D **Parameter**:
#/D *string*    Value to check.
#/D **Result**:
#/D *boolean*    **true**: Is not empty.
#/D *boolean*   **false**: Is empty.
#/D **Return**:
#/D *none*
function notEmpty() { if [ -n "$1" ] ; then true ; else false ; fi ; }

#/D
#/D #### isParameter()
#/D
#/D **Function**:
#/D *none* **isParameter**( *string* ) : *boolean*
#/D Check for a valid command line parameter tag.
#/D **Parameter**:
#/D *string*    Parameter to check.
#/D **Result**:
#/D *boolean*    **true**: Is a valid parameter tag.
#/D *boolean*   **false**: Is not a valid parameter tag.
#/D **Return**:
#/D *none*
function isParameter()
{
    if [ -z "$1" ]
    then
        false
    else
        case "$1" in
        --*) true ;;
        -*) true ;;
        *) false ;;
        esac
    fi
}

#/D
#/D #### isArgValue()
#/D
#/D **Function**:
#/D *none* **isArgValue**( *string* ) : *boolean*
#/D Check for a valid command line parameter argument|value.
#/D **Parameter**:
#/D *string*    Parameter to check.
#/D **Result**:
#/D *boolean*    **true**: Is a valid arg value.
#/D *boolean*   **false**: Is not a valid arg value.
#/D **Return**:
#/D *none*
function isArgValue()
{
    if [ -z "$1" ]
    then
        false
    else
        case "$1" in
        --*) false ;;
        -*) false ;;
        *) true ;;
        esac
    fi
}

#/D
#/D #### getScriptName()
#/D
#/D **Function**:
#/D *none* **getScriptName**( *none* ) : *string*
#/D Get shell script filename.
#/D **Parameter**:
#/D *none*
#/D **Result**:
#/D *string*    Shell script filename.
#/D **Return**:
#/D *none*
function getScriptName() { echo -n "$(basename $0)" ; }

#/D
#/D #### getFileName()
#/D
#/D **Function**:
#/D *integer* **getFileName**( *string* ) : *string*
#/D Filter filename from parameter string and return only the filename.
#/D **Parameter**:
#/D *string*    Path and filename.
#/D **Result**:
#/D *string*    Only filename.
#/D **Return**:
#/D *integer*   **0**   : Success
#/D *integer*   **1..N**: Failure
function getFileName()
{
    [ -n "$1" ] || return 1
    if [ -f "$1" ]
    then
        echo -n $(basename "$1")
    else
        echo -n ''
        return 1
    fi
}

#/D
#/D #### getName()
#/D
#/D **Function**:
#/D *integer* **getName**( *string* ) : *string*
#/D Filter name from filename parameter string and return only the name.
#/D **Parameter**:
#/D *string*    Filename
#/D **Result**:
#/D *string*    Only name from filenames.
#/D **Return**:
#/D *integer*   **0**: Success
#/D *integer*   **1**: Failure
function getName()
{
    if [ -n "$1" ]
    then
        local file=$(basename "$1")
        echo -n "${file%.*}"
    else
        echo -n ''
        return 1
    fi
}

#/D
#/D #### getExt()
#/D
#/D **Function**:
#/D *integer* **getExt**( *string* ) : *string*
#/D Filter extension from filename parameter string and return only the extension.
#/D **Parameter**:
#/D *string*    Extension
#/D **Result**:
#/D *string*    Only extension from filenames.
#/D **Return**:
#/D *integer*   **0**: Success
#/D *integer*   **1**: Failure
function getExt()
{
    if [ -n "$1" ]
    then
        local file=$(basename "$1")
        echo -n "${file##*.}"
    else
        echo -n ''
        return 1
    fi
}

#/D
#/D #### getPath()
#/D
#/D **Function**:
#/D *integer* **getPath**( *string* ) : *string*
#/D Filter path from filename parameter string and return only the path.
#/D **Parameter**:
#/D *string*    Path/Filename
#/D **Result**:
#/D *string*    Only path from filename.
#/D **Return**:
#/D *integer*   **0**: Success
#/D *integer*   **1**: Failure
function getPath()
{
    if [ -n "$1" ]
    then
        echo -n "${1%/*}"
    else
        echo -n ''
        return 1
    fi
}

#/D
#/D #### askToContinue()
#/D
#/D **Function**:
#/D *integer* **askToContinue**( *integer* , *string* ) : *string*
#/D Print a message and ask user to continue and get the answer.
#/D **Parameter**:
#/D *integer*   Timeout value, if empty, assume a default value.
#/D *string*    Message, if empty, assume a default message.
#/D **Result**:
#/D *string*    Print a message for question.
#/D **Return**:
#/D *integer*   **0**: Accepted
#/D *integer*   **1**: Rejected
#/D *integer*   **2**: Timeout
function askToContinue()
{
    local ret=2
    local timeout
    local ans
    local message
    if isInteger $1 || isFloat $1
    then
        timeout=$1
    else
        timeout=$libTIMEOUT
    fi
    if [ -n "$2" ]
    then
        message="${2}"
    else
        message="Continue? Wainting for "
    fi
    echo -e -n "$message ${timeout}s [${GRAY}y${NC}|${GRAY}N${NC}]: "
    if [ $(compareFloat "$timeout" 0.0) -lt 0 ]
    then
        return 0
    elif [ $(compareFloat "$timeout" 0.0) -gt 0 ]
    then
        read -n 1 -N 1 -t $timeout ans
    else
        read -n 1 -N 1 ans
    fi
    if isYes $ans ; then
        ret=0
    elif isNot $ans ; then
        ret=1
    fi
    echo
    return $ret
}

#/D
#/D #### wait()
#/D
#/D **Function**:
#/D *integer* **wait**( *integer* , *string* ) : *string*
#/D Print a message and wait user to continue.
#/D **Parameter**:
#/D *integer*   Timeout value, if empty, assume a default value.
#/D *string*    Message, if empty, assume a default message.
#/D **Result**:
#/D *string*    Print a message.
#/D **Return**:
#/D *integer*   **0**: No wait.
#/D *integer*   **2**: Timeout
function wait()
{
    local ans=''
    declare timeout=$([ -n "$1" ] && echo -n $1 || echo -n $libTIMEOUT)
    local message=$([ -n "$2" ] && echo -n "${2}" || echo -n "Do Wait for ")
    echo -e -n "${message} ${timeout}s [${GRAY}n${NC}|${GRAY}N${NC}]?: "
    if [ $(bin/cmpfloat "$time" 0.0) -gt 0 ]
    then
        read -n 1 -N 1 -t $timeout ans
    else
        read -n 1 -N 1 ans
    fi
    if isNot $ans
    then
        echo
        return 0
    fi
    echo
    return 2
}

#/D
#/D #### loadID()
#/D
#/D **Function**:
#/D *integer* **loadID**( *none* ) : *string*
#/D Source /etc/os-release file.
#/D **Parameter**:
#/D *none*
#/D **Result**:
#/D *none*
#/D **Return**:
#/D *integer*   **0**: Success
#/D *integer*   **1**: Failure, empty ID or file /etc/os-release not found.
function loadID()
{
    if [ -f /etc/os-release ]
    then
        source /etc/os-release
        if [ -z "$ID" ]
        then
            return 1
        fi
    else
        return 1
    fi
    return 0
}

#/D
#/D #### getID()
#/D
#/D **Function**:
#/D *integer* **getID**( *none* ) : *string*
#/D Get ID from os-release file.
#/D **Parameter**:
#/D *none*
#/D **Result**:
#/D *string*    System ID;
#/D **Return**:
#/D *integer*   **0**: Success
#/D *integer*   **1**: Failure, empty ID or file /etc/os-release not found.
function getID()
{
    if [ -n "$ID" ]
    then
        echo -n "$ID"
    elif [ -f /etc/os-release ]
    then
        source /etc/os-release
        if [ -n "$ID" ]
        then
            echo -n "$ID"
        else
            return 1
        fi
    else
        return 1
    fi
    return 0
}

#/D
#/D #### getDistroName()
#/D
#/D **Function**:
#/D *integer* **getDistroName**( *none* ) : *string*
#/D Get Linux distro name.
#/D **Parameter**:
#/D *none*
#/D **Result**:
#/D *string*    Distro name.
#/D **Return**:
#/D *integer*   **0**: Success
#/D *integer*   **1**: Failure, empty ID or empty Variant ID.
function getDistroName()
{
    if ! [ -n "$ID" ] ; then loadID || return 1 ; fi
    [ -n "$ID" ] || return 1
    case "$ID" in
    fedora) [ -n "$VARIANT_ID" ] && echo -n "$VARIANT_ID" || echo -n "$ID" ;;
    *) echo -n "$ID" ;;
    esac
    return 0
}

################################################################################
#/D
#/D ### File System

#/D
#/D #### isLink()
#/D
#/D **Function**:
#/D *none* **isLink**( *string* ) : *boolean*
#/D Check if parameter is a link to file or directory.
#/D **Parameter**:
#/D *string*    Link to file.
#/D **Result**:
#/D *boolean*    **true**: Is a link to file.
#/D *boolean*   **false**: Is not a link to file.
#/D **Return**:
#/D *none*
function isLink() { if [ -L "$1" ] ; then true ; else false ; fi ; }

#/D
#/D #### isFile()
#/D
#/D **Function**:
#/D *none* **isFile**( *string* ) : *boolean*
#/D Check if parameter is a regular file.
#/D **Parameter**:
#/D *string*    Path and|or Filename
#/D **Result**:
#/D *boolean*    **true**: Is a file.
#/D *boolean*   **false**: Is not a file.
#/D **Return**:
#/D *none*
function isFile() { if [ -f "$1" ] ; then true ; else false ; fi ; }

#/D
#/D #### isDir()
#/D
#/D **Function**:
#/D *none* **isDir**( *string* ) : *boolean*
#/D Check if parameter is a directory.
#/D **Parameter**:
#/D *string*    Path and|or Filename
#/D **Result**:
#/D *boolean*    **true**: Is a directory.
#/D *boolean*   **false**: Is not a directory.
#/D **Return**:
#/D *none*
function isDir() { if [ -d "$1" ] ; then true ; else false ; fi ; }

#/D
#/D #### isBlockDevice()
#/D
#/D **Function**:
#/D *none* **isBlockDevice**( *string* ) : *boolean*
#/D Check if parameter is a block device.
#/D **Parameter**:
#/D *string*    Path and|or block device.
#/D **Result**:
#/D *boolean*    **true**: Is a block device.
#/D *boolean*   **false**: Is not a block device.
#/D **Return**:
#/D *none*
function isBlockDevice() { if [ -b "$1" ] ; then true ; else false ; fi ; }

#/D
#/D #### followLink()
#/D
#/D **Function**:
#/D *integer* **followLink**( *string* ) : *string*
#/D Follow target from link.
#/D **Parameter**:
#/D *string*    Link to target.
#/D **Result**:
#/D *string*    Target name.
#/D **Return**:
#/D *integer*   **0**: Success
#/D *integer*   **1**: Failure
function followLink()
{
    local target=''
    local err=1
    if [ -L "$1" ]
    then
        target="$(readlink -e "$1")"
        err=$?
    fi
    echo -n "$target"
    return $err
}

#/D
#/D #### linkExist()
#/D
#/D **Function**:
#/D *none* **linkExist**( *string* ) : *boolean*
#/D Check if link referenced exist.
#/D **Parameter**:
#/D *string*    Link to target.
#/D **Result**:
#/D *boolean*    **true**: Exist
#/D *boolean*   **false**: Not Exist
#/D **Return**:
#/D *none*
function linkExist()
{
    local target="$(readlink -e "$1")"
    if [ $? -eq 0 ] && [ -n "$target" ] && [ -e "$target" ]
    then
        true
    else
        false
    fi
}

#/D
#/D #### itExist()
#/D
#/D **Function**:
#/D *none* **itExist**( *string* ) : *boolean*
#/D Check if file or directory or link reference exist.
#/D **Parameter**:
#/D *string*    Link to target.
#/D **Result**:
#/D *boolean*    **true**: Exist
#/D *boolean*   **false**: Not Exist
#/D **Return**:
#/D *none*
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

#/D
#/D #### getTempDir()
#/D
#/D **Function**:
#/D *none* **getTempDir**( *none* ) : *string*
#/D Get a valid and accessible temporary directory and return it.
#/D **Parameter**:
#/D *none*
#/D **Result**:
#/D *string*    Temporary directory.
#/D **Return**:
#/D *none*
function getTempDir() { [ -d '/tmp' ] && echo -n '/tmp' || echo "$HOME" ; }

#/D
#/D #### getMountDir()
#/D
#/D **Function**:
#/D *none* **getMountDir**( *none* ) : *string*
#/D Get mount directory.
#/D **Parameter**:
#/D *none*
#/D **Result**:
#/D *string*    Mount directory.
#/D **Return**:
#/D *none*
function getMountDir()
{
    if   [ -d /media     ] ; then echo -n "/media"
    elif [ -d /run/media ] ; then echo -n "/run/media"
    else                          echo -n "/mnt"
    fi
}

################################################################################
#/D
#/D ### Git

#/D
#/D #### gitBranchName()
#/D
#/D **Function**:
#/D *integer* **gitBranchName**( *string* ) : *string*
#/D Get current git branch name.
#/D **Parameter**:
#/D *string*    Repository name|dir.
#/D **Result**:
#/D *string*    Branch name.
#/D **Return**:
#/D *integer*   **0**: Success
#/D *integer*   **1**: Failure
function gitBranchName()
{
    local res=''
    local err=1
    local dir="$PWD"
    local back="$PWD"
    [ -z "$1" ] || dir="$1"
    if isGitRepository "${dir}"
    then
        cd "${dir}"
        res="$(git branch --show-current)"
        err=$?
    fi
    [ -z "$1" ] || cd "$back"
    echo -n "$res"
    return $err
}

#/D
#/D #### gitCountAdded()
#/D
#/D **Function**:
#/D *integer* **gitCountAdded**( *string* ) : *integer*
#/D Get git added files counter.
#/D **Parameter**:
#/D *string*    Repository name|dir.
#/D **Result**:
#/D *integer*   Added itens counter.
#/D **Return**:
#/D *integer*   **0**: Success
#/D *integer*   **1**: Failure
function gitCountAdded()
{
    local res=0
    local err=1
    local dir="$PWD"
    local back="$PWD"
    [ -z "$1" ] || dir="$1"
    if isGitRepository "${dir}"
    then
        cd "${dir}"
        res="$(git status --porcelain | grep -cF ??)"
        err=$?
    fi
    [ -z "$1" ] || cd "$back"
    echo -n "$res"
    return $err
}

#/D
#/D #### gitCountModified()
#/D
#/D **Function**:
#/D *integer* **gitCountModified**( *string* ) : *integer*
#/D Get git modified files counter.
#/D **Parameter**:
#/D *string*    Repository name|dir.
#/D **Result**:
#/D *integer*   Modified itens counter.
#/D **Return**:
#/D *integer*   **0**: Success
#/D *integer*   **1**: Failure
function gitCountModified()
{
    local res=0
    local err=1
    local dir="$PWD"
    local back="$PWD"
    [ -z "$1" ] || dir="$1"
    if isGitRepository "${dir}"
    then
        cd "${dir}"
        res="$(git status --porcelain | grep -cF M)"
        err=$?
    fi
    [ -z "$1" ] || cd "$back"
    echo -n "$res"
    return $err
}

#/D
#/D #### gitCountDeleted()
#/D
#/D **Function**:
#/D *integer* **gitCountDeleted**( *string* ) : *integer*
#/D Get git deleted files counter.
#/D **Parameter**:
#/D *string*    Repository name|dir.
#/D **Result**:
#/D *integer*   Deleted itens counter.
#/D **Return**:
#/D *integer*   **0**: Success
#/D *integer*   **1**: Failure
function gitCountDeleted()
{
    local res=0
    local err=1
    local dir="$PWD"
    local back="$PWD"
    [ -z "$1" ] || dir="$1"
    if isGitRepository "${dir}"
    then
        cd "${dir}"
        res="$(git status --porcelain | grep -cF D)"
        err=$?
    fi
    [ -z "$1" ] || cd "$back"
    echo -n "$res"
    return $err
}

#/D
#/D #### gitCountDeleted()
#/D
#/D **Function**:
#/D *none* **isGitRepository**( *string* ) : *boolean*
#/D Check is a git repository.
#/D **Parameter**:
#/D *string*    Repository name|dir.
#/D **Result**:
#/D *boolean*    **true**: Is a git repository.
#/D *boolean*   **false**: Is not a git repository.
#/D **Return**:
#/D *none*
function isGitRepository()
{
    local target="$1"
    if notEmpty "$target" ; then
        if isLink "$1" ; then
            target="$(followLink "$1")"
        fi
        if isFile "$target" ; then
            target="$(getPath "$1")"
        fi
    fi
    if notEmpty "$target" && itExist "$target/.git" ; then
        if $(git -C "$1" rev-parse --git-dir > /dev/null 2>&1)
        then
            true
        else
            false
        fi
    else
        false
    fi
}

#/D
#/D #### gitRepositoryName()
#/D
#/D **Function**:
#/D *inreger* **gitRepositoryName**( *string* ) : *string*
#/D Get git repository name.
#/D **Parameter**:
#/D *string*    Repository dir.
#/D **Result**:
#/D *boolean*    **true**: Is a git repository.
#/D *boolean*   **false**: Is not a git repository.
#/D **Return**:
#/D *none*
function gitRepositoryName()
{
    local res=''
    local err=1
    local dir="$PWD"
    local back="$PWD"
    [ -z "$1" ] || dir="$1"
    if isGitRepository "${dir}"
    then
        cd "${dir}" || logF "Change to dir ( ${dir} )"
        res="$(git rev-parse --show-toplevel)"
        res=$(basename "${res}")
        err=$?
    fi
    [ -z "$1" ] || { cd "${back}" || logF "Change to dir ( ${back} )" ; }
    echo -n "$res"
    return $err
}

#/D
#/D #### isGitChanged()
#/D
#/D **Function**:
#/D *none* **isGitChanged**( *string* ) : *boolean*
#/D Check repository git files changed.
#/D **Parameter**:
#/D *string*    Repository name|dir.
#/D **Result**:
#/D *boolean*    **true**: Git repository has changes.
#/D *boolean*   **false**: Git repository has not changes.
#/D **Return**:
#/D *none*
function isGitChanged()
{
    if [ $(gitCountAdded    "$1") -gt 0 ] || \
       [ $(gitCountModified "$1") -gt 0 ] || \
       [ $(gitCountDeleted  "$1") -gt 0 ]
    then
        true
    else
        false
    fi
}

#/D
#/D #### existBranch()
#/D
#/D **Function**:
#/D *none* **existBranch**( *string* ) : *boolean*
#/D Check if branch exist.
#/D **Parameter**:
#/D *string*    Branch name.
#/D **Result**:
#/D *boolean*    **true**: Branch exist.
#/D *boolean*   **false**: Branch not exist.
#/D **Return**:
#/D *none*
function existBranch()
{
    local res
    [ -n "$1" ] || { logF "Empty parameter for existBranch(\$1)" ; return 1 ; }
    res=$(git branch | grep -oF "$1" > /dev/null 2>&1)
    [ $? -eq 0 ] && true || false
}

#/D
#/D #### inBranch()
#/D
#/D **Function**:
#/D *none* **inBranch**( *string* ) : *boolean*
#/D Check if respository is current branch.
#/D **Parameter**:
#/D *string*    Branch name.
#/D **Result**:
#/D *boolean*    **true**: Branch is current.
#/D *boolean*   **false**: Branch is not current.
#/D **Return**:
#/D *none*
function inBranch()
{
    local res
    [ -n "$1" ] || { logF "Empty parameter for inBranch(\$1)" ; return 1 ; }
    res=$(git branch --show-current | grep -oF "$1" > /dev/null 2>&1)
    [ $? -eq 0 ] && true || false
}

#/D
#/D #### gitAdd()
#/D
#/D **Function**:
#/D *integer* **gitAdd**( *string* ) : *none*
#/D Git add files to repository.
#/D **Parameter**:
#/D *string*    Add files to repository.
#/D **Result**:
#/D *none*
#/D **Return**:
#/D *integer*   **0**: Success
#/D *integer*   **1**: Failure
function gitAdd()
{
    local res
    [ -n "$1" ] || { logF "Empty parameter for gitAdd(\$1)" ; return 1 ; }
    res=$(git add "$1" > /dev/null 2>&1)
    return $?
}

#/D
#/D #### gitCommitNotSigned()
#/D
#/D **Function**:
#/D *integer* **gitCommitNotSigned**( *string* ) : *none*
#/D Not signed commit repository with a message.
#/D **Parameter**:
#/D *string*    Add a message to commit.
#/D **Result**:
#/D *none*
#/D **Return**:
#/D *integer*   **0**: Success
#/D *integer*   **1**: Failure
function gitCommitNotSigned()
{
    local res
    [ -n "$1" ] || { logF "Empty parameter for gitNotSignCommit(\$1)" ; return 1 ; }
    res=$(git commit -m \""$1"\" > /dev/null 2>&1)
    return $?
}

#/D
#/D #### gitCommitSigned()
#/D
#/D **Function**:
#/D *integer* **gitCommitSigned**( *string* ) : *none*
#/D Signed commit repository with a message.
#/D **Parameter**:
#/D *string*    Add a message to commit.
#/D **Result**:
#/D *none*
#/D **Return**:
#/D *integer*   **0**: Success
#/D *integer*   **1**: Failure
function gitCommitSigned()
{
    local res
    [ -n "$1" ] || { logF "Empty parameter for gitSignCommit(\$1)" ; return 1 ; }
    res=$(git commit -s -m \""$1"\" > /dev/null 2>&1)
    return $?
}

#/D
#/D #### gitFetch()
#/D
#/D **Function**:
#/D *integer* **gitFetch**( *none* ) : *none*
#/D Git fetch current branch.
#/D **Parameter**:
#/D *none*
#/D **Result**:
#/D *none*
#/D **Return**:
#/D *integer*   **0**: Success
#/D *integer*   **1**: Failure
function gitFetch()
{
    local res
    res=$(git fetch origin HEAD > /dev/null 2>&1)
    return $?
}

#/D
#/D #### gitPull()
#/D
#/D **Function**:
#/D *integer* **gitPull**( *none* ) : *none*
#/D Git pull current branch.
#/D **Parameter**:
#/D *none*
#/D **Result**:
#/D *none*
#/D **Return**:
#/D *integer*   **0**: Success
#/D *integer*   **1**: Failure
function gitPull()
{
    local res
    res=$(git pull origin HEAD > /dev/null 2>&1)
    return $?
}

#/D
#/D #### gitPush()
#/D
#/D **Function**:
#/D *integer* **gitPush**( *none* ) : *none*
#/D Git push current branch.
#/D **Parameter**:
#/D *none*
#/D **Result**:
#/D *none*
#/D **Return**:
#/D *integer*   **0**: Success
#/D *integer*   **1**: Failure
function gitPush()
{
    local res
    res=$(git push origin HEAD > /dev/null 2>&1)
    return $?
}

#/D
#/D #### gitSetUpstream()
#/D
#/D **Function**:
#/D *integer* **gitSetUpstream**( *none* ) : *none*
#/D Set branch up stream for push commands.
#/D **Parameter**:
#/D *none*
#/D **Result**:
#/D *none*
#/D **Return**:
#/D *integer*   **0**: Success
#/D *integer*   **1**: Failure
function gitSetUpstream()
{
    local res
    res=$(git push --set-upstream origin > /dev/null 2>&1)
    return $?
}

#/D
#/D #### newBranch()
#/D
#/D **Function**:
#/D *integer* **newBranch**( *string* ) : *none*
#/D Createt new branch.
#/D **Parameter**:
#/D *string*    Branch name.
#/D **Result**:
#/D *none*
#/D **Return**:
#/D *integer*   **0**: Success
#/D *integer*   **1**: Failure
function newBranch()
{
    local res
    [ -n "$1" ] || { logF "Empty parameter for newBranch(\$1)" ; return 1 ; }
    res=$(git branch "$1" > /dev/null 2>&1)
    return $?
}

#/D
#/D #### gitSwitch()
#/D
#/D **Function**:
#/D *integer* **gitSwitch**( *string* ) : *none*
#/D Switch to branch name.
#/D **Parameter**:
#/D *string*    Branch name.
#/D **Result**:
#/D *none*
#/D **Return**:
#/D *integer*   **0**: Success
#/D *integer*   **1**: Failure
function gitSwitch()
{
    local res
    [ -n "$1" ] || { logF "Empty parameter for gitSwitch(\$1)" ; return 1 ; }
    res=$(git switch "$1" > /dev/null 2>&1)
    return $?
}

#/D
#/D #### createBranch()
#/D
#/D **Function**:
#/D *integer* **createBranch**( *string* ) : *none*
#/D Create a new git branch and switch to it.
#/D **Parameter**:
#/D *string*    Branch name.
#/D **Result**:
#/D *none*
#/D **Return**:
#/D *integer*   **0**: Success
#/D *integer*   **1**: Failure
function createBranch()
{
    local res
    [ -n "$1" ] || { logF "Empty parameter for createBranch(\$1)" ; return 1 ; }
    res=$(newBranch "$1")
    [ $? -eq 0 ] || { logF "newBranch($1)" ; return $? ; }
    res=$(gitSwitch "$1")
    [ $? -eq 0 ] || { logF "gitSwitch($1)" ; return $? ; }
    res=$(gitSetUpstream)
    [ $? -eq 0 ] || { logF "gitSetUpstream()" ; return $? ; }
    return $?
}

################################################################################
#/D
#/D ### Math

#/D
#/D #### compareFloat()
#/D
#/D **Function**:
#/D *integer* **compareFloat**( *double* , *double* ) : *integer*
#/D Compare float numbers and return -1, 0, 1
#/D **Parameter**:
#/D *double*    1st number
#/D *double*    2nd number
#/D **Result**:
#/D *integer*   **-1**  1st number is less than 2nd number
#/D *integer*    **0**  1st number is equal than 2nd number
#/D *integer*    **1**  1st number is greater than 2nd number
#/D **Return**:
#/D *integer*   **0**: Success
#/D *integer*   **1**: Failure
function compareFloat()
{
    local res
    local err=1
    if [ -n "$1" ] && [ -n "$2" ]
    then
        res=$(bin/cmpfloat "$1" "$2")
        err=$?
    fi
    echo -n "$res"
    return $err
}

#/D
#/D #### addFloat()
#/D
#/D **Function**:
#/D *integer* **addFloat**( *double* , *double* ) : *double*
#/D Add 2 float numbers.
#/D **Parameter**:
#/D *double*    1st number
#/D *double*    2nd number
#/D **Result**:
#/D *double*    1st number + 2nd number
#/D **Return**:
#/D *integer*   **0**: Success
#/D *integer*   **1**: Failure
function addFloat()
{
    local res
    local err=1
    if [ -n "$1" ] && [ -n "$2" ]
    then
        res=$(bin/addfloat "$1" "$2")
        err=$?
    fi
    echo -n "$res"
    return $err
}

#/D
#/D #### subFloat()
#/D
#/D **Function**:
#/D *integer* **subFloat**( *double* , *double* ) : *double*
#/D Subtract 2 floating point numbers.
#/D **Parameter**:
#/D *double*    1st number
#/D *double*    2nd number
#/D **Result**:
#/D *double*    1st number - 2nd number
#/D **Return**:
#/D *integer*   **0**: Success
#/D *integer*   **1**: Failure
function subFloat()
{
    local res
    local err=1
    if [ -n "$1" ] && [ -n "$2" ]
    then
        res=$(bin/subfloat "$1" "$2")
        err=$?
    fi
    echo -n "$res"
    return $err
}

#/D
#/D #### multiplyFloat()
#/D
#/D **Function**:
#/D *integer* **multiplyFloat**( *double* , *double* ) : *double*
#/D Multiply 2 float numbers.
#/D *double*    1st number
#/D *double*    2nd number
#/D **Result**:
#/D *double*    1st number * 2nd number
#/D **Return**:
#/D *integer* **0** Success
#/D *integer* **1** Failure
function multiplyFloat()
{
    local res
    local err=1
    if [ -n "$1" ] && [ -n "$2" ]
    then
        res=$(bin/multiplyfloat "$1" "$2")
        err=$?
    fi
    echo -n "$res"
    return $err
}

#/D
#/D #### divFloat()
#/D
#/D **Function**:
#/D *integer* **divFloat**( *double* , *double* ) : *double*
#/D Divide 2 float numbers.
#/D *double*    1st number
#/D *double*    2nd divisor
#/D **Result**:
#/D *double*    number / divisor
#/D **Return**:
#/D *integer*   **0**: Success
#/D *integer*   **1**: Failure, divisor is 0.
function divFloat()
{
    local res
    local err=1
    if [ -n "$1" ] && [ -n "$2" ]
    then
        res="$(bin/divfloat "$1" "$2")"
        err=$?
    fi
    echo -n "$res"
    return $err
}

#/D
#/D #### isFloatInRange()
#/D
#/D **Function**:
#/D *integer* **isFloatInRange**( *double* value , *double* min , *double* max ) : *boolean*
#/D Check is float number between 2 float min and max numbers value.
#/D **Parameter**:
#/D *double*    value   Number to check in range.
#/D *double*     min    Min value of range.
#/D *double*     max    Max value of range.
#/D **Result**:
#/D *boolean*    **true**: Number is in min and max range.
#/D *boolean*   **false**: Number is out of range min and max.
#/D **Return**:
#/D *integer*   **0**: Success
#/D *integer*   **1**: Failure
function isFloatInRange()
{
    local res=$(bin/isFloatInRange "$1" "$2" "$3")
    local err=$?
    echo -n "$res"
    return $err
}

################################################################################
#/D
#/D ### libShells

#/D
#/D #### getLibVersionStr()
#/D
#/D **Function**:
#/D *none* **getLibVersionStr**( *none* ) : *string*
#/D Get libShell version in string format.
#/D **Parameter**:
#/D *none*
#/D **Result**:
#/D *string*    libShell version in string format.
#/D **Return**:
#/D *none*
function getLibVersionStr() { genVersionStr ${libVERSION[@]} ; }

#/D
#/D #### getLibVersionNum()
#/D
#/D **Function**:
#/D *none* **getLibVersionNum**( *none* ) : *string*
#/D Get libShell version in number format.
#/D **Parameter**:
#/D *none*
#/D **Result**:
#/D *string*    libShell version in number format.
#/D **Return**:
#/D *none*
function getLibVersionNum() { echo -n $(genVersionNum ${libVERSION[@]}) ; }

#/D
#/D #### printLibVersion()
#/D
#/D **Function**:
#/D *none* **printLibVersion**( *none* ) : *string*
#/D Print formatted libShell string version.
#/D **Parameter**:
#/D *none*
#/D **Result**:
#/D *string*    libShell version in number format.
#/D **Return**:
#/D *none*
function printLibVersion() { echo -e "libShell Version: ${GRAY}$(getLibVersionStr)${NC}" ; }

#/D
#/D #### getLibDateVersionStr()
#/D
#/D **Function**:
#/D *none* **getLibDateVersionStr**( *none* ) : *string*
#/D Get libShell date number as string.
#/D **Parameter**:
#/D *none*
#/D **Result**:
#/D *string*    libShell date number as string.
#/D **Return**:
#/D *none*
function getLibDateVersionStr() { genDateVersionStr ${libDATE[@]} ; }

#/D
#/D #### getLibDateVersionNum()
#/D
#/D **Function**:
#/D *none* **getLibDateVersionNum**( *none* ) : *string*
#/D Get libShell date as a numer.
#/D **Parameter**:
#/D *none*
#/D **Result**:
#/D *string*    libShell libShell string date.
#/D **Return**:
#/D *none*
function getLibDateVersionNum() { echo -n $(genDateVersionNum ${libDATE[@]}) ; }

#/D
#/D #### printLibDate()
#/D
#/D **Function**:
#/D *none* **printLibDate**( *none* ) : *string*
#/D Print formatted libShell string date.
#/D **Parameter**:
#/D *none*
#/D **Result**:
#/D *string*    Formatted libShell string date.
#/D **Return**:
#/D *none*
function printLibDate() { echo -e "libShell Date ${GRAY}$(getLibDateVersionStr)${NC}" ; }

#/D
#/D #### libSetup()
#/D
#/D **Function**:
#/D *integer* **libSetup**( *string*[] ) : *none*
#/D Setup libShell.
#/D **Parameter**:
#/D *string*[]  Command line parameter list.
#/D **Result**:
#/D *none*
#/D **Return**:
#/D *integer*   **0**: Success
#/D *integer*   **1**: Failure
function libSetup()
{
    while [ -n "$1" ]
    do
        case "$1" in
        -h|--help)    printLibHelp         ; break ;;
        -V|--version) printLibVersion      ; break ;;
        -q|--quiet)   logLEVEL=$logQUIET   ;;
        -d|--default) logLEVEL=$logDEFAULT ;;
        -v|--verbose) logLEVEL=$logVERBOSE ;;
        -g|--debug)   flagDEBUG=true       ;;
        -t|--trace)   flagTRACE=true       ;;
        -l|--log)
            if isArgValue $2 ; then
                shift
                if isInteger $1 ; then
                    local target=$1
                    if [ $target -ge $logQUIET ] && [ $target -le $logFULL ] ; then
                        logTARGET=$((target * logTOSCREEN))
                    else
                        logF "Value for parameter -l|--log <0|1|2|3> is out of range."
                        return 1
                    fi
                else
                    logF "Value for parameter -l|--log <0|1|2|3> must be an integer."
                    return 1
                fi
            else
                logTARGET=$((logTOSCREEN + logTOFILE))
            fi
            logD "Log target set to ($logTARGET)"
            ;;
        -T|--timeout)
            if isArgValue "$2"
            then
                shift
                if isInteger $1
                then
                    if [ $1 -ge 0 ]
                    then
                        libTIMEOUT=$1
                        logD "Timeout set to ($libTIMEOUT)"
                    else
                        logF "Parameter value for -T|--timeout <N> must be greater or equal to 0 (zero)."
                        return 1
                    fi
                else
                    logF "Parameter value for -T|--timeout <N> must be an integer."
                    return 1
                fi
            else
                logF "Empty value for parameter -T|--timeout <N>"
                return 1
            fi
            ;;
        --) shift ; break ;;
        -*) logE "Unknown parameter $1" ; return 1 ;;
        *) logE "Unknown value $1"     ; return 1 ;;
        esac
        shift
    done
    return 0
}

#/D
#/D #### libInit()
#/D
#/D **Function**:
#/D *integer* **libInit**( *string*[] ) : *none*
#/D Initialize libShell.
#/D **Parameter**:
#/D *string*[]  Command line parameter list.
#/D **Result**:
#/D *none*
#/D **Return**:
#/D *integer*   **0**: Success
#/D *integer*   **1**: Failure
function libInit()
{
    local err=0
    libTMP="$(getTempDir)"
    logFILE="$(getLogFilename)"
    [ $# -eq 0 ] || { libSetup "$@" || return $? ; }
    return 0
}

#/D
#/D #### unsetLibVars()
#/D
#/D **Function**:
#/D *integer* **unsetLibVars**( *none* ) : *none*
#/D Unset global libShell variables.
#/D **Parameter**:
#/D *none*
#/D **Result**:
#/D *none*
#/D **Return**:
#/D *integer*   **0**: Success
function unsetLibVars()
{
    unset -v flagDEBUG
    unset -v flagTRACE
    unset -v logLEVEL
    unset -v lOGTARGET
    unset -v libTIMEOUT
    return 0
}

#/D
#/D #### libStop()
#/D
#/D **Function**:
#/D *integer* **libStop**( *none* ) : *none*
#/D Stop|End library execution.
#/D **Parameter**:
#/D *none*
#/D **Result**:
#/D *none*
#/D **Return**:
#/D *integer*   **0**: Success
function libStop()
{
    unsetLibVars
    return 0
}

#/D
#/D
#/D #### printLibHelp()
#/D
#/D **Function**:
#/D *integer* **printLibHelp**( *none* ) : *string*
#/D Print library help information.
#/D **Parameter**:
#/D *none*
#/D **Result**:
#/D *string*    Help message and syntax information.
#/D **Return**:
#/D *integer*   **0**: Success
function printLibHelp()
{
    cat << EOT
Shell Script Library
$(printLibVersion)
Source functions to support shell script programs.
Syntax: source $(getScriptName) [parameters]
Parameters:
-h|--help           Show this help information.
-V|--version        Print version number.
-q|--quiet          Disable all messages (default at startup).
-d|--default        Set log to default level.
-v|--verbose        Set log to verbose level.
-g|--debug          Enable debug messages.
-t|--trace          Enable trace messages.
-l|--log <0|1|2|3>  Set log target:
                    0=Disabled (default, at startup)
                    1=Screen only
                    2=File only
                    3=Both (default, for empty value).
-T|--timeout <N>    Set default timeout value >= 0.
EOT
    return 0
}

################################################################################
#/D
#/D ### Log

#/D
#/D #### functiongetLogFilename()
#/D
#/D **Function**:
#/D *none* **getLogFilename**( *none* ) : *string*
#/D Get log path and filename.
#/D **Parameter**:
#/D *none*
#/D **Result**:
#/D *string*    Temporary directory.
#/D **Return**:
#/D *none*
function getLogFilename() { echo -n "$(getTempDir)/$(getScriptName).log" ; }

#/D
#/D #### logBegin()
#/D
#/D **Function**:
#/D *integer* **logBegin**( *none* ) : *none*
#/D Begin|Start log to file.
#/D **Parameter**:
#/D *none*
#/D **Result**:
#/D *none*
#/D **Return**:
#/D *integer*   **0**: Success
function logBegin()
{
    if ! isLogToFileEnabled ; then return 0 ; fi
    touch "${logFILE}"
    if [ -f "${logFILE}" ]
    then
        echo "################################################################################" > "${logFILE}"
        echo "         Start Log to File on $(date +%Y-%m-%d) at $(date +%T.%N)"               >> "${logFILE}"
    else
        logE "Could not access ${logFILE}"
    fi
    return 0
}

#/D
#/D #### logEnd()
#/D
#/D **Function**:
#/D *integer* **logEnd**( *none* ) : *none*
#/D End|Stop log to file.
#/D **Parameter**:
#/D *none*
#/D **Result**:
#/D *none*
#/D **Return**:
#/D *integer*   **0**: Success
function logEnd()
{
    if ! isLogToFileEnabled ; then return 0 ; fi
    if [ -f "${logFILE}" ]
    then
        echo "         End Log to File on $(date +%Y-%m-%d) at $(date +%T.%N)"                  >> "${logFILE}"
        echo "################################################################################" >> "${logFILE}"
    else
        logE "Could not access ${logFILE}"
    fi
    return 0
}

#/D
#/D #### isLogQuiet()
#/D
#/D **Function**:
#/D *none* **isLogQuiet**( *none* ) : *boolean*
#/D Check is log quiet enabled.
#/D **Parameter**:
#/D *none*
#/D **Result**:
#/D *boolean*    **true**: Is log quiet enabled.
#/D *boolean*   **false**: Is log quiet disabled.
#/D **Return**:
#/D *none*
function isLogQuiet()
{
    if [ $logLEVEL -eq $logQUIET ]
    then
        true
    else
        false
    fi
}

#/D
#/D #### isLogDefault()
#/D
#/D **Function**:
#/D *none* **isLogDefault**( *none* ) : *boolean*
#/D Check is log default enabled.
#/D **Parameter**:
#/D *none*
#/D **Result**:
#/D *boolean*    **true**: Is log default enabled.
#/D *boolean*   **false**: Is log default disabled.
#/D **Return**:
#/D *none*
function isLogDefault()
{
    if [ $logLEVEL -eq $logDEFAULT ]
    then
        true
    else
        false
    fi
}

#/D
#/D #### isLogVerbose()
#/D
#/D **Function**:
#/D *none* **isLogDefaultVerbose**( *none* ) : *boolean*
#/D Check is log verbose enabled.
#/D **Parameter**:
#/D *none*
#/D **Result**:
#/D *boolean*    **true**: Is log verbose enabled.
#/D *boolean*   **false**: Is log verbose disabled.
#/D **Return**:
#/D *none*
function isLogVerbose()
{
    if [ $logLEVEL -eq $logVERBOSE ]
    then
        true
    else
        false
    fi
}

#/D
#/D #### isLogToScreenEnabled()
#/D
#/D **Function**:
#/D *none* **isLogToScreenEnabled**( *none* ) : *boolean*
#/D Check is log to screen enabled.
#/D **Parameter**:
#/D *none*
#/D **Result**:
#/D *boolean*    **true**: Is log to screen enabled.
#/D *boolean*   **false**: Is log to screen disabled.
#/D **Return**:
#/D *none*
function isLogToScreenEnabled()
{
    if [ $logTARGET -ge $logTOSCREEN ] && [ $logTARGET -lt $logTOFILE ]
    then
        true
    elif [ $logTARGET -ge $((logTOSCREEN + logTOFILE)) ]
    then
        true
    else
        false
    fi
}

#/D
#/D #### isLogToFileEnabled()
#/D
#/D **Function**:
#/D *none* **isLogToFileEnabled**( *none* ) : *boolean*
#/D Check is log to file enabled.
#/D **Parameter**:
#/D *none*
#/D **Result**:
#/D *boolean*    **true**: Is log to file enabled.
#/D *boolean*   **false**: Is log to file disabled.
#/D **Return**:
#/D *none*
function isLogToFileEnabled()
{
    if [ $logTARGET -ge $logTOFILE ]
    then
        true
    else
        false
    fi
}

#/D
#/D #### isLogEnabled()
#/D
#/D **Function**:
#/D *none* **isLogEnabled**( *none* ) : *boolean*
#/D Check is log enabled.
#/D **Parameter**:
#/D *none*
#/D **Result**:
#/D *boolean*    **true**: Is log enabled.
#/D *boolean*   **false**: Is log disabled.
#/D **Return**:
#/D *none*
function isLogEnabled()
{
    if [ $logTARGET -gt $logQUIET ] && [ $logLEVEL -gt $logQUIET ]
    then
        true
    else
        false
    fi
}

#/D
#/D #### Log Functions Table
#/D
#/D | Function | Description   | Level   |
#/D |:--------:|:-------------:|:-------:|
#/D | logU     | Unconditional | none    |
#/D | logIt    | Anything      | enabled |
#/D | logI     | Info          | normal  |
#/D | logR     | Runtime       | normal  |
#/D | logE     | Error         | normal  |
#/D | logF     | Failure       | normal  |
#/D | logS     | Success       | verbose |
#/D | logV     | Verbose Info  | verbose |
#/D | logW     | Warning       | verbose |
#/D | logD     | Debug         | debug   |
#/D | logT     | Trace         | trace   |
#/D

#/D
#/D #### logU()
#/D
#/D **Function**:
#/D *none* **logU**( *string* ) : *string*
#/D Log anything unconditional to screen and file.
#/D **Parameter**:
#/D *string*    Send unconditional and unformatted messages to screen.
#/D **Result**:
#/D *none*
#/D **Return**:
#/D *none*
function logU() { echo -e "$*" ; }

#/D
#/D #### logIt()
#/D
#/D **Function**:
#/D *none* **logIt**( *string* ) : *string*
#/D Log anything according to log flags.
#/D **Parameter**:
#/D *string*    Send unformatted messages to screen and|or file.
#/D **Result**:
#/D *none*
#/D **Return**:
#/D *none*
function logIt()
{
    if ! isLogEnabled ; then return ; fi
    if isLogToFileEnabled && isLogToScreenEnabled ; then
        echo -e "$*" | tee -a "${logFILE}"
    elif isLogToFileEnabled ; then
        echo -e "$*" >> "${logFILE}"
    elif isLogToScreenEnabled ; then
        echo -e "$*"
    fi
}

#/D
#/D #### logI()
#/D
#/D **Function**:
#/D *none* **logI**( *string* ) : *string*
#/D Log information messages.
#/D **Parameter**:
#/D *string*    Send formatted messages to screen and|or file.
#/D **Result**:
#/D *none*
#/D **Return**:
#/D *none*
function logI()
{
    if ! isLogEnabled ; then return ; fi
    if isLogToFileEnabled && isLogToScreenEnabled ; then
        echo -e "${DGRAY}   info:${NC} $*" | tee -a "${logFILE}"
    elif isLogToFileEnabled ; then
        echo -e "${DGRAY}   info:${NC} $*" >> "${logFILE}"
    elif isLogToScreenEnabled ; then
        echo -e "${DGRAY}   info:${NC} $*"
    fi
}

#/D
#/D #### logE()
#/D
#/D **Function**:
#/D *none* **logE**( *string* ) : *string*
#/D Log error messages.
#/D **Parameter**:
#/D *string*    Send formatted messages to screen and|or file.
#/D **Result**:
#/D *none*
#/D **Return**:
#/D *none*
function logE()
{
    if ! isLogEnabled ; then return ; fi
    if isLogToFileEnabled && isLogToScreenEnabled ; then
        echo -e "${RED}  error:${NC} $*" | tee -a "${logFILE}"
    elif isLogToFileEnabled ; then
        echo -e "${RED}  error:${NC} $*" >> "${logFILE}"
    elif isLogToScreenEnabled ; then
        echo -e "${RED}  error:${NC} $*"
    fi
}

#/D
#/D #### logF()
#/D
#/D **Function**:
#/D *none* **logF**( *string* ) : *string*
#/D Log failure messages.
#/D **Parameter**:
#/D *string*    Send formatted messages to screen and|or file.
#/D **Result**:
#/D *none*
#/D **Return**:
#/D *none*
function logF()
{
    if ! isLogEnabled ; then return ; fi
    if isLogToFileEnabled && isLogToScreenEnabled ; then
        echo -e "${HRED}failure:${NC} $*" | tee -a "${logFILE}"
    elif isLogToFileEnabled ; then
        echo -e "${HRED}failure:${NC} $*" >> "${logFILE}"
    elif isLogToScreenEnabled ; then
        echo -e "${HRED}failure:${NC} $*"
    fi
}

#/D
#/D #### logR()
#/D
#/D **Function**:
#/D *none* **logR**( *string* ) : *string*
#/D Log runtime messages.
#/D **Parameter**:
#/D *string*    Send formatted messages to screen and|or file.
#/D **Result**:
#/D *none*
#/D **Return**:
#/D *none*
function logR()
{
    if ! isLogEnabled || ! isLogVerbose ; then return ; fi
    local runtime="$(getRuntimeStr)"
    if isLogToFileEnabled && isLogToScreenEnabled ; then
        echo -e "${WHITE}runtime:${NC} ${runtime}s" | tee -a "${logFILE}"
    elif isLogToFileEnabled ; then
        echo -e "${WHITE}runtime:${NC} ${runtime}s" >> "${logFILE}"
    elif isLogToScreenEnabled ; then
        echo -e "${WHITE}runtime:${NC} ${runtime}s"
    fi
}

#/D
#/D #### logS()
#/D
#/D **Function**:
#/D *none* **logS**( *string* ) : *string*
#/D Log success messages.
#/D **Parameter**:
#/D *string*    Send formatted messages to screen and|or file.
#/D **Result**:
#/D *none*
#/D **Return**:
#/D *none*
function logS()
{
    if ! isLogEnabled || ! isLogVerbose ; then return ; fi
    if isLogToFileEnabled && isLogToScreenEnabled ; then
        echo -e "${WHITE}success:${NC} $*" | tee -a "${logFILE}"
    elif isLogToFileEnabled ; then
        echo -e "${WHITE}success:${NC} $*" >> "${logFILE}"
    elif isLogToScreenEnabled ; then
        echo -e "${WHITE}success:${NC} $*"
    fi
}

#/D
#/D #### logV()
#/D
#/D **Function**:
#/D *none* **logV**( *string* ) : *string*
#/D Log verbose messages.
#/D **Parameter**:
#/D *string*    Send formatted messages to screen and|or file.
#/D **Result**:
#/D *none*
#/D **Return**:
#/D *none*
function logV()
{
    if ! isLogEnabled || ! isLogVerbose ; then return ; fi
    if isLogToFileEnabled && isLogToScreenEnabled ; then
        echo -e "${GRAY}   info:${NC} $*" | tee -a "${logFILE}"
    elif isLogToFileEnabled ; then
        echo -e "${GRAY}   info:${NC} $*" >> "${logFILE}"
    elif isLogToScreenEnabled ; then
        echo -e "${GRAY}   info:${NC} $*"
    fi
}

#/D
#/D #### logW()
#/D
#/D **Function**:
#/D *none* **logW**( *string* ) : *string*
#/D Log warning messages.
#/D **Parameter**:
#/D *string*    Send formatted messages to screen and|or file.
#/D **Result**:
#/D *none*
#/D **Return**:
#/D *none*
function logW()
{
    if ! isLogEnabled || ! isLogVerbose ; then return ; fi
    if isLogToFileEnabled && isLogToScreenEnabled ; then
        echo -e "${HCYAN}warning:${NC} $*" | tee -a "${logFILE}"
    elif isLogToFileEnabled ; then
        echo -e "${HCYAN}warning:${NC} $*" >> "${logFILE}"
    elif isLogToScreenEnabled ; then
        echo -e "${HCYAN}warning:${NC} $*"
    fi
}

#/D
#/D #### logD()
#/D
#/D **Function**:
#/D *none* **logD**( *string* ) : *string*
#/D Log debug messages.
#/D **Parameter**:
#/D *string*    Send formatted messages to screen and|or file.
#/D **Result**:
#/D *none*
#/D **Return**:
#/D *none*
function logD()
{
    if ! $flagDEBUG || ! isLogEnabled ; then return ; fi
    if isLogToFileEnabled && isLogToScreenEnabled ; then
        echo -e "${HGREEN}  debug:${NC} $*" | tee -a "${logFILE}"
    elif isLogToFileEnabled ; then
        echo -e "${HGREEN}  debug:${NC} $*" >> "${logFILE}"
    elif isLogToScreenEnabled ; then
        echo -e "${HGREEN}  debug:${NC} $*"
    fi
}

#/D
#/D #### logT()
#/D
#/D **Function**:
#/D *none* **logT**( *string* ) : *string*
#/D Log trace messages.
#/D **Parameter**:
#/D *string*    Send formatted messages to screen and|or file.
#/D **Result**:
#/D *none*
#/D **Return**:
#/D *none*
function logT()
{
    if ! $flagTRACE || ! isLogEnabled ; then return ; fi
    if isLogToFileEnabled && isLogToScreenEnabled ; then
        echo -e "${HYELLOW}  trace:${NC} $*" | tee -a "${logFILE}"
    elif isLogToFileEnabled ; then
        echo -e "${HYELLOW}  trace:${NC} $*" >> "${logFILE}"
    elif isLogToScreenEnabled ; then
        echo -e "${HYELLOW}  trace:${NC} $*"
    fi
}

#/D
#/D #### getRuntimeStr()
#/D
#/D **Function**:
#/D *integer* **getRuntimeStr**( *none* ) : *string*
#/D Generate|Get runtime string.
#/D **Parameter**:
#/D *none*
#/D **Result**:
#/D *string*    Formatted runtime timestamp.
#/D **Return**:
#/D *integer*   **0**: Success
function getRuntimeStr()
{
    local elapsed
    local libENDTIME
    local runtime
    libENDTIME=$(( $(date +%s%N) / 1000000 ))
    runtime=$((libENDTIME - libSTARTIME))
    printf -v elapsed "%u.%03u" $((runtime / 1000)) $((runtime % 1000))
    echo -n "${elapsed}"
    return 0
}

################################################################################
#/D
#/D ### String

#/D
#/D #### genRandomAlpha()
#/D
#/D **Function**:
#/D *integer* **genRandomAlpha**( *integer* ) : *string*
#/D Generate a randomic alphabetic string.
#/D **Parameter**:
#/D *integer*   Length in bytes.
#/D **Result**:
#/D *string*    Randomic alphabetic characters.
#/D **Return**:
#/D *integer*   **0**: Success
#/D *integer*   **1**: Failure
function genRandomAlpha() { [ -n "$1" ] && tr < /dev/urandom -d -c "[:alpha:]" | head --bytes=$1 || return 1 ; }

#/D
#/D #### genRandomNumeric()
#/D
#/D **Function**:
#/D *integer* **genRandomNumeric**( *integer* ) : *string*
#/D Generate a randomic numeric string.
#/D **Parameter**:
#/D *integer*   Length in bytes.
#/D **Result**:
#/D *string*    Randomic numeric string.
#/D **Return**:
#/D *integer*   **0**: Success
#/D *integer*   **1**: Failure
function genRandomNumeric() { [ -n "$1" ] && tr < /dev/urandom -d -c "[:digit:]" | head --bytes=$1 || return 1 ; }

#/D
#/D #### genRandomAlphaNumeric()
#/D
#/D **Function**:
#/D *integer* **genRandomAlphaNumeric**( *integer* ) : *string*
#/D Generate a randomic alphanumeric string.
#/D **Parameter**:
#/D *integer*   Length in bytes.
#/D **Result**:
#/D *string*    Randomic alphanumeric string.
#/D **Return**:
#/D *integer*   **0**: Success
#/D *integer*   **1**: Failure
function genRandomAlphaNumeric() { [ -n "$1" ] && tr < /dev/urandom -d -c "[:alnum:]" | head --bytes=$1 || return 1 ; }

#/D
#/D #### genRandomLowerHexadecimalNumber()
#/D
#/D **Function**:
#/D *integer* **genRandomLowerHexadecimalNumber**( *integer* ) : *string*
#/D Generate a randomic low case char hexadecimal string.
#/D **Parameter**:
#/D *integer*   Length in bytes.
#/D **Result**:
#/D *string*    Randomic hexadecimal string.
#/D **Return**:
#/D *integer*   **0**: Success
#/D *integer*   **1**: Failure
function genRandomLowerHexadecimalNumber() { [ -n "$1" ] && tr < /dev/urandom -d -c "[:digit:]a-f" | head --bytes=$1 || return 1 ; }

#/D
#/D #### genRandomUpperHexadecimalNumber()
#/D
#/D **Function**:
#/D *integer* **genRandomUpperHexadecimalNumber**( *integer* ) : *string*
#/D Generate a randomic upper case char hexadecimal string.
#/D **Parameter**:
#/D *integer*   Length in bytes.
#/D **Result**:
#/D *string*    Randomic hexadecimal string.
#/D **Return**:
#/D *integer*   **0**: Success
#/D *integer*   **1**: Failure
function genRandomUpperHexadecimalNumber() { [ -n "$1" ] && tr < /dev/urandom -d -c "[:digit:]A-F" | head --bytes=$1 || return 1 ; }

#/D
#/D #### genRandomHexadecimalNumber()
#/D
#/D **Function**:
#/D *integer* **genRandomHexadecimalNumber**( *integer* ) : *string*
#/D Generate a randomic mixed case hexadecimal string.
#/D **Parameter**:
#/D *integer*   Length in bytes.
#/D **Result**:
#/D *string*    Randomic hexadecimal string.
#/D **Return**:
#/D *integer*   **0**: Success
#/D *integer*   **1**: Failure
function genRandomHexadecimalNumber() { [ -n "$1" ] && tr < /dev/urandom -d -c "[:xdigit:]" | head --bytes=$1 || return 1 ; }

#/D
#/D #### genRandomString()
#/D
#/D **Function**:
#/D *integer* **genRandomString**( *integer* ) : *string*
#/D Generate a randomic string with no space.
#/D **Parameter**:
#/D *integer*   Length in bytes.
#/D **Result**:
#/D *string*    Randomic string.
#/D **Return**:
#/D *integer*   **0**: Success
#/D *integer*   **1**: Failure
function genRandomString() { [ -n "$1" ] && tr < /dev/urandom -d -c "A-Za-z0-9\'\"\`~^?!;:.,@#$%&{[(<>)]}_=\+\-\*/\\|" | head --bytes=$1 || return 1 ; }

#/D
#/D #### genRandomStringSpace()
#/D
#/D **Function**:
#/D *integer* **genRandomStringSpace**( *integer* ) : *string*
#/D Generate a randomic string with space.
#/D **Parameter**:
#/D *integer*   Length in bytes.
#/D **Result**:
#/D *string*    Randomic string.
#/D **Return**:
#/D *integer*   **0**: Success
#/D *integer*   **1**: Failure
function genRandomStringSpace() { [ -n "$1" ] && tr < /dev/urandom -d -c "A-Za-z0-9\'\"\`~^?!;:.,@#$%&{[(<>)]}_=\+\-\*/\\| " | head --bytes=$1 || return 1 ; }

#/D
#/D #### genDateTimeAsCode()
#/D
#/D **Function**:
#/D *none* **genDateTimeAsCode**( *none* ) : *string*
#/D Generate a date and time as code number.
#/D **Parameter**:
#/D *none*
#/D **Result**:
#/D *string*    Date and Time as code number.
#/D **Return**:
#/D *none*
function genDateTimeAsCode() { echo -n $(date '+%Y-%m-%d-%H-%M-%S-%3N') ; }

#/D
#/D #### getDate()
#/D
#/D **Function**:
#/D *none* **getDate**( *none* ) : *string*
#/D Generate a date string.
#/D **Parameter**:
#/D *none*
#/D **Result**:
#/D *string*    Date string.
#/D **Return**:
#/D *none*
function getDate() { echo -n "$(date '+%Y-%m-%d')" ; }

#/D
#/D #### getTime()
#/D
#/D **Function**:
#/D *none* **getTime**( *none* ) : *string*
#/D Generate a time string.
#/D **Parameter**:
#/D *none*
#/D **Result**:
#/D *string*    Time string
#/D **Return**:
#/D *none*
function getTime() { echo -n "$(date '+%H:%M:%S.%3N')" ; }

#/D
#/D #### getDateTime()
#/D
#/D **Function**:
#/D *none* **getDateTime**( *none* ) : *string*
#/D Generate a date and time string.
#/D **Parameter**:
#/D *none*
#/D **Result**:
#/D *string*    Date and Time string.
#/D **Return**:
#/D *none*
function getDateTime() { echo -n "$(getDate) $(getTime)" ; }

#/D
#/D #### genRandom()
#/D
#/D **Function**:
#/D *integer* **genRandom**( *string* , *integer* ) : *string*
#/D Generate an random string according parameter length.
#/D **Parameter**:
#/D *string*    Randomic string type acording to typeRANDOM[] vector.
#/D *integer*   Randomic string length.
#/D **Result**:
#/D *string*    Randomic string.
#/D **Return**:
#/D *integer*   **0**: Success
#/D *integer*   **1**: Failure
function genRandom()
{
    local type=$1
    local len=$2
    local err=1
    local str='FAILURE'
    if [[ "${typeRANDOM[@]}" =~ "$type" ]] ; then
        case $type in
        alpha)  str="$(genRandomAlpha                  $len)" ; err=$? ;;
        digit)  str="$(genRandomNumeric                $len)" ; err=$? ;;
        alnum)  str="$(genRandomAlphaNumeric           $len)" ; err=$? ;;
        lowhex) str="$(genRandomLowerHexadecimalNumber $len)" ; err=$? ;;
        uphex)  str="$(genRandomUpperHexadecimalNumber $len)" ; err=$? ;;
        mixhex) str="$(genRandomHexadecimalNumber      $len)" ; err=$? ;;
        random) str="$(genRandomString                 $len)" ; err=$? ;;
        space)  str="$(genRandomStringSpace            $len)" ; err=$? ;;
        date)   str="$(genDateTimeAsCode)"                    ; err=$? ;;
        esac
    fi
    echo -n "${str}"
    return $err
}

#/D
#/D #### genUUID()
#/D
#/D **Function**:
#/D *integer* **genUUID**( *string* , *integer* ) : *string*
#/D Generate an random UUID string accorgin to type and length|eschema[]=(12 4 4 4 8)
#/D **Parameter**:
#/D *string*    Randomic type acording to typeRANDOM[] vector.
#/D *integer*   Randomic string length|eschema[]=(12 4 4 4 8)
#/D **Result**:
#/D *string*    Randomic UUID string.
#/D **Return**:
#/D *integer*   **0**: Success
#/D *integer*   **1**: Failure
function genUUID()
{
    local err=1
    local type=$1
    local string='FAILURE'
    if [ -n "$2" ] && isInteger $2
    then
        shift
        declare -i len=$1
        string="$(genRandom $type $len)"
        err=$?
        shift
        while [ -n "$1" ]
        do
            if isInteger $1
            then
                len=$1
                string="${string}-$(genRandom $type $len)"
                err=$?
            else
                string="FAILURE"
                err=1
                break
            fi
            shift
        done
    fi
    echo -n "${string}"
    return $err
}

#/D
#/D #### getRuntime()
#/D
#/D **Function**:
#/D *none* **getRuntime**( *none* ) : *string*
#/D Get instantaneous timestamp in milleseconds.
#/D **Parameter**:
#/D *none*
#/D **Result**:
#/D *string*    Timestamp in milleseconds
#/D **Return**:
#/D *none*
function getRuntime() { echo -n $(( $(date +%s%N) / 1000000 )) ; }

#/D
#/D #### isFloat()
#/D
#/D **Function**:
#/D *none* **isFloat**( *string* ) : *boolean*
#/D Check parameter is a floating point number.
#/D **Parameter**:
#/D *string*    String parameter.
#/D **Result**:
#/D *boolean*    **true**: Parameter is a floating point number.
#/D *boolean*   **false**: Parameter is not a floating point number.
#/D **Return**:
#/D *none*
function isFloat() { if [ -n "$( echo -n "$1" | grep -aoP "^[+-]?[0-9]+\.[0-9]+$" )" ] ; then true ; else false ; fi ; }

#/D
#/D #### isInteger()
#/D
#/D **Function**:
#/D *none* **isInteger**( *string* ) : *boolean*
#/D Check parameter is an integer number.
#/D **Parameter**:
#/D *string*    String parameter.
#/D **Result**:
#/D *boolean*    **true**: Parameter is an integer number.
#/D *boolean*   **false**: Parameter is not an integer number.
#/D **Return**:
#/D *none*
function isInteger() { [ -n "$(echo "$1" | grep -oP "^[+-]?([0-9]+)$")" ] && true || false ; }

#/D
#/D #### isAlpha()
#/D
#/D **Function**:
#/D *none* **isAlpha**( *string* ) : *boolean*
#/D Check parameter is an alphabetic string only.
#/D **Parameter**:
#/D *string*    String parameter.
#/D **Result**:
#/D *boolean*    **true**: Parameter is an alphabetic string only.
#/D *boolean*   **false**: Parameter is not an alphabetic string only.
#/D **Return**:
#/D *none*
function isAlpha() { [ -n "$(echo "$1" | grep -oP "^([A-Za-z]+)$")" ] && true || false ; }

#/D
#/D #### isDigit()
#/D
#/D **Function**:
#/D *none* **isDigit**( *string* ) : *boolean*
#/D Check parameter is a digit string only.
#/D **Parameter**:
#/D *string*    String parameter.
#/D **Result**:
#/D *boolean*    **true**: Parameter is a digit string only.
#/D *boolean*   **false**: Parameter is not a digit string only.
#/D **Return**:
#/D *none*
function isDigit() { [ -n "$(echo "$1" | grep -oP "^([0-9]+)$")" ] && true || false ; }

#/D
#/D #### isAlphaNumeric()
#/D
#/D **Function**:
#/D *none* **isAlphaNumeric**( *string* ) : *boolean*
#/D Check parameter is an alphanumeric string only.
#/D **Parameter**:
#/D *string*    String parameter.
#/D **Result**:
#/D *boolean*    **true**: Parameter is an alphanumeric string only.
#/D *boolean*   **false**: Parameter is not an alphanumeric string only.
#/D **Return**:
#/D *none*
function isAlphaNumeric() { [ -n "$(echo "$1" | grep -oP "^([A-Za-z0-9]+)$")" ] && true || false ; }

#/D
#/D #### isHexadecimalNumber()
#/D
#/D **Function**:
#/D *none* **isHexadecimalNumber**( *string* ) : *boolean*
#/D Check parameter is an hexadecimal string only.
#/D **Parameter**:
#/D *string*    String parameter.
#/D **Result**:
#/D *boolean*    **true**: Parameter is an hexadecimal string only.
#/D *boolean*   **false**: Parameter is not an hexadecimal string only.
#/D **Return**:
#/D *none*
function isHexadecimalNumber() { [ -n "$(echo "$1" | grep -oP "^([0-9A-Fa-f]+)$")" ] && true || false ; }

#/D
#/D #### isLowerHexadecimalNumber()
#/D
#/D **Function**:
#/D *none* **isLowerHexadecimalNumber**( *string* ) : *boolean*
#/D Check parameter is a low case hexadecimal string only.
#/D **Parameter**:
#/D *string*    String parameter.
#/D **Result**:
#/D *boolean*    **true**: Parameter is a low case hexadecimal string only.
#/D *boolean*   **false**: Parameter is not a low case hexadecimal string only.
#/D **Return**:
#/D *none*
function isLowerHexadecimalNumber() { [ -n "$(echo "$1" | grep -oP "^([0-9a-f]+)$")" ] && true || false ; }

#/D
#/D #### isUpperHexadecimalNumber()
#/D
#/D **Function**:
#/D *none* **isUpperHexadecimalNumber**( *string* ) : *boolean*
#/D Check parameter is an upper case hexadecimal string only.
#/D **Parameter**:
#/D *string*    String parameter.
#/D **Result**:
#/D *boolean*    **true**: Parameter is an upper case hexadecimal string only.
#/D *boolean*   **false**: Parameter is not an upper case hexadecimal string only.
#/D **Return**:
#/D *none*
function isUpperHexadecimalNumber() { [ -n "$(echo "$1" | grep -oP "^([0-9A-F]+)$")" ] && true || false ; }

#/D
#/D #### isGraphString()
#/D
#/D **Function**:
#/D *none* **isGraphString**( *string* ) : *boolean*
#/D Check parameter is a graph char string.
#/D **Parameter**:
#/D *string*    String parameter.
#/D **Result**:
#/D *boolean*    **true**: Parameter is a graph char string.
#/D *boolean*   **false**: Parameter is not a graph char string.
#/D **Return**:
#/D *none*
function isGraphString()
{
    if [ -n "$(echo "$1" | grep -oP "^([A-Za-z0-9\'\"\`¹²³£¢¬§ªº°~^?!;:.,@#$%&{\[(<>)\]}_=+\-*/\\\| ]+)$")" ]
    then
        true
    else
        false
    fi
}

#/D
#/D #### strLength()
#/D
#/D **Function**:
#/D *integer* **strLength**( *string* ) : *integer*
#/D Get string length.
#/D **Parameter**:
#/D *string*    String parameter.
#/D **Result**:
#/D *integer*   String length.
#/D **Return**:
#/D *integer*   **0**: Success
#/D *integer*   **1**: Failure
function strLength()
{
    local res=$(bin/strlen "$1")
    local err=$?
    echo -n "$res"
    return $err
}

#/D
#/D #### strCompare()
#/D
#/D **Function**:
#/D *integer* **strCompare**( *string* , *string* ) : *integer*
#/D Compare string and return -N, 0 , +N
#/D **Parameter**:
#/D *string*    1st String parameter.
#/D *string*    2nd String parameter.
#/D **Result**:
#/D *integer*   **-N**: 1st String parameter is N char lower than 2nd String parameter.
#/D *integer*    **0**: 1st String parameter is equal to 2nd String parameter.
#/D *integer*    **N**: 1st String parameter is N char upper than 2nd String parameter.
#/D **Return**:
#/D *integer*   **0**: Success
#/D *integer*   **1**: Failure
function strCompare()
{
    local res=$(bin/strcmp "$1" "$2")
    local err=$?
    echo -n "$res"
    return $err
}

#/D
#/D #### genVersionStr()
#/D
#/D **Function**:
#/D *integer* **genVersionStr**( *integer*[] ) : *string*
#/D Generate version string from parameter.
#/D Description
#/D **Parameter**:
#/D *integer*[]     Version
#/D **Result**:
#/D *string*        String version.
#/D **Return**:
#/D *integer*   **0**: Success
#/D *integer*   **1**: Failure
function genVersionStr()
{
    if [ $# -gt 0 ]
    then
        local vector=(${@})
        echo -n "${vector[0]}.${vector[1]}.${vector[2]}"
    else
        return 1
    fi
}

#/D
#/D #### genVersionNum()
#/D
#/D **Function**:
#/D *integer* **genVersionNum**( *integer*[] ) : *ingeter*
#/D Generate version number from parameter.
#/D Description
#/D **Parameter**:
#/D *integer*[]     Description
#/D **Result**:
#/D *integer*       Version integer number nnn from array parameter (n n n).
#/D **Return**:
#/D *integer*   **0**: Success
#/D *integer*   **1**: Failure
function genVersionNum()
{
    if [ $# -gt 0 ]
    then
        local vector=(${@})
        echo -n $((${vector[0]}*100 + ${vector[1]}*10 + ${vector[2]}))
    else
        return 1
    fi
}

#/D
#/D #### genDateVersionStr()
#/D
#/D **Function**:
#/D *integer* **genDateVersionStr**( *integer*[] ) : *string*
#/D Generate date version string from parameter.
#/D **Parameter**:
#/D *integer*[]     Date array (YYYY MM DD)
#/D **Result**:
#/D *string*        Formatted string date YYYY-MM-DD
#/D **Return**:
#/D *integer*   **0**: Success
#/D *integer*   **1**: Failure
function genDateVersionStr()
{
    if [ $# -gt 0 ]
    then
        local vector=(${@})
        printf "%04d-%02d-%02d" ${vector[0]} ${vector[1]} ${vector[2]}
    else
        return 1
    fi
}

#/D
#/D #### genDateVersionNum()
#/D
#/D **Function**:
#/D *integer* **genDateVersionNum**( *integer*[] ) : *integer*
#/D Generate date version number from parameter.
#/D **Parameter**:
#/D *integer*[]     Date array (YYYY MM DD)
#/D **Result**:
#/D *integer*       Formatted integer date  YYYYMMDD
#/D **Return**:
#/D *integer*   **0**: Success
#/D *integer*   **1**: Failure
function genDateVersionNum()
{
    if [ $# -gt 0 ]
    then
        local vector=(${@})
        echo -n $(( (${vector[0]}*1000000) + (${vector[1]}*1000) + (${vector[2]}) ))
    else
        return 1
    fi
}

################################################################################
#/D
#/D ### Connection

#/D
#/D #### isConnected()
#/D
#/D **Function**:
#/D *none* **isConnected**( *none* ) : *boolean*
#/D Check internet connecton available and ative.
#/D **Parameter**:
#/D *none*
#/D **Result**:
#/D *boolean*    **true**: Internet connectio is available and active.
#/D *boolean*   **false**: Internet connectio is not available neither active.
#/D **Return**:
#/D *none*
function isConnected() { ping '8.8.8.8' -q -t 30 -c 1 > /dev/null 2>&1 && true || false ; }

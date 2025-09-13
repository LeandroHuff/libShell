################################################################################
# @brief        Shell Script Library.                                          #
# @file         libShell.sh                                                    #
# @author       Leandro - leandrohuff@programmer.net                           #
# @date         2025-09-10                                                     #
# @version      2.2.3                                                          #
# @copyright    CC01 1.0 Universal                                             #
# @details      Formatted script file to service as a shell function library.  #
#               Let a rapid shell script development with a list of common and #
#               most used functions.                                           #
################################################################################
declare -i -r libSTARTIME=$(( $(date +%s%N) / 1000000 ))
## @brief   Library Version Number
declare -a -i -r libVERSION=(2 2 3)
declare -a -i -r libDATE=(2025 9 10)
## @brief   Log Levels
declare -i -r logQUIET=0
declare -i -r logDEFAULT=1
declare -i -r logVERBOSE=2
declare -i -r logFULL=3
declare -i -r logTOSCREEN=16
declare -i -r logTOFILE=32
## @brief   Random types
declare -a -r typeRANDOM=(alpha digit alnum lowhex uphex mixhex random space date)
## @brief   Escape Codes for Colors
declare -r NC="\033[0m"
declare -r RED="\033[31m"
declare -r GREEN="\033[32m"
declare -r YELLOW="\033[33m"
declare -r BLUE="\033[34m"
declare -r MAGENTA="\033[35m"
declare -r CYAN="\033[36m"
declare -r WHITE="\033[37m"
declare -r HRED="\033[91m"
declare -r HGREEN="\033[92m"
declare -r HYELLOW="\033[93m"
declare -r HBLUE="\033[94m"
declare -r HMAGENTA="\033[95m"
declare -r HCYAN="\033[96m"
declare -r HWHITE="\033[97m"
## @brief   Log Variables
declare flagDEBUG=false
declare flagTRACE=false
declare -i logTARGET=$logQUIET
declare -i logLEVEL=$logQUIET
declare libTMP=""
declare logFILE=""
## @brief   Timeout
declare -i libTIMEOUT=10
## @brief   Get script name
function getScriptName() { echo -n "$(basename $0)" ; return 0 ; }
## @brief   Get file name from parameter
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
## @brief   Get only name from a filename parameter
function getName()
{
    if [ -n "$1" ]
    then
        local file=$(basename "$1")
        echo -n "${file%.*}"
        return 0
    else
        echo -n ''
        return 1
    fi
}
## @brief   Get only extension from filename parameter
function getExt()
{
    if [ -n "$1" ]
    then
        local file=$(basename "$1")
        echo -n "${file##*.}"
        return 0
    else
        echo -n ''
        return 1
    fi
}
## @brief   Get only path from filename parameter
function getPath()
{
    if [ -n "$1" ]
    then
        echo -n "${1%/*}"
        return 0
    else
        echo -n ''
        return 1
    fi
}
## @brief   Get temporary directory
function getTempDir() { [ -d '/tmp' ] && echo -n '/tmp' || echo "$HOME" ; return 0 ; }
## @brief   Generate randomic alpha string
function genRandomAlpha() { [ -n "$1" ] && tr < /dev/urandom -d -c "[:alpha:]" | head --bytes=$1 || return 1 ; }
## @brief   Generate randomic numeric string
function genRandomNumeric() { [ -n "$1" ] && tr < /dev/urandom -d -c "[:digit:]" | head --bytes=$1 || return 1 ; }
## @brief   Fenerate randomic alpha numeric string
function genRandomAlphaNumeric() { [ -n "$1" ] && tr < /dev/urandom -d -c "[:alnum:]" | head --bytes=$1 || return 1 ; }
## @brief   Generate randomic lower case hexadecimal number string
function genRandomLowerHexadecimalNumber() { [ -n "$1" ] && tr < /dev/urandom -d -c "[:digit:]a-f" | head --bytes=$1 || return 1 ; }
## @brief   Fenerate randomic upper caes hexadecimal number strin
function genRandomUpperHexadecimalNumber() { [ -n "$1" ] && tr < /dev/urandom -d -c "[:digit:]A-F" | head --bytes=$1 || return 1 ; }
## @brief   Generate randomic mixed lower and upper case hexadecimal number string
function genRandomHexadecimalNumber() { [ -n "$1" ] && tr < /dev/urandom -d -c "[:xdigit:]" | head --bytes=$1 || return 1 ; }
## @brief   Generate Randomic graph char string
function genRandomString() { [ -n "$1" ] && tr < /dev/urandom -d -c "A-Za-z0-9\'\"\`~^?!;:.,@#$%&{[(<>)]}_=\+\-\*/\\|" | head --bytes=$1 || return 1 ; }
## @brief   Generate randomic graph char and space string
function genRandomStringSpace() { [ -n "$1" ] && tr < /dev/urandom -d -c "A-Za-z0-9\'\"\`~^?!;:.,@#$%&{[(<>)]}_=\+\-\*/\\| " | head --bytes=$1 || return 1 ; }
## @brief   Generate date and time as a code string (without spaces)
function genDateTimeAsCode() { echo -n $(date '+%Y-%m-%d-%H-%M-%S-%3N') ; return 0 ; }
## @brief   Generate date and time string
function getDate() { echo -n "$(date '+%Y-%m-%d')" ; }
function getTime() { echo -n "$(date '+%H:%M:%S.%3N')" ; }
function getDateTime() { echo -n "$(getDate) $(getTime)" ; }
## @brief   Get libShell version number as string
function getLibVersionStr() { genVersionStr ${libVERSION[@]} ; }
## @brief   Get libShell version as a numer
function getLibVersionNum() { echo -n $(genVersionNum ${libVERSION[@]})  ; return 0 ; }
## @brief   Print formatted libShell string version.
function printLibVersion() { echo -e "libShell Version: ${WHITE}$(getLibVersionStr)${NC}" ; return 0 ; }
## @brief   Get libShell date number as string
function getLibDateVersionStr() { genDateVersionStr ${libDATE[@]} ; }
## @brief   Get libShell date as a numer
function getLibDateVersionNum() { echo -n $(genDateVersionNum ${libDATE[@]})  ; return 0 ; }
## @brief   Print formatted libShell string date
function printLibDate() { echo -e "libShell Date ${WHITE}$(getLibDateVersionStr)${NC}" ; return 0 ; }
## @brief   Get runtime number
function getRuntime() { echo -n $(( $(date +%s%N) / 1000000 )) ; return 0 ; }
## @brief   Get log path and filename
function getLogFilename() { echo -n "$(getTempDir)/$(getScriptName).log" ; return 0 ; }
## @brief   Check is the internet connecton ative
function isConnected() { ping '8.8.8.8' -q -t 30 -c 1 > /dev/null 2>&1 && true || false ; }
## @brief    Check empty parameter
function isEmpty() { if [ -n "$1" ] ; then false ; else true ; fi ; }
## @brief    Check not empty parameter
function notEmpty() { if [ -n "$1" ] ; then true ; else false ; fi ; }
## @brief    Check if parameter is a link to file or directory
function isLink() { if [ -L "$1" ] ; then true ; else false ; fi ; }
## @brief    Check parameter is a regualr file
function isFile() { if [ -f "$1" ] ; then true ; else false ; fi ; }
## @brief    Check parameter is a directory
function isDir() { if [ -d "$1" ] ; then true ; else false ; fi ; }
## @brief   isBlockDevice()
function isBlockDevice() { if [ -b "$1" ] ; then true ; else false ; fi ; }
## @brief   Get target following link
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
## @brief   Check parameter is affirmative
function isYes() { case "$1" in [yY] | [yY][eE][sS]) true ;; *) false ;; esac ; }
## @brief   Check parameter is negative
function isNot() { case "$1" in [nN] | [nN][oO] | [nN][oO][tT]) true ;; *) false ;; esac ; }
## @brief   Check parameter is fa float or double number
function isFloat() { if [ -n "$( echo -n "$1" | grep -aoP "^[+-]?[0-9]+\.[0-9]+$" )" ] ; then true ; else false ; fi ; }
## @brief   Check parameter is an integer number
function isInteger() { [ -n "$(echo "$1" | grep -oP "^[+-]?([0-9]+)$")" ] && true || false ; }
## @brief   Check parameter is an alphabetic string
function isAlpha() { [ -n "$(echo "$1" | grep -oP "^([A-Za-z]+)$")" ] && true || false ; }
## @brief   Check parameter is a digit number
function isDigit() { [ -n "$(echo "$1" | grep -oP "^([0-9]+)$")" ] && true || false ; }
## @brief   Check parameter is alphabetic and numberic.string
function isAlphaNumeric() { [ -n "$(echo "$1" | grep -oP "^([A-Za-z0-9]+)$")" ] && true || false ; }
## @brief   Check parameter is a hexadecimal string
function isHexadecimalNumber() { [ -n "$(echo "$1" | grep -oP "^([0-9A-Fa-f]+)$")" ] && true || false ; }
## @brief   Check parameter is a lower case hexadecimal string.
function isLowerHexadecimalNumber() { [ -n "$(echo "$1" | grep -oP "^([0-9a-f]+)$")" ] && true || false ; }
## @brief   Check parameter is a upper case hexadecimal string.
function isUpperHexadecimalNumber() { [ -n "$(echo "$1" | grep -oP "^([0-9A-F]+)$")" ] && true || false ; }
## @brief   Check parameter is all graphical character into the string
function isAllGraphChar()
{
    if [ -n "$(echo "$1" | grep -oP "^([A-Za-z0-9'\"\`¹²³£¢¬§ªº°~^?!;:.,@#$%&{\[(<>)\]}_=+\-*/\\\| ]+)$")" ]
    then
        true
    else
        false
    fi
}
## @brief   Get string length
function strLength()
{
    local res=$(bin/strlen "$1")
    local err=$?
    echo -n "$res"
    return $err
}
## @brief   Compare string and return -1,0,1
function strCompare()
{
    local res=$(bin/strcmp "$1" "$2")
    local err=$?
    echo -n "$res"
    return $err
}
## @brief   Compare float numbers and return -1,0,1
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
## @brief   Add 2 flaot numbers
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
## @brief   Subtract 2 float number
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
## @brief   Multiply 2 float numbers
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
## @brief   Divide 2 float numbers
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
## @brief   Check is float number between 2 float numbers value
function isFloatInRange()
{
    local res=$(bin/isFloatInRange "$1" "$2" "$3")
    local err=$?
    echo -n "$res"
    return $err
}
## @brief   Get git branch name
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
## @brief   Get git added files counter
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
## @brief   Get git modified files counter
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
## @brief   Get git deleted files counter
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
## @brief   Check is a git repository
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
## @brief   Get git repository name
function gitRepositoryName()
{
    local res=''
    local err=1
    local dir="$PWD"
    local back="$PWD"
    [ -z "$1" ] || dir="$1"
    if isGitRepository "${dir}"
    then
        cd "${dir}"
        res="$(basename `git rev-parse --show-toplevel`)"
        err=$?
    fi
    [ -z "$1" ] || cd "$back"
    echo -n "$res"
    return $err
}
## @brief   Check git files changed
function isGitChanged()
{
    if [ $(gitCountAdded    "$1") -gt 0 ] || \
       [ $(gitCountModified "$1") -gt 0 ] || \
       [ $(gitCountDeleted  "$1") -gt 0 ]
    then
        true
        return 0
    else
        false
        return 1
    fi
}

function existBranch()
{
    local res
    [ -n "$1" ] || { logF "Empty parameter for existBranch(\$1)" ; return 1 ; }
    res=$(git branch | grep -oF "$1" > /dev/null 2>&1)
    [ $? -eq 0 ] && true || false
}

function inBranch()
{
    local res
    [ -n "$1" ] || { logF "Empty parameter for inBranch(\$1)" ; return 1 ; }
    res=$(git branch --show-current | grep -oF "$1" > /dev/null 2>&1)
    [ $? -eq 0 ] && true || false
}

function gitAdd()
{
    local res
    [ -n "$1" ] || { logF "Empty parameter for gitAdd(\$1)" ; return 1 ; }
    res=$(git add "$1" > /dev/null 2>&1)
    return $?
}

function gitCommitNotSigned()
{
    local res
    [ -n "$1" ] || { logF "Empty parameter for gitNotSignCommit(\$1)" ; return 1 ; }
    res=$(git commit -m \""$1"\" > /dev/null 2>&1)
    return $?
}

function gitCommitSigned()
{
    local res
    [ -n "$1" ] || { logF "Empty parameter for gitSignCommit(\$1)" ; return 1 ; }
    res=$(git commit -s -m \""$1"\" > /dev/null 2>&1)
    return $?
}

function gitFetch()
{
    local res
    res=$(git fetch origin HEAD > /dev/null 2>&1)
    return $?
}

function gitPull()
{
    local res
    res=$(git pull origin HEAD > /dev/null 2>&1)
    return $?
}

function gitPush()
{
    local res
    res=$(git push origin HEAD > /dev/null 2>&1)
    return $?
}

function gitSetUpstream()
{
    local res
    res=$(git push --set-upstream origin > /dev/null 2>&1)
    return $?
}

function newBranch()
{
    local res
    [ -n "$1" ] || { logF "Empty parameter for newBranch(\$1)" ; return 1 ; }
    res=$(git branch "$1" > /dev/null 2>&1)
    return $?
}

function gitSwitch()
{
    local res
    [ -n "$1" ] || { logF "Empty parameter for gitSwitch(\$1)" ; return 1 ; }
    res=$(git switch "$1" > /dev/null 2>&1)
    return $?
}

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

## @brief   Check if link referenced exist
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
## @brief   Check if file or directory or link reference exist
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
## @brief   Get ID from os-release file
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
## @brief   Generate version string from parameter
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
## @brief   Generate version number from parameter
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
## @brief   Generate date version string from parameter
function genDateVersionStr()
{
    if [ $# -gt 0 ]
    then
        local vector=(${@})
        printf "%04d.%02d.%02d" ${vector[0]} ${vector[1]} ${vector[2]}
    else
        return 1
    fi
}
## @brief   Generate date version number from parameter
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
# +===========+===============+==============+
# | Function  | Description   | Flag         |
# +===========+===============+==============+
# | logU      | Unconditional | none         |
# +-----------+---------------+--------------+
# | logIt     | Anything      | enabled      |
# +-----------+---------------+--------------+
# | logI      | Info          | normal       |
# +-----------+---------------+--------------+
# | logR      | Runtime       | normal       |
# +-----------+---------------+--------------+
# | logE      | Error         | normal       |
# +-----------+---------------+--------------+
# | logF      | Failure       | normal       |
# +-----------+---------------+--------------+
# | logS      | Success       | verbose      |
# +-----------+---------------+--------------+
# | logV      | Verbose Info  | verbose      |
# +-----------+---------------+--------------+
# | logW      | Warning       | verbose      |
# +-----------+---------------+--------------+
# | logD      | Debug         | debug        |
# +-----------+---------------+--------------+
# | logT      | Trace         | trace        |
# +-----------+---------------+--------------+

## @brief   Log anything unconditional to screen and file.
function logU() { echo -e "$*" ; }

## @brief   Check is log quiet enabled
function isLogQuiet()
{
    if [ $logLEVEL -eq $logQUIET ]
    then
        true
    else
        false
    fi
}
## @brief   Check is log default enabled
function isLogDefault()
{
    if [ $logLEVEL -eq $logDEFAULT ]
    then
        true
    else
        false
    fi
}
## @brief   Check verbose log enabled
function isLogVerbose()
{
    if [ $logLEVEL -eq $logVERBOSE ]
    then
        true
    else
        false
    fi
}
## @brief   Check log to screen enabled
function isLogToScreenEnabled()
{
    if [[ $logTARGET -ge $logTOSCREEN && $logTARGET -lt $logTOFILE ]] || [ $logTARGET -ge $((logTOSCREEN + logTOFILE)) ]
    then
        true
    else
        false
    fi
}
## @brief   Check log to file enabled
function isLogToFileEnabled()
{
    if [ $logTARGET -ge $logTOFILE ]
    then
        true
    else
        false
    fi
}
## @brief   Check log enabled (screen or file and not quiet)
function isLogEnabled()
{
    if [ $logTARGET -gt $logQUIET ] && [ $logLEVEL -gt $logQUIET ]
    then
        true
    else
        false
    fi
}
## @brief   Log anything according to log flags.
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
## @brief   Info logs.
function logI()
{
    if ! isLogEnabled ; then return ; fi
    if isLogToFileEnabled && isLogToScreenEnabled ; then
        echo -e "${WHITE}   info:${NC} $*" | tee -a "${logFILE}"
    elif isLogToFileEnabled ; then
        echo -e "${WHITE}   info:${NC} $*" >> "${logFILE}"
    elif isLogToScreenEnabled ; then
        echo -e "${WHITE}   info:${NC} $*"
    fi
}
## @brief   Error logs.
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
## @brief   Failure logs.
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
## @brief   Runtime logs.
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
## @brief   Success logs.
function logS()
{
    if ! isLogEnabled || ! isLogVerbose ; then return ; fi
    if isLogToFileEnabled && isLogToScreenEnabled ; then
        echo -e "${HWHITE}success:${NC} $*" | tee -a "${logFILE}"
    elif isLogToFileEnabled ; then
        echo -e "${HWHITE}success:${NC} $*" >> "${logFILE}"
    elif isLogToScreenEnabled ; then
        echo -e "${HWHITE}success:${NC} $*"
    fi
}
## @brief   Verbose info logs.
function logV()
{
    if ! isLogEnabled || ! isLogVerbose ; then return ; fi
    if isLogToFileEnabled && isLogToScreenEnabled ; then
        echo -e "${WHITE}   info:${NC} $*" | tee -a "${logFILE}"
    elif isLogToFileEnabled ; then
        echo -e "${WHITE}   info:${NC} $*" >> "${logFILE}"
    elif isLogToScreenEnabled ; then
        echo -e "${WHITE}   info:${NC} $*"
    fi
}
## @brief   Warning logs.
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
## @brief   Debug logs.
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
## @brief   Trace logs.
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
##
# @fn       getRuntimeStr( $1 )
# @brief    Generate|Get runtime string.
# @param    $1  Start runtime number.
# @print        Formatted runtime string.
# @return   0   Success
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
##
# @fn       isParameter( $1 )
# @brief    Check command line parameter is a true parameter.
# @param    $1      Word to check.
# @return   true    Is a true parameter.
#           false   Is not a true parameter.
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
##
# @fn       isArgValue( $1 )
# @brief    Check command line parameter is a true value.
# @param    $1      Word to check.
# @return   true    Is a true value.
#           false   Is not a true value.
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
##
# @fn       unsetLibVars()
# @brief    Unset library variables.
# @param    none
# @return   0   Success.
function unsetLibVars()
{
    unset -v flagDEBUG
    unset -v flagTRACE
    unset -v logLEVEL
    unset -v lOGTARGET
    unset -v libTIMEOUT
    return 0
}
##
# @fn       libStop()
# @brief    Stop|End library execution.
# @param    none
# @return   0   Success.
function libStop()
{
    unsetLibVars
    return 0
}
##
# @fn       printLibHelp()
# @brief    Print library help information.
# @param    none
# @return   0   Success.
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
##
# @fn       genRandom( $1 $2 )
# @brief    Generate an random string according parameter length.
# @param    $1      Type (alpha digit alnum lowhex uphex mixhex random date)
#           $2      Length
# @print    string  Random characters.
# @return   0       Success
#           1..N    Error code.
function genRandom()
{
    local type=$1
    local len=$2
    local err=0
    local str=""
    if [[ "${typeRANDOM[@]}" =~ "$type" ]] ; then
        case $type in
        alpha)  str="$(genRandomAlpha                  $len)" ;;
        digit)  str="$(genRandomNumeric                $len)" ;;
        alnum)  str="$(genRandomAlphaNumeric           $len)" ;;
        lowhex) str="$(genRandomLowerHexadecimalNumber $len)" ;;
        uphex)  str="$(genRandomUpperHexadecimalNumber $len)" ;;
        mixhex) str="$(genRandomHexadecimalNumber      $len)" ;;
        random) str="$(genRandomString                 $len)" ;;
        space)  str="$(genRandomStringSpace            $len)" ;;
        date)   str="$(genDateTimeAsCode)"                    ;;
        *) err=1 ;;
        esac
    else
        err=1
    fi
    echo -n "${str}"
    return $err
}
##
# @fn        genUUID( $1 $2 [$3 ... $@] )
# @brief     Generate an random string according parameters.
# @param     $1           Type (alpha digit alnum lowhex uphex mixhex random date)
#            $2           Length for first string group.
#            [$3 ... $N]  Schema for next string group.
# @return    string       Random String
# @details   Generate a random string according to the parameters,
#            the fist parameter set the random type, for date, the second parameter
#            length can be any integer value, it will be ignored, for others type,
#            the function will generate groups of string separated by '-' character.
#            The result could be something like: 12345678-1234-1234-1234-12345678902
#            The type instruct how the string group will be generated.
#            alpha : Alphabetic [A-Za-z]
#            digit : Numeric [0-9]
#            alnum : Alphanumeric [A-Za-z0-9]
#            lowhex: Lower Case Hexadecimal [0-9a-f]
#            uphex : Upper Case Haxadecimal [0-9A-F]
#            mixhex: Lower + Upper Case Hexadecimal [0-9a-fA-F]
#            random: alphanumeric + punctuation characters.
#            space : alphanumeric + punctuation + space characters.
#            date  : Formatted date as YYYY-mm-dd-HH-MM-SS-sss
#            Where:
#            YYYY: Year        0000..9999
#              mm: Month         01..12
#              dd: Day           01..31
#              HH: Hour          00..23
#              MM: Minutes       00..59
#              SS: Seconds       00..59
#             sss: Milliseconds 000..999
#
function genUUID()
{
    local type=$1
    local string=''
    if [ -n "$2" ] && isInteger $2
    then
        shift
        declare -i len=$1
        string="$(genRandom $type $len)"
        shift
        while [ -n "$1" ]
        do
            if isInteger $1
            then
                len=$1
                string="${string}-$(genRandom $type $len)"
            else
                string="FAILURE"
            fi
            shift
        done
    else
        string="FAILURE"
    fi
    echo -n "${string}"
    return 0
}
##
# @fn       getMountDir()
# @brief    Get mount directory string.
# @param    none
# @return   /media or
#           /run/media or
#           /mnt
function getMountDir()
{
    if   [ -d /media     ] ; then echo -n "/media"
    elif [ -d /run/media ] ; then echo -n "/run/media"
    else                          echo -n "/mnt"
    fi
}
##
# @fn       logBegin()
# @brief    Begin|Start log to file.
# @param    none
# @return   0   Success
#           1   Failure
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
        return 1
    fi
    return 0
}
##
# @fn       logEnd()
# @brief    End|Stop log to file.
# @param    none
# @return   0   Success
#           1   Failure
function logEnd()
{
    if ! isLogToFileEnabled ; then return 0 ; fi
    if [ -f "${logFILE}" ]
    then
        echo "         End Log to File on $(date +%Y-%m-%d) at $(date +%T.%N)"                  >> "${logFILE}"
        echo "################################################################################" >> "${logFILE}"
    else
        logE "Could not access ${logFILE}"
        return 1
    fi
    return 0
}
##
# @fn       askToContinue( $1 )
# @brief    Print a message and ask user to continue and get the answer.
# @param    $1  Timeout
#           $2  Message
# @return   0   Yes
#           1   Not
#           2   Error
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
    echo -e -n "$message ${timeout}s [${HWHITE}y${NC}|${HWHITE}N${NC}]: "
    if [ $(compareFloat "$timeout" 0.0) -gt 0 ]
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
##
# @fn       wait( $1 , $2 )
# @brief    Print a message and wait user to continue.
# @param    $1      Timeout value.
#           $2      Alternative message.
# @return   0       Not
#           2       Timeout
function wait()
{
    local ans=''
    declare timeout=$([ -n "$1" ] && echo -n $1 || echo -n $libTIMEOUT)
    local message=$([ -n "$2" ] && echo -n "${2}" || echo -n "Do Wait for ")
    echo -e -n "${message} ${timeout}s [${HWHITE}n${NC}|${HWHITE}N${NC}]?: "
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
##
# @fn       loadID()
# @brief    Source /etc/os-release file.
# @param    none
# @return   0   Success
#           1   Error
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
##
# @fn       getDistroName()
# @brief    Get Linux distro name.
# @param    none
# @return   Distro name or Variant name.
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
##
# @fn       libSetup( $@ )
# @brief    Parse command line parameters.
# @param    $@      Arguments to parsing.
# @return   0       Success
#           1..N    Error code.
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
##
# @fn       libInit( $@ )
# @brief    Initialize library variables.
# @param    $@      Arguments to parsing.
# @return   0       Success
#           1..N    Error code.
function libInit()
{
    local err=0
    if [ $# -gt 0 ]
    then
        libSetup "$@"
        err=$?
    fi
    libTMP="$(getTempDir)"
    logFILE="$(getLogFilename)"
    return $err
}

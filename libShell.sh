#MD # libShell

#MD **Description**: Shell Script Library.
#MD **File**       : libShell.sh
#MD **Author**     : Leandro - leandrohuff@programmer.net
#MD **Date**       : 2025-09-10
#MD **Version**    : 2.2.3
#MD **Copyright**  : CC01 1.0 Universal
#MD **Details**    : Formatted script file to service as a shell function library.
#MD            Let a rapid shell script development with a list of common and
#MD            most used functions.

#MD ### Constants

#MD *integer* **libSTARTIME** = *timeseconds*
declare -i -r libSTARTIME=$(( $(date +%s%N) / 1000000 ))
#MD *vector integer* **libVERSION** = *(2 2 3)*
declare -a -i -r libVERSION=(2 2 3)
#MD *vector integer* **libDATE** = *(2025 9 10)*
declare -a -i -r libDATE=(2025 9 10)
#MD *integer* **logQUIET** = *0*
declare -i -r logQUIET=0
#MD *integer* **logDEFAULT** = *1*
declare -i -r logDEFAULT=1
#MD *integer* **logVERBOSE** = *2*
declare -i -r logVERBOSE=2
#MD *integer* **logFULL** = *3*
declare -i -r logFULL=3
#MD *integer* **logTOSCREEN** = *16*
declare -i -r logTOSCREEN=16
#MD *integer* **logTOFILE** = *32*
declare -i -r logTOFILE=32
#MD *vector string* **typeRANDOM** = *(alpha digit alnum lowhex uphex mixhex random space date)*
declare -a -r typeRANDOM=(alpha digit alnum lowhex uphex mixhex random space date)

#MD #### Color Codes

#MD *string* **NC** = *'\033[0m'*
declare -r NC='\033[0m'
#MD *string* **BLACK** = *'\033[30m'*
declare -r BLACK='\033[30m'
#MD *string* **RED** = *'\033[31m'*
declare -r RED='\033[31m'
#MD *string* **GREEN** = *'\033[32m'*
declare -r GREEN='\033[32m'
#MD *string* **YELLOW** = *'\033[33m'*
declare -r YELLOW='\033[33m'
#MD *string* **BLUE** = *'\033[34m'*
declare -r BLUE='\033[34m'
#MD *string* **MAGENTA** = *'\033[35m'*
declare -r MAGENTA='\033[35m'
#MD *string* **CYAN** = *'\033[36m'*
declare -r CYAN='\033[36m'
#MD *string* **GRAY** = *'\033[37m'*
declare -r GRAY='\033[37m'
#MD *string* **DGRAY** = *'\033[90m'*
declare -r DGRAY='\033[90m'
#MD *string* **HRED** = *'\033[91m'*
declare -r HRED='\033[91m'
#MD *string* **HGREEN** = *'\033[92m'*
declare -r HGREEN='\033[92m'
#MD *string* **HYELLOW** = *'\033[93m'*
declare -r HYELLOW='\033[93m'
#MD *string* **HBLUE** = *'\033[94m'*
declare -r HBLUE='\033[94m'
#MD *string* **HMAGENTA** = *'\033[95m'*
declare -r HMAGENTA='\033[95m'
#MD *string* **HCYAN** = *'\033[96m'*
declare -r HCYAN='\033[96m'
#MD *string* **WHITE** = *'\033[97m'*
declare -r WHITE='\033[97m'

#MD ### Variables

#MD *boolean* **flagDEBUG** = *false*
declare flagDEBUG=false
#MD *boolean* **flagTRACE** = *false*
declare flagTRACE=false
#MD *integer* **logTARGET** = *\$logQUIET*
declare -i logTARGET=$logQUIET
#MD *integer* **logLEVEL** = *\$logQUIET*
declare -i logLEVEL=$logQUIET
#MD *string* **libTMP** = *''*
declare libTMP=''
#MD *string* **logFILE** = *''*
declare logFILE=''
#MD *integer* **libTIMEOUT** = *10*
declare -i libTIMEOUT=10

#MD ### Functions

#MD *none* **getScriptName**( **none** ) : *string*    - Get script name.
function getScriptName() { echo -n "$(basename $0)" ; }
#MD *integer* **getFileName**( *string* **path/filename.extension** ) : *string*    - Get file name from parameter.
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
#MD *integer* **getName**( **none** ) : *string*    - Get only name from a filename parameter.
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
#MD *integer* **getExt**( *string* **filename.extension** ) : *string*    - Get only extension from filename parameter.
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
#MD *integer* **getPath**( *string* **path/filename** ) : *string*    - Get only path from filename parameter.
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
#MD *none* **getTempDir**( **none** ) : *string*    - Get temporary directory.
function getTempDir() { [ -d '/tmp' ] && echo -n '/tmp' || echo "$HOME" ; }
#MD *integer* **genRandomAlpha**( *integer* **length** ) : *string*    - Generate randomic alpha string.
function genRandomAlpha() { [ -n "$1" ] && tr < /dev/urandom -d -c "[:alpha:]" | head --bytes=$1 || return 1 ; }
#MD *integer* **genRandomNumeric**( *integer* **length** ) : *string*    - Generate randomic numeric string.
function genRandomNumeric() { [ -n "$1" ] && tr < /dev/urandom -d -c "[:digit:]" | head --bytes=$1 || return 1 ; }
#MD *integer* **genRandomAlphaNumeric**( *integer* **length** ) : *string*    - Generate randomic alpha numeric string.
function genRandomAlphaNumeric() { [ -n "$1" ] && tr < /dev/urandom -d -c "[:alnum:]" | head --bytes=$1 || return 1 ; }
#MD *integer* **genRandomLowerHexadecimalNumber**( *integer* **length** ) : *string*    - Generate randomic lower case hexadecimal number string.
function genRandomLowerHexadecimalNumber() { [ -n "$1" ] && tr < /dev/urandom -d -c "[:digit:]a-f" | head --bytes=$1 || return 1 ; }
#MD *integer* **genRandomUpperHexadecimalNumber**( *integer* **length** ) : *string*    - Generate randomic upper caes hexadecimal number string.
function genRandomUpperHexadecimalNumber() { [ -n "$1" ] && tr < /dev/urandom -d -c "[:digit:]A-F" | head --bytes=$1 || return 1 ; }
#MD *integer* **genRandomHexadecimalNumber**( *integer* **length** ) : *string*    - Generate randomic mixed lower and upper case hexadecimal number string.
function genRandomHexadecimalNumber() { [ -n "$1" ] && tr < /dev/urandom -d -c "[:xdigit:]" | head --bytes=$1 || return 1 ; }
#MD *integer* **genRandomString**( *integer* **length** ) : *string*    - Generate Randomic graph char string.
function genRandomString() { [ -n "$1" ] && tr < /dev/urandom -d -c "A-Za-z0-9\'\"\`~^?!;:.,@#$%&{[(<>)]}_=\+\-\*/\\|" | head --bytes=$1 || return 1 ; }
#MD *integer* **genRandomStringSpace**( *integer* **length** ) : *string*    - Generate randomic graph char and space string.
function genRandomStringSpace() { [ -n "$1" ] && tr < /dev/urandom -d -c "A-Za-z0-9\'\"\`~^?!;:.,@#$%&{[(<>)]}_=\+\-\*/\\| " | head --bytes=$1 || return 1 ; }
#MD *none* **genDateTimeAsCode**( **none** ) : *string*    - Generate a formatted date and time string code.
function genDateTimeAsCode() { echo -n $(date '+%Y-%m-%d-%H-%M-%S-%3N') ; }
#MD *none* **getDateTime**( **none** ) : *string*    - Generate a formatted date string.
function getDate() { echo -n "$(date '+%Y-%m-%d')" ; }
#MD *none* **getDateTime**( **none** ) : *string*    - Generate a formatted time string.
function getTime() { echo -n "$(date '+%H:%M:%S.%3N')" ; }
#MD *none* **getDateTime**( **none** ) : *string*    - Generate a formatted date and time string.
function getDateTime() { echo -n "$(getDate) $(getTime)" ; }
#MD *none* **getLibVersionStr**( **none** ) : *string*    - Get libShell version number as string
function getLibVersionStr() { genVersionStr ${libVERSION[@]} ; }
#MD *none* **getLibVersionNum**( **none** ) : *string*    - Get libShell version as a numer.
function getLibVersionNum() { echo -n $(genVersionNum ${libVERSION[@]}) ; }
#MD *none* **printLibVersion**( **none** ) : *string*    - Print formatted libShell string version.
function printLibVersion() { echo -e "libShell Version: ${GRAY}$(getLibVersionStr)${NC}" ; }
#MD *none* **getLibDateVersionStr**( **none** ) : *string*    - Get libShell date number as string.
function getLibDateVersionStr() { genDateVersionStr ${libDATE[@]} ; }
#MD *none* **getLibDateVersionNum**( **none** ) : *string*    - Get libShell date as a numer.
function getLibDateVersionNum() { echo -n $(genDateVersionNum ${libDATE[@]}) ; }
#MD *none* **printLibDate**( **none** ) : *string*   - Print formatted libShell string date.
function printLibDate() { echo -e "libShell Date ${GRAY}$(getLibDateVersionStr)${NC}" ; }
#MD *none* **getRuntime**( **param** ) : *string*    - Get runtime number.
function getRuntime() { echo -n $(( $(date +%s%N) / 1000000 )) ; }
#MD *none* **getLogFilename**( **none** ) : *string*    - Get log path and filename.
function getLogFilename() { echo -n "$(getTempDir)/$(getScriptName).log" ; }
#MD *boolean* **isConnected**( **none** ) : *none*   - Check is the internet connecton ative.
function isConnected() { ping '8.8.8.8' -q -t 30 -c 1 > /dev/null 2>&1 && true || false ; }
#MD *boolean* **isEmpty**( *string* **variable** ) : *none*    - Check empty parameter.
function isEmpty() { if [ -n "$1" ] ; then false ; else true ; fi ; }
#MD *boolean* **notEmpty**( *string* **variable** ) : *none*    - Check not empty parameter.
function notEmpty() { if [ -n "$1" ] ; then true ; else false ; fi ; }
#MD *boolean* **isLink**( *string* **link** ) : *none*    - Check if parameter is a link to file or directory.
function isLink() { if [ -L "$1" ] ; then true ; else false ; fi ; }
#MD *boolean* **isFile**( *string* **file** ) : *none*    - Check parameter is a regualr file.
function isFile() { if [ -f "$1" ] ; then true ; else false ; fi ; }
#MD *boolean* **isDir**( *string* **dir** ) : *none*    - Check if parameter is a directory
function isDir() { if [ -d "$1" ] ; then true ; else false ; fi ; }
#MD *boolean* **isBlockDevice**( *string* **device** ) : *none*    - Check if parameter for block device.
function isBlockDevice() { if [ -b "$1" ] ; then true ; else false ; fi ; }
#MD *integer* **followLink**( *string* **link** ) : *string*    - Follow link and get target file.
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
#MD *boolean* **isYes**( *string* **variable** ) : *none*    - Check parameter is affirmative.
function isYes() { case "$1" in [yY] | [yY][eE][sS]) true ;; *) false ;; esac ; }
#MD *boolean* **isNot**( *string* **variable** ) : *none*    - Check parameter is negative.
function isNot() { case "$1" in [nN] | [nN][oO] | [nN][oO][tT]) true ;; *) false ;; esac ; }
#MD *boolean* **isFloat**( *string* **variable** ) : *none*    - Check parameter is fa float or double number.
function isFloat() { if [ -n "$( echo -n "$1" | grep -aoP "^[+-]?[0-9]+\.[0-9]+$" )" ] ; then true ; else false ; fi ; }
#MD *boolean* **isInteger**( *string* **variable** ) : *none*    - Check parameter is an integer number.
function isInteger() { [ -n "$(echo "$1" | grep -oP "^[+-]?([0-9]+)$")" ] && true || false ; }
#MD *boolean* **isAlpha**( *string* **variable** ) : *none*    - Check parameter is an alphabetic string.
function isAlpha() { [ -n "$(echo "$1" | grep -oP "^([A-Za-z]+)$")" ] && true || false ; }
#MD *boolean* **isDigit**( *string* **variable** ) : *none*    - Check parameter is a digit number.
function isDigit() { [ -n "$(echo "$1" | grep -oP "^([0-9]+)$")" ] && true || false ; }
#MD *boolean* **isAlphaNumeric**( *string* **variable** ) : *none*    - Check parameter is alphabetic and numberic.string.
function isAlphaNumeric() { [ -n "$(echo "$1" | grep -oP "^([A-Za-z0-9]+)$")" ] && true || false ; }
#MD *boolean* **isHexadecimalNumber**( *string* **variable** ) : *none*    - Check parameter is a hexadecimal string
function isHexadecimalNumber() { [ -n "$(echo "$1" | grep -oP "^([0-9A-Fa-f]+)$")" ] && true || false ; }
#MD *boolean* **isLowerHexadecimalNumber**( *string* **variable** ) : *none*    - Check parameter is a lower case hexadecimal string.
function isLowerHexadecimalNumber() { [ -n "$(echo "$1" | grep -oP "^([0-9a-f]+)$")" ] && true || false ; }
#MD *boolean* **isUpperHexadecimalNumber**( *string* **variable** ) : *none*    - Check parameter is a upper case hexadecimal string.
function isUpperHexadecimalNumber() { [ -n "$(echo "$1" | grep -oP "^([0-9A-F]+)$")" ] && true || false ; }
#MD *boolean* **isAllGraphChar**( *string* **variable** ) : *none*    - Check parameter is all graphical character into the string.
function isAllGraphChar()
{
    if [ -n "$(echo "$1" | grep -oP "^([A-Za-z0-9\'\"\`¹²³£¢¬§ªº°~^?!;:.,@#$%&{\[(<>)\]}_=+\-*/\\\| ]+)$")" ]
    then
        true
    else
        false
    fi
}
#MD *integer err* **strLength**( *string* **variable** ) : *integer length*    - Get string length.
function strLength()
{
    local res=$(bin/strlen "$1")
    local err=$?
    echo -n "$res"
    return $err
}
#MD *integer* **strCompare**( *string* **text 1** , *string* **text 2** ) : *integer*    - Compare string and return -N, 0 , +N
function strCompare()
{
    local res=$(bin/strcmp "$1" "$2")
    local err=$?
    echo -n "$res"
    return $err
}
#MD *integer* **compareFloat**( *string* **number 1** , *string* **number 2** ) : *integer*    - Compare float numbers and return -1,0,1
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
#MD *integer* **subFloat**( *string* **number 1** , *string* **number 2** ) : *string*    - Add 2 flaot numbers.
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
#MD *integer* **subFloat**( *string* **number 1** , *string* **number 2** ) : *string*    - Subtract 2 float number.
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
#MD *integer* **multiplyFloat**( *string* **float number** , *string* **float divisor** ) : *string*    - Multiply 2 float numbers.
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
#MD *integer* **divFloat**( *string* **float number** , *string* **float divisor** ) : *string*    - Divide 2 float numbers.
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
#MD *integer* **isFloatInRange**( *string* **float number** , *string* **float min** , *string* **float max** ) : *integer*    - Check is float number between 2 float min and max numbers value.
function isFloatInRange()
{
    local res=$(bin/isFloatInRange "$1" "$2" "$3")
    local err=$?
    echo -n "$res"
    return $err
}
#MD *integer* **gitBranchName**( *string* **repository** ) : *string*    - Get current git branch name.
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
#MD *integer* **gitCountAdded**( *string* **repository** ) : *integer*    - Get git added files counter.
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
#MD *integer* **gitCountModified**( *string* **repository** ) : *integer*    - Get git modified files counter.
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
#MD *integer* **gitCountDeleted**( *string* **repository** ) : *integer*    - Get git deleted files counter.
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
#MD *boolean* **isGitRepository**( *string* **repository** ) : *none*    - Check is a git repository.
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
#MD *inreger* **gitRepositoryName**( *string* **repository** ) : *string*    - Get git repository name.
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
#MD *boolean* **isGitChanged**( *string* **repository** ) : *none*    - Check repository git files changed.
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
#MD *boolean* **existBranch**( *string* **branch** ) : *none*    - Check repository have branch in its list.
function existBranch()
{
    local res
    [ -n "$1" ] || { logF "Empty parameter for existBranch(\$1)" ; return 1 ; }
    res=$(git branch | grep -oF "$1" > /dev/null 2>&1)
    [ $? -eq 0 ] && true || false
}
#MD *boolean* **inBranch**( *string* **branch** ) : *none*    - Check if respository is current branch.
function inBranch()
{
    local res
    [ -n "$1" ] || { logF "Empty parameter for inBranch(\$1)" ; return 1 ; }
    res=$(git branch --show-current | grep -oF "$1" > /dev/null 2>&1)
    [ $? -eq 0 ] && true || false
}
#MD *integer* **gitAdd**( *string* **files** ) : *none*    - Git add files to repository.
function gitAdd()
{
    local res
    [ -n "$1" ] || { logF "Empty parameter for gitAdd(\$1)" ; return 1 ; }
    res=$(git add "$1" > /dev/null 2>&1)
    return $?
}
#MD *integer* **gitCommitNotSigned**( *string* **message** ) : *none*    - Git not signed commit repository with a message.
function gitCommitNotSigned()
{
    local res
    [ -n "$1" ] || { logF "Empty parameter for gitNotSignCommit(\$1)" ; return 1 ; }
    res=$(git commit -m \""$1"\" > /dev/null 2>&1)
    return $?
}
#MD *integer* **gitCommitSigned**( *string* **message** ) : *none*    - Git signed commit repository with a message.
function gitCommitSigned()
{
    local res
    [ -n "$1" ] || { logF "Empty parameter for gitSignCommit(\$1)" ; return 1 ; }
    res=$(git commit -s -m \""$1"\" > /dev/null 2>&1)
    return $?
}
#MD *integer* **gitFetch**( **none** ) : *none*    - Git fetch current branch.
function gitFetch()
{
    local res
    res=$(git fetch origin HEAD > /dev/null 2>&1)
    return $?
}
#MD *integer* **gitPull**( **none** ) : *none*    - Git pull current branch.
function gitPull()
{
    local res
    res=$(git pull origin HEAD > /dev/null 2>&1)
    return $?
}
#MD *integer* **gitPush**( **none** ) : *none*    - Git push current branch.
function gitPush()
{
    local res
    res=$(git push origin HEAD > /dev/null 2>&1)
    return $?
}
#MD *integer* **gitSetUpstream**( **none** ) : *none*    - Set branch up stream for push commands.
function gitSetUpstream()
{
    local res
    res=$(git push --set-upstream origin > /dev/null 2>&1)
    return $?
}
#MD *integer* **newBranch**( *string* **branch** ) : *none*    - Createt new branch.
function newBranch()
{
    local res
    [ -n "$1" ] || { logF "Empty parameter for newBranch(\$1)" ; return 1 ; }
    res=$(git branch "$1" > /dev/null 2>&1)
    return $?
}
#MD *integer* **gitSwitch**( *string* **branch** ) : *none*    - Switch to branch name.
function gitSwitch()
{
    local res
    [ -n "$1" ] || { logF "Empty parameter for gitSwitch(\$1)" ; return 1 ; }
    res=$(git switch "$1" > /dev/null 2>&1)
    return $?
}
#MD *integer* **createBranch**( *string* **branch** ) : *none*    - Create a new git branch and switch to it.
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
#MD *boolean* **linkExist**( *string* **link** ) : *none*    - Check if link referenced exist.
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
#MD *boolean* **itExist**( *string* **link** ) : *none*    - Check if file or directory or link reference exist.
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
#MD *integer* **getID**( **none** ) : *string*    - Get ID from os-release file.
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
#MD *integer* **genVersionStr**( *vector integer* **version** ) : *result*    - Generate version string from parameter.
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
#MD *integer* **genVersionNum**( *vector integer* **version** ) : *result*    - Generate version number from parameter.
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
#MD *integer* **genDateVersionStr**( *vector integer* **date_version** ) : *string*    - Generate date version string from parameter.
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
#MD *integer* **genDateVersionNum**( *vector integer* **date_version** ) : *integer*    - Generate date version number from parameter.
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
#MD *boolean* **isLogQuiet**( **none** ) : *none*    - Check is log quiet enabled.
function isLogQuiet()
{
    if [ $logLEVEL -eq $logQUIET ]
    then
        true
    else
        false
    fi
}
#MD *boolean* **isLogDefault**( **none** ) : *none*    - Check is log default enabled.
function isLogDefault()
{
    if [ $logLEVEL -eq $logDEFAULT ]
    then
        true
    else
        false
    fi
}
#MD *boolean* **isLogVerbose**( **none** ) : *none*    - Check verbose log enabled.
function isLogVerbose()
{
    if [ $logLEVEL -eq $logVERBOSE ]
    then
        true
    else
        false
    fi
}
#MD *boolean* **isLogToScreenEnabled**( **none** ) : *none*    - Check log to screen enabled.
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
#MD *boolean* **isLogToFileEnabled**( **none** ) : *none*    - Check log to file enabled.
function isLogToFileEnabled()
{
    if [ $logTARGET -ge $logTOFILE ]
    then
        true
    else
        false
    fi
}
#MD *boolean* **isLogEnabled**( **none** ) : *none*    - Check log enabled (screen or file and not quiet).
function isLogEnabled()
{
    if [ $logTARGET -gt $logQUIET ] && [ $logLEVEL -gt $logQUIET ]
    then
        true
    else
        false
    fi
}

#MD ### Log Functions Table

#MD | Function | Description   | Level   |
#MD |:--------:|:-------------:|:-------:|
#MD | logU     | Unconditional | none    |
#MD | logIt    | Anything      | enabled |
#MD | logI     | Info          | normal  |
#MD | logR     | Runtime       | normal  |
#MD | logE     | Error         | normal  |
#MD | logF     | Failure       | normal  |
#MD | logS     | Success       | verbose |
#MD | logV     | Verbose Info  | verbose |
#MD | logW     | Warning       | verbose |
#MD | logD     | Debug         | debug   |
#MD | logT     | Trace         | trace   |

#MD *none* **logU**( *string* **message** ) : *string*    - Log anything unconditional to screen and file.
function logU() { echo -e "$*" ; }
#MD *none* **logIt**( *string* **message** ) : *string*    - Log anything according to log flags.
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
#MD *none* **logI**( *string* **message** ) : *string*    - Info logs.
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
#MD *none* **logE**( *string* **message** ) : *string*    - Error logs.
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
#MD *none* **logF**( *string* **message** ) : *string*    - Failure logs.
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
#MD *none* **logR**( *string* **message** ) : *string*    - Runtime logs.
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
#MD *none* **logS**( *string* **message** ) : *string*    - Success logs.
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
#MD *none* **logV**( *string* **message** ) : *string*    - Verbose info logs.
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
#MD *none* **logW**( *string* **message** ) : *string*    - Warning logs.
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
#MD *none* **logD**( *string* **message** ) : *string*    - Debug logs.
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
#MD *none* **logT**( *string* **message** ) : *string*    - Trace logs.
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
#MD *integer* **getRuntimeStr**( **none** ) : *string*    - Generate|Get runtime string.
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
#MD *boolean* **isParameter**( *string* **parameter** ) : *result*    - Check command line parameter is a true parameter.
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
#MD *boolean* **isArgValue**( *string* **argv** ) : *none*    - Check command line parameter is a true value.
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
#MD *integer* **unsetLibVars**( **none** ) : *none*    - Unset library variables.
function unsetLibVars()
{
    unset -v flagDEBUG
    unset -v flagTRACE
    unset -v logLEVEL
    unset -v lOGTARGET
    unset -v libTIMEOUT
    return 0
}
#MD *integer* **libStop**( **none** ) : *none*    - Stop|End library execution.
function libStop()
{
    unsetLibVars
    return 0
}
#MD *integer* **printLibHelp**( **none** ) : *string*    - Print library help information.
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
#MD *integer* **genRandom**( *string* **type** , *integer* **length** ) : *string*    - Generate an random string according parameter length.
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
#MD *integer* **genUUID**( *string* **type** , *integer* **length** ) : *string*    - Generate an random string according parameters.
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
#MD *none* **getMountDir**( **none** ) : *string*    - Get mount directory string.
function getMountDir()
{
    if   [ -d /media     ] ; then echo -n "/media"
    elif [ -d /run/media ] ; then echo -n "/run/media"
    else                          echo -n "/mnt"
    fi
}
#MD *integer* **logBegin**( **none** ) : *none*    - Begin|Start log to file.
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
#MD *integegr* **logEnd**( **none** ) : *result*    - End|Stop log to file.
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
#MD *integer* **askToContinue**( *integer* **timetou** , *string* **message** ) : *none*    - Print a message and ask user to continue and get the answer.
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
#MD *integer* **wait**( *integer* **timeout** , *string* **message** ) : *none*    - Print a message and wait user to continue.
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
#MD *integer* **loadID**( **none** ) : *result*    - Source /etc/os-release file.
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
#MD *integer* **function**( **none** ) : *string*    - Get Linux distro name.
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
#MD *integer* **libSetup**( *vector string* **[@]** ) : *none*    - Setup libShell.
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
#MD *integer* **libInit**( *vector string* **[@]** ) : *none*    - Initialize libShell.
function libInit()
{
    local err=0
    libTMP="$(getTempDir)"
    logFILE="$(getLogFilename)"
    [ $# -eq 0 ] || { libSetup "$@" || return $? ; }
    return 0
}

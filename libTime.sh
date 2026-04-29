################################################################################
# @file         libTemplate.sh
# @brief        Source variables and functions to add wait states and ask for user
#               confirmation in a bash source code.
# @author:      Leandro D. Huff
# @copyright:   https://creativecommons.org/licenses/by/4.0/
# @sintaxe:     source libTime.sh
################################################################################

# Must be sourced not running
[[ "${BASH_SOURCE[0]}" == "${0}" ]] && { echo -e "\033[91mfailure\033[0m: $(basename $0) must be sourced not running." ; exit 1 ; }

declare -i libTimeout=10

## @brief   Filter and validate integer numbers from a string.
declare reINT='[+-]?\d+'

## @brief   Filter and validate float numbers from a string.
declare reNUM='[-+]?(\d+\.?\d*|\d*\.\d+)([eE][+-]?0*[1-9]+\d*)?'

## @brief   Check parameter for 'yes' confirmation.
function _isYes() { case "$1" in [yY] | [yY][eE][sS]) true ;; *) false ;; esac ; }

## @brief   Check parameter for 'no|not' confirmation.
function _isNot() { case "$1" in [nN] | [nN][oO] | [nN][oO][tT]) true ;; *) false ;; esac ; }

## @brief   Check parameter for a number.
function _isNumber() { if echo -n "${1}" | grep -qaoP "^${reNUM}$" > /dev/null 2>&1 ; then true ; else false ; fi ; }

## @brief   Check a parameter for an integer number.
function _isInteger() { if echo -n "${1}" | grep -qaoP "^${reINT}$" > /dev/null 2>&1 ; then true ; else false ; fi ; }

## @brief   Ask user to confirm question.
function ask()
{
    local tout="${1:-0}"
    local msg="${2:-'Continue [y|Y]? '}"
    local ret ans=''
    read -r -s -N 1 -n 1 $([ $tout -gt 0 ] && echo -n "-t $1") -p "${msg}" ans
    ret=$?
    echo -n "${ans}"
    return $ret
}

## @brief   Ask user to confirm quention about to continue or not.
function askToContinue()
{
    local tout="${1:-0}"
    local msg="${2:-'Continue [y|Y]? '}"
    local ret answer err=1
    answer=$(ask $tout "${msg}")
    ret=$?
    echo
    if [ $ret -eq 0 ] && _isYes $answer ; then err=0 ; fi
    return $err
}

## @brief   Print an usage help message.
function libTimeUsage()
{
    cat << EOT
Bash script libTime source function for wait and times.
Usage: source libTime.sh [options]
       libTimeSetup [options]
Options:
-h|--help               Show help message.
-t|--timeout <time>     Set new timeout in seconds.
EOT
}

## @brief   Setup lib time to change default timeout.
function libTimeSetup()
{
    local err=0
    while [ $# -gt 0 ] && [ -n "$1" ]
    do
        case $1 in
        -h|--help) libTimeUsage ; break ;;
        -t|--timeout)
            if _isInteger "$2"
            then
                shift
                libTimeout=$1
            else
                err=1
                break
            fi
            ;;
        -*) err=2 ; break ;;
         *) err=3 ; break ;;
        esac
        shift
    done
    return $err
}

## @brief   Exit from lib time and unload all variables and functions.
function libTimeExit()
{
    unset -v libTime
    unset -v libTimeout
    unset -f _isNum
    unset -f _isInt
    unset -f _isNot
    unset -f _isYes
    unset -f wait
    unset -f askToContinue
    unset -f libTimeSetup
    unset -f libTimeUsage
    unset -f libTimeIsArg
    unset -f libTimeExit
    return 0
}

## @brief   Variable to check if lib time was loaded.
declare libTime='loaded'

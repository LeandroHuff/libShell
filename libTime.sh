################################################################################
# @file         libTemplate.sh
# @brief        Source variables and functions to add wait states and ask for user
#               confirmation in a bash source code.
# @author:      Leandro D. Huff
# @copyright:   https://creativecommons.org/licenses/by/4.0/
# @sintaxe:     source libTime.sh
################################################################################

# Must be sourced not running
[[ "${BASH_SOURCE[0]}" == "${0}" ]] && exit 1

declare libTime=''

declare -i libTimeout=10

function _isNum() { if echo -n "${1}" | grep -aoP '^[-+]?(\d+\.?\d*|\d*\.\d+)$' > /dev/null 2>&1 ; then true ; else false ; fi ; }
function _isInt() { if echo -n "${1}" | grep -aoP '^[+-]?\d+$' > /dev/null 2>&1 ; then true ; else false ; fi ; }
function _isNot() { case "$1" in [nN] | [nN][oO] | [nN][oO][tT]) true ;; *) false ;; esac ; }
function _isYes() { case "$1" in [yY] | [yY][eE][sS])            true ;; *) false ;; esac ; }
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

function libTimeIsArg() { if [ -n "$1" ] ; then case $1 in -*) false ;; *) true ;; esac ; else false ; fi ; }

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

function libTimeSetup()
{
    local err=0
    while [ $# -gt 0 ] && [ -n "$1" ]
    do
        case $1 in
        -h|--help) libTimeUsage ; break ;;
        -t|--timeout)
            if _isInt "$2"
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

libTime='loaded'

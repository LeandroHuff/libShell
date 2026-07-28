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

declare -i libTimeOut=10

## @brief   Check parameter for 'yes' confirmation.
function libTimeIsYES() { case "$1" in [yY] | [yY][eE][sS]) true ;; *) false ;; esac ; }

## @brief   Ask user to confirm question.
function libTimeAsk()
{
    local tout="${1:-0}"
    local msg="${2:-Continue [y|Y]? }"
    local ret ans=''
    read -r -s -N 1 -n 1 `[ $tout -gt 0 ] && echo -n "-t $1"` -p "${msg}" ans
    ret=$?
    echo -n "${ans}"
    return $ret
}

## @brief   Ask user to confirm quention about to continue or not.
function libTimeAskToContinue()
{
    local tout="${1:-0}"
    local msg="${2:-Continue [y|Y]? }"
    local ret answer err=1
    read -r -s -N 1 -n 1 $([ $tout -gt 0 ] && echo -n "-t $1") -p "${msg}" answer
    ret=$?
    echo
    if [ $ret -eq 0 ] && libTimeIsYES $answer ; then err=0 ; fi
    return $err
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
            if echo -n "${2}" | grep -qaoP '[+-]?\d+'
            then
                shift
                libTimeOut=$1
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

##  @brief  Exit from libTime, unload all variables and functions.
function libTimeExit()
{
    # unset variables
    unset -v libTimeOut
    # unset functions
    unset -f libTimeIsYES
    unset -f libTimeAsk
    unset -f libTimeAskToContinue
    unset -f libTimeSetup
}

declare libTime='loaded'

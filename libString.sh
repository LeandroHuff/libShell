################################################################################
# @file         libString.sh
# @brief        Source variables and functions to treat and validate strings.
# @author:      Leandro D. Huff
# @copyright:   https://creativecommons.org/licenses/by/4.0/
# @sintaxe:     source libString.sh
################################################################################

# Must be sourced not running
[[ "${BASH_SOURCE[0]}" == "${0}" ]] && { echo -e "\033[91mfailure\033[0m: $(basename $0) must be sourced not running." ; exit 1 ; }

## @brief   Generate version string from integer array.
function genVersionStr() { local vector=("${@}") ; echo -n "${vector[0]}.${vector[1]}.${vector[2]}" ; }

## @brief   Generate version integer from integer array.
function genVersionNum() { local vector=("${@}") ; echo -n $((vector[0]*100 + vector[1]*10 + vector[2])) ; }

## @brief   Generate date version string from a date integers array.
function genDateVersionStr() { local vector=("${@}") ; printf "%04d-%02d-%02d" ${vector[0]} ${vector[1]} ${vector[2]} ; }

## @brief   Generate date integer version from date array integers.
function genDateVersionNum() { local vector=("${@}") ; echo -n $((vector[0]*1000000 + vector[1]*1000 + vector[2])) ; }

## @brief   Check parameter for 'yes' confirmation.
function isYes() { case "$1" in [yY] | [yY][eE][sS]) true ;; *) false ;; esac ; }

## @brief   Check parameter for 'no|not' confirmation.
function isNot() { case "$1" in [nN] | [nN][oO] | [nN][oO][tT]) true ;; *) false ;; esac ; }

## @brief   Check for empty parameter.
function isEmpty()  { if [ -n "$1" ] ; then false ; else true  ; fi ; }

## @brief   Get date string, format YYYY-mm-dd
function notEmpty() { if [ -n "$1" ] ; then true  ; else false ; fi ; }

## @brief   Parameter from command line.
function isParam()  { if echo -n "$1" | grep -qaoP '^-{1}(\w|(-?\d+)|(-_*\w{2,}))$'; then true; else false; fi; }

## @brief   Argument from command line.
function isArg()  { if echo -n "$1" | grep -qaoP '^((-?\d+)|([\w+]))$'; then true; else false; fi; }

## @brief   Get date string, format YYYY-mm-dd
function getDate() { echo -n "$(date '+%Y-%m-%d')" ; }

## @brief   Get time string, format HH:MM:SS
function getTime() { echo -n "$(date '+%H:%M:%S')" ; }

## @brief   Get date and time string.
function getDateTime() { echo -n "$(getDate) $(getTime)" ; }

## @brief   Get tag name from a string parameter as tag=value
function getTag() { echo -n "${1%=*}" ; }

## @brief   Get value from a string parameter as tag=value
function getValue() { echo -n "${1##*=}" ; }

## @brief   Get string length.
function strLen(){ echo -n ${#1} ; }

## @brief   Compare string and return -1|0|1 for less, equal or greater.
function cmpStr()
{
    if   [ "$1" \< "$2" ] ; then echo -n -1
    elif [ "$1" \> "$2" ] ; then echo -n  1
    else echo -n 0
    fi
}

## @brief   Add prefix to parameter list.
function addPrefix()
{
    [ -n "${1}" ] || return 1
    local prefix="$1"
    shift
    local join=''
    declare -a res=()
    while [ -n "$1" ]
    do
        join="${prefix}${1}"
        res+=("${join}")
        shift
    done
    echo -n ${res[@]}
    return 0
}


## @brief   Add suffix to parameter list.
function addSuffix()
{
    [ -n "${1}" ] || return 1
    local sufix="$1"
    shift
    local join=''
    declare -a res=()
    while [ -n "$1" ]
    do
        join="${1}${sufix}"
        res+=("${join}")
        shift
    done
    echo -n ${res[@]}
    return 0
}

## @brief   Add prefix and suffix to parameter list.
function addPrefixSuffix()
{
    [ -n "${1}" ] || return 1
    [ -n "${2}" ] || return 1
    local prefix="$1"
    local sufix="$2"
    shift 2
    local join=''
    declare -a res=()
    while [ -n "$1" ]
    do
        join="${prefix}${1}${sufix}"
        res+=("${join}")
        shift
    done
    echo -n ${res[@]}
    return 0
}

## @brief   Exit from lib and unload all variables and functions.
function libStringExit()
{
    unset -v libString
    unset -f genVersionStr
    unset -f genVersionNum
    unset -f genDateVersionStr
    unset -f genDateVersionNum
    unset -f isYes
    unset -f isNot
    unset -f isEmpty
    unset -f notEmpty
    unset -f isParam
    unset -f isArg
    unset -f getTag
    unset -f getValue
    unset -f getDate
    unset -f getTime
    unset -f getDateTime
    unset -f strLen
    unset -f cmpStr
    unset -f addPrefix
    unset -f addSuffix
    unset -f addPrefixSuffix
    unset -f libStringExit
    return 0
}

## @brief   Check if libRegex is loaded and available.
declare libString='loaded'

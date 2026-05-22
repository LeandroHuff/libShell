################################################################################
# @file         libRandom.sh
# @brief        Source variables and functions to generate randomic strings.
# @author:      Leandro D. Huff
# @copyright:   https://creativecommons.org/licenses/by/4.0/
# @sintaxe:     source libRandom.sh
################################################################################

# Must be sourced not running
[[ "${BASH_SOURCE[0]}" == "${0}" ]] && { echo -e "\033[91mfailure\033[0m: $(basename $0) must be sourced not running." ; exit 1 ; }

declare libRandom=''

declare -a typeRANDOM=(alpha digit alnum lowhex uphex mixhex graph space date)

# Functions
function _isInteger() { if echo -n "${1}" | grep -aoP '^[+-]?\d+$' > /dev/null 2>&1 ; then true ; else false ; fi ; }

## @brief   Generate a randomic alphabetic caracters with length size by parameter.
function genRandomAlpha() { if _isInteger "$1" ; then tr < /dev/urandom -d -c [:alpha:] | head --bytes=$1 ; else return 1 ; fi ; }

## @brief   Generate a randomic numeric string with length size by parameter.
function genRandomNumeric() { if _isInteger "$1" ; then tr < /dev/urandom -d -c [:digit:] | head --bytes=$1 ; else return 1 ; fi ; }

## @brief   Generate a randomic alphanumeric string with length size by parameter.
function genRandomAlphaNumeric() { if _isInteger "$1" ; then tr < /dev/urandom -d -c [:alnum:] | head --bytes=$1 ; else return 1 ; fi ; }

## @brief   Generate a randomic lower case hexadecimal string with length size by parameter.
function genRandomLowerHexadecimalNumber() { if _isInteger "$1" ; then tr < /dev/urandom -d -c [:digit:]"a-f" | head --bytes=$1 ; else return 1 ; fi ; }

## @brief   Generate a randomic upper case hexadecimal string with length size by parameter.
function genRandomUpperHexadecimalNumber() { if _isInteger "$1" ; then tr < /dev/urandom -d -c [:digit:]"A-F" | head --bytes=$1 ; else return 1 ; fi ; }

## @brief   Generate a randomic lower|upper case hexadecimal string with length size by parameter.
function genRandomHexadecimalNumber() { if _isInteger "$1" ; then tr < /dev/urandom -d -c [:xdigit:] | head --bytes=$1 ; else return 1 ; fi ; }

## @brief   Generate randomic graphic caracters string with length size by parameter.
function genRandomGraph() { if _isInteger "$1" ; then tr < /dev/urandom -d -c [:graph:] | head --bytes=$1 ; else return 1 ; fi ; }

## @brief   Generate randomic graphic and space caracters string with length size by parameter.
function genRandomGraphSpace() { if _isInteger "$1" ; then tr < /dev/urandom -d -c [:graph:][:space:] | head --bytes=$1 ; else return 1 ; fi ; }

##
# @brief    Generate a date and time string as a timestamp code.
# @detail   format: YYYY-mm-dd-HH-MM-SS-NNN
#           where:               Min  Max
#           YYYY: Year        : 0000..9999
#             mm: Month       :   01..12
#             dd: Day         :   01..31
#             HH: Hour        :   00..23
#             MM: Minutes     :   00..59
#             SS: Seconds     :   00..59
#            NNN: Milliseconds:  000..999
#        example: 2026-04-22-19-18-23-328
function genDateTimeAsCode() { echo -n $(date '+%Y-%m-%d-%H-%M-%S-%3N') ; }

##
# @brief    Generate randomic string according to parameters.
# @param    $1      Random type.
# @param    $2      String size.
# @result   string  Randomic string.
# @return   0       Success
#           1       Empty parameter for random type.
#           2       Invalid random type, not in typeRANDOM list.
#           3       Empty string size parameter.
#           4       String size is not an integer parameter.
#           N       Error code to generate randomic string.
function genRandom()
{
    local err=1
    local str=''
    if [ -n "$1" ]
    then
        if [[ "${typeRANDOM[@]}" =~ "$1" ]]
        then
            declare type="$1"
            if [ -n "$2" ] || [ "${type}" = 'date' ]
            then
                if _isInteger "$2" || [ "${type}" = 'date' ]
                then 
                    declare -i len=$2
                    case "$type" in
                    alpha)  str="$(genRandomAlpha                  $len)" ; err=$? ;;
                    digit)  str="$(genRandomNumeric                $len)" ; err=$? ;;
                    alnum)  str="$(genRandomAlphaNumeric           $len)" ; err=$? ;;
                    lowhex) str="$(genRandomLowerHexadecimalNumber $len)" ; err=$? ;;
                    uphex)  str="$(genRandomUpperHexadecimalNumber $len)" ; err=$? ;;
                    mixhex) str="$(genRandomHexadecimalNumber      $len)" ; err=$? ;;
                    graph)  str="$(genRandomGraph                  $len)" ; err=$? ;;
                    space)  str="$(genRandomGraphSpace             $len)" ; err=$? ;;
                    date)   str="$(genDateTimeAsCode)"                  ; err=$? ;;
                    esac
                else
                    err=5
                fi
            else
                err=4
            fi
        else
            err=3
        fi
    else
        err=2
    fi
    echo -n "${str}"
    return $err
}

## @brief   Generate an UUID random hexadecimal number.
function genUUID()
{
    local err=1
    local str=''
    if [ -n "$1" ]
    then
        declare -a typeUUID=(alpha digit alnum lowhex uphex mixhex)
        if [[ "${typeUUID[*]}" =~ "$1" ]]
        then
            local _type="$1"
            shift
            if [ -n "$1" ]
            then
                if _isInteger $1
                then
                    str="$(genRandom ${_type} $1)"
                    err=$?
                    shift
                    [ $err -eq 0 ] || str=''
                    while [ -n "$1" ] && [ $err -eq 0 ]
                    do
                        if _isInteger $1
                        then
                            len=$1
                            str="${str}-$(genRandom $_type $len)"
                            err=$?
                        else
                            str=''
                            err=6
                        fi
                        shift
                    done
                else
                    err=5
                fi
            else
                err=4
            fi
        else
            err=3
        fi
    else
        err=2
    fi
    echo -n "${str}"
    return $err
}

## @brief   Exit from lib and unload all variables and functions.
function libRandomExit()
{
    # local variables
    unset -v libRandom
    unset -v typeRANDOM
    # local functions
    unset -f _isInteger
    unset -f libRandomIsInt
    unset -f genRandomAlpha
    unset -f genRandomNumeric
    unset -f genRandomAlphaNumeric
    unset -f genRandomLowerHexadecimalNumber
    unset -f genRandomUpperHexadecimalNumber
    unset -f genRandomHexadecimalNumber
    unset -f genRandomString
    unset -f genRandomStringSpace
    unset -f genDateTimeAsCode
    unset -f genRandom
    unset -f genUUID
    unset -f libRandomExit
    return 0
}

## @brief   Check if libRandom is loaded and available.
declare libRandom='loaded'

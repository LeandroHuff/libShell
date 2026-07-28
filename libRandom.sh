################################################################################
# @file         libRandom.sh
# @brief        Source variables and functions to generate randomic strings.
# @author:      Leandro D. Huff
# @copyright:   https://creativecommons.org/licenses/by/4.0/
# @sintaxe:     source libRandom.sh
################################################################################

# Must be sourced not running
[[ "${BASH_SOURCE[0]}" == "${0}" ]] && { echo -e "\033[91mfailure\033[0m: $(basename $0) must be sourced not running." ; exit 1 ; }

declare -a typeRANDOM=(alpha digit alphanum lowhex uphex mixhex graph space code)

declare libRandomRegexInt='^\d+$'
function libRandomIsInt() { echo -n "${1}" | grep -qaoP "${libRandomRegexInt}" ; }

## @brief   Generate a randomic alphabetic caracters with length size by parameter.
function genRandomAlpha() { if libRandomIsInt "${1}" ; then tr < /dev/urandom -d -c [:alpha:] | head --bytes=$1 ; else return 1 ; fi ; }

## @brief   Generate a randomic numeric string with length size by parameter.
function genRandomNum() { if libRandomIsInt "${1}" ; then tr < /dev/urandom -d -c [:digit:] | head --bytes=$1 ; else return 1 ; fi ; }

## @brief   Generate a randomic alphanumeric string with length size by parameter.
function genRandomAlphaNum() { if libRandomIsInt "${1}" ; then tr < /dev/urandom -d -c [:alnum:] | head --bytes=$1 ; else return 1 ; fi ; }

## @brief   Generate a randomic lower case hexadecimal string with length size by parameter.
function genRandomLowHex() { if libRandomIsInt "${1}" ; then tr < /dev/urandom -d -c [:digit:]"a-f" | head --bytes=$1 ; else return 1 ; fi ; }

## @brief   Generate a randomic upper case hexadecimal string with length size by parameter.
function genRandomUpHex() { if libRandomIsInt "${1}" ; then tr < /dev/urandom -d -c [:digit:]"A-F" | head --bytes=$1 ; else return 1 ; fi ; }

## @brief   Generate a randomic lower|upper case hexadecimal string with length size by parameter.
function genRandomHex() { if libRandomIsInt "${1}" ; then tr < /dev/urandom -d -c [:xdigit:] | head --bytes=$1 ; else return 1 ; fi ; }

## @brief   Generate randomic graphic caracters string with length size by parameter.
function genRandomGraph() { if libRandomIsInt "${1}" ; then tr < /dev/urandom -d -c [:graph:] | head --bytes=$1 ; else return 1 ; fi ; }

## @brief   Generate randomic graphic and space caracters string with length size by parameter.
function genRandomGraphSpace() { if libRandomIsInt "${1}" ; then tr < /dev/urandom -d -c [:graph:][:space:] | head --bytes=$1 ; else return 1 ; fi ; }

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
#           1       Empty parameter or string size is not an integer.
#           2       Code type is not valid.
#           3       Random type fail.
function genRandom()
{
    declare -i err=1
    declare random=''
    if [ -n "$1" ] && ! [ "$1" = 'code' ] && [ -n "$2" ] && libRandomIsInt "$2"
    then
        case "$1" in
        alpha)    random="$(genRandomAlpha      $2)" ; err=$? ;;
        digit)    random="$(genRandomNum        $2)" ; err=$? ;;
        alphanum) random="$(genRandomAlphaNum   $2)" ; err=$? ;;
        lowhex)   random="$(genRandomLowHex     $2)" ; err=$? ;;
        uphex)    random="$(genRandomUpHex      $2)" ; err=$? ;;
        mixhex)   random="$(genRandomHex        $2)" ; err=$? ;;
        graph)    random="$(genRandomGraph      $2)" ; err=$? ;;
        space)    random="$(genRandomGraphSpace $2)" ; err=$? ;;
        *)                                             err=3 ;;
        esac
    elif [ "$1" = 'code' ]
    then
        random="$(genDateTimeAsCode)"
        err=$?
    else
        err=2
    fi
    echo -n "${random}"
    return $err
}

## @brief   Generate an UUID random hexadecimal number as a format.
# examble:
# genUUID 8 4 4 4 12
# 798c5484-06a0-43e7-9114-597ead18af7b
function genUUID()
{
    declare -i err=1
    declare uuid=''
    # not empty and is an integer
    if [ "x$1" != 'x' ] && echo -n "${1}" | grep -qaoP '^\d+$'
    then
        uuid="$(genRandom lowhex $1)"
        err=$?
        shift
        while [ "x$1" != 'x' ] && [ $err -eq 0 ]
        do
            # is an insteger
            if echo -n "${1}" | grep -qaoP '^\d+$'
            then
                uuid="${uuid}-$(genRandom lowhex $1)"
                err=$?
            else
                err=3
            fi
            shift
        done
    else
        err=2
    fi
    [ $err -eq 0 ] && echo -n "${uuid}" || echo -n ''
    return $err
}

##  @brief  Exit from libRandom, unload all variables and functions.
function libRandomExit()
{
    # unset variables
    unset -v typeRANDOM
    unset -v libRandomRegexInt
    # unset functions
    unset -f libRandomIsInt
    unset -f genRandomAlpha
    unset -f genRandomNum
    unset -f genRandomAlphaNum
    unset -f genRandomLowHex
    unset -f genRandomUpHex
    unset -f genRandomHex
    unset -f genRandomGraph
    unset -f genRandomGraphSpace
    unset -f genDateTimeAsCode
    unset -f genRandom
    unset -f genUUID
}

declare libRandom='loaded'

################################################################################
# @file         libLog.sh
# @brief        Source variables and functions to calculate most common mathematics
#               espressions.
# @author:      Leandro D. Huff
# @copyright:   https://creativecommons.org/licenses/by/4.0/
# @sintaxe:     source libMath.sh
################################################################################

# Must be sourced not running
[[ "${BASH_SOURCE[0]}" == "${0}" ]] && { echo -e "\033[91mfailure\033[0m: $(basename $0) must be sourced not running." ; exit 1 ; }

## @brief   Check if parameter is a number.
function _isNumber()
{
    local regexFloat='^[+-]?(\d+\.?\d*|\d*\.?\d+)$'
    if echo -n "$1" | grep -qaoP "${regexFloat}" > /dev/null 2>&1
    then
        true
    else
        false
    fi
}

## @brief   Check if parameter is an integer or float zero not IEEE 32.
function _isZero()
{
    local regexZero='^[-+]?(0+\.?0*|0*\.?0+)$'
    if _isNumber "$1"
    then
        if echo -n "$1" | grep -qaoP "${regexZero}" > /dev/null 2>&1
        then
            true
        else
            false
        fi
    else
        false
    fi
}

## @brief   Check if parameter is an integer or float zero and accept IEEE 32.
function _isFloatZero()
{
    local regexZero='^[-+]?(0+\.?0*|0*\.?0+)([eE][+-]?0*[1-9]+\d*)?$'
    if echo -n "$1" | grep -qaoP "${regexZero}" > /dev/null 2>&1
    then
        true
    else
        false
    fi
}

## @brief   Check if the parameter is a regular float number.
function _isFloat()
{
    local regexFloat='^[-+]?([0-9]+\.?[0-9]*|[0-9]*\.[0-9]+)([eE][+-]?0*[1-9]+\d*)?$'
    if echo -n "$1" | grep -qaoP "${regexFloat}" > /dev/null 2>&1
    then
        true
    else
        false
    fi
}

## @brief   Add zero before|after dot for float point numbers.
function normalizeNumber()
{
    local err=1
    local fp='NaN'
    if _isNumber "$1"
    then
        fp="$1"
        fp=$([[ "${1:0:1}" == '+' ]] && echo -n "${1:1}" || echo -n "${1}")
        for ((i=0 ; i<4 ; i++))
        do
            case ${fp} in
                *.)  fp="${fp}0" ;;
                .*)  fp="0${fp}" ;;
                *.*) break ;;
                *)   fp="${fp}.0" ;;
            esac
        done
        err=0
    fi
    echo -n "${fp:-0}"
    return $err
}

# @brief
#   Trim left and right zeros from float number.
# @parameters
#   $1 : Float number.
# @result
#   float : Number leading left and right zeros.
#   'NaN' : Wrong parameter, not a regular float number.
# @return
#   0 : Success
#   1 : Error
# @examples
#   trimZeros '000001.100000'  result  '1.1'
#   trimZeros '+000001.100000' result  '1.1'
#   trimZeros '-000001.100000' result '-1.1'
#   trimZeros '000001d100000'  result 'NaN' (Not a Number by wrong parameter)
function trimZeros()
{
    local err=0
    local fp=''
    if _isNumber "$1"
    then
        fp="$(normalizeNumber "${1}")"
        fp="$(echo "${fp}" | bc -l | sed -e 's/^[0]*//' -e 's/[0]*$//' -e 's/\.$//g')"
        fp="$([ -n "${fp}" ] && echo -n "${fp}" || echo -n 0)"
        fp="$(normalizeNumber "${fp}")"
    else
        fp='NaN'
        err=1
    fi
    echo -n "${fp:-0}"
    return $err
}

## @brief   Get integer number from a floating pointer number.
function getIntegerFromFloat()
{
    local err=0
    local fp='NaN'
    if _isNumber "$1"
    then
        fp=$([[ "${1:0:1}" == '+' ]] && echo -n "${1:1}" || echo -n "${1}")
        fp="$(normalizeNumber "${fp}")"
        fp="$(trimZeros "${fp}")"
        fp="$(normalizeNumber "${fp}")"
        case ${fp} in *.*) fp="${fp%.*}" ;; esac
    else
        err=1
    fi
    echo -n "${fp:-0}"
    return $err
}

## @brief   Get fraction number from a floating point number.
function getFractionFromFloat()
{
    local err=0
    local fp='NaN'
    if _isNumber "$1"
    then
        fp=$([[ "${1:0:1}" == '+' ]] && echo -n "${1:1}" || echo -n "${1}")
        fp="$(normalizeNumber "${fp}")"
        fp="$(trimZeros "${fp}")"
        fp="$(normalizeNumber "${fp}")"
        case ${fp} in
            *.*) fp="${fp##*.}" ;;
            *) fp=0 ;;
        esac
    else
        err=1
    fi
    echo -n "${fp:-0}"
    return $err
}

## @brief   Execute calculation according to operator (+ - * /) parameter.
function calcNumber()
{
    local err=1
    local fp1="$1"
    local oper="$2"
    local fp2="$3"
    local res='NaN'
    declare -a operTable=('+' '-' '*' '/')
    if _isNumber "${fp1}" && _isNumber "${fp2}"
    then
        if [[ "${operTable[@]}" =~ "${oper}" ]]
        then
            fp1="$(normalizeNumber "${fp1}")"
            fp2="$(normalizeNumber "${fp2}")"
            fp1=$(trimZeros "${fp1}")
            fp2=$(trimZeros "${fp2}")
            res="$(echo "${fp1} ${oper} ${fp2}" | bc -l)"
            res=$(trimZeros "${res}")
            err=$?
        else
            fp1="$(normalizeNumber "${fp1}")"
            fp2="$(normalizeNumber "${fp2}")"
            fp1=$(trimZeros "${fp1}")
            fp2=$(trimZeros "${fp2}")
            fp1="$(normalizeNumber "${fp1}")"
            fp2="$(normalizeNumber "${fp2}")"
            res="$(echo "${fp1} ${oper} ${fp2}" | bc -l)"
            err=$?
        fi
    fi
    echo -n "${res}"
    return $err
}

## @brief   Exit from lib and unload all variables and functions.
function libMathExit()
{
    # unset variables
    unset -v libMath
    unset -v regexDouble
    unset -v regexZero
    # unset functions
    unset -f _isZero
    unset -f _isNumber
    unset -f getIntegerFromFloat
    unset -f getFractionFromFloat
    unset -f _isFloatZero
    unset -f _isFloat
    unset -f isNumberInRange
    unset -f libMathExit
    return 0
}

## @brief   Check if libRegex is loaded and available.
declare libMath='loaded'

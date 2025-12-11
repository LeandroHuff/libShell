#!/usr/bin/env bash

################################################################################
# @file         libLog.sh
# @brief        Source variables and functions to calculate most common mathematics
#               espressions.
# @author:      Leandro D. Huff
# @copyright:   https://creativecommons.org/licenses/by/4.0/
################################################################################

function isNumber()
{
    local regexDouble='^[+-]?(\d+\.?\d*|\d*\.?\d+)$'
    if echo -n "$1" | grep -aoP "${regexDouble}" > /dev/null 2>&1
    then
        true
    else
        false
    fi
}

function isZero()
{
    local regexZero='^[-+]?(0+\.?0*|0*\.?0+)$'
    if isNumber "$1"
    then
        if echo -n "$1" | grep -aoP "${regexZero}" > /dev/null 2>&1
        then
            true
        else
            false
        fi
    else
        false
    fi
}

function normalizeNumber()
{
    local err=1
    local fp='NaN'
    if isNumber "$1"
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
    if isNumber "$1"
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

function getIntegerFromFloat()
{
    local err=0
    local fp='NaN'
    if isNumber "$1"
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

function getFractionFromFloat()
{
    local err=0
    local fp='NaN'
    if isNumber "$1"
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

function isFloatZero()
{
    local regexZero='^[-+]?(0+\.?0*|0*\.?0+)([eE][+-]?0*[1-9]+\d*)?$'
    if echo -n "$1" | grep -aoP "${regexZero}" > /dev/null 2>&1
    then
        true
    else
        false
    fi
}

function isFloat()
{
    local regexDouble='^[-+]?([0-9]+\.?[0-9]*|[0-9]*\.[0-9]+)([eE][+-]?0*[1-9]+\d*)?$'
    if echo -n "$1" | grep -aoP "${regexDouble}" > /dev/null 2>&1
    then
        true
    else
        false
    fi
}

function calcNumber()
{
    local err=1
    local fp1="$1"
    local oper="$2"
    local fp2="$3"
    local res='NaN'
    declare -a operTable=('+' '-' '*' '/')
    if isNumber "${fp1}" && isNumber "${fp2}"
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

################################################################################
# Exit
function libMathExit()
{
    # unset variables
    unset -v regexDouble
    unset -v regexZero
    # unset functions
    unset -f isZero
    unset -f isNumber
    unset -f getIntegerFromFloat
    unset -f getFractionFromFloat
    unset -f isFloatZero
    unset -f isFloat
    unset -f isNumberInRange
    unset -f libMathExit
    return 0
}

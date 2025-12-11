#!/usr/bin/env bash

################################################################################
# @file         libRegex.sh
# @brief        Source variables and functions to validate strings by regex string.
# @author:      Leandro D. Huff
# @copyright:   https://creativecommons.org/licenses/by/4.0/
################################################################################

# constants
declare regexFLOAT='^[-+]?(\d+\.?\d*|\d*\.\d+)([eE][+-]0*[1-9]+\d*)?$'
declare regexINTEGER='^[+-]?\d+$'
declare regexALPHA='^[[:alpha:]]+$'
declare regexDIGIT='^[[:digit:]]+$'
declare regexALPHADIGIT='^[[:alnum:]]+$'
declare regexHEXA='^[[:xdigit:]]+$'
declare regexLOHEXA='^([[:digit:]]|[a-f])+$'
declare regexUPHEXA='^([[:digit:]]|[A-F])+$'
declare regexGRAPH='^[[:graph:]]+$'
declare regexGRAPHSPACE='^[[:graph:]]+([[:space:]][[:graph:]]+)*$'
declare regexDATE='^((1[6-9]|[2-9]\d)\d{2})[-\.\/](((0?[13578]|1[02])[-\.\/]31)|((0?[1,3-9]|1[0-2])[-\.\/](29|30)))$|^((((1[6-9]|[2-9]\d)?(0?[48]|[2468][048]|[13579][26])|((16|[2468][048]|[3579][26])00)))[-\.\/]02[-\.\/]29)$|^((1[6-9]|[2-9]\d)\d{2})[-\.\/]((0?[1-9])|(1[0-2]))[-\.\/](0?[1-9]|1\d|2[0-8])$'
declare regexTIME12='^(?:(1[0-2]|0?[1-9]):(?:[0-5][0-9])(:(?:[0-5]\d))? ?([AaPp][Mm]))$'
declare regexTIME24='^(?:[01]\d|2[0-3]):(?:[0-5]\d)(:(?:[0-5]\d))?$'
declare regexTIME124="${regexTIME12}|${regexTIME24}"
declare regexDATETIME12='^\d{4}[-\.\/]((0?\d)|(1[0-2]))[-\.\/]((0?[1-9])|([1-2]\d)|(3[0-1])) ((0?[1-9])|(1[0-2])):([0-5]\d):([0-5]\d) ?[aApP][mM]$'
declare regexDATETIME24='^\d{4}[-\.\/]((0?\d)|(1[0-2]))[-\.\/]((0?[1-9])|([1-2]\d)|(3[0-1])) ((0?\d)|(1\d)|(2[0-3])):([0-5]\d):([0-5]\d)$'
declare regexDATETIME124='^\d{4}[-\.\/]((0?\d)|(1[0-2]))[-\.\/]((0?[1-9])|([1-2]\d)|(3[0-1])) (((?:(1[0-2]|0?[1-9]):(?:[0-5][0-9])(:(?:[0-5]\d))? ?([AaPp][Mm])))|((?:[01]\d|2[0-3]):(?:[0-5]\d)(:(?:[0-5]\d))?))$'
declare regexDATETIMEASCODE='^\d{4}-((0[1-9])|(1[0-2]))-(([0-2]\d)|(3[0-1]))-(([0-1]\d)|(2[0-3]))-([0-5]\d)-([0-5]\d)-(\d{3})$'

# functions
function regexIt()
{
    if [ -n "$1" ]
    then
        local ret
        echo -n "${1}" | grep -aoP "${2}" > /dev/null 2>&1
        ret=$?
        if  [ $ret -eq 0 ]
        then
            true
        else
            false
        fi
    else
        false
    fi
}

function isFloat()            { regexIt "${1}" "${regexFLOAT}"          ; }
function isInteger()          { regexIt "${1}" "${regexINTEGER}"        ; }
function isAlpha()            { regexIt "${1}" "${regexALPHA}"          ; }
function isDigit()            { regexIt "${1}" "${regexDIGIT}"          ; }
function isAlphaNumeric()     { regexIt "${1}" "${regexALPHADIGIT}"     ; }
function isHexadecimal()      { regexIt "${1}" "${regexHEXA}"           ; }
function isLowerHexadecimal() { regexIt "${1}" "${regexLOHEXA}"         ; }
function isUpperHexadecimal() { regexIt "${1}" "${regexUPHEXA}"         ; }
function isGraph()            { regexIt "${1}" "${regexGRAPH}"          ; }
function isGraphSpace()       { regexIt "${1}" "${regexGRAPHSPACE}"     ; }
function isDate()             { regexIt "${1}" "${regexDATE}"           ; }
function isTime12()           { regexIt "${1}" "${regexTIME12}"         ; }
function isTime24()           { regexIt "${1}" "${regexTIME24}"         ; }
function isTime124()          { regexIt "${1}" "${regexTIME124}"        ; }
function isDateTime12()       { regexIt "${1}" "${regexDATETIME12}"     ; }
function isDateTime24()       { regexIt "${1}" "${regexDATETIME24}"     ; }
function isDateTime124()      { regexIt "${1}" "${regexDATETIME124}"    ; }
function isDateTimeAsCode()   { regexIt "${1}" "${regexDATETIMEASCODE}" ; }

function libRegexExit()
{
    # unset variables
    unset -v regexFLOAT
    unset -v regexINTEGER
    unset -v regexALPHA
    unset -v regexDIGIT
    unset -v regexALPHADIGIT
    unset -v regexHEXA
    unset -v regexLOHEXA
    unset -v regexUPHEXA
    unset -v regexGRAPH
    unset -v regexGRAPHSPACE
    unset -v regexDATE
    unset -v regexTIME12
    unset -v regexTIME24
    unset -v regexTIME124
    unset -v regexDATETIME12
    unset -v regexDATETIME24
    unset -v regexDATETIME124
    unset -v regexDATETIMEASCODE
    # unset functions
    unset -f regexIt
    unset -f isFloat
    unset -f isInteger
    unset -f isAlpha
    unset -f isDigit
    unset -f isAlphaNumeric
    unset -f isHexadecimal
    unset -f isLowerHexadecimal
    unset -f isUpperHexadecimal
    unset -f isGraph
    unset -f isGraphSpace
    unset -f libRegexExit
    # return code
    return 0
}

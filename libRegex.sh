################################################################################
# @file         libRegex.sh
# @brief        Source variables and functions to validate strings by regex string.
# @author:      Leandro D. Huff
# @copyright:   https://creativecommons.org/licenses/by/4.0/
# @sintaxe:     source libRegex.sh
################################################################################

# Must be sourced not running
[[ "${BASH_SOURCE[0]}" == "${0}" ]] && { echo -e "\033[91merror\033[0m: $(basename $0) must be sourced not running." ; exit 1 ; }

declare libRegex=''

# constants
declare regexFS='(btrfs|exfat|ext2|ext3|ext4|fat16|fat32|hfs|hfsplus|jfs|ntfs|reiser|reiser4|ufs|xfs|zfs)'
declare regexCryptFS='(crypto_LUKS)'
declare regexTAG='^\w+'
declare regexVALUE='\w+$'
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
declare regexCompressFile='[\w-]+\.((txz|tgz|tbz2|z|zip|7z|7zip|gz|gzip|xz|xzip|bz|bz2|bzip|bzip2){1}|(tar\.(gz|gzip|xz|xzip|bz|bz2|bzip|bzip2)){1})?$'
declare regexCompressExt='(txz|tbz2|tgz|tar|z|zip|7z|7zip|gz|gzip|xz|xzip|bz|bz2|bzip|bzip2){1}|(tar\.(gz|gzip|xz|xzip|bz|bz2|bzip|bzip2){1})?$'

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

function reGetStr()             { echo -n "${1}" | grep -aoP "${2}"         ; return $?; }
function reGetTag()             { echo -n "${1}" | grep -aoP "${regexTAG}"  ; return $?; }
function reGetValue()           { echo -n "${1}" | grep -aoP "${regexVALUE}"; return $?; }
function reIsFloat()            { regexIt "${1}" "${regexFLOAT}"          ; }
function reIsInteger()          { regexIt "${1}" "${regexINTEGER}"        ; }
function reIsAlpha()            { regexIt "${1}" "${regexALPHA}"          ; }
function reIsDigit()            { regexIt "${1}" "${regexDIGIT}"          ; }
function reIsAlphaNumeric()     { regexIt "${1}" "${regexALPHADIGIT}"     ; }
function reIsHexadecimal()      { regexIt "${1}" "${regexHEXA}"           ; }
function reIsLowerHexadecimal() { regexIt "${1}" "${regexLOHEXA}"         ; }
function reIsUpperHexadecimal() { regexIt "${1}" "${regexUPHEXA}"         ; }
function reIsGraph()            { regexIt "${1}" "${regexGRAPH}"          ; }
function reIsGraphSpace()       { regexIt "${1}" "${regexGRAPHSPACE}"     ; }
function reIsDate()             { regexIt "${1}" "${regexDATE}"           ; }
function reIsTime12()           { regexIt "${1}" "${regexTIME12}"         ; }
function reIsTime24()           { regexIt "${1}" "${regexTIME24}"         ; }
function reIsTime124()          { regexIt "${1}" "${regexTIME124}"        ; }
function reIsDateTime12()       { regexIt "${1}" "${regexDATETIME12}"     ; }
function reIsDateTime24()       { regexIt "${1}" "${regexDATETIME24}"     ; }
function reIsDateTime124()      { regexIt "${1}" "${regexDATETIME124}"    ; }
function reIsDateTimeAsCode()   { regexIt "${1}" "${regexDATETIMEASCODE}" ; }
function libRegexExit()
{
    # unset variables
    unset -v libRegex
    unset -v regexTAG
    unset -v regexVALUE
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
    unset -v regexCompressFile
    unset -v regexCompressExt
    # unset functions
    unset -f regexIt
    unset -f reGetStr
    unset -f reGetTag
    unset -f reGetValue
    unset -f reIsFloat
    unset -f reIsInteger
    unset -f reIsAlpha
    unset -f reIsDigit
    unset -f reIsAlphaNumeric
    unset -f reIsHexadecimal
    unset -f reIsLowerHexadecimal
    unset -f reIsUpperHexadecimal
    unset -f reIsGraph
    unset -f reIsGraphSpace
    unset -f reIsDate
    unset -f reIsTime12
    unset -f reIsTime24
    unset -f reIsTime124
    unset -f reIsDateTime12
    unset -f reIsDateTime24
    unset -f reIsDateTime124
    unset -f reIsDateTimeAsCode
    unset -f reIibRegexExit
    # return code
    return 0
}

libRegex='loaded'

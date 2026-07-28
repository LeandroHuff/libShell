################################################################################
# @file:        libString.sh
# @brief:       Source variables and functions to treat and validate strings.
# @author:      Leandro D. Huff
# @copyright:   https://creativecommons.org/licenses/by/4.0/
# @sintaxe:     source libString.sh
################################################################################

# Must be sourced not running
[[ "${BASH_SOURCE[0]}" == "${0}" ]] && { echo -e "\033[91mfailure\033[0m: $(basename $0) must be sourced not running." ; exit 1 ; }

##
# @brief    Parameter from command line.
# @details  Accept Short Parameterss:
#             -a|-A             short parameters
#             -123              positive numbers.
#             --123             negative numbers.
#           Accept Long Parameters:
#             --abcd_123_efgh   mixed letters, numbers and underline.
#             --_abcd_          started by underline.
#           Do not accept:
#             -abc              single hiffen must be followed by only one caracter.
#             --a               double hiffen must be followed by two or more caracter as [a-zA-Z0-9_]
## @brief   File System types.
declare regexFS='(btrfs|exfat|ext2|ext3|ext4|fat|fat16|fat32|hfs|hfsplus|jfs|ntfs|reiser|reiser4|ufs|xfs|zfs|crypto_LUKS)'

## @brief    Encrypted File System type.
declare regexCryptFS='(crypto_LUKS)'

## @brief   Filter and validate float numbers from a string.
declare reFLOAT='[-+]?(\d+\.?\d*|\d*\.\d+)([eE][+-]?0*[1-9]+\d*)?'
declare regexFLOAT="^${reFLOAT}$"

## @brief   Filter and validate integer numbers from a string.
declare reINTEGER='[+-]?\d+'
declare regexINTEGER="^${reINTEGER}$"

## @brief   Filter and validate generic numbers integer or float from string.
declare regexNumber="^((${reFLOAT})|(${reINTEGER}))$"

## @brief   Filter and validate an integer or float number zero '0' or '0.0'
declare regexZero='^[-+]?(0+\.0+|0+)$'

## @brief   Filter and validate a float pointer number zero '0.' or '.0' or '0.0'
declare regexFloatZero='^[-+]?(0+\.0+|0*\.0+|0+\.0*)$'

## @brief   Filter and validate alphabetic string from a string.
declare regexALPHA='^[[:alpha:]]+$'

## @brief   Filter and validate numeric string from a string.
declare regexDIGIT='^[[:digit:]]+$'

## @brief   Filter and validate alphanumeric string from a string.
declare regexALPHADIGIT='^[[:alnum:]]+$'

## @brief   Filter and validate haxadecimal numbers from a string.
declare regexHEXA='^[[:xdigit:]]+$'

## @brief   Filter and validate lower case hexadecimal numbers from a string.
declare regexLOHEXA='^([[:digit:]]|[a-f])+$'

## @brief   Filter and validate upper case hexadecimal numbers from a string.
declare regexUPHEXA='^([[:digit:]]|[A-F])+$'

## @brief   Filter and validate graphical caracters from a string.
declare regexGRAPH='^[[:graph:]]+$'

## @brief   Filter and validate graphical + space caracters from a string.
declare regexGRAPHSPACE='^([[:space:]]|[[:graph:]])*$'

##
# @brief    Filter and validate a date and leap year from a string.
# @details  Format: YYYY-MM-DD or YYYY.MM.DD or YYYY/MM/DD
#           Where:
#            YYYY: year
#              MM: month
#              DD: day
declare regexDATE='^((1[6-9]|[2-9]\d)\d{2})[-\.\/](((0?[13578]|1[02])[-\.\/]31)|((0?[13-9]|1[0-2])[-\.\/](29|30)))$|^((((1[6-9]|[2-9]\d)?(0?[48]|[2468][048]|[13579][26])|((16|[2468][048]|[3579][26])00)))[-\.\/]02[-\.\/]29)$|^((1[6-9]|[2-9]\d)\d{2})[-\.\/]((0?[1-9])|(1[0-2]))[-\.\/](0?[1-9]|1\d|2[0-8])$'

## @brief   Filter and validate time in 12 hours format from a string.
declare reTIME12='(?:(1[0-2]|0?[1-9]):(?:[0-5][0-9])(:(?:[0-5]\d))? ?([AaPp][Mm]))'
declare regexTIME12="^${reTIME12}$"

## @brief   Filter and validate time in 24 hours format from a string.
declare reTIME24='(?:[01]\d|2[0-3]):(?:[0-5]\d)(:(?:[0-5]\d))?'
declare regexTIME24="^${reTIME24}$"

## @brief   Filter and validate a time in 12 or 24 hours format from a string.
declare regexTIME124="((${regexTIME12})|(${regexTIME24}))"

## @brief   Filter and validate a date and time in 12 hours format from a string.
declare reDATE='\d{4}[-\.\/]((0?\d)|(1[0-2]))[-\.\/]((0?[1-9])|([1-2]\d)|(3[0-1]))'
declare regexDATETIME12="^${reDATE} *${reTIME12}$"

## @brief   Filter and validate a date and time in 24 hours format from a string.
declare regexDATETIME24="^${reDATE} *${reTIME24}$"

## @brief   Filter and validate a time in 12 or 24 hours format from a string.
declare regexDATETIME124="^${reDATE} *((${reTIME12})|(${reTIME24}))$"

##
# @brief    Filter and validate a date and time as a code|timestamp format from a string.
# @details  Format:
#           YYYY-mm-dd-HH-MM-SS-NNN
#           Where:
#           YYYY: year
#             mm: month
#             dd: day
#             HH: hours
#             MM: minutes
#             SS: seconds
#            NNN: milliseconds
declare regexDATETIMEASCODE='^\d{4}-((0[1-9])|(1[0-2]))-(([0-2]\d)|(3[0-1]))-(([0-1]\d)|(2[0-3]))-([0-5]\d)-([0-5]\d)-(\d{3})$'

## @brief   Filter and validate a compressed file name from a string.
declare regexCompressFile='[\w-]+\.((txz|tgz|tbz2|z|zip|7z|7zip|gz|gzip|xz|xzip|bz|bz2|bzip|bzip2){1}|(tar\.(gz|gzip|xz|xzip|bz|bz2|bzip|bzip2)){1})?$'

## @brief   Filter and validate a compressed file extension name from a string.
declare regexCompressExt='(txz|tbz2|tgz|tar|z|zip|7z|7zip|gz|gzip|xz|xzip|bz|bz2|bzip|bzip2){1}|(tar\.(gz|gzip|xz|xzip|bz|bz2|bzip|bzip2){1})?$'

##
# @brief    Check an validate a string by a regex.
# @param    $1      String to validate.
# @param    $2      Regex string.
# @result   0       The string is valid.
#           1+      The string is not valid.
function regexIt()
{
    if [ -n "$1" ]
    then
        echo -n "${1}" | grep -qaoP "${2}" 2> /dev/null
    else
        return 1
    fi
}

##
# @brief    Check if a sub string is into a string parameter.
# @param    $1      String to search in.
# @param    $2      String to find.
# @return   0       Success
#           1+      Empty parameter or not found.
function hasStrInto()
{
    if [ -n "$1" ]
    then
        echo -n "${1}" | grep -qaoT "${2}" 2> /dev/null
    else
        return 1
    fi
}

##
# @brief    Get a sub string from a string by regex.
# @param    $1      String to search in.
# @param    $2      String to find.
# @result   string  The string found.
#           none    String not found.
# @return   0       Success
#           1+      Empty parameter or failure.
function reGetStrFrom()
{
    if [ -n "$1" ]
    then
        echo -n "${1}" | grep -aoP "${2}" 2> /dev/null
    else
        return 1
    fi
}

##
# @brief    Get a sub string from a string by a text parameter.
# @param    $1      String to search in.
# @param    $2      String to find.
# @result   string  The string found.
#           none    String not found.
# @return   0       Success
#           1+      Empty parameter or failure.
function getStrFrom()
{
    if [ -n "$1" ]
    then
        echo -n "${1}" | grep -aoT "${2}" 2> /dev/null
    else
        return 1
    fi
}

## @brief   Check parameter for 'yes' confirmation.
function isYes() { case "$1" in [yY] | [yY][eE][sS]) true ;; *) false ;; esac ; }

## @brief   Check parameter for 'no|not' confirmation.
function isNot() { case "$1" in [nN] | [nN][oO] | [nN][oO][tT]) true ;; *) false ;; esac ; }

## @brief   Check for empty parameter.
function isEmpty()  { if [ "x$1" = 'x' ] ; then true ; else false  ; fi ; }

## @brief   Get tag name from a string parameter as tag=value
function getTag() { echo -n "${1%=*}" ; }

## @brief   Get value from a string parameter as tag=value
function getValue() { echo -n "${1##*=}" ; }

## @brief   Check parameter for valid command line option|parameter.
function isParam()
{
    if [ "x$1" = 'x' ] ; then return 1 ; fi
    echo -n "$1" | grep -qaoP '^([-+][a-zA-Z0-9]{1}|-[-]?\d+|--\w{2})$' 2> /dev/null
}

## @brief   Check parameter for valid command line argument.
function isArg()
{
    if [ "x$1" = 'x' ]
    then
        return 1
    elif echo -n "$1" | grep -qaoP '^[-+]?\d+$' 2> /dev/null
    then
        return 0
    else
        case "$1" in
        -*) return 1 ;;
         *) return 0 ;;
        esac
    fi
}

## @brief   Check parameter for valid float number.
function reIsFloat() { regexIt "${1}" "${regexFLOAT}" ; }

## @brief   Check parameter for valid integer number.
function reIsInteger() { regexIt "${1}" "${regexINTEGER}" ; }

## @brief   Check parameter for valid zero number.
function reIsZero() { regexIt "${1}" "${regexZero}" ; }

## @brief   Check parameter for valid floating point zero number.
function reIsFloatZero() { regexIt "${1}" "${regexFloatZero}" ; }

## @brief   Check parameter for valid number (integer or float).
function reIsNumber() { regexIt "${1}" "${regexNumber}" ; }

## @brief   Check parameter for valid alphabetic caracters.
function reIsAlpha() { regexIt "${1}" "${regexALPHA}" ; }

## @brief   Check parameter for valid digit number.
function reIsDigit() { regexIt "${1}" "${regexDIGIT}" ; }

## @brief   Check parameter for valid alphanumeric caracters.
function reIsAlphaNumeric() { regexIt "${1}" "${regexALPHADIGIT}" ; }

## @brief   Check parameter for valid hexadecimal number.
function reIsHexadecimal() { regexIt "${1}" "${regexHEXA}" ; }

## @brief   Check parameter for valid lower case hexadecimal number.
function reIsLowerHexadecimal() { regexIt "${1}" "${regexLOHEXA}" ; }

## @brief   Check parameter for valid upper case hexadecimal number.
function reIsUpperHexadecimal() { regexIt "${1}" "${regexUPHEXA}" ; }

## @brief   Check parameter for valid graphic caracters.
function reIsGraph() { regexIt "${1}" "${regexGRAPH}" ; }

## @brief   Check parameter for valid graphic and space caracters.
function reIsGraphSpace() { regexIt "${1}" "${regexGRAPHSPACE}" ; }

## @brief   Check parameter for valid date with leap year verification.
function reIsDate() { regexIt "${1}" "${regexDATE}" ; }

## @brief   Check parameter for valid 12 hours time format.
function reIsTime12() { regexIt "${1}" "${regexTIME12}" ; }

## @brief   Check parameter for valid 24 hours time format.
function reIsTime24() { regexIt "${1}" "${regexTIME24}" ; }

## @brief   Check parameter for valid 12/24 hours time format.
function reIsTime124() { regexIt "${1}" "${regexTIME124}" ; }

## @brief   Check parameter for valid date and 12 hours time format.
function reIsDateTime12() { regexIt "${1}" "${regexDATETIME12}" ; }

## @brief   Check parameters for valid date and 24 hours time format.
function reIsDateTime24() { regexIt "${1}" "${regexDATETIME24}" ; }

## @brief   Check parameters for valid date and 12/24 hours time format.
function reIsDateTime124() { regexIt "${1}" "${regexDATETIME124}" ; }

## @brief   Check parameters for valid date and time as unique code|timestamp format.
function reIsDateTimeAsCode() { regexIt "${1}" "${regexDATETIMEASCODE}" ; }

## @brief   Generate version string from integer array.
function genVersionStr() { local vector=("${@}") ; echo -n "${vector[0]}.${vector[1]}.${vector[2]}" ; }

## @brief   Generate version integer from integer array.
function genVersionNum() { local vector=("${@}") ; echo -n $((vector[0]*1000000 + vector[1]*1000 + vector[2])) ; }

## @brief   Generate date version string from a date integers array.
function genDateVersionStr() { local vector=("${@}") ; printf "%04d-%02d-%02d" ${vector[0]} ${vector[1]} ${vector[2]} ; }

## @brief   Generate date integer version from date array integers.
function genDateVersionNum() { local vector=("${@}") ; echo -n $((vector[0]*1000000 + vector[1]*1000 + vector[2])) ; }

## @brief   Get date string, format YYYY-mm-dd
function getDate() { echo -n "$(date '+%Y-%m-%d')" ; }

## @brief   Get time string, format HH:MM:SS
function getTime() { echo -n "$(date '+%H:%M:%S')" ; }

## @brief   Get date and time string.
function getDateTime() { echo -n "$(getDate) $(getTime)" ; }

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
    declare -a res=()
    while [ -n "$1" ]
    do
        res+=("${prefix}${1}")
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
    declare -a res=()
    while [ -n "$1" ]
    do
        res+=("${1}${sufix}")
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
    declare -a res=()
    while [ -n "$1" ]
    do
        res+=("${prefix}${1}${sufix}")
        shift
    done
    echo -n ${res[@]}
    return 0
}

##  @brief  Exit from libString, unload all variables and functions.
function libStringExit()
{
    # unset variables
    unset -v regexFS
    unset -v regexCryptFS
    unset -v reFLOAT
    unset -v regexFLOAT
    unset -v reINTEGER
    unset -v regexINTEGER
    unset -v regexNumber
    unset -v regexZero
    unset -v regexFloatZero
    unset -v regexALPHA
    unset -v regexDIGIT
    unset -v regexALPHADIGIT
    unset -v regexHEXA
    unset -v regexLOHEXA
    unset -v regexUPHEXA
    unset -v regexGRAPH
    unset -v regexGRAPHSPACE
    unset -v regexDATE
    unset -v reTIME12
    unset -v regexTIME12
    unset -v reTIME24
    unset -v regexTIME24
    unset -v regexTIME124
    unset -v reDATE
    unset -v regexDATETIME12
    unset -v regexDATETIME24
    unset -v regexDATETIME124
    unset -v regexDATETIMEASCODE
    unset -v regexCompressFile
    unset -v regexCompressExt
    # unset functions
    unset -f regexIt
    unset -f hasStrInto
    unset -f reGetStrFrom
    unset -f getStrFrom
    unset -f isYes
    unset -f isNot
    unset -f isEmpty
    unset -f getTag
    unset -f getValue
    unset -f isParam
    unset -f isArg
    unset -f reIsFloat
    unset -f reIsInteger
    unset -f reIsZero
    unset -f reIsFloatZero
    unset -f reIsNumber
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
    unset -f genVersionStr
    unset -f genVersionNum
    unset -f genDateVersionStr
    unset -f genDateVersionNum
    unset -f getDate
    unset -f getTime
    unset -f getDateTime
    unset -f strLen
    unset -f cmpStr
    unset -f addPrefix
    unset -f addSuffix
    unset -f addPrefixSuffix
}

declare libString='loaded'

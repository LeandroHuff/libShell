################################################################################
# @file         libRegex.sh
# @brief        Source variables and functions to validate strings by regex string.
# @author:      Leandro D. Huff
# @copyright:   https://creativecommons.org/licenses/by/4.0/
# @sintaxe:     source libRegex.sh
################################################################################

# Must be sourced not running
[[ "${BASH_SOURCE[0]}" == "${0}" ]] && { echo -e "\033[91mfailure\033[0m: $(basename $0) must be sourced not running." ; exit 1 ; }

## @brief   Parameter from command line.
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
declare regexParam='^-{1}((-?\d+)|.|(-_*\w{2,}))$'

## @brief   Argument from command line.
declare regexArg='^((-?\d+)|([\w+]))$'

## @brief   File System types
declare regexFS='(btrfs|exfat|ext2|ext3|ext4|fat16|fat32|hfs|hfsplus|jfs|ntfs|reiser|reiser4|ufs|xfs|zfs)'

## @brief    Encrypted File System type
declare regexCryptFS='(crypto_LUKS)'

## @brief   Filter and validate float numbers from a string.
declare reFLOAT='[-+]?(\d+\.?\d*|\d*\.\d+)([eE][+-]?0*[1-9]+\d*)?'
declare regexFLOAT="^${reFLOAT}$"

## @brief   Filter and validate integer numbers from a string.
declare reINTEGER='[+-]?\d+'
declare regexINTEGER="^${reINTEGER}$"

## @brief   Filter and validate generic numbers (float|integer) from string.
declare regexNumber="^((${reFLOAT})|(${reINTEGER}))$"

## @brief   Filter and validate a number zero.
declare regexZero='^[-+]?(0+\.?0*|0*\.?0+)$'

## @brief   Filter and validate a float pointer zero number.
declare regexFloatZero='^[-+]?(0+\.0+|0*\.0+)$'

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
declare regexGRAPHSPACE='^[[:graph:]]+([[:space:]][[:graph:]]+)*$'

##
# @brief    Filter and validate a date and leap year from a string.
# @details  Format: YYYY-MM-DD or YYYY.MM.DD or YYYY/MM/DD
#           Where:
#            YYYY: year
#              MM: month
#              DD: day
declare regexDATE='^((1[6-9]|[2-9]\d)\d{2})[-\.\/](((0?[13578]|1[02])[-\.\/]31)|((0?[1,3-9]|1[0-2])[-\.\/](29|30)))$|^((((1[6-9]|[2-9]\d)?(0?[48]|[2468][048]|[13579][26])|((16|[2468][048]|[3579][26])00)))[-\.\/]02[-\.\/]29)$|^((1[6-9]|[2-9]\d)\d{2})[-\.\/]((0?[1-9])|(1[0-2]))[-\.\/](0?[1-9]|1\d|2[0-8])$'

## @brief   Filter and validate time in 12 hours format from a string.
declare reTIME12='(?:(1[0-2]|0?[1-9]):(?:[0-5][0-9])(:(?:[0-5]\d))? ?([AaPp][Mm]))'
declare regexTIME12="^${reTIME12}$"

## @brief   Filter and validate time in 24 hours format from a string.
declare reTIME24='(?:[01]\d|2[0-3]):(?:[0-5]\d)(:(?:[0-5]\d))?'
declare regexTIME24="^${reTIME24}$"

## @brief   Filter and validate a time in 12 and 24 hours format from a string.
declare regexTIME124="((${regexTIME12})|(${regexTIME24}))"

## @brief   Filter and validate a date and time in 12 hours format from a string.
declare reDATE='\d{4}[-\.\/]((0?\d)|(1[0-2]))[-\.\/]((0?[1-9])|([1-2]\d)|(3[0-1]))'
declare regexDATETIME12="^${reDATE} *${reTIME12}$"

## @brief   Filter and validate a date and time in 24 hours format from a string.
declare regexDATETIME24="^${reDATE} *${reTIME24}$"

## @brief   Filter and validate a time in 12 and 24 hours format from a string.
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
# @brief    Check an validate a string by a regex string.
# @param    $1      String to validate.
# @param    $2      Regex string.
# @result   true    The string is valid.
#           false   The string is not valid.
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

## @brief   Check parameter for valid command line option|parameter.
function reIsParam() { regexIt "$1" "${regexParam}" ; }

## @brief   Check parameter for valid command line argument.
function reIsArg() { regexIt "$1" "${regexArg}" ; }

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

## @brief   Exit from lib and unload all variables and functions.
function libRegexExit()
{
    # unset variables
    unset -v libRegex
    unset -v regexArg
    unset -v regexParam
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
    unset -f reGetTag
    unset -f reGetValue
    unset -f reIsParam
    unset -f reIsArg
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
    unset -f libRegexExit
    # return code
    return 0
}

## @brief   Check if libRegex is loaded and available.
declare libRegex='loaded'

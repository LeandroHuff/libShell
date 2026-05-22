################################################################################
# @file         libEscCodes.sh
# @brief        Source variables and functions to resource escape codes for colors and fonts.
# @author:      Leandro D. Huff
# @copyright:   https://creativecommons.org/licenses/by/4.0/
# @sintaxe:     source libEscCodes.sh
################################################################################

# Must be sourced not running
[[ "${BASH_SOURCE[0]}" == "${0}" ]] && { echo -e "\033[91mfailure\033[0m: $(basename $0) must be sourced not running." ; exit 1 ; }

declare libEscCodes=''

# Escape Styles Fonts
declare -i DEFAULT=0
declare -i CLEAR=0
declare -i RESET=0
declare -i NORMAL=0
declare -i BRIGHT=1
declare -i BOLD=1

declare -i FADE=2
declare -i ITALIC=3
declare -i UNDERLINE=4
declare -i BLINK=5
declare -i REVERSE=7
declare -i INVERT=7
declare -i HIDDEN=8
declare -i STRIKETHR=9

declare -i STOFF=20

declare -i notFADE=$((FADE+STOFF))
declare -i notITALIC=$((ITALIC+STOFF))
declare -i notUNDERLINE=$((UNDERLINE+STOFF))
declare -i notBLINK=$((BLINK+STOFF))
declare -i notREVERSE=$((REVERSE+STOFF))
declare -i notHIDDEN=$((HIDDEN+STOFF))
declare -i notSTRIKETHR=$((STRIKETHR+STOFF))

# Escape Colors
#  D: Dark
#  I: Intense
# FG: Fore Ground
# BG: Back Ground
declare -i DFG=30
declare -i DBG=40
declare -i IFG=90
declare -i IBG=100

# Color Codes
declare -i BLACK=0
declare -i RED=1
declare -i GREEN=2
declare -i YELLOW=3
declare -i BLUE=4
declare -i MAGENTA=5
declare -i CYAN=6
declare -i WHITE=7

# Escape. No Color, Reset Color, Default Color, Codes
declare escDC='\033[0m'
declare escNC='\033[0;39;49m'
declare escNBG='\033[49m'
declare escNFG='\033[39m'
# Escape Dark Colors Codes
declare escBLACK='\033[30m'
declare escRED='\033[31m'
declare escGREEN='\033[32m'
declare escYELLOW='\033[33m'
declare escBLUE='\033[34m'
declare escMAGENTA='\033[35m'
declare escCYAN='\033[36m'
declare escWHITE='\033[37m'
# Escape Light|Bright Colors Codes
declare escIBLACK='\033[90m'
declare escIRED='\033[91m'
declare escIGREEN='\033[92m'
declare escIYELLOW='\033[93m'
declare escIBLUE='\033[94m'
declare escIMAGENTA='\033[95m'
declare escICYAN='\033[96m'
declare escIWHITE='\033[97m'

# Screen Reverse On/Off
declare escScrRevON='\033[?5h'
declare escScrRevOFF='\033[?5l'

##
# @brief    Generate extended Foreground RGB escape code
# @param    $1  Red color.
# @param    $2  Green color.
# @param    $3  Blue color.
# @result       Escape code for extended foreground RGB color.
# @return   0   Success
#           N   Error code.
function genExtFgRGB()  { echo -e -n "\033[38;2;${1};${2};${3}m" ; }

##
# @brief    Generate extended Background RGB escape code
# @param    $1  Red color.
# @param    $2  Green color.
# @param    $3  Blue color.
# @result       Escape code for extended background RGB color.
# @return   0   Success
#           N   Error code.
function genExtBgRGB()  { echo -e -n "\033[48;2;${1};${2};${3}m" ; }

##
# @brief    Generate extended font style, foreground and background escape code
# @param    $1  Font style.
# @param    $2  Foreground color.
# @param    $3  Background color.
# @result       Escape code for font style, foreground and background color.
# @return   0   Success
#           N   Error code.
function genExtStFgBg() { echo -e -n "\033[${1};38;5;${2};48;5;${3}m" ; }

##
# @brief    Generate font style, foreground and background escape code
# @param    $1  Font style.
# @param    $2  Foreground color.
# @param    $3  Background color.
# @result       Escape code for font, foreground and background color.
# @return   0   Success
#           N   Error code.
function genEscStFgBg() { echo -e -n "\033[${1};${2};${3}m" ; }

##
# @brief    Generate extended foreground escape code
# @param    $1  Foreground color.
# @result       Escape code foreground color.
# @return   0   Success
#           N   Error code.
function genExtFg()     { echo -e -n "\033[38;5;${1}m" ; }

##
# @brief    Generate extended background escape code
# @param    $1  Background color.
# @result       Escape code background color.
# @return   0   Success
#           N   Error code.
function genExtBg()     { echo -e -n "\033[48;5;${1}m" ; }

##
# @brief    Generate escape code from parameter.
# @param    $1  Color code.
# @result       Escape code for color.
# @return   0   Success
#           N   Error code.
function genEscape()    { echo -e -n "\033[${1}m" ; }

## @brief   Generate dark foreground escape code color from color code.
function genDFg()       { echo -n $((30+$1))  ; }

## @brief   Generate dark background escape code color from color code.
function genDBg()       { echo -n $((40+$1))  ; }

## @brief   Generate bright foreground escape code color from parameter.
function genIFg()       { echo -n $((90+$1))  ; }

## @brief   Generate bright background escape code color from parameter.
function genIBg()       { echo -n $((100+$1)) ; }

## @brief   Generate font style escape code from parameter.
function genEscSt()     { genEscape $1 ; }

## @brief   Generate dark foreground escape code color from parameter.
function genEscDFg()    { genEscape $((30+$1))  ; }

## @brief   Generate dark background escape code color from parameter.
function genEscDBg()    { genEscape $((40+$1))  ; }

## @brief   Generate bright foreground escape code color from parameter.
function genEscIFg()    { genEscape $((90+$1))  ; }

## @brief   Generate bright background escape code color from parameter.
function genEscIBg()    { genEscape $((100+$1)) ; }

## @brief   Generate a soft screen reset on screen.
function softReset()    { printf '\033[!p' ; }

## @brief   Generate a full screen reset.
function fullReset()
{
    # Reset Foreground Color
    printf '\033[39m'
    # Reset Background Color
    printf '\033[49m'
    # Reset Style Font
    printf '\033[0m'
    # Cursor Enable Blinking
    printf '\033[?12h'
    # Show Cursor, make it visible.
    printf '\033[?25h'
    # Reset Cursor Shape to:
    #   0:Default Cursor 
    #   1:Block Blinking
    #   2:Block Steady
    #   3:Underline Blinking
    #   4:Underline Steady
    #   5:Bar Blinking
    #   6:Bar Steady
    printf '\033[0 q'
    # Default Font
    printf '\033(B'
    printf '\033)B'
    # Make current line use single-with
    printf '\033#5'
    # Reset Palette
    #printf '\033]R'
    # Reset Selected Mapping index 10, primary font
    #printf '\033]10;rgb:c0/c0/c0'
    # Reset Selected Mapping index 11, first alternate font
    #printf '\033]11;rgb:00/00/01'
    # Reset Selected Mapping index 11, second alternate font
    #printf '\033]12;rgb:00/00/01'
    return 0
}

## @brief   Wait a key and return success if pressed or an error if timeout.
function _kbhit() { read -r -s -n 1 -t ${1:-0.25} -u 0 && return 0 || return 1 ; }

function escScreenFlashes()
{
    echo -e "Press any keyboard key..."
    while ! _kbhit $2
    do
        echo -ne "${escScrRevON}"
        sleep ${1:-0.25}
        echo -ne "${escScrRevOFF}"
        sleep ${1:-0.25}
    done 
}

## @brief   Exit from libKbHit and unload all variables and functions.
function libEscCodesExit()
{
    # Unset Variables
    unset -v libEscCodes
    unset -v STOFF
    unset -v DEFAULT
    unset -v CLEAR
    unset -v RESET
    unset -v NORMAL
    unset -v BRIGHT
    unset -v BOLD
    unset -v FADE
    unset -v DIM
    unset -v ITALIC
    unset -v UNDERLINE
    unset -v UNDERSCORE
    unset -v BLINK
    unset -v BLINKFAST
    unset -v REVERSE
    unset -v INVERT
    unset -v HIDDEN
    unset -v STRIKETHR
    unset -v FRAMED
    unset -v CIRCLED
    unset -v OVERLINE
    unset -v notBRIGHT
    unset -v notBOLD
    unset -v notFADE
    unset -v notDIM
    unset -v notITALIC
    unset -v notUNDERLINE
    unset -v notUNDERSCORE
    unset -v notBLINK
    unset -v notBLINKFAST
    unset -v notREVERSE
    unset -v notINVERSE
    unset -v notHIDDEN
    unset -v notSTRIKETHR
    unset -v notFRAMED
    unset -v notCIRCLED
    unset -v notOVERLINE
    unset -v DFG
    unset -v DBG
    unset -v IFG
    unset -v IBG
    unset -v BLACK
    unset -v RED
    unset -v GREEN
    unset -v YELLOW
    unset -v BLUE
    unset -v MAGENTA
    unset -v CYAN
    unset -v WHITE
    unset -v escNC
    unset -v escDBG
    unset -v escDFG
    unset -v escBLACK
    unset -v escRED
    unset -v escGREEN
    unset -v escYELLOW
    unset -v escBLUE
    unset -v escMAGENTA
    unset -v escCYAN
    unset -v escWHITE
    unset -v escIBLACK
    unset -v escIRED
    unset -v escIGREEN
    unset -v escIYELLOW
    unset -v escIBLUE
    unset -v escIMAGENTA
    unset -v escICYAN
    unset -v escIWHITE
    # Unset Functions
    unset -f genExtStFgBg
    unset -f genExtFg
    unset -f genExtBg
    unset -f genEscape
    unset -f genEscSt
    unset -f genEscDFg
    unset -f genEscDBg
    unset -f genEscIFg
    unset -f genEscIBg
    unset -f genEscFgRGB
    unset -f genEscBgRGB
    unset -f softReset
    unset -f fullReset
    unset -f escScreenFlashes
    unset -f libEscCodesExit
    # Return Code
    return 0
}

## @brief   Check if libRegex is loaded and available.
declare libEscCodes='loaded'

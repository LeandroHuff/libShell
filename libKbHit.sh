################################################################################
# @file         libKbHit.sh
# @brief        Source variables and functions to detect keyboard key pressed.
# @author:      Leandro D. Huff
# @copyright:   https://creativecommons.org/licenses/by/4.0/
# @sintaxe:     source libKbHit.sh
################################################################################

# Must be sourced not running
[[ "${BASH_SOURCE[0]}" == "${0}" ]] && { echo -e "\033[91mfailure\033[0m: $(basename $0) must be sourced not running." ; exit 1 ; }

## @brief   Check for key pressed, return 0 for key pressed, otherwise return 1.
function kbhit()
{
    local wait=$([ -n "$2" ] && echo -n "$2" || echo -n '1.0')
    read -s -n 1 -t $wait && return 0
    return 1
}

## @brief   Exit from lib and unload all variables and functions.
function libKbHitExit()
{
    unset -v libKbHit
    # Unset Functions
    unset -f kbhit
    unset -f libKbHitExit
    # Return Code
    return 0
}

## @brief   Variable to check lib loaded.
declare libKbHit='loaded'

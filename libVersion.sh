################################################################################
# @file         libVersion.sh
# @brief        Source variables and functions to store and get libShell version.
# @author:      Leandro D. Huff
# @copyright:   https://creativecommons.org/licenses/by/4.0/
# @sintaxe:     source libVersion.sh ... libVersionExit
################################################################################

# Must be sourced not running
[[ "${BASH_SOURCE[0]}" == "${0}" ]] && { echo -e "\033[91mfailure\033[0m: $(basename $0) must be sourced not running." ; exit 1 ; }

## @brief   libShell version (version release revision)
declare -a -i libVERSION=(2 2 5)

## @brief   Get libShell string version.
function libVersionStr() { printf "%d.%d.%d" ${libVERSION[0]} ${libVERSION[1]} ${libVERSION[2]} ; }

##
# @brief    Get libShell number version
# @details  Format is vvvrrreee
#           Where:
#           vvv: Version number
#           rrr: Release number
#           eee: Revision number
function libVersionNum() { echo -n $(( libVERSION[0]*1000000 + libVERSION[1]*1000 + libVERSION[2])) ; }

## @brief   Exit from libVersion and unload all variables and functions.
function libVersionExit()
{
    unset -v libVersion
    unset -v libVersion
    unset -f libVersionStr
    unset -f libVersionNum
    unset -f libVersionExit
    return 0
}

## @brief   Variable to verify if lib version is loaded.
declare libVersion='loaded'

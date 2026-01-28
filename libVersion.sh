################################################################################
# @file         libVersion.sh
# @brief        Source variables and functions to store and get libShell version.
# @author:      Leandro D. Huff
# @copyright:   https://creativecommons.org/licenses/by/4.0/
# @sintaxe:     source libVersion.sh ... libVersionExit
################################################################################

# Must be sourced not running
[[ "${BASH_SOURCE[0]}" == "${0}" ]] && exit 1

declare -a -i libVERSION=(2 2 4 3)

function libVersionStr() { printf "%d.%d.%d.%03d" ${libVERSION[0]} ${libVERSION[1]} ${libVERSION[2]} ${libVERSION[3]} ; }
function libVersionNum() { echo -n $(( libVERSION[0]*1000000000 + libVERSION[1]*1000000 + libVERSION[2]*1000 + libVERSION[3])) ; }

function libVersionExit()
{
    unset -v libVersion
    unset -v libVersion
    unset -f libVersionStr
    unset -f libVersionNum
    unset -f libVersionExit
    return 0
}

libVersion='loaded'

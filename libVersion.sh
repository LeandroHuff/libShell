################################################################################
# @file         libVersion.sh
# @brief        Source variables and functions to store and get libShell version.
# @author:      Leandro D. Huff
# @copyright:   https://creativecommons.org/licenses/by/4.0/
# @sintaxe:     source libVersion.sh ... libVersionExit
################################################################################

# Must be sourced not running
[[ "${BASH_SOURCE[0]}" == "${0}" ]] && exit 1

declare libVersion=''

declare -a -i libVersion=(2 2 4 2)

function libVersionStr() { printf "%d.%d.%d.%03d" ${libVersion[0]} ${libVersion[1]} ${libVersion[2]} ${libVersion[3]}; }
function libVersionNum() { echo -n $(( libVersion[0] * 1000000000 + libVersion[1] * 1000000 + libVersion[2] * 1000 + libVersion[3] )); }

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

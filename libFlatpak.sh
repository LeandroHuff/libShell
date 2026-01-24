################################################################################
# @file         libFlatpak.sh
# @brief        Source variables and functions to manage flagpak packaegs.
# @author:      Leandro D. Huff
# @copyright:   https://creativecommons.org/licenses/by/4.0/
# @sintaxe:     source libFlatpak.sh ... libFlatpakExit
################################################################################

# Must be sourced not running
[[ "${BASH_SOURCE[0]}" == "${0}" ]] && exit 1



function libFlatpakExit()
{

    unset -f libFlatpakExit
    return 0
}
################################################################################
# @file         libFlatpak.sh
# @brief        Source variables and functions to manage flagpak packaegs.
# @author:      Leandro D. Huff
# @copyright:   https://creativecommons.org/licenses/by/4.0/
# @sintaxe:     source libFlatpak.sh ... libFlatpakExit
################################################################################

# Must be sourced not running
[[ "${BASH_SOURCE[0]}" == "${0}" ]] && { echo -e "\033[91mfailure\033[0m: $(basename $0) must be sourced not running." ; exit 1 ; }

declare libFlatpak=''

function libFlatpakExit()
{
    unset -v libFlatpak

    unset -f libFlatpakExit
    return 0
}

libFlatpak='loaded'

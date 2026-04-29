################################################################################
# @file         libConn.sh
# @brief        Source variables and functions to check available internet connection.
# @author:      Leandro D. Huff
# @copyright:   https://creativecommons.org/licenses/by/4.0/
# @sintaxe:     source libConn.sh
################################################################################

# Must be sourced not running
[[ "${BASH_SOURCE[0]}" == "${0}" ]] && { echo -e "\033[91mfailure\033[0m: $(basename $0) must be sourced not running." ; exit 1 ; }

##
# @brief    Check available internet connection.
# @param    $1      limit answer counter, default 30.
# @param    $2      life time, default 1.
# @param    $3      IP table index item [0..6], default 5.
# @return   true    internet is available.
#           false   internet is not available.
function isConnected()
{
# tableIP=('CF I' 'CF II' 'Google I' 'Google II' 'Q9' 'OpenDNS I' 'OpenDNS II')
    declare -a tableIP=(1.0.0.1 1.1.1.1 8.8.4.4 8.8.8.8 9.9.9.9 208.67.220.220 208.67.222.222)
    declare -i time=${1:-30}
    declare -i retry=${2:-1}
    declare -i item=${3:-5}
    [ $item -le ${#tableIP[@]} ] || item=$((${#tableIP[@]}-1))
    if ping ${tableIP[$item]} -q -t $time -c $retry > /dev/null 2>&1
    then
        true
    else
        false
    fi
}

## @brief   Exit from lib conn and unload all variables and functions.
function libConnExit()
{
    unset -v libConn
    unset -f isConnected
    unset -f libConnExit
    return 0
}

## @brief   Check lib conn loaded and available.
declare libConn='loaded'

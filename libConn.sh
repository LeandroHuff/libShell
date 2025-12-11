#!/usr/bin/env bash

################################################################################
# @file         libConn.sh
# @brief        Source variables and functions to check available internet connection.
# @author:      Leandro D. Huff
# @copyright:   https://creativecommons.org/licenses/by/4.0/
################################################################################

function isConnected()
{
    local time=$([ -n "$1" ] && echo -n $1 || echo -n 30)
    local  try=$([ -n "$2" ] && echo -n $2 || echo -n  1)
#                        CF I      CF II     Google I  Google II Q9        OpenDNS I        OpenDNS II
    declare -a tableIP=('1.0.0.1' '1.1.1.1' '8.8.4.4' '8.8.8.8' '9.9.9.9' '208.67.220.220' '208.67.222.222')
    local res=false
    index=5
    #for ((index = 0 ; index < ${#tableIP[@]} ; index++))
    #do
        if ping "${tableIP[$index]}" -q -t $time -c $try > /dev/null 2>&1
        then
            true
            return
        fi
    #done
    false
}

function libConnExit()
{
    unset -f isConnected
    unset -f libConnExit
    return 0
}

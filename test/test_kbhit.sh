#!/usr/bin/env bash

################################################################################
# @file     test_libKbhit.sh
# @brief    Test and check libKbhit file.
# @parameter
#           -h|--help           Show help message.
#           -g|--debug          Set debug mode on.
#           -p|--path <dir>     Set libShell path.
#           -t|--type <0|1|2>   Set test type, 0 default.
#           -l|--load           Enable source libShell.
#              --               Let next parameters to setup libs.
# @return
#           0 : Success
#           1+: failure
################################################################################

function logI() { printf "\033[97minfo\033[0m: $*\n" ; }
logI "Press key [q or Q] to exit from program."

while true
do
    if kbhit
    then
        key=$(getchar)
        if [ "${key}" = 'q' ] || [ "${key}" = 'Q' ]
        then
            break
        fi
    fi
    sleep 0.1
done

exit 0

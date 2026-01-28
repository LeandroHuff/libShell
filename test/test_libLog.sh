#!/usr/bin/env bash

declare -a  libLIST=(Log)
declare -a  libLOADED=()
declare     libPATH="/home/${USER}/dev/libShell"
declare     testPATH="/home/${USER}/dev/libShell/test"

################################################################################
# @file     test_libLog.sh
# @brief    Test and check libLog file.
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

function logFail() { echo -e "\033[91mfailure\033[0m: $*" ; }

function _exit()
{
    local code=${1:-0}
    logR
    logStop $code
    for file in ${libLOADED[@]}
    do
        $(lib${file}Exit $code) || logFail "Unload lib${file}.sh"
    done
    # Unload local variables
    unset -v file
    unset -f logFail
    unset -f _exit

    exit $code
}

for file in ${libLIST[@]}
do
    if [ -f "${libPATH}/lib${file}.sh" ]
    then
        source "${libPATH}/lib${file}.sh"
        if [ $? -eq 0 ]
        then
            libLOADED+=(${file})
        else
            logFail "Load lib${file}.sh"
            _exit 1
        fi
    else
        logFail "File ${libPATH}/lib${file}.sh not found."
        _exit 2
    fi
done

logInit "$@"

logD "message debug"
logS "message success"
logF "message failure"
logE "message error"
logI "message info"

_exit 1

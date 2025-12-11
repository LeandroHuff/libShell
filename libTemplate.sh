#!/usr/bin/env bash

################################################################################
# @file         libTemplate.sh
# @brief        Source variables and functions to start programming a shell librarie.
# @author:      Leandro D. Huff
# @copyright:   https://creativecommons.org/licenses/by/4.0/
################################################################################

# Local variables.
declare -a  libLIST=(Config Conn EscCodes File Git Log Math Random Regex Shell String Time)
declare -a  libLOADED=()
declare     libPATH="/home/${USER}/dev/libShell"
declare     libTemplateLoaded=false

# Print failure messages on terminal.
function failure() { echo -e "\033[31mfailure\033[0m: $*" ; }

# Setup lib
function libTemplateSetup()
{
    function isParam() { case "$1" in -*) true ;; *) false ;; esac ; }
    declare -i err=0
    if [ $# -gt 0 ]
    then
        while [ -n "$1" ]
        do
            case "$1" in
                --) shift ; break ;;
                *) failure 'Invalid parameter ($1).' ; return 1 ;;
            esac
            shift
        done
    fi
    return $err
}

# Verify lib is loaded.
function isLibTemplateLoaded() { if $libTemplateLoaded ; then true ; else false ; fi }

# Unload Libs, Variables and Functions.
function libTemplateExit()
{
    for file in "${libLOADED[@]}"
    do
        $(lib${file}Exit) || failure "Unload lib${file}.sh"
    done

    # Unset Variables
    unset -v libLIST
    unset -v libLOADED
    unset -v libPATH
    unset -v libTemplateLoaded

    # Unset Functions
    unset -f failure
    unset -f main
    unset -f libTemplateSetup
    unset -f isLibTemplateLoaded
    unset -f libTemplateExit

    return 0
}

# Main Program Application.
function main()
{
    echo '--------------------------------------------------------------------------------'

    # Setup Libs
    logInit -d -f
    libTimeSetup -t 5

    logI "Log loaded and all (${libLOADED[@]}) libs."
    logR

    # Reset Libs
    logStop

    echo '--------------------------------------------------------------------------------'
    return 0
}

# Load Libs
for file in "${libLIST[@]}"
do
    if [ -f "${libPATH}/lib${file}.sh" ]
    then
        source "${libPATH}/lib${file}.sh"
        if [ $? -eq 0 ]
        then
            libLOADED+=(${file})
        else
            failure "Load lib${file}.sh"
        fi
    else
        failure "File lib${file}.sh not found."
    fi
done

# Template Loaded Flag.
libTemplateLoaded=true

# Call main() function.
main "$@"
code=$?

# Unload Libs, Variables and Functions.
libTemplateExit
exit $code

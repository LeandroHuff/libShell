#!/usr/bin/env bash

################################################################################
# @file         libTemplate.sh
# @brief        Source variables and functions to add wait states and ask for user
#               confirmation in a bash source code.
# @author:      Leandro D. Huff
# @copyright:   https://creativecommons.org/licenses/by/4.0/
################################################################################

declare -i libTimeout=10

function _isNum() { if echo -n "${1}" | grep -aoP '^[-+]?(\d+\.?\d*|\d*\.\d+)$' > /dev/null 2>&1 ; then true ; else false ; fi ; }
function _isInt() { if echo -n "${1}" | grep -aoP '^[+-]?\d+$' > /dev/null 2>&1 ; then true ; else false ; fi ; }
function _isNot() { case "$1" in [nN] | [nN][oO] | [nN][oO][tT]) true ;; *) false ;; esac ; }
function _isYes() { case "$1" in [yY] | [yY][eE][sS])            true ;; *) false ;; esac ; }

function wait() {
    local _time=$(if _isInt $1 ; then echo -n $1 ; else echo -n $libTimeout ; fi)
    local ans=''
    if [ $_time -gt 0 ]; then
        while true; do
            echo -e -n "\rWait ($_time)? [n]: "
            read -n 1 -N 1 -t 1 ans
            _time=$((_time - 1))
            if _isNot $ans || [ $_time -le 0 ]; then
                echo
                break
            fi
        done
    else
        read -n 1 -N 1 -p "Press any key to continue... "
        echo
    fi
    return 0
}

function askToContinue() {
    local count=0
    local err=2
    if _isInt $1
    then
        count=$1
        if [ $count -gt 0 ]
        then
            while [ $count -gt 0 ]
            do
                printf "\rContinue [y|n] ($count): "
                read -t 1 -n 1 -N 1 answer
                res=$?
                if [ $res -eq 0 ]
                then
                    if _isYes $answer
                    then
                        echo
                        err=0
                        break
                    elif _isNot $answer
                    then
                        echo
                        err=1
                        break
                    fi
                fi
                count=$((count - 1))
            done
        elif [ $count -eq 0 ]
        then
            read -n 1 -N 1 -p "Continue [y|n]? : " answer
            if [ $res -eq 0 ]
            then
                echo
                err=0
            elif _isNot $answers
            then
                echo
                err=1
            fi
        fi
    else
        err=3
    fi
    return $err
}

function libTimeIsArg() { if [ -n "$1" ] ; then case $1 in -*) false ;; *) true ;; esac ; else false ; fi ; }

function libTimeUsage()
{
    cat << EOT
Bash script libTime source function for wait and times.
Usage: source libTime.sh [options]
       libTimeSetup [options]
Options:
-h|--help               Show help message.
-t|--timeout <time>     Set new timeout in seconds.
EOT
}

function libTimeSetup()
{
    local err=0
    while [ $# -gt 0 ] && [ -n "$1" ]
    do
        case $1 in
        -h|--help) libTimeUsage ; break ;;
        -t|--timeout)
            if _isInt "$2"
            then
                shift
                libTimeout=$1
            else
                err=1
                break
            fi
            ;;
        -*) err=2 ; break ;;
         *) err=3 ; break ;;
        esac
        shift
    done
    return $err
}

function libTimeExit()
{
    unset -v libTimeout
    unset -f _isNum
    unset -f _isInt
    unset -f _isNot
    unset -f _isYes
    unset -f wait
    unset -f askToContinue
    unset -f libTimeExit
    unset -f libTimeSetup
    unset -f libTimeUsage
    unset -f libTimeIsArg
    return 0
}

#!/usr/bin/env bash

################################################################################
# @file         libRandom.sh
# @brief        Source variables and functions to generate randomic strings.
# @author:      Leandro D. Huff
# @copyright:   https://creativecommons.org/licenses/by/4.0/
################################################################################

declare -a typeRANDOM=(alpha digit alnum lowhex uphex mixhex graph space date)

# Functions
function _isInt() { if echo -n "${1}" | grep -aoP '^[+-]?\d+$' > /dev/null 2>&1 ; then true ; else false ; fi ; }

function genRandomAlpha()                  { if _isInt "$1" ; then tr < /dev/urandom -d -c [:alpha:]          | head --bytes=$1 ; else return 1 ; fi ; }
function genRandomNumeric()                { if _isInt "$1" ; then tr < /dev/urandom -d -c [:digit:]          | head --bytes=$1 ; else return 1 ; fi ; }
function genRandomAlphaNumeric()           { if _isInt "$1" ; then tr < /dev/urandom -d -c [:alnum:]          | head --bytes=$1 ; else return 1 ; fi ; }
function genRandomLowerHexadecimalNumber() { if _isInt "$1" ; then tr < /dev/urandom -d -c [:digit:]"a-f"     | head --bytes=$1 ; else return 1 ; fi ; }
function genRandomUpperHexadecimalNumber() { if _isInt "$1" ; then tr < /dev/urandom -d -c [:digit:]"A-F"     | head --bytes=$1 ; else return 1 ; fi ; }
function genRandomHexadecimalNumber()      { if _isInt "$1" ; then tr < /dev/urandom -d -c [:xdigit:]         | head --bytes=$1 ; else return 1 ; fi ; }
function genRandomGraph()                  { if _isInt "$1" ; then tr < /dev/urandom -d -c [:graph:]          | head --bytes=$1 ; else return 1 ; fi ; }
function genRandomGraphSpace()             { if _isInt "$1" ; then tr < /dev/urandom -d -c [:graph:][:space:] | head --bytes=$1 ; else return 1 ; fi ; }
function genDateTimeAsCode()               { echo -n $(date '+%Y-%m-%d-%H-%M-%S-%3N') ; }
function genRandom()
{
    local err=1
    local str=''
    if [ -n "$1" ]
    then
        if [[ "${typeRANDOM[@]}" =~ "$1" ]]
        then
            declare type="$1"
            if [ -n "$2" ] || [ "${type}" = 'date' ]
            then
                if _isInt "$2" || [ "${type}" = 'date' ]
                then 
                    declare -i len=$2
                    case "$type" in
                    alpha)  str="$(genRandomAlpha                  $len)" ; err=$? ;;
                    digit)  str="$(genRandomNumeric                $len)" ; err=$? ;;
                    alnum)  str="$(genRandomAlphaNumeric           $len)" ; err=$? ;;
                    lowhex) str="$(genRandomLowerHexadecimalNumber $len)" ; err=$? ;;
                    uphex)  str="$(genRandomUpperHexadecimalNumber $len)" ; err=$? ;;
                    mixhex) str="$(genRandomHexadecimalNumber      $len)" ; err=$? ;;
                    graph)  str="$(genRandomGraph                  $len)" ; err=$? ;;
                    space)  str="$(genRandomGraphSpace             $len)" ; err=$? ;;
                    date)   str="$(genDateTimeAsCode)"                  ; err=$? ;;
                    esac
                else
                    err=5
                fi
            else
                err=4
            fi
        else
            err=3
        fi
    else
        err=2
    fi
    echo -n "${str}"
    return $err
}

function genUUID()
{
    local err=1
    local str=''
    if [ -n "$1" ]
    then
        declare -a typeUUID=(alpha digit alnum lowhex uphex mixhex)
        if [[ "${typeUUID[*]}" =~ "$1" ]]
        then
            local _type="$1"
            shift
            if [ -n "$1" ]
            then
                if _isInt $1
                then
                    str="$(genRandom ${_type} $1)"
                    err=$?
                    shift
                    [ $err -eq 0 ] || str=''
                    while [ -n "$1" ] && [ $err -eq 0 ]
                    do
                        if _isInt $1
                        then
                            len=$1
                            str="${str}-$(genRandom $_type $len)"
                            err=$?
                        else
                            str=''
                            err=6
                        fi
                        shift
                    done
                else
                    err=5
                fi
            else
                err=4
            fi
        else
            err=3
        fi
    else
        err=2
    fi
    echo -n "${str}"
    return $err
}

function libRandomExit()
{
    # local variables
    unset -v typeRANDOM
    # local functions
    unset -f _isInt
    unset -f libRandomIsInt
    unset -f genRandomAlpha
    unset -f genRandomNumeric
    unset -f genRandomAlphaNumeric
    unset -f genRandomLowerHexadecimalNumber
    unset -f genRandomUpperHexadecimalNumber
    unset -f genRandomHexadecimalNumber
    unset -f genRandomString
    unset -f genRandomStringSpace
    unset -f genDateTimeAsCode
    unset -f genRandom
    unset -f genUUID
    unset -f libRandomExit
    return 0
}
#!/usr/bin/env bash

################################################################################
# @file         libFile.sh
# @brief        Source variables and functions to treat files on file system.
# @author:      Leandro D. Huff
# @copyright:   https://creativecommons.org/licenses/by/4.0/
################################################################################

function getScriptName() { echo -n "$(basename "$0")" ; }
function getFileName()   { echo -n "$(basename "$1")" ; }
function getName()       { local file="$(basename "$1")" ; echo -n "${file%.*}" ; }
function getExt()        { local file="$(basename "$1")" ; echo -n "${file##*.}" ; }
function getPath()       { echo -n "${1%/*}" ; }
function isLink()        { if [ -L "$1" ] ; then true ; else false ; fi ; }
function isFile()        { if [ -f "$1" ] ; then true ; else false ; fi ; }
function isDir()         { if [ -d "$1" ] ; then true ; else false ; fi ; }
function isBlockDevice() { if [ -b "$1" ] ; then true ; else false ; fi ; }
function getTempDir()    { [ -d '/tmp' ] && echo -n '/tmp' || echo "$HOME/tmp" ; }
function followLink()
{
    local target=''
    local err=1
    if [ -L "$1" ]
    then
        target="$(readlink -e "$1")"
        err=$?
    fi
    echo -n "${target}"
    return $err
}
function linkTargetExist()
{
    local target
    target="$(readlink -e "$1")"
    if [ $? -eq 0 ] && [ -n "${target}" ] && [ -e "${target}" ]
    then
        true
    else
        false
    fi
}
function itExist()
{
    if [ -e "$1" ]
    then
        if [ -L "$1" ]
        then
            if [ -e "$(readlink -e "$1")" ]
            then
                true
            else
                false
            fi
        else
            true
        fi
    else
        false
    fi
}
function getMountDir()
{
    if   [ -d /media     ] ; then echo -n "/media"
    elif [ -d /run/media ] ; then echo -n "/run/media"
    else                          echo -n "/mnt"
    fi
}

function tryRun()
{
    local res=''
    declare -i err=1
    declare -i try=1
    declare -i debugEn=0
    declare -i traceEn=0
    declare -i resultEn=0
    function _isInt() { if echo -n "$1" | grep -aoP '^\d$' > /dev/null 2>&1 ; then true ; else false ; fi ; }
    function _error() { if [ $debugEn  -ne 0 ] ; then echo -e "\033[31m  error\033[0m: $*" >&2 ; fi ; }
    function _debug() { if [ $debugEn  -ne 0 ] ; then echo -e "\033[32m  debug\033[0m: $*" >&2 ; fi ; }
    function _result(){ if [ $resultEn -ne 0 ] ; then echo -n "$*" ; fi ; }
    while [ -n "$1" ]
    do
        case "$1" in
        -g|--debug) debugEn=1 ;;
        -r|--res|--result) resultEn=1 ;;
        -c|--retry)
            shift
            if _isInt "$1"
            then
                try=$1
            else
                _error "Invalid ($1) for option -c|--retry <number>"
                break
            fi
            ;;
        -*) _error "Invalid parameter ($1)" ; break ;;
        *)  while [ $try -gt 0 ] && [ $err -ne 0 ]
            do
                _debug "eval $* 2> /dev/null"
                res="$(eval "$* 2> /dev/null")"
                err=$?
                let try--
            done
            break
            ;;
        esac
        shift
    done
    _debug "res: '${res}'"
    _result "${res}"
    return $err
}

function libFileExit()
{
    unset -f getScriptName
    unset -f getFileName
    unset -f getName
    unset -f getExt
    unset -f getPath
    unset -f isLink
    unset -f isFile
    unset -f isDir
    unset -f isBlockDevice
    unset -f getTempDir
    unset -f followLink
    unset -f linkTargetExist
    unset -f itExist
    unset -f getMountDir
    unset -f tryRun
    unset -f libFileExit
    return 0
}

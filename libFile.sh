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
    unset -f libFileExit
    return 0
}

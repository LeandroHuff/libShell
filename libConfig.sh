#!/usr/bin/env bash

################################################################################
# @file         libConfig.sh
# @brief        Source variables and functions to save and load user configuration
#               in/from local files.
# @author:      Leandro D. Huff
# @copyright:   https://creativecommons.org/licenses/by/4.0/
################################################################################

function getTag(){ echo -n "${1%=*}" ; }
function getValue() { echo -n "${1##*=}" ; }

#
# parameter:
#   $1  : filename
#   $2  : length
#   $[@]: tags
#   $[@]: values
function saveConfigToFile()
{
    local filename="$1"
    shift
    local len=$1
    shift
    local tags=()
    local values=()
    local err=0
    local index
    local string
    # Check filename parameters.
    [ -n "${filename}" ] || return 1
    [ $len -gt 0 ] || return 2
    # Get all tags
    for ((index=0; index < len; index++))
    do
        tags+=("$1")
        shift
    done
    # Get all values
    for ((index=0; index < len; index++))
    do
        values+=("$1")
        shift
    done
    # Clear target file.
    echo -n > "${filename}"
    # Save tag=value into filename.
    for ((index=0; index < len; index++))
    do
        printf -v string "%s=%s" "${tags[$index]}" "${values[$index]}"
        echo "${string}" >> "${filename}" || { err=$((err|8)) ; echo -e "\033[31merror\033[0m: Save ${tags[$index]}=${values[$index]} into file ${filename}" ; }
    done
    return $err
}

function readTagsFromFile()
{
    local filename="$1"
    local tags=()
    if [ -f "${filename}" ]
    then
        while read -e line
        do
            if [ -z "${line}" ] ; then continue ; fi
            if [ ${line:0:1} = "#" ] ; then continue ; fi
            tags+=("$(getTag "${line}")")
        done < "${filename}"
    else
        return -1
    fi
    echo -n "${tags[@]}"
    return "${#tags[@]}"
}

function readValuesFromFile()
{
    local filename="$1"
    local tableVALUES=()
    if [ -f "${filename}" ]
    then
        while read -e line
        do
            if [ -z "${line}" ] ; then continue ; fi
            if [ ${line:0:1} = "#" ] ; then continue ; fi
            tableVALUES+=("$(getValue "${line}")")
        done < "${filename}"
    else
        return -1
    fi
    echo -n "${tableVALUES[@]}"
    return "${#tableVALUES[@]}"
}

function loadConfigFromFile()
{
    local _filename="$1"
    shift
    local _len=$1
    shift

    declare -i _err=0
    declare -i _index
    local _tableTAG=()
    local _tableDEFAULT=()
    local _tableCONFIG=()
    local _value=''

    # Check filename parameters.
    if [ -z "${_filename}" ]
    then
        return 1
    fi
    if [ -z "$_len" ]
    then
        return 2
    fi
    if [ $_len -le 0 ]
    then
        return 4
    fi

    # Get all tags
    for ((_index=0; _index < _len; _index++))
    do
        [ -n "$1" ] || return 8
        _tableTAG+=("$1")
        shift
    done

    # Get all values
    for ((_index=0; _index < _len; _index++))
    do
        [ -n "$1" ] || return 16
        _tableDEFAULT+=("$1")
        shift
    done

    if ! [ -f "${_filename}" ]
    then
        echo -n "${_tableDEFAULT[@]}"
        return 32
    fi

    local _found
    # search tag
    for ((_index=0 ; _index < $_len ; _index++))
    do
        _found=false
        while read -e _line ; do
            # do not compute empty lines
            if ! [ -n "${_line}" ] ; then continue ; fi
            # do not compute commented lines
            if [ ${_line:0:1} = "#" ] ; then continue ; fi
            # take tag from line
            if [[ "$(getTag "${_line}")" == "${_tableTAG[$_index]}" ]]
            then
                _value="$(getValue "${_line}")"
                if [ -n "${_value}" ]
                then
                    _tableCONFIG+=("${_value}")
                    _found=true
                fi
                break
            fi
        done < "${_filename}"
        if ! $_found ; then _tableCONFIG+=("${_tableTAG[$_index]}") ; fi
    done

    echo -n "${_tableCONFIG[@]}"
    return 0
}

function libConfigExit()
{
    unset -f getTag
    unset -f getValue
    unset -f saveConfigToFile
    unset -f readTagsFromFile
    unset -f readValuesFromFile
    unset -f loadConfigFromFile
    unset -f libConfigExit
    return 0
}

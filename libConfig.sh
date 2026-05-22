################################################################################
# @file         libConfig.sh
# @brief        Source variables and functions to save and load user configuration
#               in/from local files.
# @author:      Leandro D. Huff
# @copyright:   https://creativecommons.org/licenses/by/4.0/
# @sintaxe:     source libConfig.sh
################################################################################

# Must be sourced not running
[[ "${BASH_SOURCE[0]}" == "${0}" ]] && { echo -e "\033[91mfailure\033[0m: $(basename $0) must be sourced not running." ; exit 1 ; }

## @brief   Get tag name from a string parameter as tag=value
function _getTag() { echo -n "${1%=*}" ; }

## @brief   Get value from a string parameter as tag=value
function _getValue() { echo -n "${1##*=}" ; }

#
# parameter:
#   $1  : filename
#   $2  : tags|values array items counter
#   $[@]: tags
#   $[@]: values
function saveConfigToFile()
{
    local filename="$1"
    shift
    local items=$1
    shift
    local tags=()
    local values=()
    local err=0
    local index
    local string
    # Check filename parameters.
    [ -n "${filename}" ] || return 1
    [ $items -gt 0 ] || return 2
    # Get all tags
    for ((index=0; index < items; index++))
    do
        tags+=("$1")
        shift
    done
    # Get all values
    for ((index=0; index < items; index++))
    do
        values+=("$1")
        shift
    done
    # Clear target file.
    echo -n > "${filename}"
    # Save tag=value into filename.
    for ((index=0; index < items; index++))
    do
        printf -v string "%s=%s" "${tags[$index]}" "${values[$index]}"
        echo "${string}" >> "${filename}" || { err=$((err|8)) ; echo -e "\033[31m  error\033[0m: Save ${tags[$index]}=${values[$index]} into file ${filename}" ; }
    done
    return $err
}

function readTagsFromFile()
{
    declare filename="$1"
    declare -a tags=()
    if [ -f "${filename}" ]
    then
        while read -e line
        do
            # skip empty lines
            if echo -n "${line}" | grep -qaoP '^ *$' > /dev/null 2>&1 ; then continue ; fi
            # skip commented lines
            if echo -n "${line}" | grep -qaoP '^ *#+' > /dev/null 2>&1 ; then continue ; fi
            tags+=("$(_getTag ${line})")
        done < "${filename}"
    else
        return 0
    fi
    # print list
    echo -n ${tags[@]}
    # return items counter
    return ${#tags[@]}
}

function readValuesFromFile()
{
    declare filename="$1"
    declare -a values=()
    if [ -f "${filename}" ]
    then
        while read -e line
        do
            # skip empty lines
            if echo -n "${line}" | grep -qaoP '^ *$' > /dev/null 2>&1 ; then continue ; fi
            # skip commented lines
            if echo -n "${line}" | grep -qaoP '^ *#+' > /dev/null 2>&1 ; then continue ; fi
            values+=("$(_getValue ${line})")
        done < "${filename}"
    else
        return 0
    fi
    # print list
    echo -n ${values[@]}
    # print items counter
    return ${#values[@]}
}

function loadConfigFromFile()
{
    declare filename="$1"
    shift
    declare -i items=$1
    shift

    declare -i err=0
    declare -i index
    declare -a tableTAG=()
    declare -a tableDEFAULT=()
    declare -a tableCONFIG=()
    declare -a value=''

    # Check filename parameters.
    if [ -z "${filename}" ]
    then
        return 1
    fi
    if [ -z "$items" ]
    then
        return 2
    fi
    if [ $items -le 0 ]
    then
        return 4
    fi

    # Get all tags
    for ((index=0; index < items; index++))
    do
        [ -n "$1" ] || return 8
        tableTAG+=("$1")
        shift
    done

    # Get all values
    for ((index=0; index < items; index++))
    do
        [ -n "$1" ] || return 16
        tableDEFAULT+=("$1")
        shift
    done

    if ! [ -f "${filename}" ]
    then
        echo -n "${tableDEFAULT[@]}"
        return 32
    fi

    local found
    # search tag
    for ((index=0 ; index < $items ; index++))
    do
        found=false
        while read -e line ; do
            # skip empty lines
            if echo -n "${line}" | grep -qaoP '^ *$' > /dev/null 2>&1 ; then continue ; fi
            # skip commented lines
            if echo -n "${line}" | grep -qaoP '^ *#+' > /dev/null 2>&1 ; then continue ; fi
            # take tag from line
            if [[ "$(_getTag ${line})" == "${tableTAG[$index]}" ]]
            then
                value="$(_getValue ${line})"
                if [ -n "${value}" ]
                then
                    tableCONFIG+=("${value}")
                    found=true
                fi
                break
            fi
        done < "${filename}"
        if ! $found ; then tableCONFIG+=("${tableTAG[$index]}") ; fi
    done

    echo -n "${tableCONFIG[@]}"
    return ${#tableCONFIG[@]}
}

function libConfigExit()
{
    unset -v libConfig
    unset -f _getTag
    unset -f _getValue
    unset -f saveConfigToFile
    unset -f readTagsFromFile
    unset -f readValuesFromFile
    unset -f loadConfigFromFile
    unset -f libConfigExit
    return 0
}

declare libConfig='loaded'

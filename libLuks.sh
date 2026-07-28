################################################################################
# @file         libLuks.sh
# @brief        Source variables and functions to treat encrypted files by LUKS.
# @author:      Leandro D. Huff
# @copyright:   https://creativecommons.org/licenses/by/4.0/
# @sintaxe:     source libLuks_v2.sh [-v] [-g]
#               where:
#               -v  Set verbose and disable quiet mode, enable info, warning and error messages.
#               -g  Enable debug messages.
################################################################################

[[ "${BASH_SOURCE[0]}" == "${0}" ]] && { echo -e "\033[91mfailure\033[0m: $(basename $0) must be sourced not running." ; return 1 ; }

declare -a luks_fsTABLE=(ext4 btrfs)
declare luks_fsDEFAULT="${luks_fsTABLE[0]}"
declare luks_fsMODE='0700'
declare luks_usrMODE='0744'

function luks_getMountDir()
{
    if [ -d /run/media ]
    then
        echo -n "/run/media/$USER"
    elif [ -d /media ]
    then
        echo -n "/media/$USER"
    else
        echo -n "/mnt/$USER"
    fi
}

function luks_getMapperDir() { echo -n '/dev/mapper' ; }

# $1:target
function luks_stripPunct() { echo -n "$1" | tr -d '[:punct:]' ; }

# $1:target
function luks_stripPathPunct() { luks_stripPunct "$(basename "$1")" ; }

# $1:target
function luks_genDeviceName() { echo -n "luks-$(luks_stripPathPunct "$1")" ; }

# $1:target $2:mode
function luks_setMode() { sudo chmod --quiet ${2:-$luks_fsMODE} "$1" 2> /dev/null ; }

# $1:target $2:mode
function luks_setOwner() { sudo chown --quiet -f ${2:-$USER}:${2:-$USER} "$1" 2> /dev/null ; }

# $1:target
function luks_makeDir() { mkdir -p --mode=${2:-$luks_usrMODE} "$1" 2> /dev/null ; }

# $1:target
function luks_removeDir() { sudo rmdir "$1" 2> /dev/null ; }

# $1:target $2:fstype
function luks_hasBlockFS() { lsblk -l -o fstype "$1" 2> /dev/null | grep -qaoF "${2:-$luks_fsDEFAULT}" &> /dev/null ; }

# $1:target $2:fstype
function luks_hasDirFS() { df --output=fstype "$1" 2> /dev/null | grep -qaoF "${2:-$luks_fsDEFAULT}" &> /dev/null ; }

# $1:target $2:fstype
function luks_hasBlockAnyFS() { lsblk -l -o fstype "$1" &> /dev/null ; }

# $1:target
function luks_hasDirAnyFS() { df --output=fstype "$1" &> /dev/null ; }

# $1:target
function luks_isLuksDevice() { sudo cryptsetup isLuks "$1" &> /dev/null ; }

# $1:target [$2:keyfile]
function luks_format()
{
    if [ -n "$2" ]
    then
        sudo cryptsetup -q -M luks2 -y -d "$2" luksFormat "$1" 2> /dev/null
    else
        sudo cryptsetup -q -M luks2 -y luksFormat "$1" 2> /dev/null
    fi
}

# $1:target $2:device [$3:keyfile]
function luks_open()
{
    if [ -n "$3" ]
    then
        sudo cryptsetup -q -M luks2 -d "$3" luksOpen "$1" "$2" 2> /dev/null
    else
        sudo cryptsetup -q -M luks2 luksOpen "$1" "$2" 2> /dev/null
    fi
}

# $1:target
function luks_close() { sudo cryptsetup -q luksClose "$1" 2> /dev/null ; }

# $1:target $2:fstype
function luks_formatFS() { sudo mkfs.${2:-$luks_fsDEFAULT} -q -f "${1}" 2> /dev/null ; }

# $1:source $2:destine $3:user
function luks_mountDevice()
{
    if [ -n "$1" ] && [ -n "$2" ]
    then
        sudo mount -m -i -n \
--onlyonce \
--make-private \
--make-unbindable \
-o rw,owner,noatime,nodev,nofail,user="${3:-$USER}" \
--source "$1" \
--target "$2" 2> /dev/null
    else
        return 1
    fi
}

# $1:target
function luks_umountDevice()
{
    if [ -n "$1" ]
    then
        sudo umount -d -f -n -l -q "$1" 2> /dev/null
        sleep 5
        luks_removeDir "$1"
    else
        return 1
    fi
}

# $1:target $2:mode $3:user
function luks_setAccess()
{
    if [ -n "$1" ] && [ -n "$2" ]
    then
        luks_setOwner "$1" "${3:-$USER}" $2
        luks_setMode "$1" $2
        luks_makeDir "${1}/${3:-$USER}_success" "$luks_usrMODE"
        echo 1 > "${1}/${3:-$USER}_success/ok"
    else
        return 1
    fi
}

# $1:device [$2:keyfile]
function luks_openDrive()
{
    declare target=''
    declare device=''
    declare keyfile=''

    if [ -n "$1" ]
    then
        target="$1"
        device="$(luks_genDeviceName "$1")"
        mountDir="$(luks_getMountDir)"
        mapperDir="$(luks_getMapperDir)"

        if [ -n "$2" ]
        then
            keyfile="$2"
            luks_open "${target}" "${device}" "${keyfile}"
        else
            luks_open "${target}" "${device}"
        fi

        luks_mountDevice "${mapperDir}/${1}" "${mountDir}/${1}"
        luks_setAccess "${mountDir}/${1}" "$luks_fsMODE"
    else
        return 1
    fi
}

# $1:device
function luks_closeDevice()
{
    declare device=''
    declare mountDir="$(luks_getMountDir)"
    declare mapperDir="$(luks_getMapperDir)"

    if [ -n "$1" ]
    then
        device="$1"
        luks_umountDevice "${mapperDir}/${device}"
        luks_close "${device}"
    else
        return 1
    fi
}

# $1:target [$2:fstype] [$3:keyfile]
function luks_formatDrive()
{
    declare target=''
    declare keyfile=''
    declare device=''
    declare fstype='ext4'
    declare mountDir="$(luks_getMountDir)"
    declare mapperDir="$(luks_getMapperDir)"

    if [ -n "$1" ]
    then
        target="$1"
        device="$(luks_genDeviceName "$target")"

        if [[ "${luks_fsTABLE[@]}" =~ "$2" ]] ; then fstype="$2" ; fi

        if [ -n "$3" ]
        then
            keyfile="$3"
            luks_format "$target" "$keyfile"
            luks_open "$target" "$device" "$keyfile"
        else
            luks_format "$target"
            luks_open "$target" "$device"
        fi

        luks_formatFS "${mapperDir}/${device}" "$fstype"
        luks_mountDevice "${mapperDir}/${device}" "${mountDir}/${device}"
        luks_setAccess "${mountDir}/${device}" "$luks_fsMODE"
    else
        return 1
    fi
}

##  @brief  Exit from libLuks, unload all variables and functions.
function libLuksExit()
{
    # unset variables
    unset -v luks_fsTABLE
    unset -v luks_fsDEFAULT
    unset -v luks_fsMODE
    unset -v luks_usrMODE
    # unset functions
    unset -f luks_getMountDir
    unset -f luks_getMapperDir
    unset -f luks_stripPunct
    unset -f luks_stripPathPunct
    unset -f luks_genDeviceName
    unset -f luks_setMode
    unset -f luks_setOwner
    unset -f luks_makeDir
    unset -f luks_removeDir
    unset -f luks_hasBlockFS
    unset -f luks_hasDirFS
    unset -f luks_hasBlockAnyFS
    unset -f luks_hasDirAnyFS
    unset -f luks_isLuksDevice
    unset -f luks_format
    unset -f luks_open
    unset -f luks_close
    unset -f luks_formatFS
    unset -f luks_mountDevice
    unset -f luks_umountDevice
    unset -f luks_setAccess
    unset -f luks_openDrive
    unset -f luks_closeDevice
    unset -f luks_formatDrive
}

declare libLuks='loaded'

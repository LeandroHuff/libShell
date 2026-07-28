################################################################################
# @file         libFile.sh
# @brief        Source variables and functions to treat files on file system.
# @author:      Leandro D. Huff
# @copyright:   https://creativecommons.org/licenses/by/4.0/
# @sintaxe:     source libFile.sh
################################################################################

# Must be sourced not running
[[ "${BASH_SOURCE[0]}" == "${0}" ]] && { echo -e "\033[91mfailure\033[0m: $(basename $0) must be sourced not running." ; exit 1 ; }

if [ "x$logFile" = 'x' ]
then
    declare logFILE="$HOME/src/aliases/logs.sh"

    if [ -f "$logFILE" ]
    then
        source "$logFILE"

        if [ $? -ne 0 ]
        then
            echo -e "\033[91m  error\033[0m: File $logFILE could not be loaded."
            exit 2
        fi
    else
        echo -e "\033[91m  error\033[0m: File $logFILE not found."
        exit 1
    fi

    unset -v logFILE
fi

setupLog -g 1

declare -a    tableFS=(btrfs ext4)
declare       regexFS='(btrfs|ext4)'
declare -a tableAnyFS=(btrfs crypto_LUKS exfat ext2 ext3 ext4 fat fat16 fat32 hfs hfsplus jfs ntfs reiser reiser4 ufs xfs zfs)
declare    regexAnyFS='(btrfs|crypto_LUKS|exfat|ext2|ext3|ext4|fat|fat16|fat32|hfs|hfsplus|jfs|ntfs|reiser|reiser4|ufs|xfs|zfs)'
declare     defaultFS="${tableFS[0]}"
declare        fsMODE='0700'
declare       usrMODE='0744'

## @brief   Check string by regex.
function file_regexIt()
{
    if [ "x$1" = 'x' ] || [ "x$2" = 'x' ]
    then
        return 1
    else
        local str="$1"
        local reg="$2"
        shift 2
        echo -n "${str}" | grep -aoP --color=never "$@" "${reg}" 2> /dev/null || return 1
    fi
}

## @brief   Get main script name.
function getScriptName() { echo -n "$(basename "$0")" ; }

## @brief   Get filename (name + extension).
function getFileName() { if [ "x$1" = 'x' ] ; then return 1 ; else echo -n "$(basename "$1")" ; fi ; }

## @brief   Get file name only.
function getName() { if [ "x$1" = 'x' ] ; then return 1 ; else local file="$(basename "$1")" ; echo -n "${file%.*}" ; fi ; }

## @brief   Get file extension only.
function getExt() { [ "x$1" = 'x' ] && return 1 ; local name="$(basename "$0")" ; echo -n "${name##*.}" ; }

## @brief   Get path from filename.
function getPath() { [ "x$1" = 'x' ] && return 1 || echo -n "$(dirname "$1")" ; }

## @brief   Check if parameter is a link.
function isLink() { [ -L "$1" ] && true || false ; }

## @brief   Check if parameter is a file.
function isFile() { [ -f "$1" ] && true || false ; }

## @brief   Check if parameter is a directory.
function isDir() { [ -d "$1" ] && true || false ; }

# @brief    Check if parameter is a block device.
function isBlockDevice() { [ -b "$1" ] && true || false ; }

## @brief   Check if link target is valid and exist.
function isLink() { [ -L "$1" ] && true || false ; }

function getTarget() { readlink -e "$1" ; }

## @brief   Check if parameter exist, follow link if needed.
function targetExist() { if [ -e "$(getTarget "$1")" ] ; then true ; else false ; fi ; }

##
# @brief    Try and retry run an external program for N times until success.
# @param    [-r|--retry <N>]  Retry n times, default 0, run 1 time.
# @param    [-w|--wait  <N>]  Wait n seconds before try again, default none.
# @param    [-g|--debug]      Print debug messages on terminal, default false.
# @param    $*                Program name and its own parameters.
# @result   string            Program results.
# @return   0                 Success
#           N                 Last error code from external program.
function tryRun()
{
    if [ "x$1" = 'x' ] ; then return 1 ; fi
    local -i err=1
    local -i retry=0
    local    wait=''
    local    enDebug=false
    function onDebug() { if $enDebug ; then echo -e "\033[92m  debug\033[0m: $*" ; fi ; }
    while [ -n "$1" ]
    do
        case "$1" in
        -r|--retry) shift ; retry=$1 ;;
        -w|--wait)  shift ;  wait=$1 ;;
        -g|--debug) enDebug=true ;;
        -*) break ;;
         *) for ((try=0 ; try <= retry ; try++))
            do
                onDebug "eval \"$*\""
                eval "$*"
                err=$?
                if [ $err -ne 0 ]
                then
                    if [ $try -lt $retry ] && [ "x${wait}" != 'x' ]
                    then
                        sleep $wait
                    fi
                else
                    break
                fi
            done
            break
            ;;
        esac
        shift
    done
    return $err
}

##
# @brief    Find files into directory by wildcard to make a list of files to calculate sha256sum of them.
# @param    $3=target   path[/]                 Source path.
#                       path                    Calculate only one checksum for whole files found.
#                       path/                   Calculate individual checksum for each file found.
# @param    $4=filter   file.ext|file.*|*.ext   Filter files.
# @param    $1=attrib   '>'|'>>'                New sha256sum file or add to sha256sum file.
# @param    $2=hash     path/sha256sum          Target hash file.
#
# Whole files from path $PWD.
# buildFindCmd "$PWD" '*.ext' > file.hash
# cmd="find ${PWD}/* -type f -name '*.ext' -not -path '.git' -exec sha256sum {} + | sha256sum > file.hash"
function buildFindCmd()
{
    if  [ "x$1" = 'x' ] ||
        [ "x$2" = 'x' ] ||
        [ "x$3" = 'x' ] ; then return 1 ; fi

    local dir="$1"
    local attrib="$2"
    local hash="$3"
    local filter="$4"

    if ! echo -n "$dir"    | grep -qaoP '^\.?(\/?[\w-]+)+\/?\*?$' 2> /dev/null || ! [ -d "$dir" ] ; then return 2 ; fi
    if ! echo -n "$attrib" | grep -qaoP '^>>?$' 2> /dev/null ; then return 3 ; fi
    if ! echo -n "$hash"   | grep -qaoP '^\.?(/?\w+\.?\w*)+$' 2> /dev/null ; then return 4 ; fi

    if [ "x$filter" != 'x' ] && ! echo -n "$filter" | grep -qaoP '^\*?\.?\*?(\w+)?\*?\.?\*?(\w+)?$' 2> /dev/null
    then
        return 5
    fi

    # find from dir
    local cmd=''
    cmd="find ${dir}"

    # concatenate '/*' if needed
    if [ "x`echo -n ${dir} | grep -aoP '/*$'`" = 'x/' ]
    then
        cmd+="*"
    elif [ "x`echo -n ${dir} | grep -aoP '/*$'`" = 'x' ]
    then
        cmd+='/*'
    fi

    # search only files
    cmd+=" -type f"

    # apply filter
    if [ "x$filter" != 'x' ]
    then
        cmd+=" -name '${filter}'"
    fi

    # avoid .git directory and exec checksum commmand for each file found.
    cmd+=" -not -path '.git' -exec sha256sum {} +"

    # checksum for individual files or whole files found.
    if ! echo -n "${dir}" | grep -qaoP '/\*?$' 2> /dev/null
    then
        cmd+=' | sha256sum'
    fi

    # 
    cmd+=" ${attrib} ${hash}"

    echo -n "${cmd}"
}

##
# @brief    Calculate a new checksum sha256sum from directory/files|wildcard
# @param    $1=hash     path/sha256sum file.
# @param    $2=target   path[/] source file path.
#                       path    calculate all files together.
#                       path/   calculate individual files.
# @param    $3=files    *.ext|file.ext  individual file or group (wildcard *.ext) of files.
function calcChecksum()
{
    local cmd=''
    cmd="$(buildFindCmd "$1" '>' "$2" "$3")" || return $?
    eval "${cmd}"
    return $?
}

##
# @brief    Calculate and add a checksum sha256sum from directory/files|wildcard
# @param    $1=hash     path/sha256sum file.
# @param    $2=target   path[/] source file path.
#                       path    calculate all files together.
#                       path/   calculate individual files.
# @param    $3=files    *.ext|file.ext  individual file or group (wildcard *.ext) of files.
function addChecksum()
{
    local cmd=''
    cmd="$(buildFindCmd "$1" '>>' "$2" "$3")" || return $?
    eval "${cmd}"
    return $?
}

##
# @brief    Verify checksum sha256sum from sha256file and directory/files|wildcard
# @param    $1=hash     path/sha256sum file.
function verifyChecksum()
{
    if [ "x$1" = 'x' ] ; then return 1 ; fi
    if ! [ -f "$1"   ] ; then return 2 ; fi
    sha256sum --status -c "$1"
}

##
# @brief    Check for checksum sha256sum changes.
# @param    $1=hash     path/sha256sum file.
# @return   true        if checksum file (hash file) not found.
#                       if checksum is Ok.
#           false       if checksum is not Ok.
function haveChanges()
{
    if [ "x$1" = 'x' ] ; then return 1 ; fi
    if ! [ -f "$1"   ] ; then return 2 ; fi
    if verifyChecksum "$1"
    then
        false
    else
        true
    fi
}

function getMountDir()
{
    if   [ -d /run/media ] ; then echo -n "/run/media/$USER"
    elif [ -d /media     ] ; then echo -n "/media/$USER"
    else                          echo -n "/mnt/$USER"
    fi
}

function getMapperDir() { echo -n '/dev/mapper' ; }

# $1:target
function stripPunct() { if [ "x$1" = 'x' ] ; then return 1 ; else echo -n "$1" | tr -d '[:punct:]' ; fi ; }

# $1:target
function stripPathPunct() { if [ "x$1" = 'x' ] ; then return 1 ; else stripPunct "$(basename "$1")" ; fi ; }

# $1:target
function genDeviceName()
{
    if [ "x$1" = 'x' ] ; then return 1 ; fi
    local device="$(echo -n "$(basename "$1")" | tr -d '[:punct:]')"
    echo -n "luks-${device}"
}

# $1:target [$2:mode(octal)]
function setMode()
{
    if [ "x$1" = 'x' ] ; then return 1 ; fi
    if ! [ -e "$1"   ] ; then return 2 ; fi
    local mode="${2:-$fsMODE}"
    if echo -n "$mode" | grep -qaoP '^0\d{3}$' 2> /dev/null
    then
        sudo chmod --quiet $mode "$1" 2> /dev/null || return 4
    else
        return 3
    fi
}

# $1:target
function setOwner()
{
    if [ "x$1" = 'x' ] ; then return 1 ; fi
    if ! [ -e "$1"   ] ; then return 2 ; fi
    local user="${2:-$USER}"
    sudo chown --quiet -f "${user}":"${user}" "$1" 2> /dev/null || return 3
}

# $1:target [$2:usrMode]
function makeDir()
{
    if [ "x$1" = 'x' ] ; then return 1 ; fi
    local mode="${2:-$usrMODE}"
    if echo -n "$mode" | grep -qaoP '^0\d{3}$' 2> /dev/null
    then
        mkdir -p --mode=${mode} "$1" 2> /dev/null || return 3
    else
        return 2
    fi
}

# $1:target
function removeDir()
{
    if [ "x$1" = 'x' ] ; then return 1 ; fi
    sudo rmdir "$1" 2> /dev/null
}

# $1:target [$2:fstype]
function getFS()
{
    if [ "x$1" = 'x' ]
    then
        return 1
    elif ! [ -e "$1" ]
    then
        return 2
    elif [ -b "${1}" ]
    then
        if [ "x$2" = 'x' ]
        then
            file_regexIt "$(lsblk -o FSTYPE "${1}" 2> /dev/null)" "${regexFS}" || return 3
        else
            file_regexIt "$(lsblk -o FSTYPE "${1}" 2> /dev/null)" "$2" || return 3
        fi
    else
        if [ "x$2" = 'x' ]
        then
            file_regexIt "$(df --output=fstype "${1}" 2> /dev/null)" "${regexFS}" || return 3
        else
            file_regexIt "$(df --output=fstype "${1}" 2> /dev/null)" "$2" || return 3
        fi
    fi
}

# $1:target [$2:fstype]
function hasFS()
{
    if [ "x$1" = 'x' ]
    then
        return 1
    elif ! [ -e "$1" ]
    then
        return 2
    elif [ -b "${1}" ]
    then
        if [ "x$2" = 'x' ]
        then
            file_regexIt "$(lsblk -l -o fstype "$1" 2> /dev/null)" "${regexAnyFS}" &> /dev/null || return 3
        else
            file_regexIt "$(lsblk -l -o fstype "$1" 2> /dev/null)" "$2" &> /dev/null || return 3
        fi
    else
        if [ "x$2" = 'x' ]
        then
            file_regexIt "$(df --output=fstype "$1" 2> /dev/null)" "${regexAnyFS}" &> /dev/null || return 3
        else
            file_regexIt "$(df --output=fstype "$1" 2> /dev/null)" "$2" &> /dev/null || return 3
        fi
    fi
}

# $1:target
function isLuksDevice()
{
    if [ "x$1" = 'x' ] ; then return 1 ; fi
    if ! [ -e "$1" ] ; then return 2 ; fi
    sudo cryptsetup isLuks "$1" &> /dev/null || return 3
}

# $1:target [$2:keyfile]
function format()
{
    if [ "x$1" = 'x' ] ; then return 1 ; fi
    if ! [ -e "$1" ] ; then return 2 ; fi
    if [ "x$2" != 'x' ]
    then
        if [ -f "$2" ]
        then
            sudo cryptsetup -q -M luks2 -y -d "$2" luksFormat "$1" 2> /dev/null || return 4
        else
            return 3
        fi
    else
        sudo cryptsetup -q -M luks2 -y luksFormat "$1" 2> /dev/null || return 4
    fi
}

# $1:target $2:device [$3:keyfile]
function open()
{
    if [ "x$1" = 'x' ] ; then return 1 ; fi
    if ! [ -e "$1" ] ; then return 2 ; fi
    if [ "x$2" = 'x' ] ; then return 3 ; fi
    if [ "x$3" = 'x' ]
    then
        sudo cryptsetup -q -M luks2 luksOpen "$1" "$2" 2> /dev/null || return 5
    else
        if [ -f "$3" ]
        then
            sudo cryptsetup -q -M luks2 -d "$3" luksOpen "$1" "$2" 2> /dev/null || return 5
        else
            return 4
        fi
    fi
}

# $1:target
function close()
{
    local mapperDir="$(getMapperDir)"
    if [ "x$1" = 'x' ] ; then return 1 ; fi
    if ! [ -e "${mapperDir}/$1" ] ; then return 2 ; fi
    if ! [ -b "${mapperDir}/$1" ] ; then return 3 ; fi
    sudo cryptsetup -q luksClose "$1" 2> /dev/null || return 4
}

# $1:target [$2:fstype]
function formatFS()
{
    if [ "x$1" = 'x' ] ; then return 1 ; fi
    if ! [ -e "$1" ] ; then return 2 ; fi

    local fs=''

    if [ "x$2" = 'x' ]
    then
        fs="$defaultFS"
    elif [[ "${tableFS[@]}" =~ "$2" ]]
    then
        fs="$2"
    else
        return 3
    fi

    if [ "${fs}" = 'btrfs' ]
    then
        sudo mkfs.btrfs -q -f "$1" 2> /dev/null
    elif [ "${fs}" = 'ext4' ]
    then
        sudo mkfs.ext4 -q "$1" <<< 'y' 2> /dev/null || return 4
    else
        sudo mkfs.${fs} -q "$1" 2> /dev/null || return 4
    fi
}

# $1:source $2:target [$3:user]
function mountDevice()
{
    if [ "x$1" = 'x' ] ; then return 1 ; fi
    if ! [ -e "$1" ] ; then return 2 ; fi
    if [ "x$2" = 'x' ] ; then return 3 ; fi
    if [ -e "$2" ] ; then return 4 ; fi

    sudo mount -m -i -n --onlyonce --make-private --make-unbindable -o rw,owner,noatime,nodev,nofail,user="$USER" --source "$1" --target "$2" 2> /dev/null || return 5
}

# $1:target
function umountDevice()
{
    local -i err=0
    local mountDir="$(getMountDir)"

    if [ "x$1" = 'x' ] ; then return 1 ; fi
    if ! [ -e "${mountDir}/$1" ] ; then return 2 ; fi

    sudo umount -d -f -n -l -q "${mountDir}/$1" 2> /dev/null || ((err+1))
    sleep 3

    removeDir "${mountDir}/$1" || ((err+2))

    if [ $err -gt 1 ] && [ -e "${mountDir}/$1" ] && ! hasFS "${mountDir}/$1"
    then
        rm -rf "${mountDir}/$1"
    fi

    return $err
}

# $1:target $2:mode [$3:user]
function setAccess()
{
    if [ "x$1" = 'x' ] ; then return 1 ; fi
    if ! [ -e "$1" ] ; then return 2 ; fi
    if ! hasFS   "$1" ; then return 3 ; fi
    if [ "x$2" = 'x' ] ; then return 4 ; fi

    local user=''

    if [ "x$3" = 'x' ]
    then
        user="$USER"
    else
        user="$3"
    fi

    setOwner "$1" "$USER" $2
    setMode "$1" $2
    makeDir "${1}/${user}_success" "$usrMODE"
    echo 1 > "${1}/${user}_success/ok"
}

# $1:target [$2:device] [$2:keyfile] [$3:mode]
function openDrive()
{
    # empty parameter?
    if [ "x$1" = 'x' ] ; then return 1 ; fi

    local force=false
    local target=''
    local device=''
    local keyfile=''
    local fsmode="$defaultFS"
    local mountDir="$(getMountDir)"
    local mapperDir="$(getMapperDir)"

    # parse list of parameters.
    while [ -n "$1" ]
    do
        # target parameter?
        if isLuksDevice "$1"
        then
            target="$1"
        # keyfile parameter?
        elif [ -f "$1" ]
        then
            keyfile="$1"
        # file system mode parameter?
        elif [[ "${tableFS[@]}" =~ "$1" ]]
        then
            fsmode="$1"
        # force overwrite device source and target?
        elif [[ "$1" == '-f' ]] || [[ "$1" == '--force' ]]
        then
            force=true
        # anything else is a device parameter!
        else
            device="$1"
        fi
        shift
    done

    # target is empty?
    if [ "x$target" = 'x' ]
    then
        return 2
    fi

    # device is empty?
    if [ "x$device" = 'x' ]
    then
        device="$(genDeviceName "$target")"
    fi

    # device already exist at mount directory? then rename device's name.
    if ! $force
    then
        while itExist "${mountDir}/${device}" || itExist "${mapperDir}/${device}"
        do
            device+="I"
        done
    fi

    # key file is empty? open by password from keyboard.
    if [ "x${keyfile}" = 'x' ]
    then
        [ -b "${mapperDir}/${device}" ] || open "${target}" "${device}" || return $?
    # key file presence? open by password from key file.
    else
        [ -b "${mapperDir}/${device}" ] || open "${target}" "${device}" "${keyfile}" || return $?
    fi

    mountDevice "${mapperDir}/${device}" "${mountDir}/${device}" || return $?
    setAccess "${mountDir}/${device}" "$fsMODE" || return $?
}

# $1:device
function closeDevice()
{
    # empty parameter?
    if [ "x$1" = 'x' ] ; then return 1 ; fi
    device="$1"
    umountDevice "${device}"
    close "${device}"
}

# $1:target $2:fstype [$3:keyfile]
function formatDrive()
{
    # empty parameter?
    if [ "x$1" = 'x' ] ; then return 1 ; fi

    local mountDir="$(getMountDir)"
    local mapperDir="$(getMapperDir)"
    local fstype="$defaultFS"
    local keyfile=''
    local device=''
    local target="$1"
    shift

    while [ -n "$1" ]
    do
        # store file system
        if [[ "${tableFS[@]}" =~ "$1" ]]
        then
            fstype="$1"
        # store keyfile
        elif [ -f "$1" ]
        then
            keyfile="$1"
        # force to overwrite device source and target?
        elif [[ "$1" == '-f' ]] || [[ "$1" == '--force' ]]
        then
            force=true
        # store device
        else
            device="$1"
        fi
        shift
    done

    if [ "x${device}" = 'x' ]
    then
        device="$(genDeviceName "$target")"
    fi

    # device already exist at mount directory? then rename device's name.
    if ! $force
    then
        # device already exist at mount directory? then rename device's name.
        while itExist "${mapperDir}/${device}" || itExist "${mountDir}/${device}"
        do
            device+="I"
        done
    fi

    if [ "x${keyfile}" = 'x' ]
    then
        format "$target" || return $?
        [ -b "${mapperDir}/${device}" ] || open "$target" "$device" || return $?
    else
        format "$target" "$keyfile" || return $?
        [ -b "${mapperDir}/${device}" ] || open "$target" "$device" "$keyfile" || return $?
    fi

    formatFS "${mapperDir}/${device}" "$fstype" || return $?
    mountDevice "${mapperDir}/${device}" "${mountDir}/${device}" || return $?
    setAccess "${mountDir}/${device}" "$fsMODE" || return $?
}

##  @brief  Exit from libFile, unload all variables and functions.
function libFileExit()
{
    # unset variables
    unset -v tableFS
    unset -v regexFS
    unset -v tableAnyFS
    unset -v regexAnyFS
    unset -v defaultFS
    unset -v fsMODE
    unset -v usrMODE
    # unset functions
    unset -f file_regexIt
    unset -f getScriptName
    unset -f getFileName
    unset -f getName
    unset -f getExt
    unset -f getPath
    unset -f isLink
    unset -f isFile
    unset -f isDir
    unset -f isBlockDevice
    unset -f followLink
    unset -f linkTargetExist
    unset -f itExist
    unset -f tryRun
    unset -f buildFindCmd
    unset -f calcChecksum
    unset -f addChecksum
    unset -f verifyChecksum
    unset -f haveChanges
    unset -f getMountDir
    unset -f getMapperDir
    unset -f stripPunct
    unset -f stripPathPunct
    unset -f genDeviceName
    unset -f setMode
    unset -f setOwner
    unset -f makeDir
    unset -f removeDir
    unset -f getFS
    unset -f hasFS
    unset -f isLuksDevice
    unset -f format
    unset -f open
    unset -f close
    unset -f formatFS
    unset -f mountDevice
    unset -f umountDevice
    unset -f setAccess
    unset -f openDrive
    unset -f closeDevice
    unset -f formatDrive
}

declare libFile='loaded'

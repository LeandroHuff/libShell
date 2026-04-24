################################################################################
# @file         libCrypto.sh
# @brief        Source variables and functions to treat encrypted files.
# @author:      Leandro D. Huff
# @copyright:   https://creativecommons.org/licenses/by/4.0/
# @sintaxe:     source libCrypto.sh
################################################################################

# Must be sourced not running
[[ "${BASH_SOURCE[0]}" == "${0}" ]] && { error "$(basename $0) must be sourced not running." ; return 1 ; }

## @brief   Check dependences
if [ "x$(libLog)"  = 'x' ] ; then echo -e "\033[91m  error\033[0m: libLog must be loaded before libCrypto." ; return 1 ; fi
if [ "x$(libFile)" = 'x' ] ; then echo -e "\033[91m  error\033[0m: libFile must be loaded before libCrypto." ; return 1 ; fi

declare FS='ext4'
declare PREFIX='luks_'
declare DEVICE=''
declare rexFS='(btrfs|ext4|tmpfs)'
declare rexCryptFS='(crypto_LUKS)'
declare MOUNT="$(getMountDir)"
declare MAPPER="$(getMapperDir)"

##
# @brief    Set device name from drive name.
# @param    $1      Drive name.
# @result   string  Formatted device name.
# @return   0       Success
#           N       Error code
function setDeviceName()
{
    local name="$(stripPunct ${1})"
    DEVICE="${PREFIX}${name}"
    echo -n "${DEVICE}"
}

##
# @brief    Encrypt external drive or local file block.
# @param    $1      Path/Drive|Filename
# @param    $2      Keyfile
# @return   0       Success
# @         N       Error code
function encryptDrive()
{
    local key=$([ -n "${2}" ] && echo -n "--keyfile=${2}" || echo -n '')
    sudo cryptsetup --type=luks2 --verify-passphrase luksFormat ${key} "${1}"
}

##
# @brief    Open an encrypted drive or file as device.
# @param    $1      Drive or filename
# @param    $2      Optional device name (luks_"Drive|Filename")
# @param    $3      Optional keyfile
# @return   0       Success
#           N       Error code
function openDrive()
{
    local key=$([ -n "${3}" ] && echo -n "--keyfile=${3}" || echo -n '')
    sudo cryptsetup -q luksOpen ${key} "${1}" "${2}"
}

##
# @brief    Close encrypted device.
# @param    $1      Device name
# @return   0       Success
#           N       Error code
function closeDevice() { sudo cryptsetup -q luksClose "${1}" ; }

##
# @brief    Format device as filesystem.
# @param    $1      File system type (ext4)
# @param    $2      Path/DeviceName
# @return   0       Success
#           N       Error code
function formatDevice() { sudo mkfs.${2:-ext4} "${1}" ; }

##
# @brief    Mount a device from mapper into mount dir.
# @param    $1      MapperPath/DeviceName
# @param    $2      MountPath/DeviceName
# @return   0       Success
#           N       Error code
function mountDevice()
{
    sudo mount -m -i -n \
--onlyonce \
--make-private \
--make-unbindable \
-o rw,owner,noatime,nodev,nofail,user=$USER \
--source "${1}" \
--target "${2}"
}

##
# @brief    Umount device from filesystem.
# @param    $1      Path/Device
# @return   0       Success
#           N       Error
function umountDevice()
{
    local err=0
    if hasFS "${1}"  ; then sudo umount -l "${1}" || err=$((err+1)) ; fi
    if [ -d "${1}" ] ; then sudo rmdir     "${1}" || err=$((err+2)) ; fi
    return $err
}

##
# @brief    Set device access right.
# @param    $1          Device path and name.
# @result   filesystem  New directory $USER_success at mount directory
#                       New file "ok" into $USER_success/ directory.
# @return   0           Success
#           N           Error code.
function setDeviceAccess()
{
    local err=0
    sudo chown -f -R $USER:$USER "${1}" || return 5
    [ -d "${1}/${USER}_success" ] || mkdir "${1}/${USER}_success" || return 6
    echo 1 > "${1}/${USER}_success/ok" || return 7
    return 0
}

##
# @brief    Create an encrypted drive.
# @param    $1      Path/Drive or Filename
# @param    $2      Device name
# @param    $3      Optional Path/Key Filename (passphrase)
# @param    $4      Optional FS type (ext4)
# @return   0       Success
#           N       Error code
function createEncryptedDrive()
{
    local device="${2:-$(getDeviceName ${1})}"
    encryptDrive "${1}" "${3}" || return 1
    openDrive "${1}" "${device}" "${3}" || return 2
    formatDevice "${device}" "${4}" || return 3
    mountDevice "${MAPPER}/${device}" "${MOUNT}/${device}" || return 4
    setDeviceAccess "${MOUNT}/${device}" || return $?
    sleep 2
    umount "${MOUNT}/${device}" || return $?
    closeDevice "${device}" || return 10
    return 0
}

##
# @brief    Open an encrypted drive as device name.
# @param    $1      Drive name.
# @param    $2      Device name.
# @param    $3      Key filename.
# @return   0       Success
#           N       Error code.
function openEncryptedDevice()
{
    local device="${2:-$(getDeviceName ${1})}"
    openDrive "${1}" "${device}" "${3}" || return 2
    mountDevice "${MAPPER}/${device}" "${MOUNT}/${device}" || return 4
    setDeviceAccess "${MOUNT}/${device}" || return $?
    return 0
}

##
# @brief    Umount and close an encrypted device.
# @param    $1      Device name.
# @return   0       Success
#           N       Error code.
function closeEncryptedDevice()
{
    umount "${MOUNT}/${1}" || return 8
    closeDevice "${MAPPER}/${1}" || return 9
    return 0
}

## @brief   Check if libRegex is loaded and available.
declare libCrypto='loaded'

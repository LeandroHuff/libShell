################################################################################
# @file         libCompress.sh
# @brief        Source variables and functions to compress/uncompress files.
# @author:      Leandro D. Huff
# @copyright:   https://creativecommons.org/licenses/by/4.0/
# @sintaxe:     source libCompress.sh
################################################################################

# Must be sourced not running
[[ "${BASH_SOURCE[0]}" == "${0}" ]] && { echo -e "\033[91merror\033[0m: $(basename $0) must be sourced not running." ; exit 1 ; }

declare libCompress=''

##
# @brief    unCompress files.
# @param    $1          Crompressed filename.
#           $2..$10     Extra parameters to uncompressor program.
# @return   0           Success
#           1..99       Uncompressor error code.
#           101         Empty parameter.
#           102         File not found.
#           103         Unknown compressed method by file extension.
function unCompress()
{
    local err=0
    local file="$1"
    shift

    if [ -n "${file}" ] ; then
        if [ -f "${file}" ] ; then
            case "${file}" in
            *.tar.bz2|*.tbz2|*.tar.gz|*.tgz|*.tar.xz|*.txz|*.tar) tar -a -x -f "${file}" "$1" "$2" "$3" "$4" "$5" "$6" "$7" "$8" "$9" || err=$? ;;
            *.7z|*.7zip) 7z x -mmt4 "${file}" "$1" "$2" "$3" "$4" "$5" "$6" "$7" "$8" "$9" || err=$? ;;
            *.zip|*.z) unzip -q "${file}" "$1" "$2" "$3" "$4" "$5" "$6" "$7" "$8" "$9" || err=$? ;;
            *.gz) gzip -d -f -q "${file}" "$1" "$2" "$3" "$4" "$5" "$6" "$7" "$8" "$9" || err=$? ;;
            *.bz2) bzip2 -d -f -q "${file}" "$1" "$2" "$3" "$4" "$5" "$6" "$7" "$8" "$9" || err=$? ;;
            *.xz) xz -d -T 0 -f -q "${file}" "$1" "$2" "$3" "$4" "$5" "$6" "$7" "$8" "$9" || err=$? ;;
            *) err=103 ;;
            esac
        else
            err=102
        fi
    else
        err=101
    fi

    return $err
}

##
# @brief    Compress files.
# @param    $1          Crompress filename.
#           $2..$10     Extra parameters to compressor program.
# @return   0           Success
#           1..99       Compressor error code.
#           101         Empty parameter.
#           102         File not found.
#           103         Unknown compressed method by file extension.
function compress()
{
    local err=0
    local file="$1"
    shift

    if [ -n "${file}" ] ; then
        if ! [ -f "${file}" ] ; then
            case "${file}" in
            *.tar.gz|*.tgz|*.tar.xz|*.txz|*.tar.bz2|*.tbz2|*.tar) tar -a -c -f "${file}" "$1" "$2" "$3" "$4" "$5" "$6" "$7" "$8" "$9" || err=$? ;;
            *.7z|*.7zip) 7z a -snh -snl -mmt4 -mx9 "${file}" "$1" "$2" "$3" "$4" "$5" "$6" "$7" "$8" "$9" || err=$? ;;
            *.zip|*.z) zip -9 -y -f -q "${file}" "$1" "$2" "$3" "$4" "$5" "$6" "$7" "$8" "$9" || err=$? ;;
            *.gz|*.gzip) gzip -d -f -k -q -9 "${file}" "$1" "$2" "$3" "$4" "$5" "$6" "$7" "$8" "$9" || err=$? ;;
            *.bz2) bzip2 -z -k -9 -f -q "${file}" "$1" "$2" "$3" "$4" "$5" "$6" "$7" "$8" "$9" || err=$? ;;
            *.xz) xz -z -k -f -9 -e -T 0 -q "${file}" "$1" "$2" "$3" "$4" "$5" "$6" "$7" "$8" "$9" || err=$? ;;
            *) err=103 ;;
            esac
        else
            err=102
        fi
    else
        err=101
    fi

    return $err
}

##
# @brief    Exit from Compress program.
# @param    none
# @return   0       Success
function libCompressExit()
{
    unset -v libCompress
    unset -f compress
    unset -f unCompress
    unset -f libCompressExit
    return 0
}

libCompress='loaded'

################################################################################
# @file         libCompress.sh
# @brief        Source variables and functions to compress/uncompress files.
# @author:      Leandro D. Huff
# @copyright:   https://creativecommons.org/licenses/by/4.0/
# @sintaxe:     source libCompress.sh
################################################################################

# Must be sourced not running
[[ "${BASH_SOURCE[0]}" == "${0}" ]] && exit 1

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
            *) err=3 ;;
            esac
        else
            err=2
        fi
    else
        err=1
    fi

    return $err
}

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
            *) err=3 ;;
            esac
        else
            err=2
        fi
    else
        err=1
    fi

    return $err
}

function libCompressExit()
{
    unset -f compress
    unset -f unCompress
    unset -f libCompressExit
    return 0
}

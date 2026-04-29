################################################################################
# @file         libLog.sh
# @brief        Shell script source code to print log messages on terminal or file.
# @author:      Leandro D. Huff
# @copyright:   https://creativecommons.org/licenses/by/4.0/
# @sintaxe:     source libLog.sh [parameters]
################################################################################

# Must be sourced not running
[[ "${BASH_SOURCE[0]}" == "${0}" ]] && { echo -e "\033[91mfailure\033[0m: $(basename $0) must be sourced not running." ; exit 1 ; }

# Constants
declare -i logSTARTIME=$(( $(date +%s%N) / 1000000 ))
declare -i logRamSIZE=$((4096 * 1024 * 1024))
declare    logRamNAME='logRamDrive'

# log message and colors
declare    escINFO='\033[37m   info\033[0m:'
declare escSUCCESS='\033[97msuccess\033[0m:'
declare escRUNTIME='\033[97mruntime\033[0m:'
declare    escWARN='\033[96mwarning\033[0m:'
declare   escERROR='\033[31m  error\033[0m:'
declare    escFAIL='\033[91mfailure\033[0m:'
declare   escDEBUG='\033[32m  debug\033[0m:'
declare   escTRACE='\033[92m  trace\033[0m:'

# flags
declare logQUIET=false
declare logDEBUG=false
declare logTRACE=false
declare logRAM=false
declare logFILE=false

## @brief   Get temporary directory.
function _getTempDir() { [ -d '/tmp' ] && echo -n '/tmp' || echo "$HOME/tmp" ; }

declare logTmpDIR="$(_getTempDir)"
declare logTOFILE="${logTmpDIR}/$(basename $0).log"

## @brief   Validate only integer numbers.
function _isInteger() { if echo -n "${1}" | grep -qaoP '^[+-]?\d+$' > /dev/null 2>&1 ; then true ; else false ; fi ; }

## @brief   Get runtime timestamp, format #.###s
function _getRuntime()
{
    declare -i runtime=$(($(date +%s%N) / 1000000 - logSTARTIME))
    printf -v elapsed "%u.%03u" $((runtime / 1000)) $((runtime % 1000))
    echo -n ${elapsed}
}

# @brief    Get base directory to mount devices.
function _getMountDir()
{
    declare -a list=('/media' '/run/media' '/mnt')
    local target=''

    for dir in "${list[@]}"
    do
        if [ -L "$1" ]
        then
            target="$(readlink -m $1)"
            if [ -d "${target}" ]
            then
                echo -n "${target}/$USER"
                return 0
            fi
        else
            if [ -d "${1}" ]
            then
                echo -n "${1}/$USER"
                return 0
            fi
        fi
    done
    return 1
}

## @brief   Directories for logs
declare logMountDIR=$(_getMountDir)
declare logRamDIR="${logMountDIR}/${logRamNAME}"

## @brief    Print log messages
function _log()
{
    if [ "$1" = "file" ]
    then
        shift
        echo -e -n "$*" >> ${logTOFILE}
    elif $logQUIET
    then
        echo -e -n "$*" >> ${logTOFILE}
    elif $logFILE
    then
        echo -e -n "$*" | tee -a ${logTOFILE}
    else
        echo -e -n "$*"
    fi
}


## @brief    Begin logs.
function logBegin()
{
    _log file "------------ Start Log to File on $(date +%Y-%m-%d) at $(date +%T.%N) -------------\n"
}

## @brief    End logs.
function logEnd()
{
    _log file "------------- End Log to File on $(date +%Y-%m-%d) at $(date +%T.%N) --------------\n"
}

## @brief   Unconditional log.
function logU() { _log "$*" ; }

## @brief    log info messages
function logI() { _log "${escINFO} $*\n" ; }

## @brief    log success messages
function logS() { _log "${escSUCCESS} $*\n" ; }

## @brief    log runtime messages
function logR() { _log "${escRUNTIME} $(_getRuntime)s\n" ; }

## @brief    log with time stamp
function logTS() { _log "\033[97m$(_getRuntime)\033[0m: $*\n" ; }

## @brief    log warning messages
function logW() { _log "${escWARNING} $*\n" ; }

## @brief    log error messagges
function logE() { _log "${escERROR} $*\n" ; }

## @brief    log failure messages
function logF() { _log "${escFAIL} $*\n" ; }

## @brief    log debug messages
function logD() { if $logDEBUG; then _log "${escDEBUG} $*\n"; fi; }

## @brief    log trace messages
function logT() { if $logTRACE; then _log "${escTRACE} $*\n"; fi; }

## @brief    On error log a message
function logOnE() { local err=$1; shift; if [ $err -ne 0 ]; then _log "${escERROR} $*\n"; fi; return $err; }

## @brief    On empty string, log a message
function logOnZ() { if [ "x${1}" = 'x' ]; then shift; _log "${escERROR} $*\n"; fi; }

## @brief    log debug if flag enabled
function onDebugLog() { if $logDEBUG; then _log "${escDEBUG} $*\n"; fi; }

## @brief    log failure on error
function onFailLog() { local err=$1; shift; if [ $err -ne 0 ]; then _log "${escFAIL} $*\n"; fi; return $err; }

## @brief    On error, log a trace message and return the error code to exit from program.
## @details  Usage: onErrorTrace $errCode "trace message" || _exit $?
function onErrorTrace()
{
    local err=$1
    if [ $err -ne 0 ]
    then
        shift
        logR
        _log "${escTRACE} $*\n"
    fi
    return $err
}

## @brief    Create and open a drive on RAM.
function openRamdrive()
{
    if ! $logRAM ; then return 0 ; fi
    local err=0
    local dir="${1:-$logRamDIR}"
    local size=${2:-$logRamSIZE}
    if [ -f "${dir}"/success ]
    then
        logTmpDIR="${dir}"
        return $err
    fi
    printf -v cmd "sudo mount -m -i -n --onlyonce --make-private --make-unbindable -t tmpfs -o rw,owner,noatime,nodev,nofail,user=%s,size=%d tmpfs %s" "$USER" ${size} "${dir}"
    eval "${cmd}" || err=$?
    if ((err != 0))
    then
        logRAM=false
        _log "${escFAIL} Run mount command line.\n"
        return $err
    fi
    if ! [ -d "${dir}" ]
    then
        logRAM=false
        _log "${escFAIL} ramDrive folder ${dir} not found.\n"
        return 1
    fi
    printf -v cmd "sudo chown -R %s:%s %s" $USER $USER "${dir}"
    eval "${cmd}" || err=$?
    if ((err != 0))
    then
        logRAM=false
        _log "${escFAIL} Change device owner to $USER\n"
        return $err
    fi
    if ! [ -f "${dir}/success" ]
    then
        printf -v cmd "echo 1 > %s" "${dir}/success"
        eval "${cmd}" || err=$?
        if ((err != 0))
        then
            logRAM=false
            _log "${escFAIL} ramDrive file access.\n"
            return $err
        fi
    fi
    if ((err == 0))
    then
        logTmpDIR="${dir}"
        _log "${escSUCCESS} ramDrive enabled and running at path ${logTmpDIR}\n"
    else
        _log "${escFAIL} ramDrive create and open, may it is not available.\n"
    fi
    return $err
}

## @brief    Close and unmount a drive from RAM.
function closeRamdrive()
{
    if ! $logRAM ; then return 0 ; fi
    local err=0
    local dir="${1:-$logRamDIR}"
    printf -v cmd "sudo umount -l %s" "${dir}"
    eval "${cmd}" || err=$((err+$?))
    onErrorLog $err "Unmount ${dir} RAM drive."
    sleep 1
    printf -v cmd "sudo rmdir %s" "${dir}"
    eval "${cmd}" || err=$((err+$?))
    onErrorLog $err "Umount and remove directory ${dir}"
    if ((err != 0))
    then
        logRAM=false
        logTmpDIR="$(_getTempDir)"
        logToFILE="${logTmpDIR}/${logScriptName}.log"
        _log "${escINFO} Closed ramdrive from path ${logTmpDIR}\n"
    fi
    return $err
}

## @brief    print help for log messages
function logHelp()
{
    printf "\
Lib log messages.
Syntax: source libLog.sh [options]
               logInit   [options]
               logSetup  [options]
Options:
  -h|--help                 Show this usage information.
  -f|--file                 Enable log to file.
  -g|--debug                Enable debug messages.
  -q|--quiet                Disable messates to screen.
  -t|--trace                Enable trace messages.
     --ram [name] [size]    Set ramDrive [name=logRamDrive] and/or [size=128*1024*1024=134217728].
     --                     Let next parameter to another application.
"
    return 0
}

## @brief   Set RAM drive name or size.
function setRam()
{
    if _isInteger $1
    then
        logRamSIZE=$1
    else
        logRamNAME="${1}"
        logRamDIR="${logMountDIR}/${1}"
    fi
    return 0
}

## @brief    parse and setup log from command line parameters.
function logSetup()
{
    (($# > 0)) || return 0
    while [ -n "$1" ]
    do
        case "$1" in
        -h|--help)      logHelp ; break ;;
        -f|--file)      logFILE=true ;;
        -g|--debug)     logDEBUG=true ;;
        -t|--trace)     logTRACE=true ;;
        -q|--quiet)     logQUIET=true ;;
           --ram)       logRAM=true
                        local maxargs=2
                        while [ -n "$2" ] && ((maxargs > 0))
                        do
                            case "$2" in
                            -*) break ;;
                             *) setRam "$2" ; ((maxargs--)) ;;
                            esac
                            shift
                        done
                        ;;
        --) shift ; set -- "$@" ; return 0 ;;
        -*) _log "${escERROR} Unknown parameter $1\n" ; return 1 ;;
         *) _log "${escERROR} Unknown value $1\n"     ; return 2 ;;
        esac
        shift
    done
    return 0
}

## @brief    Initialize lib log.
function logInit()
{
    logSetup "$@" || return $?
    openRamdrive  || return $?
    logTOFILE="${logTmpDIR}/${logScriptName}.log"
    logBegin
    return 0
}

## @brief    Stop or disable log messages.
function logStop()
{
    local code=${1:-0}
    logEnd
    logSetup -q
    if ((code == 0)) ; then closeRamdrive || _log "${escERROR} Close ramdrive ${logRamDIR}\n" ; fi
    if [ -f "${logRamDIR}"/success ] ; then _log "${escERROR} Ram drive ${logFILE} for log are opened and must be closed manually.\n" ; fi
}

## @brief   Exit from lib and unload all variables and functions.
function libLogExit()
{
    # unset variables
    unset -v libLog
    unset -v logRamSIZE
    unset -v logMountDIR
    unset -v logRamDIR
    unset -v logTmpDIR
    unset -v logFILE
    unset -v logRAM
    unset -v logFILE
    unset -v logFILE
    unset -v logDEBUG
    unset -v logTRACE
    # unset functions
    unset -v _getTempDir
    unset -v _isInteger
    unset -v _getRuntime
    unset -v _getMountDir
    unset -f _log
    unset -f logBegin
    unset -f logEnd
    unset -f getRuntime
    unset -f logCRNLF
    unset -f logI
    unset -f logS
    unset -f logR
    unset -f logTS
    unset -f logW
    unset -f logE
    unset -f logF
    unset -f logD
    unset -f logT
    unset -f logOnE
    unset -f logOnZ
    unset -f onDebugLog
    unset -f onErrorLog
    unset -f onFailLog
    unset -f onErrorTrace
    unset -f openRamdrive
    unset -f closeRamdrive
    unset -f logHelp
    unset -f regexIt
    unset -f setRam
    unset -f logSetup
    unset -f logInit
    unset -f logStop
    unset -f libLogExit
    return 0
}

## @brief   Check if libRegex is loaded and available.
declare libLog='loaded'

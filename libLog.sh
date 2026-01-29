################################################################################
# @file         libLog.sh
# @brief        Source variables and functions to print log messages on terminal
#               or file.
# @author:      Leandro D. Huff
# @copyright:   https://creativecommons.org/licenses/by/4.0/
# @sintaxe:     source libLog.sh
################################################################################

# Must be sourced not running
[[ "${BASH_SOURCE[0]}" == "${0}" ]] && exit 1

declare libLog=''

# Constants
declare -i  logSTARTIME=$(( $(date +%s%N) / 1000000 ))
declare -i  logRamSIZE=$((4096*1024*1024))
declare     logMountDIR=$([ -d '/media' ] && echo -n "/media/$USER" || { [ -d '/run/media' ] && echo -n "/run/media/$USER" || echo -n "/mnt/$USER" ; })
declare     logRamNAME='logRamDrive'
declare     logRamDIR="${logMountDIR}/${logRamNAME}"
declare     logTmpDIR='/tmp'
declare     logFILE="${logTmpDIR}/$(basename $0).log"
# log message and colors
declare   ERROR='\033[31m  error\033[0m:'
declare    FAIL='\033[91mfailure\033[0m:'
declare   DEBUG='\033[32m  debug\033[0m:'
declare   TRACE='\033[92m  trace\033[0m:'
declare    WARN='\033[93mwarning\033[0m:'
declare SUCCESS='\033[97msuccess\033[0m:'
declare RUNTIME='\033[97mruntime\033[0m:'
declare    INFO='\033[98m   info\033[0m:'
# Variables
declare     flagQUIET=false
declare     flagVERBOSE=false
declare     flagDEBUG=false
declare     flagTRACE=false
declare     flagFILE=false
declare -i  logFULL=0
declare -i  logVERBOSE=1
declare -i  logINFO=2
declare -i  logSUCCESS=3
declare -i  logRUNTIME=4
declare -i  logWARNING=5
declare -i  logERROR=6
declare -i  logFAILURE=7
declare -i  logDEBUG=8
declare -i  logTRACE=9
declare -i  logNONE=10
declare -i  logDISABLE=10
declare -i -a levelLIST=($logFULL $logVERBOSE $logINFO $logSUCCESS $logRUNTIME $logWARNING $logERROR $logFAILURE $logDEBUG $logTRACE $logNONE)
declare    -a logLevelNamesLIST=(logFULL logVERBOSE logINFO logSUCCESS logRUNTIME logWARNING logERROR logFAILURE logDEBUG logTRACE logNONE)
declare -i  logLevel=$logNONE
# Functions

# begin logs.
function logBegin()
{
    if $flagFILE
    then
        touch "${logFILE}" || logE "${logFILE} access."
        if [ -f "${logFILE}" ]
        then
            echo "################################################################################" > "${logFILE}"
            echo "         Start Log to File on $(date +%Y-%m-%d) at $(date +%T.%N)"               >> "${logFILE}"
        else
            logE "File ${logFILE} not found."
            return 1
        fi
    fi
    return 0
}

# end logs.
function logEnd()
{
    if $flagFILE
    then
        if [ -f "${logFILE}" ]
        then
            echo "         End Log to File on $(date +%Y-%m-%d) at $(date +%T.%N)"                  >> "${logFILE}"
            echo "################################################################################" >> "${logFILE}"
        else
            logE "File ${logFILE} not found."
            return 1
        fi
    fi
    return 0
}

# get elapsed runtime
function getRuntime()
{
    local elapsed
    local logENDTIME
    local runtime
    logENDTIME=$(( $(date +%s%N) / 1000000 ))
    runtime=$((logENDTIME - logSTARTIME))
    printf -v elapsed "%u.%03u" $((runtime / 1000)) $((runtime % 1000))
    echo -n "${elapsed}"
}

# no line feed, just log message with Carriage Return Not Line Feed.
function logCRNLF() { echo -e -n "\r$*" ; }

# log unconditional
function logU() { if $flagFILE ; then echo -e "$*" | tee -a "${logFILE}" ; else echo -e "$*" ; fi ; }

# log any message
function log()
{
    if $flagFILE
    then
        if $flagQUIET
        then
            # only to file
            echo -e "$*" >> "${logFILE}"
        else
            # to screen and file
            echo -e "$*" | tee -a "${logFILE}"
        fi
    elif ! $flagQUIET
    then
        # only to screen
        echo -e "$*"
    #else
        # neither screen nor to file
    fi
}

# log info messages
function logI() { if [ $logLevel -le $logINFO ] ; then log "${INFO} $*" ; fi ; }

# log success messages
function logS() { if [ $logLevel -le $logSUCCESS ] ; then log "${SUCCESS} $*" ; fi ; }

# log runtime messages
function logR() { if [ $logLevel -le $logRUNTIME ] ; then log "${RUNTIME} $(getRuntime)" ; fi ; }

# log verbose messages
function logV() { if $flagVERBOSE && [ $logLevel -le $logVERBOSE ] ; then [ $flagFILE ] && echo -e "${INFO} $*" | tee -a || echo -e "${INFO} $*" ; fi ; }

# log warning messages
function logW() { if [ $logLevel -le $logWARNING ] ; then log "${WARN} $*" ; fi ; }

# log error messagges
function logE() { if [ $logLevel -le $logERROR ] ; then log "${ERROR} $*" ; fi ; }

# log failure messages
function logF() { if [ $logLevel -le $logFAILURE ] ; then log "${FAIL} $*" ; fi ; }

# log debug messages
function logD() { if $flagDEBUG && [ $logLevel -le $logDEBUG ] ; then logU "${DEBUG} $*" ; fi ; }

# log trace messages
function logT() { if $flagTRACE && [ $logLevel -le $logTRACE ] ; then logU "${TRACE} $*" ; fi ; }

# on error log trace message and return the error code to exit from program.
# usage: onErrorTraceAndExit $errCode "trace message" || _exit $?
function onErrorTraceAndExit()
{
    local err=$1
    if (( $err != 0 ))
    then
        shift
        logR
        logU "${TRACE} $*"
        logStop
        libLogExit
    fi
    return $err
}

# on error log message
function logOnE() { if (( $1 != 0 )) && [ $logLevel -le $logERROR ] ; then shift ; log "${ERROR} $*" ; fi ; }

# on empty string log message
function logOnZ() { if [ -z "$1"  ] && [ $logLevel -le $logERROR ] ; then shift ; log "${ERROR} $*" ; fi ; }

# print help for log messages
function logHelp()
{
    printf "\
Lib log messages.
Syntax: source libLog.sh [options]
               logInit   [options]
               logSetup  [options]
Options:
  -d|--default              Set log to default level.
  -f|--file [name]          Enable log to file as '/tmp/name.log',
                            [name] is an optional argument,
                            if empty, assume default as '/tmp/scriptname.log'.
  -g|--debug                Enable debug messages.
  -l|--level <level>        Set log level:
                              0|${logLevelNamesLIST[0]}:\tFull
                              1|${logLevelNamesLIST[1]}:\tVerbose
                              2|${logLevelNamesLIST[2]}:\tInfo
                              3|${logLevelNamesLIST[3]}:\tSuccess
                              4|${logLevelNamesLIST[4]}:\tRuntime
                              5|${logLevelNamesLIST[5]}:\tWarning
                              6|${logLevelNamesLIST[6]}:\tError
                              7|${logLevelNamesLIST[7]}:\tFailure
                              8|${logLevelNamesLIST[8]}:\tDebug
                              9|${logLevelNamesLIST[9]}:\tTrace
                              10|${logLevelNamesLIST[10]}:\tNone|Disable (default)
  -q|--quiet                Disable all messages (default at startup).
     --ram [name] [size]    Set ramdrive name and size.
     --ramName <name>       Set ramdrive name.
     --ramSize <size>       Set ramdrive size.
  -t|--trace                Enable trace messages.
  -v|--verbose              Enable verbose level.
     --                     Let next parameter to another application.
"
    return 0
}

function openRamdrive()
{
    if ! $flagRAM ; then return 0 ; fi
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
    if (( $err != 0 ))
    then
        flagRAM=false
        logE "Run mount command line."
        return $err
    fi
    if ! [ -d "${dir}" ]
    then
        flagRAM=false
        logF "ramDrive folder ${dir} not found."
        return 1
    fi
    printf -v cmd "sudo chown -R %s:%s %s" $USER $USER "${dir}"
    eval "${cmd}" || err=$?
    if (( $err != 0 ))
    then
        flagRAM=false
        logF "Change device owner to $USER"
        return $err
    fi
    if ! [ -f "${dir}"/success ]
    then
        printf -v cmd "echo 1 > %s" "${dir}/success"
        eval "${cmd}" || err=$?
        if (( $err != 0 ))
        then
            flagRAM=false
            logF "ramDrive file access."
            return $err
        fi
    fi
    if (( $err == 0 ))
    then
        logTmpDIR="${dir}"
    fi
    return $err
}

function closeRamdrive()
{
    if ! $flagRAM ; then return 0 ; fi
    local err=0
    local dir="${1:-$logRamDIR}"
    printf -v cmd "sudo umount -l %s" "${dir}"
    eval "${cmd}" || err=$((err+$?))
    logOnE $err "Unmount ${dir} RAM drive."
    sleep 1
    printf -v cmd "sudo rmdir %s" "${dir}"
    eval "${cmd}" || err=$((err+$?))
    logOnE $err "Umount and remove directory ${dir}"
    return $err
}

# parse and setup log from command line parameters.
function logSetup()
{
    (( $# > 0 )) || return 0
    local err=0
    # is (I)nteger
    function isI() { if echo -n "$1" | grep -aoP '^[+-]?[0-9]+$' > /dev/null 2>&1; then true; else false; fi; }
    # is (V)alue|Arg
    function isV() { case "$1" in --*|-*|'') false;; *) true;; esac; }
    while [ -n "$1" ]
    do
        case "$1" in
        -h|--help)    logHelp ; err=$((err+1)) ; break ;;
        -q|--quiet)   logLevel=$logNONE   ; flagQUIET=true ; flagVERBOSE=false ;;
        -v|--verbose) logLevel=$logVERBOSE; flagQUIET=false; flagVERBOSE=true  ;;
        -g|--debug)   [ $logLevel -le $logDEBUG ] || logLevel=$logDEBUG; flagDEBUG=true; logU "${DEBUG} Enabled" ;;
        -t|--trace)   [ $logLevel -le $logTRACE ] || logLevel=$logTRACE; flagTRACE=true; logU "${TRACE} Enabled" ;;
        -d|--default) [ $logLevel -le $logINFO  ] || logLevel=$logINFO
                      flagQUIET=false
                      flagVERBOSE=false
                      flagDEBUG=false
                      flagTRACE=false
                      ;;
        -l|--level)
            if isV "$2"
            then
                shift
                if isI "$1"
                then
                    if [[ ${levelLIST[@]} =~ $1 ]]
                    then
                        logLevel=$1
                    else
                        logF "Level out of range [0..10]"
                        err=$((err+2))
                        break
                    fi
                else
                    logF "Level must be an integer value."
                    err=$((err+2))
                    break
                fi
            else
                logF "Empty level value for parameter -l|--level <level>"
                err=$((err+2))
                break
            fi
            ;;
        -f|--file) flagFILE=true ;;
        --ram)
            flagRAM=true
            local maxparam=2
            while [ -n "$2" ] && (( $maxparam > 0 ))
            do
                case "$2" in
                -*) break ;;
                 *) if isI "$2"
                    then
                        logRamSIZE=$2
                        let maxparam--
                    else
                        logRamNAME="${2}"
                        logRamDIR="${logMountDIR}/${logRamNAME}"
                        let maxparam--
                    fi
                    ;;
                esac
                shift
            done
            ;;
        --ramName)
            flagRAM=true
            if isV "$2"
            then
                if ! isI "$2"
                then
                    logRamNAME="${2}"
                    logRamDIR="${logMountDIR}/${logRamNAME}"
                else
                    logF "Invalid name type value for --ramName <name>"
                    err=$((err+4))
                    break
                fi
                shift
            else
                logF "Empty name value for --ramName <name>"
                err=$((err+4))
                break
            fi
            ;;
        --ramSize)
            flagRAM=true
            if isV "$2"
            then
                if isI "$2"
                then
                    logRamSIZE=$2
                else
                    logF "Size must be an integer value for --ramSize <size>"
                    err=$((err+8))
                    break
                fi
                shift
            else
                logF "Empty size value for --ramSize <size>"
                err=$((err+8))
                break
            fi
            ;;
        --) shift ; break ;;
        -*) logE "Unknown parameter $1" ; err=$((err+16)) ; break ;;
         *) logE "Unknown value $1"     ; err=$((err+32)) ; break ;;
        esac
        shift
    done
    return $err
}

# Initialize lib log.
function logInit()
{
    logSetup "$@" || return $?
    openRamdrive  || return $?
    logFILE="${logTmpDIR}/$(basename $0).log"
    logBegin
    return 0
}

# Stop or disable log messages.
function logStop()
{
    local code=${1:-0}
    logEnd
    if (( $code == 0 )) ; then closeRamdrive || logF "Close ramdrive ${logRamDIR}" ; fi
    if [ -f "${logRamDIR}"/success ] ; then logW "Ram drive ${logFILE} for log are opened and must be closed manually." ; fi
    logLevel=$logNONE
    flagQUIET=true
    flagVERBOSE=false
    flagDEBUG=false
    flagTRACE=false
    flagFILE=false
}

# exit from lib log.
function libLogExit()
{
    # unset variables
    unset -v libLog
    unset -v logSTARTIME
    unset -v logFILE
    unset -v logRamSIZE
    unset -v logMountDIR
    unset -v logRamNAME
    unset -v logRamDIR
    unset -v logTmpDIR
    unset -v flagDEBUG
    unset -v flagTRACE
    unset -v flagVERBOSE
    unset -v flagQUIET
    unset -v flagFILE
    unset -v levelLIST
    unset -v logLevelNamesLIST
    unset -v ERROR
    unset -v FAIL
    unset -v DEBUG
    unset -v TRACE
    unset -v WARN
    unset -v SUCCESS
    unset -v RUNTIME
    unset -v INFO
    unset -v logFULL
    unset -v logVERBOSE
    unset -v logINFO
    unset -v logSUCCESS
    unset -v logRUNTIME
    unset -v logWARNING
    unset -v logERROR
    unset -v logFAILURE
    unset -v logDEBUG
    unset -v logTRACE
    unset -v logNONE
    unset -v logLevel
    unset -v libLogLoaded
    # unset functions
    unset -f openRamdrive
    unset -f closeRamdrive
    unset -f logBegin
    unset -f logEnd
    unset -f log
    unset -f logU
    unset -f logIt
    unset -f logI
    unset -f logE
    unset -f logOnE
    unset -f logOnZ
    unset -f logF
    unset -f logCRNLF
    unset -f getRuntime
    unset -f logR
    unset -f logS
    unset -f logV
    unset -f logW
    unset -f logD
    unset -f logT
    unset -f onErrorTraceAndExit
    unset -f logHelp
    unset -f logVersion
    unset -f logIsValue
    unset -f logIsParameter
    unset -f logIsInteger
    unset -f logSetup
    unset -f logInit
    unset -f logStop
    unset -f libLogExit
    return 0
}

libLog='loaded'

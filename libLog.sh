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
declare -i logSTARTIME=$(( $(date +%s%N) / 1000000 ))
declare -i logRamSIZE=$((4096*1024*1024))
declare    logMountDIR=$([ -d '/media' ] && echo -n "/media/$USER" || { [ -d '/run/media' ] && echo -n "/run/media/$USER" || echo -n "/mnt/$USER" ; })
declare    logRamNAME='logRamDrive'
declare    logRamDIR="${logMountDIR}/${logRamNAME}"
declare    logTmpDIR='/tmp'
declare    logFILE="${logTmpDIR}/$(basename $0).log"
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
declare    flagRAM=false
declare    flagQUIET=false
declare    flagVERBOSE=false
declare    flagDEBUG=false
declare    flagTRACE=false
declare -i logTONONE=0
declare -i logTOSCREEN=1
declare -i logTOFILE=2
declare -i logTOALL=$((logTOSCREEN+logTOFILE))
declare -a logTOLIST=($logTOSCREEN $logTOFILE $((logTOSCREEN+logTOFILE)))
declare -i logTO=$logTONONE
declare -i logALL=0
declare -i logINFO=1
declare -i logSUCCESS=2
declare -i logRUNTIME=3
declare -i logWARNING=4
declare -i logERROR=5
declare -i logFAILURE=6
declare -i logDEBUG=7
declare -i logTRACE=8
declare -i logNONE=9
declare -i logENABLE=$logALL
declare -i logDISABLE=$logNONE
declare -i -a levelLIST=($logALL $logINFO $logSUCCESS $logRUNTIME $logWARNING $logERROR $logFAILURE $logDEBUG $logTRACE $logNONE)
declare    -a logLevelNamesLIST=(ALL INFO SUCCESS RUNTIME WARNING ERROR FAILURE DEBUG TRACE NONE)
declare -i logLevel=$logDISABLE
# Functions

# begin logs.
function logBegin()
{
    if (((logTO & logTOFILE) == logTOFILE))
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
    if (((logTO & logTOFILE) == logTOFILE))
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

# log any message
function logScreen() { echo -e "$*" ; }
function logFile() { echo -e "$*" >> "${logFILE}" ; }
function logScreenFile() { echo -e "$*" | tee -a "${logFILE}" ; }

# log unconditional
function logU()
{
    case "$1" in
    $logTOALL)    shift ; logScreenFile "$*" ;;
    $logTOSCREEN) shift ; logScreen "$*" ;;
    $logTOFILE)   shift ; logFile "$*" ;;
    esac
}

# log to Screen and/or File
function log()
{
    [[ "${logTOLIST[@]}" =~ "$logTO" ]] || return 0
    if   ((logTO == logTOALL))    ; then logScreenFile "$*"
    elif ((logTO == logTOSCREEN)) ; then logScreen "$*"
    elif ((logTO == logTOFILE))   ; then logFile "$*"
    fi
}

# no line feed, just log message with Carriage Return Not Line Feed.
function logCRNLF() { echo -e -n "\r$*" ; }

# log info messages
function logI() { if ((logLevel <= $logINFO)) ; then log "${INFO} $*" ; fi ; }

# log success messages
function logS() { if ((logLevel <= logSUCCESS)) ; then log "${SUCCESS} $*" ; fi ; }

# log runtime messages
function logR() { if ((logLevel <= logRUNTIME)) ; then log "${RUNTIME} $(getRuntime)" ; fi ; }

# log verbose messages
function logV() { if $flagVERBOSE && ((logLevel <= $logINFO)) ; then log "${INFO} $*" ; fi ; }

# log warning messages
function logW() { if ((logLevel <= logWARNING)) ; then log "${WARN} $*" ; fi ; }

# log error messagges
function logE() { if ((logLevel <= logERROR)) ; then log "${ERROR} $*" ; fi ; }

# log failure messages
function logF() { if ((logLevel <= logFAILURE)) ; then log "${FAIL} $*" ; fi ; }

# log debug messages
function logD() { if $flagDEBUG && ((logLevel <= logDEBUG)) ; then log "${DEBUG} $*" ; fi ; }

# log trace messages
function logT() { if $flagTRACE && ((logLevel <= logTRACE)) ; then log "${TRACE} $*" ; fi ; }

# on error log trace message and return the error code to exit from program.
# usage: onErrorTraceAndExit $errCode "trace message" || _exit $?
function onErrorTraceAndExit()
{
    local err=$1
    if ((err != 0))
    then
        shift
        logR
        logU $logTOALL "${TRACE} $*"
        logStop $err
        libLogExit
    fi
    return $err
}

# on error log message
function logOnE() { if (($1 != 0)) then shift ; logE "$*" ; fi ; }

# on empty string log message
function logOnZ() { if [ -z "$1" ] ; then shift ; logE "$*" ; fi ; }

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
    if ((err != 0))
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
    if ((err != 0))
    then
        flagRAM=false
        logF "Change device owner to $USER"
        return $err
    fi
    if ! [ -f "${dir}"/success ]
    then
        printf -v cmd "echo 1 > %s" "${dir}/success"
        eval "${cmd}" || err=$?
        if ((err != 0))
        then
            flagRAM=false
            logF "ramDrive file access."
            return $err
        fi
    fi
    if ((err != 0))
    then
        logTmpDIR="${dir}"
        logU $logTOSCREEN "ramDrive enabled and running at path ${logTmpDIR}"
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
    if ((err != 0))
    then
        flagRAM=false
        logTmpDIR='/tmp'
        logFILE="${logTmpDIR}/$(basename $0).log"
        logU $logTOSCREEN "${INFO} Closed ramdrive from path ${logTmpDIR}"
    fi
    return $err
}

# print help for log messages
function logHelp()
{
    printf "\
Lib log messages.
Syntax: source libLog.sh [options]
               logInit   [options]
               logSetup  [options]
Options:
  -h|--help                 Show this usage information.
  -d|--default              Reset logs to (default) state.
  -e|--enable <level> <target>  Enable logs.
                                <level>
                                    0|${logLevelNamesLIST[0]}:\tAll
                                    1|${logLevelNamesLIST[1]}:\tVerbose
                                    2|${logLevelNamesLIST[2]}:\tInfo (default)
                                    3|${logLevelNamesLIST[3]}:\tSuccess
                                    4|${logLevelNamesLIST[4]}:\tRuntime
                                    5|${logLevelNamesLIST[5]}:\tWarning
                                    6|${logLevelNamesLIST[6]}:\tError
                                    7|${logLevelNamesLIST[7]}:\tFailure
                                    8|${logLevelNamesLIST[8]}:\tDebug
                                    9|${logLevelNamesLIST[9]}:\tTrace
                                   10|${logLevelNamesLIST[10]}:\tNone
                                <target>
                                    $logTONONE:\tDisabled
                                    $logTOSCREEN:\tScreen
                                    $logTOFILE:\tFile
                                    $logTOALL:\tAll
  -f|--file                 Enable log to file.
  -g|--debug                Enable debug messages.
  -q|--quiet                Disable messates to screen.
  -s|--screen               Enable log to screen (default).
  -t|--trace                Enable trace messages.
  -v|--verbose              Enable verbose level.
     --disable              Disable logs.
     --ram [name] [size]    Set ramDrive [name=logRamDrive] and/or [size=128*1024*1024=134217728].
     --                     Let next parameter to another application.
"
    return 0
}

function logDisable()
{
    logTO=$logTONONE
    logLevel=$logNONE
    flagQUIET=true
    flagVERBOSE=false
    flagDEBUG=false
    flagTRACE=false
    flagRAM=false
    return 0
}

function logEnable()
{
    if [[ "${levelLIST[@]}" =~ $1 ]]
    then
        logLevel=$1
    else
        return 1
    fi
    if [[ "${logTOLIST[@]}" =~ $2 ]]
    then
        logTO=$2
    else
        return 1
    fi
    return 0
}

function logDefault()
{
    logEnable $logINFO $logTOSCREEN
    flagQUIET=false
    flagVERBOSE=false
    flagDEBUG=false
    flagTRACE=false
    return 0
}

function setRam()
{
    function isI() { if echo -n "$1" | grep -aoP '^[+-]?[0-9]+$' > /dev/null 2>&1; then true; else false; fi; }
    if isI "$1"
    then
        logRamSIZE=$1
    else
        logRamNAME="${1}"
        logRamDIR="${logMountDIR}/${1}"
    fi
    return 0
}

# parse and setup log from command line parameters.
function logSetup()
{
    (($# > 0)) || return 0
    local err=0
    while [ -n "$1" ]
    do
        case "$1" in
        -h|--help)      logHelp ; break ;;
        -d|--default)   logDefault ;;
        -e|--enable)    logEnable $1 $2 || { logF "Invalid parameter to -e|--enable <level> <target>" ; return $? ; } ;;
        -f|--file)      ((logTO|=logTOFILE)) ;;
        -g|--debug)     ((logLevel <= logDEBUG)) || logLevel=$logDEBUG; flagDEBUG=true; logU $logTOSCREEN "${DEBUG} Enabled" ;;
        -q|--quiet)     logLevel=$logNONE ; flagQUIET=true ; flagVERBOSE=false ;;
        -s|--screen)    ((logTO|=logTOSCREEN)) ;;
        -t|--trace)     ((logLevel <= logTRACE)) || logLevel=$logTRACE; flagTRACE=true; logU $logTOSCREEN "${TRACE} Enabled" ;;
        -v|--verbose)   logLevel=$logINFO; flagQUIET=false; flagVERBOSE=true ;;
           --disable)   logDisable ;;
           --ram)       flagRAM=true
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
        --) shift ; set -- "$@" ; break ;;
        -*) logE "Unknown parameter $1" ; ((err+=1)) ; break ;;
         *) logE "Unknown value $1"     ; ((err+=2)) ; break ;;
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
    if ((code == 0)) ; then closeRamdrive || logF "Close ramdrive ${logRamDIR}" ; fi
    if [ -f "${logRamDIR}"/success ] ; then logW "Ram drive ${logFILE} for log are opened and must be closed manually." ; fi
    logDisable
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
    unset -v logTOSCREEN
    unset -v logTOFILE
    unset -v logTOALL
    unset -v logToFile
    unset -v logToScreen
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
    unset -f logEnable
    unset -f logDisable
    unset -f logDefault
    unset -f libLogExit
    return 0
}

libLog='loaded'

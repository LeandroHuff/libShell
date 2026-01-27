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
declare     logFILE="/tmp/$(basename "$0").log"
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
function logU() { if $flagFILE; then echo -e "$*" | tee -a "${logFILE}"; else echo -e "$*"; fi; }

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
function logI() { if [ $logLevel -le $logINFO ]; then log "${INFO} $*"; fi; }

# log success messages
function logS() { if [ $logLevel -le $logSUCCESS ]; then log "${SUCCESS} $*"; fi; }

# log runtime messages
function logR() { if [ $logLevel -le $logRUNTIME ]; then log "${RUNTIME} $(getRuntime)"; fi; }

# log verbose messages
function logV() { if $flagVERBOSE && [ $logLevel -le $logVERBOSE ]; then [ $flagFILE ] && echo -e "${INFO} $*" | tee -a || echo -e "${INFO} $*"; fi; }

# log warning messages
function logW() { if [ $logLevel -le $logWARNING ]; then log "${WARN} $*"; fi; }

# log error messagges
function logE() { if [ $logLevel -le $logERROR ]; then log "${ERROR} $*"; fi; }

# log failure messages
function logF() { if [ $logLevel -le $logFAILURE ]; then log "${FAIL} $*"; fi; }

# log debug messages
function logD() { if $flagDEBUG && [ $logLevel -le $logDEBUG ]; then logU "${DEBUG} $*"; fi; }

# log trace messages
function logT() { if $flagTRACE && [ $logLevel -le $logTRACE ]; then logU "${TRACE} $*"; fi; }

# on error log trace message and return the error code to exit from program.
# usage: onErrorTraceAndExit $errCode "trace message" || _exit $?
function onErrorTraceAndExit()
{
    local err
    if $flagTRACE && [ -n "$1" ] && [ $1 -ne 0 ]
    then
        err=$1
        shift
        logR
        logU "${TRACE} $*"
        logStop
        libLogExit
        return $err
    fi
}

# on error log message
function logOnE() { if [ $1 -ne 0 ] && [ $logLevel -le $logERROR ]; then shift; log "${ERROR} $*"; fi; }

# on empty string log message
function logOnZ() { if [ -z "$1"  ] && [ $logLevel -le $logERROR ]; then shift; log "${ERROR} $*"; fi; }

# print help for log messages
function logHelp()
{
    printf "\
Lib log messages.
Syntax: source libLog.sh [options]
               logInit   [options]
               logSetup  [options]
Options:
  -q|--quiet          Disable all messages (default at startup).
  -g|--debug          Enable debug messages.
  -t|--trace          Enable trace messages.
  -v|--verbose        Enable verbose level.
  -d|--default        Set log to default level.
  -f|--file [name]    Enable log to file as '/tmp/name.log',
                      [name] is an optional argument,
                      if empty, assume default as '/tmp/scriptname.log'.
  -l|--level <level>  Set log level:
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

     --               Let next parameter to another application.
"
    return 0
}

# parse and setup log from command line parameters.
function logSetup()
{
    # is (I)nteger
    function isI() { if echo -n "$1" | grep -aoP '^[+-]?[0-9]+$' > /dev/null 2>&1; then true; else false; fi; }
    # is (V)alue|Arg
    function isV() { case "$1" in --*|-*|'') false;; *) true;; esac; }
    while [ -n "$1" ]
    do
        case "$1" in
        -h|--help)    logHelp   ; return 1;;
        -q|--quiet)   logLevel=$logNONE   ; flagQUIET=true ; flagVERBOSE=false ;;
        -v|--verbose) logLevel=$logVERBOSE; flagQUIET=false; flagVERBOSE=true  ;;
        -g|--debug)   [ $logLevel -le $logDEBUG ] || logLevel=$logDEBUG; flagDEBUG=true; logD "Enabled" ;;
        -t|--trace)   [ $logLevel -le $logTRACE ] || logLevel=$logTRACE; flagTRACE=true; logT "Enabled" ;;
        -d|--default) [ $logLevel -le $logINFO  ] || logLevel=$logINFO
                      flagQUIET=false
                      flagVERBOSE=false
                      flagDEBUG=false
                      flagTRACE=false
                      local oldFlagFILE=$flagFILE
                      flagFILE=true
                      if ! $oldFlagFILE && $flagFILE ; then logBegin ; fi
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
                        return 3
                    fi
                else
                    logF "Level must be an integer value."
                    return 4
                fi
            else
                logF "Empty level value for parameter -l|--level <level>"
                return 5
            fi
            ;;
        -f|--file)
            local oldFlagFILE=$flagFILE
            flagFILE=true
            if isV "$2"
            then
                shift
                if [[ "${logFILE}" != "/tmp/$(basename ${1}).log" ]]
                then
                    "${logFILE}"="/tmp/$(basename ${1}).log"
                    logD "New log to file ${logFILE}"
                fi
            else
                if [[ "${logFILE}" != "/tmp/$(basename "${0}").log" ]]
                then
                    logFILE="/tmp/$(basename "${0}").log"
                    logD "New log to file ${logFILE}"
                fi
            fi
            if ! $oldFlagFILE && $flagFILE ; then logBegin ; fi
            ;;
        --) shift ; break ;;
        -*) logE "Unknown parameter $1"; return 1 ;;
         *) logE "Unknown value $1"    ; return 2 ;;
        esac
        shift
    done
    return 0
}

# Initialize lib log.
function logInit()
{
    local err=0
    [ $# -eq 0 ] || logSetup "$@" || err=$((err+1))
    [ -n "${logFILE}" ] || logFILE="/tmp/$(basename "$0").log"
    return $err
}

# Stop or disable log messages.
function logStop() { logEnd; logLevel=$logNONE; flagQUIET=true; flagVERBOSE=false; flagDEBUG=false; flagTRACE=false; flagFILE=false; }

# exit from lib log.
function libLogExit()
{
    # unset variables
    unset -v libLog
    unset -v logSTARTIME
    unset -v logFILE
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
    unset -f logNLF
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

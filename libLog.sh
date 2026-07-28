################################################################################
# @file         libLog.sh
# @brief        Shell script source code to print log messages on terminal or file.
# @author       Leandro D. Huff
# @copyright    https://creativecommons.org/licenses/by/4.0/
# @sintaxe      source libLog.sh [options]
#               Options:
#               -h|--help       Show usage information.
#               -f|--file       Enable log to file.
#               -g|--debug      Enable debug messages.
#               -q|--quiet      Disable messages to screen.
#               -t|--trace      Enable trace messages.
#                  --           Let next parameter to another application.
################################################################################

# Must be sourced not running
[[ "${BASH_SOURCE[0]}" == "${0}" ]] && { echo -e "\033[91m  error\033[0m: $(basename $0) must be sourced not running." ; exit 1 ; }

# Constants
declare -i logSTARTIME=$((`date +%s%N` / 1000000))

# log message and colors
declare    escINFO='\033[37m   info\033[0m:'
declare escSUCCESS='\033[97msuccess\033[0m:'
declare escRUNTIME='\033[97mruntime\033[0m:'
declare    escWARN='\033[96mwarning\033[0m:'
declare   escERROR='\033[91m  error\033[0m:'
declare   escDEBUG='\033[92m  debug\033[0m:'
declare   escTRACE='\033[93m  trace\033[0m:'

# flags
declare logVERBOSE=false
declare logQUIET=false
declare logDEBUG=false
declare logTRACE=false
declare logFILE=false

declare logTOFILE="/tmp/$(basename $0).log"

## @brief   Validate only integer numbers.
function _isInteger() { if echo -n "${1}" | grep -qaoP '^[+-]?\d+$' &> /dev/null ; then true ; else false ; fi ; }

## @brief   Get runtime timestamp, format #.###s
function _getRuntime()
{
    declare -i runtime=$((`date +%s%N` / 1000000 - logSTARTIME))
    printf -v elapsed "%u.%03u" $((runtime / 1000)) $((runtime % 1000))
    echo -n ${elapsed}
}

## @brief    Print log messages
function _log()
{
    if [ "$1" = "file" ]
    then
        shift
        echo -e -n "$*" >> ${logTOFILE}
    elif [ $logQUIET = true ] && [ $logFILE = true ]
    then
        echo -e -n "$*" >> ${logTOFILE}
    elif [ $logFILE = true ]
    then
        echo -e -n "$*" | tee -a ${logTOFILE}
    else
        echo -e -n "$*"
    fi
}

## @brief    Begin logs.
function logBegin()
{
    _log file "----------- Start Log to File on $(date +%Y-%m-%d) at $(date +%T.%N) --------------\n"
}

## @brief    End logs.
function logEnd()
{
    _log file "------------- End Log to File on $(date +%Y-%m-%d) at $(date +%T.%N) --------------\n"
}

## @brief   Unformatted log.
function logU() { _log "$*" ; }

## @brief    log info messages
function logI() { _log "${escINFO} $*\n" ; }

## @brief    log verbose info messages
function logV() { if $logVERBOSE ; then logI "$*" ; fi ; }

## @brief    log success messages
function logS() { _log "${escSUCCESS} $*\n" ; }

## @brief    log runtime messages
function logR() { _log "${escRUNTIME} $(_getRuntime)s\n" ; }

## @brief    log with time stamp
function logTS() { _log "\033[97m$(_getRuntime)\033[0m: $*\n" ; }

## @brief    log warning messages
function logW() { _log "${escWARN} $*\n" ; }

## @brief    log error messagges
function logE() { _log "${escERROR} $*\n" ; }

## @brief    log debug messages
function logD() { if [ $logDEBUG = true ] ; then _log "${escDEBUG} $*\n" ; fi ; }

## @brief    log trace messages
function logT() { if [ $logTRACE = true ] ; then _log "${escTRACE} $*\n" ; fi ; }

## @brief    On error log a message and return the error code.
function logOnE() { local err=$1 ; shift ; if [ $err -ne 0 ] ; then _log "${escERROR} $*\n" ; fi ; return $err ; }

## @brief    On empty variable, log a message
function logOnZ() { if [ "x${1}" = 'x' ] ; then shift ; _log "${escERROR} $*\n" ; fi ; }

## @brief    On error, log a trace message and return the error code to exit from program.
## @details  Usage: traceOnError $? "trace message" || exit $?
function traceOnError()
{
    local err=$1
    if [ $err -ne 0 ]
    then
        shift
        _log "${escTRACE} \033[97m$(_getRuntime)\033[0m: $*\n"
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
     --                     Let next parameter to another application.
"
    return 0
}

## @brief    parse and setup log from command line parameters.
function logSetup()
{
    (($# > 0)) || return 0

    while [ -n "$1" ]
    do
        case "$1" in
        -h|--help)  logHelp
                    break
                    ;;
        -f|--file)  local logfile=$logFILE
                    logFILE=true
                    if ! $logfile && $logFILE ; then logBegin ; fi
                    ;;
        -g|--debug) logDEBUG=true
                    ;;
        -t|--trace) logTRACE=true
                    logDEBUG=true
                    ;;
        -q|--quiet) logQUIET=true
                    ;;
           --)      shift
                    set -- "$@"
                    return 0
                    ;;
        -*)         _log "${escERROR} Unknown parameter ($1).\n"
                    return 1
                    ;;
         *)         _log "${escERROR} Unknown value ($1).\n"
                    return 2
                    ;;
        esac
        shift
    done
    return 0
}

## @brief    Initialize lib log.
function logInit()
{
    logSetup "$@" || return $?
    return 0
}

## @brief    Stop or disable log messages.
function logStop()
{
    logSetup -q
    return 0
}

##  @brief  Exit from libLog, unload all variables and functions.
function libLogExit()
{
    # unset variables
    unset -v logSTARTIME
    unset -v escINFO
    unset -v escSUCCESS
    unset -v escRUNTIME
    unset -v escWARN
    unset -v escERROR
    unset -v escDEBUG
    unset -v escTRACE
    unset -v logVERBOSE
    unset -v logQUIET
    unset -v logDEBUG
    unset -v logTRACE
    unset -v logFILE
    unset -v logTOFILE
    # unset functions
    unset -f _isInteger
    unset -f _getRuntime
    unset -f _log
    unset -f logBegin
    unset -f logEnd
    unset -f logU
    unset -f logI
    unset -f logV
    unset -f logS
    unset -f logR
    unset -f logTS
    unset -f logW
    unset -f logE
    unset -f logD
    unset -f logT
    unset -f logOnE
    unset -f logOnZ
    unset -f traceOnError
    unset -f logHelp
    unset -f logSetup
    unset -f logInit
    unset -f logStop
}

declare libLog='loaded'

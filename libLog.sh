#!/usr/bin/env bash

################################################################################
# @file         libLog.sh
# @brief        Source variables and functions to print log messages on terminal
#               or file.
# @author:      Leandro D. Huff
# @copyright:   https://creativecommons.org/licenses/by/4.0/
################################################################################

# Constants
declare -i  logSTARTIME
            logSTARTIME=$(( $(date +%s%N) / 1000000 ))
declare     logFILE
            logFILE="/tmp/$(basename "$0").log"
# log message and colors
declare   ERROR='\033[91m  error\033[0m:'
declare    FAIL='\033[91mfailure\033[0m:'
declare   DEBUG='\033[92m  debug\033[0m:'
declare   TRACE='\033[93m  trace\033[0m:'
declare    WARN='\033[96mwarning\033[0m:'
declare SUCCESS='\033[97msuccess\033[0m:'
declare RUNTIME='\033[97mruntime\033[0m:'
declare    INFO='\033[98m   info\033[0m:'
# Variables
declare flagQUIET=false
declare flagVERBOSE=false
declare flagDEBUG=false
declare flagTRACE=false
declare flagFILE=false
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

# log any message, check flags.
function log()
{
    if ! $flagQUIET
    then
        if $flagFILE
        then
            echo -e "$*" | tee -a "${logFILE}"
        else
            echo -e "$*"
        fi
    fi
}

# log info messages
function logI() { log "${INFO} $*"; }

# log error messagges
function logE() { log "${ERROR} $*"; }

# log failure messages
function logF() { log "${FAIL} $*" ; }

# log success messages
function logS() { log "${SUCCESS} $*" ; }

# log warning messages
function logW() { log "${WARN} $*" ; }

# log verbose messages
function logV() { if $flagVERBOSE ; then [ $flagFILE ] && echo -e "${INFO} $*" | tee -a || echo -e "${INFO} $*" ; fi ; }

# log debug messages
function logD() { if $flagDEBUG ; then logU "${DEBUG} $*" ; fi ; }

# log trace messages
function logT() { if $flagTRACE ; then logU "${TRACE} $*" ; fi ; }

# log runtime messages
function logR() { log "${RUNTIME} $(getRuntime)" ; }

# on error log trace message and exit from program.
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
        exit $err
    fi
}

# on error log message
function logOnE() { if [ $1 -ne 0 ] ; then shift ; log "${ERROR} $*" ; fi ; }

# on empty string log message
function logOnZ() { if [ -z "$1"  ] ; then shift ; log "${ERROR} $*" ; fi ; }

# print help for log messages
function logHelp()
{
    cat << EOT
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
     --               Let follow parameter to next application.
EOT
    return $?
}

# print version for log
function logVersion()
{
    cat << EOT
Bash script libLog.sh
Version: 2.2.4
EOT
    return $?
}

# parse and setup log from command line parameters.
function logSetup()
{
    #function isI() { if echo -n "$1" | grep -aoP '^[+-]?[0-9]+$' > /dev/null 2>&1 ; then true ; else false ; fi ; }
    function isV() { case "$1" in --*|-*|'') false ;; *) true ;; esac ; }
    while [ -n "$1" ]
    do
        case "$1" in
        -V|--version) logVersion      ; exit 0            ;;
        -h|--help)    logHelp         ; exit 0            ;;
        -q|--quiet)   flagQUIET=true  ; flagVERBOSE=false ;;
        -v|--verbose) flagQUIET=false ; flagVERBOSE=true  ;;
        -g|--debug)   flagDEBUG=true  ; logD "Enabled"    ;;
        -t|--trace)   flagTRACE=true  ; logT "Enabled"    ;;
        -d|--default) flagQUIET=false
                      flagVERBOSE=false
                      flagDEBUG=false
                      flagTRACE=false
                      flagFILE=true ;;
        -f|--file)
            flagFILE=true
            if isV "$2"
            then
                shift
                if [[ "${logFILE}" != "/tmp/$(basename ${1}).log" ]]
                then
                    "${logFILE}"="/tmp/$(basename ${1}).log"
                    logBegin
                    logD "New log to file ${logFILE}"
                else
                    logW "Log to file ${logFILE} was previously settled."
                fi
            else
                if [[ "${logFILE}" != "/tmp/$(basename ${0}).log" ]]
                then
                    "${logFILE}"="/tmp/$(basename ${0}).log"
                    logBegin
                    logD "New log to file ${logFILE}"
                else
                    logW "Log to file ${logFILE} was previously settled."
                fi
            fi
            ;;
        --) shift ; break ;;
        -*) logU "${ERROR} Unknown parameter $1" ; return 1 ;;
         *) logU "${ERROR} Unknown value $1"     ; return 1 ;;
        esac
        shift
    done
    return 0
}

# Initialize lib log.
function logInit()
{
    local err=0
    [ $# -eq 0 ] || logSetup "$@"
    err=$((err+$?))
    if [ -z "${logFILE}" ] ; then logFILE="/tmp/$(basename "$0").log" ; fi
    err=$((err+$?))
    return $err
}

# Stop or disable log messages.
function logStop() { logEnd; flagQUIET=true; flagVERBOSE=false; flagDEBUG=false; flagTRACE=false; flagFILE=false; }

# exit from lib log.
function libLogExit()
{
    # unset variables
    unset -v logSTARTIME
    unset -v logFILE
    unset -v flagDEBUG
    unset -v flagTRACE
    unset -v flagVERBOSE
    unset -v flagQUIET
    unset -v flagFILE
    unset -v ERROR
    unset -v FAIL
    unset -v DEBUG
    unset -v TRACE
    unset -v WARN
    unset -v SUCCESS
    unset -v RUNTIME
    unset -v INFO
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

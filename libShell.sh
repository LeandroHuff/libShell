#!/usr/bin/env bash

################################################################################
# @brief        Shell Script Library.                                          #
# @file         libShell                                                       #
# @author       Leandro - leandrohuff@programmer.net                           #
# @date         2025-08-20                                                     #
# @version      2.0.0                                                          #
# @copyright    CC01 1.0 Universal                                             #
# @details      Formatted script file to service as a shell function library.  #
#               Let a rapid develop with a list of common and most used        #
#               functions.                                                     #
################################################################################

# version number
declare -a -r libVERSION=(2 1 0)
# log levels
declare -i -r QUIET=0
declare -i -r NORMAL=1
declare -i -r VERBOSE=2
# log target
declare -i -r DISABLED=0
declare -i -r SCREEN=10
declare -i -r FILE=20
declare -i -r FULL=30
declare    -r LOGFILE="/tmp/$(basename $0).log"
# escape codes for colors
declare NC="\033[0m"
declare RED="\033[31m"
declare GREEN="\033[32m"
declare YELLOW="\033[33m"
declare BLUE="\033[34m"
declare MAGENTA="\033[35m"
declare CYAN="\033[36m"
declare WHITE="\033[37m"
declare HRED="\033[91m"
declare HGREEN="\033[92m"
declare HYELLOW="\033[93m"
declare HBLUE="\033[94m"
declare HMAGENTA="\033[95m"
declare HCYAN="\033[96m"
declare HWHITE="\033[97m"
# variables
declare    DEBUG=false
declare    TRACE=false
declare -i ENABLED=$((SCREEN + LEVEL))
declare -i LEVEL=$NORMAL
declare    LOG=$ENABLED
declare -i TIMEOUT=10
# support functions
function getScriptName()         { echo -n "$(basename $0)" ; }
function getFileName()           { echo -n "$(basename $1)" ; }
function getName()               { echo -n "${1%.*}"        ; }
function getExt()                { echo -n "${1##*.}"       ; }
function getPath()               { echo -n "${1%/*}"        ; }
function genRandomAlphaNumeric() { tr < /dev/urandom -d -c "[:alnum:]" | head --bytes=$1 ; }
function genRandomUpHexNumber()  { tr < /dev/urandom -d -c "0-9A-F"    | head --bytes=$1 ; }
function genRandomLowHexNumber() { tr < /dev/urandom -d -c "0-9a-f"    | head --bytes=$1 ; }
function genRandomMixHexNumber() { tr < /dev/urandom -d -c "0-9A-Fa-f" | head --bytes=$1 ; }
function genRandomString()       { tr < /dev/urandom -d -c "[:graph:]" | head --bytes=$1 ; }
function genVersionStr           { declare -a -r vector=(${@}) ; echo -n "${vector[0]}.${vector[1]}.${vector[2]}" ; }
function genVersionNum           { declare -a -i -r vector=(${@}) ; echo -n $((${vector[0]}*100 + ${vector[1]}*10 + ${vector[2]})) ; }
function getLibVersionStr()      { echo -n $(genVersionStr ${libVERSION[@]}) ; }
function getLibVersionNum()      { echo -n $(genVersionNum ${libVERSION[@]}) ; }
function getRuntime()            { echo -n $(( $(date +%s%N) / 1000000 )) ; }
function getLogFilename()        { echo -n "/tmp/$(basename $0).log"      ; }
function getID()                 { if [ -n "$ID" ] ; then [ -f /etc/os-release ] && . /etc/os-release ; fi ; echo -n "$ID"  ; }
function isFloat()               { if [ -n "$( echo -n "$1" | grep -aoP "^[+-]?[0-9]+\.[0-9]+$" )" ] ; then true ; else false ; fi ; }
function isInteger()             { [ -n "$(echo "$1" | grep -oP "^[+-]?([0-9]+)$")" ] && true || false ; }
function isYes()                 { case "$1" in [yY] | [yY][eE][sS])            true ;; *) false ;; esac ; }
function isNot()                 { case "$1" in [nN] | [nN][oO] | [nN][oO][tT]) true ;; *) false ;; esac ; }
function isConnected()           { ping 8.8.8.8 -q -t 10 -c 1 > /dev/null 2>&1 && true || false ; }
########################################
# Log Table                            #
########################################
# logU - Unconditional, none    flag.  #
# logC - Connection   , normal  flag.  #
# logE - Error        , normal  flag.  #
# logF - Failure      , normal  flag.  #
# logI - Info         , normal  flag.  #
# logR - Runtime      , normal  flag.  #
# logS - Success      , verbose flag.  #
# logV - Info         , verbose flag.  #
# logW - Warning      , verbose flag.  #
# logD - Debug        , debug   flag.  #
# logT - Trace        , trace   flag.  #
########################################
# unconditional logs
function logU() { echo -e "${WHITE}    log:${NC} $*" ; }
# warning logs
function logW()
{
	[ $LOG -ge $((SCREEN + VERBOSE)) ] || return
	if [ $LOG -ge $FULL ] ; then
		if [ $LOG -ge $((FULL + VERBOSE)) ] ; then
			echo -e "${HCYAN}warning:${NC} $*" | tee -a "${LOGFILE}"
		fi
	elif [ $LOG -ge $FILE ] ; then
		if [ $LOG -ge $((FILE + VERBOSE)) ] ; then
			echo -e "${HCYAN}warning:${NC} $*" >> "${LOGFILE}"
		fi
	elif [ $LOG -ge $SCREEN ] ; then
		if [ $LOG -ge $((SCREEN + VERBOSE)) ] ; then
			echo -e "${HCYAN}warning:${NC} $*"
		fi
	fi
}
# error logs
function logE()
{
	[ $LOG -ge $ENABLED ] || return
	if [ $LOG -ge $FULL ] ; then
		if [ $LOG -ge $((FULL + NORMAL)) ] ; then
			echo -e "${RED}  error:${NC} $*" | tee -a "${LOGFILE}"
		fi
	elif [ $LOG -ge $FILE ] ; then
		if [ $LOG -ge $((FILE + NORMAL)) ] ; then
			echo -e "${RED}  error:${NC} $*" >> "${LOGFILE}"
		fi
	elif [ $LOG -ge $SCREEN ] ; then
		if [ $LOG -ge $((SCREEN + NORMAL)) ] ; then
			echo -e "${RED}  error:${NC} $*"
		fi
	fi
}
# failure logs
function logF()
{
	[ $LOG -ge $ENABLED ] || return
	if [ $LOG -ge $FULL ] ; then
		if [ $LOG -ge $((FULL + NORMAL)) ] ; then
			echo -e "${HRED}failure:${NC} $*" | tee -a "${LOGFILE}"
		fi
	elif [ $LOG -ge $FILE ] ; then
		if [ $LOG -ge $((FILE + NORMAL)) ] ; then
			echo -e "${HRED}failure:${NC} $*" >> "${LOGFILE}"
		fi
	elif [ $LOG -ge $SCREEN ] ; then
		if [ $LOG -ge $((SCREEN + NORMAL)) ] ; then
			echo -e "${HRED}failure:${NC} $*"
		fi
	fi
}
# info log
function logI()
{
	[ $LOG -ge $ENABLED ] || return
	if [ $LOG -ge $FULL ] ; then
		if [ $LOG -ge $((FULL + NORMAL)) ] ; then
			echo -e "${WHITE}   info:${NC} $*" | tee -a "${LOGFILE}"
		fi
	elif [ $LOG -ge $FILE ] ; then
		if [ $LOG -ge $((FILE + NORMAL)) ] ; then
			echo -e "${WHITE}   info:${NC} $*" >> "${LOGFILE}"
		fi
	elif [ $LOG -ge $SCREEN ] ; then
		if [ $LOG -ge $((SCREEN + NORMAL)) ] ; then
			echo -e "${WHITE}   info:${NC} $*"
		fi
	fi
}
# verbose info log
function logV()
{
	[ $LOG -ge $((SCREEN + VERBOSE)) ] || return
	if [ $LOG -ge $FULL ] ; then
		if [ $LOG -ge $((FULL + VERBOSE)) ] ; then
			echo -e "${WHITE}   info:${NC} $*" | tee -a "${LOGFILE}"
		fi
	elif [ $LOG -ge $FILE ] ; then
		if [ $LOG -ge $((FILE + VERBOSE)) ] ; then
			echo -e "${WHITE}   info:${NC} $*" >> "${LOGFILE}"
		fi
	elif [ $LOG -ge $SCREEN ] ; then
		if [ $LOG -ge $((SCREEN + VERBOSE)) ] ; then
			echo -e "${WHITE}   info:${NC} $*"
		fi
	fi
}
# success logs
function logS()
{
	[ $LOG -ge $((SCREEN + VERBOSE)) ] || return
	if [ $LOG -ge $FULL ] ; then
		if [ $LOG -ge $((FULL + VERBOSE)) ] ; then
			echo -e "${HWHITE}success:${NC} $*" | tee -a "${LOGFILE}"
		fi
	elif [ $LOG -ge $FILE ] ; then
		if [ $LOG -ge $((FILE + VERBOSE)) ] ; then
			echo -e "${HWHITE}success:${NC} $*" >> "${LOGFILE}"
		fi
	elif [ $LOG -ge $SCREEN ] ; then
		if [ $LOG -ge $((SCREEN + VERBOSE)) ] ; then
			echo -e "${HWHITE}success:${NC} $*"
		fi
	fi
}
# runtime logs
function logR()
{
	[ $LOG -ge $ENABLED ] || return
	if [ $LOG -ge $FULL ] ; then
		if [ $LOG -ge $((FULL + NORMAL)) ] ; then
			echo -e "${WHITE}runtime:${NC} $*" | tee -a "${LOGFILE}"
		fi
	elif [ $LOG -ge $FILE ] ; then
		if [ $LOG -ge $((FILE + NORMAL)) ] ; then
			echo -e "${WHITE}runtime:${NC} $*" >> "${LOGFILE}"
		fi
	elif [ $LOG -ge $SCREEN ] ; then
		if [ $LOG -ge $((SCREEN + NORMAL)) ] ; then
			echo -e "${WHITE}runtime:${NC} $*"
		fi
	fi
}
# debug logs
function logD()
{
	if ! $DEBUG ; then return ; fi
	if [ $LOG -ge $FULL ] ; then
		echo -e "${HGREEN}  debug:${NC} $*" | tee -a "${LOGFILE}"
	elif [ $LOG -ge $FILE ] ; then
		echo -e "${HGREEN}  debug:${NC} $*" >> "${LOGFILE}"
	elif [ $LOG -ge $SCREEN ] ; then
		echo -e "${HGREEN}  debug:${NC} $*"
	fi
}
# trace logs
function logT()
{
	if ! $TRACE ; then  return ; fi
	if [ $LOG -ge $FULL ] ; then
		echo -e "${HYELLOW}  trace:${NC} $*" | tee -a "${LOGFILE}"
	elif [ $LOG -ge $FILE ] ; then
		echo -e "${HYELLOW}  trace:${NC} $*" >> "${LOGFILE}"
	elif [ $LOG -ge $SCREEN ] ; then
		echo -e "${HYELLOW}  trace:${NC} $*"
	fi
}
# connection logs
function logC()
{
	[ $LOG -ge $ENABLED ] || return
	if isConnected ; then
		logI "Internet ${HGREEN}is connected${NC}."
	else
		logI "Internet is ${HRED}not connected${NC}."
	fi
}
# runtime timestamp
function getRuntimeStr()
{
	declare elapsed
	declare -i begin=$1
	declare -i end=$(getRuntime)
	declare -i runtime=$((end - begin))
	printf -v elapsed "%u.%03u" $((runtime / 1000)) $((runtime % 1000))
	echo -n "${elapsed}"
	return 0
}
# print runtime timestamp
function printRuntime()
{
	if [ $LEVEL -ge $ENABLED ] ; then
		declare -i time=$1
		declare elapsed="$(getRuntimeStr $time)"
		logR "${elapsed}s"
	fi
	return 0
}
# check valid parameter from command line
function isParameter()
{
	if [ -z "$1" ]
	then
		false
	else
		case "$1" in
		--*) true ;;
		-*) true ;;
		*) false ;;
		esac
	fi
}
# check valid value from command line'
function isArgValue()
{
	if [ -z "$1" ]
	then
		false
	else
		case "$1" in
		--*) false ;;
		-*) false ;;
		*) true ;;
		esac
	fi
}
# at the end of program, uset all global variables.
function unsetLibVars()
{
	unset -v DEBUG
	unset -v TRACE
	unset -v ENABLED
	unset -v LEVEL
	unset -v LOG
	unset -v TIMEOUT
	return 0
}
# deinitialize shell library.
function libStop()
{
	unsetLibVars
	return 0
}

function printLibVersion() { echo -e "libShell Version: ${WHITE}$(getLibVersionStr)${NC}" ; }

# print a help message.
function printLibHelp()
{
	cat << EOT
Library Shell Script
$(printLibVersion)
Source functions for support tshell script programs.
Syntax: source $(getScriptName) [parameters]
Parameters:
-h|--help                 Show this help information.
-V|--version              Print version number.
-q|--quiet                Disable all messages.
-g|--debug                Enable debug messages.
-t|--trace 				Enable trace messages.
-l|--log <0|1|2|3>        Set log target:
						0=Disabled
						1=Screen only (default, at startup).
						2=File only.
						3=Both (default, for empty value).
-v|--verbose              Set verbose messages.
-T|--timeout <N>          Set default timeout value >= 0
EOT
	return 0
}

# generate formatted randomic hexadecimal numbers.
function _genUUID()
{
	local uuid
	if [ -n "$1" ] && isInteger $1
	then
		declare -i len=$1
		uuid="$(genRandomLowHexNumber $len)"
		shift
		len=$1
		while [ -n "$len" ]
		do
			if isInteger $len
			then
				uuid="$uuid-$(genRandomLowHexNumber $len)"
				if [ -n "$2" ] && isInteger $2
				then
					shift
					len=$1
				else
					break
				fi
			else
				break
			fi
		done
	else
		return
	fi
	echo -n "$uuid"
}
# generate formatted randomic UUID.
function genUUID()
{
	local -a schema=(8 4 4 4 12)
	local uuid=""
	if [ -n "$1" ]
	then
		uuid="$(_genUUID $@)"
	else
		uuid="$(_genUUID ${schema[@]})"
	fi
	echo -n "$uuid"
}
# get available directory to mount devices.
function getMountDir()
{
	if   [ -d /media     ] ; then echo -n "/media"
	elif [ -d /run/media ] ; then echo -n "/run/media"
	else                          echo -n "/mnt"
	fi
}
# start log to file
function logBegin()
{
	[[ $LOG -ge $FULL || $LOG -eq $FILE ]] || return 0
	touch "${LOGFILE}"
	if [ -f "${LOGFILE}" ]
	then
		echo "################################################################################"  > "${LOGFILE}"
		echo "         Start Log to File on $(date +%Y-%m-%d) at $(date +%T.%N)"                >> "${LOGFILE}"
	else
		logE "Could not access ${LOGFILE}"
		return 1
	fi
	return 0
}
# end log to file.
function logEnd()
{
	[[ $LOG -ge $FULL || $LOG -eq $FILE ]] || return 0
	if [ -f "${LOGFILE}" ]
	then
		echo "         End Log to File on $(date +%Y-%m-%d) at $(date +%T.%N)"                  >> "${LOGFILE}"
		echo "################################################################################" >> "${LOGFILE}"
	else
		logE "Could not access ${LOGFILE}"
		return 1
	fi
	return 0
}
# ask user to continue
function askToContinue()
{
	local ans
	local message=$([ -n "$1" ] && echo -n "$1" || echo -n "Continue" )
	printf "$message [${HWHITE}y${NC}|${HWHITE}n${NC}]? "
	read -n 1 -N 1 -t 1 ans
	if isYes $ans ; then
		echo
		return 0
	elif isNot $ans ; then
		echo
		return 1
	fi
	echo
	return 2
}
# wait a time to continue
function wait()
{
	local ans
	declare -i time=$([ -n "$1" ] && echo -n $1 || echo -n 10)
	local message=$([ -n "$2" ] && echo -n "${2}" || echo -n "Wait")
	while [ $time -ge 0 ]
	do
		printf "\r${message} %02ds? [${HWHITE}n${NC}|${HWHITE}N${NC}]: " $time
		read -n 1 -N 1 -t 1 ans
		time=$((time - 1))
		if isNot $ans
		then
			echo
			return 0
		fi
	done
	echo
	return 2
}
# load distro ID
function loadID()
{
	if [ -f /etc/os-release ]
	then
		. /etc/os-release
		if [ -z "$ID" ] && [ -z "$VARIANT_ID" ]
		then
			logE "Emtpy ID and VARIANT_ID on system."
			return 1
		fi
	else
		logF "File /etc/os-release not found."
		return 1
	fi
	return 0
}
# get distro name.
function getDistroName()
{
	[ -n "$ID" ] || return 1
	case "$ID" in
	fedora) [ -n "$VARIANT_ID" ] && echo -n "$VARIANT_ID" || echo -n "$ID" ;;
	*) echo -n "$ID" ;;
	esac
	return 0
}

function libStart()
{
	while [ -n "$1" ]
	do
		case "$1" in
		-h|--help)    printLibHelp      ; break ;;
		-V|--version) printLibVersion   ; break ;;
		-q|--quiet)   LEVEL=$QUIET   ; LOG=$(( (LOG - (LOG % 10)) + LEVEL)) ;;
		-v|--verbose) LEVEL=$VERBOSE ; LOG=$(( (LOG - (LOG % 10)) + LEVEL)) ;;
		-g|--debug)   DEBUG=true  ; logD 'Enabled' ;;
		-t|--trace)	  TRACE=true  ; logT 'Enabled' ;;
		-l|--log)
			if isArgValue $2 ; then
				shift
				if isInteger $1 ; then
					if [[ $1 -ge 0 && $1 -le 3 ]] ; then
						LOG=$(($1 * 10 + LEVEL))
						logD "Log level set to ($LOG)."
					else
						logF "Value for parameter -l|--log <0|1|2|3> is out of range."
						return 1
					fi
				else
					logF "Value for parameter -l|--log <0|1|2|3> must be an integer."
					return 1
				fi
			else
				LOG=$((FULL + LEVEL))
				logD "Log level set to ($LOG)."
			fi
			;;
		-T|--timeout)
			if isArgValue "$2"
			then
				shift
				if isInteger $1 ; then
					if [ $1 -ge 0 ] ; then
						TIMEOUT=$1
						logD "Timeout set to ($TIMEOUT)."
					else
						logF "Parameter value for -T|--timeout <N> must be greater or equal to 0 (zero)."
						return 1
					fi
				else
					logF "Parameter value for -T|--timeout <N> must be an integer."
					return 1
				fi
			else
				logF "Empty value for parameter -T|--timeout <N>"
				return 1
			fi
			;;
		--) shift ; break ;;
		-*) logE "Unknown parameter $1" ; return 1 ;;
		 *) logE "Unknown value $1"     ; return 1 ;;
		esac
		shift
	done
	return 0
}

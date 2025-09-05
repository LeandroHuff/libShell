################################################################################
# @brief        Shell Script Library.                                          #
# @file         libShell.sh                                                    #
# @author       Leandro - leandrohuff@programmer.net                           #
# @date         2025-09-02                                                     #
# @version      2.1.2                                                          #
# @copyright    CC01 1.0 Universal                                             #
# @details      Formatted script file to service as a shell function library.  #
#               Let a rapid shell script development with a list of common and #
#               most used functions.                                           #
################################################################################
declare -i -r libSTARTIME=$(( $(date +%s%N) / 1000000 ))
## @brief	Library Version Number
declare -a -r libVERSION=(2 1 2)
## @brief	Log Levels
declare -i -r logQUIET=0
declare -i -r logDEFAULT=1
declare -i -r logVERBOSE=2
## @brief	Log Targets
declare -i -r logDISABLED=0
declare -i -r logSCREEN=16
declare -i -r logFILE=32
declare -i -r logENABLED=$((logSCREEN + logDEFAULT))
## @brief	Log File
declare    -r libTMP="/tmp/$(date '+%Y-%m-%d-%H-%M-%S-%3N')"
declare    -r libLOGFILE="$libTMP/$(basename $0).log"
## @brief	Random types
declare -a -r typeRANDOM=(alpha digit alnum lowhex uphex mixhex random space date)
## @brief	Escape Codes for Colors
declare -r NC="\033[0m"
declare -r RED="\033[31m"
declare -r GREEN="\033[32m"
declare -r YELLOW="\033[33m"
declare -r BLUE="\033[34m"
declare -r MAGENTA="\033[35m"
declare -r CYAN="\033[36m"
declare -r WHITE="\033[37m"
declare -r HRED="\033[91m"
declare -r HGREEN="\033[92m"
declare -r HYELLOW="\033[93m"
declare -r HBLUE="\033[94m"
declare -r HMAGENTA="\033[95m"
declare -r HCYAN="\033[96m"
declare -r HWHITE="\033[97m"
# trace messages
declare -r TC="\033[93;42m"
## @brief	Variables
declare    flagDEBUG=false
declare    flagTRACE=false
declare -i logLEVEL=$logDEFAULT
declare -i libLOG=$logENABLED
declare -i libTIMEOUT=10

##
# @fn		getScriptName( $0 )
# @brief	Get and return the script filename.
# @param	$0		Path and script filename
# @return			Script filename
function getScriptName() { echo -n "$(basename $0)" ; }

##
# @fn		getFileName( $1 )
# @brief	Get filename from parameter.
# @param	$1		Path and|or filename.
# @return			Filename.
function getFileName() { echo -n "$(basename $1)" ; }

##
# @fn		getName( $1 )
# @brief	Get and extract the name of a filename.
# @param	$1		Filename.
# @return			Name of a filename.
function getName() { echo -n "${1%.*}" ; }

##
# @fn		getExt( $1 )
# @brief	Get and extract the extension of a filename.
# @param	$1		Filename.
# @return			Extension.
function getExt() { echo -n "${1##*.}" ; }

##
# @fn		getPath( $1 )
# @brief	Get and extract the path of a path+filename.
# @param	$1		Path + Filename.
# @return			Path (folder)
function getPath() { echo -n "${1%/*}" ; }

function genRandomAlpha()        { tr < /dev/urandom -d -c "[:alpha:]"          | head --bytes=$1 ; }
function genRandomNumeric()      { tr < /dev/urandom -d -c "[:digit:]"          | head --bytes=$1 ; }
function genRandomAlphaNumeric() { tr < /dev/urandom -d -c "[:alnum:]"          | head --bytes=$1 ; }
function genRandomLowHexNumber() { tr < /dev/urandom -d -c "[:digit:]a-f"       | head --bytes=$1 ; }
function genRandomUpHexNumber()  { tr < /dev/urandom -d -c "[:digit:]A-F"       | head --bytes=$1 ; }
function genRandomMixHexNumber() { tr < /dev/urandom -d -c "[:xdigit:]"         | head --bytes=$1 ; }
function genRandomString()       { tr < /dev/urandom -d -c "[:graph:]"          | head --bytes=$1 ; }
function genRandomStringSpace()  { tr < /dev/urandom -d -c "[:graph:][:space:]" | head --bytes=$1 ; }
function genDateTime()           { echo -n $(date '+%Y-%m-%d-%H-%M-%S-%3N')                       ; }
function getDateTime()           { echo -n $(date '+%Y-%m-%d %H:%M:%S.%3N')                       ; }

##
# @fn		genVersionStr( $@ )
# @brief	Generate a version string according to array parameter.
# @param	(X Y Z)		Version array.
# @return	'X.Y.Z'		Version string.
function genVersionStr() { declare -a -r vector=(${@}) ; echo -n "${vector[0]}.${vector[1]}.${vector[2]}" ; }

##
# @fn		genVersionNum( $@ )
# @brief	Generate a version integer number according to array parameter.
# @param	(X Y Z)		Version array.
# @return	XYZ			Version number.
function genVersionNum() { declare -a -i -r vector=(${@}) ; echo -n $((${vector[0]}*100 + ${vector[1]}*10 + ${vector[2]})) ; }

##
# @fn		getLibVersionStr( $@ )
# @brief	Generate|Get the library version string.
# @param	none
# @return	Library version string.
function getLibVersionStr() { echo -n $(genVersionStr ${libVERSION[@]}) ; }

##
# @fn		getLibVersionNum( $@ )
# @brief	Generate|Get the library version number.
# @param	none
# @return	Library version number.
function getLibVersionNum() { echo -n $(genVersionNum ${libVERSION[@]}) ; }

##
# @fn		getRuntime()
# @brief	Get the runtime string in seconds.
# @param	none
# @return	Runtime string in seconds.
function getRuntime() { echo -n $(( $(date +%s%N) / 1000000 )) ; }

##
# @fn		getLogFilename()
# @brief	Get log path and filename.
# @param	none
# @return	Log path + filename.
function getLogFilename() { echo -n "/tmp/$(basename $0).log" ; }

##
# @fn		getID()
# @brief	Get the system ID according to /etc/os-release.
# @param	none
# @return	"$ID"	System ID.
function getID() { if [ -n "$ID" ] ; then [ -f /etc/os-release ] && . /etc/os-release ; fi ; echo -n "$ID" ; }

##
# @fn		isFloat( $1 )
# @brief	Check if parameter is a floating point number.
# @param	$1		Float point number.
# @return	true	Is float point number.
#			false	Is not a float point number.
function isFloat() { if [ -n "$( echo -n "$1" | grep -aoP "^[+-]?[0-9]+\.[0-9]+$" )" ] ; then true ; else false ; fi ; }

##
# @fn		isInteger( $1 )
# @brief	Check if parameter is a integer number.
# @param	$1		Integer number.
# @return	true	Is an integer number.
#			false	Is not an integer number.
function isInteger() { [ -n "$(echo "$1" | grep -oP "^[+-]?([0-9]+)$")" ] && true || false ; }

##
# @fn		isYes( $1 )
# @brief	Check if parameter is an affirmative yY|yYeEsS parameter.
# @param	$1		Word to check.
# @return	true	Is an affirmative word|letter.
#			false	Is not an affirmative word|letter.
function isYes() { case "$1" in [yY] | [yY][eE][sS]) true ;; *) false ;; esac ; }

##
# @fn		isNot( $1 )
# @brief	Check if parameter is a negative nN|nNoO|nNoOtT parameter.
# @param	$1		Word to check.
# @return	true	Is an negative word|letter.
#			false	Is not an negative word|letter.
function isNot() { case "$1" in [nN] | [nN][oO] | [nN][oO][tT]) true ;; *) false ;; esac ; }

##
# @fn		isConnected()
# @brief	Check active internet connection sending a request message to an IP and wait for answer.
# @param	none
# @return	true	Is connected.
#			false	Is not connected.
function isConnected() { ping '8.8.8.8' -q -t 30 -c 1 > /dev/null 2>&1 && true || false ; }

# +===========+===============+==============+
# | Function  | Description   | Flag         |
# +===========+===============+==============+
# | logIt     | Unconditional | none         |
# +-----------+---------------+--------------+
# | logI      | Info          | normal       |
# +-----------+---------------+--------------+
# | logR      | Runtime       | normal       |
# +-----------+---------------+--------------+
# | logC      | Connection    | normal       |
# +-----------+---------------+--------------+
# | logE      | Error         | normal       |
# +-----------+---------------+--------------+
# | logF      | Failure       | normal       |
# +-----------+---------------+--------------+
# | logS      | Success       | verbose      |
# +-----------+---------------+--------------+
# | logV      | Info          | verbose      |
# +-----------+---------------+--------------+
# | logW      | Warning       | verbose      |
# +-----------+---------------+--------------+
# | logD      | Debug         | debug        |
# +-----------+---------------+--------------+
# | logT      | Trace         | trace        |
# +-----------+---------------+--------------+

function isLogDefault()
{
	if [ $((libLOG % logSCREEN)) -ge $logDEFAULT ]
	then
		true
	else
		false
	fi
}

function isLogQuiet()
{
	if [ $((libLOG % logSCREEN)) -eq $logQUIET ]
	then
		true
	else
		false
	fi
}

function isLogVerbose()
{
	if [ $((libLOG % logSCREEN)) -ge $logVERBOSE ]
	then
		true
	else
		false
	fi
}

function isLogToFileEnabled()
{
	if [ $((libLOG & logFILE)) -gt $logDISABLED ]
	then
		true
	else
		false
	fi
}

function isLogToScreenEnabled()
{
	if [ $((libLOG & logSCREEN)) -gt $logDISABLED ]
	then
		true
	else
		false
	fi
}

function isLogEnabled()
{
	if [ $((libLOG & logSCREEN)) -gt $logDISABLED ] && [ $((libLOG % logSCREEN)) -gt $logQUIET ]
	then
		true
	else
		false
	fi
}

## @brief	Log anything to screen and file.
function logU() { echo -e "$*" | tee -a "${libLOGFILE}" ; }

## @brief	Log anything according to log flags.
function logIt()
{
	if ! isLogEnabled ; then return ; fi

	if isLogToFileEnabled && isLogToScreenEnabled ; then
		echo -e "$*" | tee -a "${libLOGFILE}"
	elif isLogToFileEnabled ; then
		echo -e "$*" >> "${libLOGFILE}"
	elif isLogToScreenEnabled ; then
		echo -e "$*"
	fi
}

## @brief	Info Logs.
function logI()
{
	if ! isLogEnabled ; then return ; fi

	if isLogToFileEnabled && isLogToScreenEnabled ; then
		echo -e "${WHITE}   info:${NC} $*" | tee -a "${libLOGFILE}"
	elif isLogToFileEnabled ; then
		echo -e "${WHITE}   info:${NC} $*" >> "${libLOGFILE}"
	elif isLogToScreenEnabled ; then
		echo -e "${WHITE}   info:${NC} $*"
	fi
}

## @brief	Error Logs.
function logE()
{
	if ! isLogEnabled ; then return ; fi

	if isLogToFileEnabled && isLogToScreenEnabled ; then
		echo -e "${RED}  error:${NC} $*" | tee -a "${libLOGFILE}"
	elif isLogToFileEnabled ; then
		echo -e "${RED}  error:${NC} $*" >> "${libLOGFILE}"
	elif isLogToScreenEnabled ; then
		echo -e "${RED}  error:${NC} $*"
	fi
}

## @brief	Failure Logs.
function logF()
{
	if ! isLogEnabled ; then return ; fi

	if isLogToFileEnabled && isLogToScreenEnabled ; then
		echo -e "${HRED}failure:${NC} $*" | tee -a "${libLOGFILE}"
	elif isLogToFileEnabled ; then
		echo -e "${HRED}failure:${NC} $*" >> "${libLOGFILE}"
	elif isLogToScreenEnabled ; then
		echo -e "${HRED}failure:${NC} $*"
	fi
}

## @brief	Runtime Logs.
function logR()
{
	if ! isLogEnabled || ! isLogVerbose ; then return ; fi

	local runtime="$(getRuntimeStr)"

	if isLogToFileEnabled && isLogToScreenEnabled ; then
		echo -e "${WHITE}runtime:${NC} ${runtime}s" | tee -a "${libLOGFILE}"
	elif isLogToFileEnabled ; then
		echo -e "${WHITE}runtime:${NC} ${runtime}s" >> "${libLOGFILE}"
	elif isLogToScreenEnabled ; then
		echo -e "${WHITE}runtime:${NC} ${runtime}s"
	fi
}

## @brief	Success logs.
function logS()
{
	if ! isLogEnabled || ! isLogVerbose ; then return ; fi

	if isLogToFileEnabled && isLogToScreenEnabled ; then
		echo -e "${HWHITE}success:${NC} $*" | tee -a "${libLOGFILE}"
	elif isLogToFileEnabled ; then
		echo -e "${HWHITE}success:${NC} $*" >> "${libLOGFILE}"
	elif isLogToScreenEnabled ; then
		echo -e "${HWHITE}success:${NC} $*"
	fi
}

## @brief	Verbose info logs.
function logV()
{
	if ! isLogEnabled || ! isLogVerbose ; then return ; fi

	if isLogToFileEnabled && isLogToScreenEnabled ; then
		echo -e "${WHITE}   info:${NC} $*" | tee -a "${libLOGFILE}"
	elif isLogToFileEnabled ; then
		echo -e "${WHITE}   info:${NC} $*" >> "${libLOGFILE}"
	elif isLogToScreenEnabled ; then
		echo -e "${WHITE}   info:${NC} $*"
	fi
}

## @brief	Warning Logs.
function logW()
{
	if ! isLogEnabled || ! isLogVerbose ; then return ; fi

	if isLogToFileEnabled && isLogToScreenEnabled ; then
		echo -e "${HCYAN}warning:${NC} $*" | tee -a "${libLOGFILE}"
	elif isLogToFileEnabled ; then
		echo -e "${HCYAN}warning:${NC} $*" >> "${libLOGFILE}"
	elif isLogToScreenEnabled ; then
		echo -e "${HCYAN}warning:${NC} $*"
	fi
}

## @brief	Debug Logs.
function logD()
{
	if ! $flagDEBUG || ! isLogEnabled ; then return ; fi

	if isLogToFileEnabled && isLogToScreenEnabled ; then
		echo -e "${HGREEN}  debug:${NC} $*" | tee -a "${libLOGFILE}"
	elif isLogToFileEnabled ; then
		echo -e "${HGREEN}  debug:${NC} $*" >> "${libLOGFILE}"
	elif isLogToScreenEnabled ; then
		echo -e "${HGREEN}  debug:${NC} $*"
	fi
}

## @brief	Trace Logs.
function logT()
{
	if ! $flagTRACE || ! isLogEnabled ; then return ; fi

	if isLogToFileEnabled && isLogToScreenEnabled ; then
		echo -e "${TC}  trace:${NC} $*" | tee -a "${libLOGFILE}"
	elif isLogToFileEnabled ; then
		echo -e "${TC}  trace:${NC} $*" >> "${libLOGFILE}"
	elif isLogToScreenEnabled ; then
		echo -e "${TC}  trace:${NC} $*"
	fi
}

##
# @fn		getRuntimeStr( $1 )
# @brief	Generate|Get runtime string.
# @param	$1	Start runtime number.
# @print		Formatted runtime string.
# @return	0	Success
function getRuntimeStr()
{
	declare elapsed
	declare -i libENDTIME
	declare -i runtime
	libENDTIME=$(( $(date +%s%N) / 1000000 ))
	runtime=$((libENDTIME - libSTARTIME))
	printf -v elapsed "%u.%03u" $((runtime / 1000)) $((runtime % 1000))
	echo -n "${elapsed}"
	return 0
}

##
# @fn		isParameter( $1 )
# @brief	Check command line parameter is a true parameter.
# @param	$1		Word to check.
# @return	true	Is a true parameter.
#			false	Is not a true parameter.
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

##
# @fn		isArgValue( $1 )
# @brief	Check command line parameter is a true value.
# @param	$1		Word to check.
# @return	true	Is a true value.
#			false	Is not a true value.
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

##
# @fn		unsetLibVars()
# @brief	Unset library variables.
# @param	none
# @return	0	Success.
function unsetLibVars()
{
	unset -v flagDEBUG
	unset -v flagTRACE
	unset -v logLEVEL
	unset -v libLOG
	unset -v libTIMEOUT
	return 0
}

##
# @fn		libStop()
# @brief	Stop|End library execution.
# @param	none
# @return	0	Success.
function libStop()
{
	unsetLibVars
	return 0
}

##
# @fn		printLibVersion()
# @brief	Print library string version.
# @param	none
# @return	none
function printLibVersion() { echo -e "libShell Version: ${WHITE}$(getLibVersionStr)${NC}" ; }

##
# @fn		printLibHelp()
# @brief	Print library help information.
# @param	none
# @return	0	Success.
function printLibHelp()
{
	cat << EOT
Shell Script Library
$(printLibVersion)
Source functions to support shell script programs.
Syntax: source $(getScriptName) [parameters]
Parameters:
 -h|--help           Show this help information.
 -V|--version        Print version number.
 -q|--quiet          Disable all messages.
 -v|--verbose        Set verbose messages.
 -g|--debug          Enable debug messages.
 -t|--trace          Enable trace messages.
 -l|--log <0|1|2|3>  Set log target:
                       0=Disabled
                       1=Screen only (default, at startup).
                       2=File only.
                       3=Both (default, for empty value).
 -T|--timeout <N>    Set default timeout value >= 0
EOT
	return 0
}

##
# @fn		genRandom( $1 $2 )
# @brief	Generate an random string according parameter length.
# @param	$1		Type (alpha digit alnum lowhex uphex mixhex random date)
#			$2		Length
# @print	string	Random characters.
# @return	0		Success
#			1..N	Error code.
function genRandom()
{
	local type=$1
	local len=$2
	local err=0
	local str=""
	if [[ "${typeRANDOM[@]}" =~ "$type" ]] ; then
		case $type in
		alpha)  str="$(genRandomAlpha        $len)" ;;
		digit)  str="$(genRandomNumeric      $len)" ;;
		alnum)  str="$(genRandomAlphaNumeric $len)" ;;
		lowhex) str="$(genRandomLowHexNumber $len)" ;;
		uphex)  str="$(genRandomUpHexNumber  $len)" ;;
		mixhex) str="$(genRandomMixHexNumber $len)" ;;
		random) str="$(genRandomString       $len)" ;;
		space)  str="$(genRandomStringSpace  $len)" ;;
		date)   str="$(genDateTime)"                ;;
		*) err=1 ;;
		esac
	else
		err=1
	fi
	echo -n "${str}"
	return $err
}

##
# @fn        genUUID( $1 $2 [$3 ... $@] )
# @brief     Generate an random string according parameters.
# @param     $1           Type (alpha digit alnum lowhex uphex mixhex random date)
#            $2           Length for first string group.
#            [$3 ... $N]  Schema for next string group.
# @return    string       Random String
# @details   Generate a random string according to the parameters,
#            the fist parameter set the random type, for date, the second parameter
#            length can be any integer value, it will be ignored, for others type,
#            the function will generate groups of string separated by '-' character.
#            The result could be something like: 12345678-1234-1234-1234-12345678902
#            The type instruct how the string group will be generated.
#            alpha : Alphabetic [A-Za-z]
#            digit : Numeric [0-9]
#            alnum : Alphanumeric [A-Za-z0-9]
#            lowhex: Lower Case Hexadecimal [0-9a-f]
#            uphex : Upper Case Haxadecimal [0-9A-F]
#            mixhex: Lower + Upper Case Hexadecimal [0-9a-fA-F]
#            random: alphanumeric + punctuation characters.
#            space : alphanumeric + punctuation + space characters.
#            date  : Formatted date as YYYY-mm-dd-HH-MM-SS-sss
#            Where:
#            YYYY: Year        0000..9999
#              mm: Month         01..12
#              dd: Day           01..31
#              HH: Hour          00..23
#              MM: Minutes       00..59
#              SS: Seconds       00..59
#             sss: Milliseconds 000..999
#
function genUUID()
{
	local type=$1
	local string=""
	if [ -n "$2" ] && isInteger $2
	then
		shift
		declare -i len=$1
		string="$(genRandom $type $len)"
		shift
		while [ -n "$1" ]
		do
			if isInteger $1
			then
				len=$1
				string="${string}-$(genRandom $type $len)"
			else
				string="FAILURE"
			fi
			shift
		done
	else
		string="FAILURE"
	fi
	echo -n "${string}"
	return 0
}

##
# @fn		getMountDir()
# @brief	Get mount directory string.
# @param	none
# @return	/media or
#			/run/media or
#			/mnt
function getMountDir()
{
	if   [ -d /media     ] ; then echo -n "/media"
	elif [ -d /run/media ] ; then echo -n "/run/media"
	else                          echo -n "/mnt"
	fi
}

##
# @fn		logBegin()
# @brief	Begin|Start log to file.
# @param	none
# @return	0	Success
#			1	Failure
function logBegin()
{
	[ $libLOG -ge $logFILE ] || return 0
	touch "${libLOGFILE}"
	if [ -f "${libLOGFILE}" ]
	then
		echo "################################################################################" > "${libLOGFILE}"
		echo "         Start Log to File on $(date +%Y-%m-%d) at $(date +%T.%N)"               >> "${libLOGFILE}"
	else
		logE "Could not access ${libLOGFILE}"
		return 1
	fi
	return 0
}

##
# @fn		logEnd()
# @brief	End|Stop log to file.
# @param	none
# @return	0	Success
#			1	Failure
function logEnd()
{
	[ $libLOG -ge $logFILE ] || return 0
	if [ -f "${libLOGFILE}" ]
	then
		echo "         End Log to File on $(date +%Y-%m-%d) at $(date +%T.%N)"                  >> "${libLOGFILE}"
		echo "################################################################################" >> "${libLOGFILE}"
	else
		logE "Could not access ${libLOGFILE}"
		return 1
	fi
	return 0
}

##
# @fn		askToContinue( $1 )
# @brief	Print a message and ask user to continue and get the answer.
# @param	$1		Timeout
#           $2      Message
# @return	0		Yes
#			1		Not
#			2		Error
function askToContinue()
{
	local ret=0
	local timeout
	local ans
	local message

	if isInteger $1 || isFloat $1
	then
		timeout=$1
	else
		timeout=$libTIMEOUT
	fi

	if [ -n "$2" ]
	then
		message="${2}"
	else
		message="Continue? Wainting for "
	fi

	echo -e -n "$message ${timeout}s [${HWHITE}y${NC}|${HWHITE}N${NC}]: "

	if [ $(bin/cmpfloat "$timeout" 0.0) -gt 0 ]
	then
		read -n 1 -N 1 -t $timeout ans
	else
		read -n 1 -N 1 ans
	fi

	if isYes $ans ; then
		ret=0
	elif isNot $ans ; then
		ret=1
	else
		ret=2
	fi

	echo
	return $ret
}

##
# @fn		wait( $1 , $2 )
# @brief	Print a message and wait user to continue.
# @param	$1		Timeout value.
#			$2		Alternative message.
# @return	0		Not
#			2		Timeout
function wait()
{
	local ans=''
	declare timeout=$([ -n "$1" ] && echo -n $1 || echo -n $libTIMEOUT)
	local message=$([ -n "$2" ] && echo -n "${2}" || echo -n "Do Wait for ")
	echo -e -n "${message} ${timeout}s [${HWHITE}n${NC}|${HWHITE}N${NC}]?: "

	if [ $(bin/cmpfloat "$time" 0.0) -gt 0 ]
	then
		read -n 1 -N 1 -t $timeout ans
	else
		read -n 1 -N 1 ans
	fi

	if isNot $ans
	then
		echo
		return 0
	fi
	echo
	return 2
}


##
# @fn		loadID()
# @brief	Source /etc/os-release file.
# @param	none
# @return	0	Success
#			1	Error
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

##
# @fn		getDistroName()
# @brief	Get Linux distro name.
# @param	none
# @return	Distro name or Variant name.
function getDistroName()
{
	[ -n "$ID" ] || return 1
	case "$ID" in
	fedora) [ -n "$VARIANT_ID" ] && echo -n "$VARIANT_ID" || echo -n "$ID" ;;
	*) echo -n "$ID" ;;
	esac
	return 0
}

##
# @fn		libInit( $@ )
# @brief	Initialize library by parsing arguments.
# @param	$@		Arguments to parsing.
# @return	0		Success
#			1..N	Error code.
function libInit()
{
	if ! [ -d $libTMP ]
	then
		mkdir $libTMP
		if [ $? -ne 0 ]
		then
			logF "Make dir $libTMP"
			return 1
		else
			logS "Make dir $libTMP"
		fi
	else
		logW "Dir $libTMP alredy exit."
	fi

	while [ -n "$1" ]
	do
		case "$1" in
		-h|--help)    printLibHelp         ; break ;;
		-V|--version) printLibVersion      ; break ;;
		-q|--quiet)   logLEVEL=$logQUIET   ; libLOG=$((libLOG & logQUIET)) ;;
		-v|--verbose) logLEVEL=$logVERBOSE ; libLOG=$(((libLOG & logQUIET) + logLEVEL)) ;;
		-g|--debug)   flagDEBUG=true       ; logD 'Enabled' ;;
		-t|--trace)	  flagTRACE=true       ; logT 'Enabled' ;;
		-l|--log)
			if isArgValue $2 ; then
				shift
				if isInteger $1 ; then
					if [ $1 -ge 0 ] && [ $1 -le 3 ] ; then
						libLOG=$(($1 * logSCREEN + logLEVEL))
						logD "Log level set to ($libLOG)."
					else
						logF "Value for parameter -l|--log <0|1|2|3> is out of range."
						return 1
					fi
				else
					logF "Value for parameter -l|--log <0|1|2|3> must be an integer."
					return 1
				fi
			else
				libLOG=$((logSCREEN + logFILE + logLEVEL))
				logD "Log level set to ($libLOG)."
			fi
			;;
		-T|--timeout)
			if isArgValue "$2"
			then
				shift
				if isInteger $1 ; then
					if [ $1 -ge 0 ] ; then
						libTIMEOUT=$1
						logD "Timeout set to ($libTIMEOUT)."
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

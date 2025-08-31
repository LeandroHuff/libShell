#!/usr/bin/env bash

################################################################################
# @brief        Build all *.c files to their respective binary target.         #
# @file         build.sh                                                       #
# @author       Leandro - leandrohuff@programmer.net                           #
# @date         2025-07-30                                                     #
# @version      2.0.0                                                          #
# @date         2025-08-26                                                     #
# @version      2.1.0                                                          #
# @copyright    CC01 1.0 Universal                                             #
# @details      Call gcc to compile all *.c source code from src/ folder to    #
#               their respecitve binary and store all at the folder bin/       #
#               Default values can be modified by parameters.                  #
################################################################################


################################################################################
# @brief	Load libShell file and its content, for any error, log it and exit.
source libShell.sh "$@" || { logF "Load libShell"   ; exit 1 ; }

################################################################################
# @brief	Start libShell and pass all command line parameters, any error,
#			log it and exit.
# @details	Obs.: Parameters from command line to libShell.sh and build.sh will
#			be parsed in this source file.
#libStart "$@" || { logF "Call libStart()" ; exit 1 ; }

################################################################################
# @brief	Start|Enable log to file according parameters from command line.
logBegin

################################################################################
# @brief	Declare global variables for use along shell script.
# @var		VERSION		Build shell script version.
#			DIR			Current shell script folder.
#			tableTARGET	Binaries names list.
declare -a -i VERSION=(2 1 0)
declare DIR="$PWD"
declare -a tableTARGET=(strcmp strlen addfloat subfloat divfloat multifloat cmpfloat rangefloat)

################################################################################
# @brief	Unset all global variables.
# @param	none
# @return	none
function unsetVars()
{
	unset -v VERSION
	unset -v DIR
	unset -v tableTARGET
}

################################################################################
# @brief	Exit to system.
# @param	[$1]	Exit code, optional, default is 0.
# @return	0		Success
#			1..N	Error code.
function _exit()
{
	local -i code=$([ -n "$1" ] && echo $1 || echo 0)
	unsetVars
	exit $code
}

################################################################################
# @brief	Print script vertion.
# @param	none
# @return	none
function printVersion() { echo -e "Build Version: ${WHITE}$(genVersionStr ${VERSION[@]})${NC}" ; }

################################################################################
# @fn		_help()
# @brief	Print help information to screen.
# @param	none
# @return	0	Success
function _help
{
	local scriptName=$(getScriptName)
	local F=${WHITE}
	local P=${HCYAN}
	local V=${HBLUE}
	local N=${NC}

	echo -e "Compile target source file in binary files by gcc tool."
	echo -e "Build Version: ${F}$(genVersionStr ${VERSION[@]})${N}"
	echo -e "libShell Version: ${F}$(getLibVersionStr)${N}"
	echo -e "Usage:"
	echo -e "  ${F}$scriptName${N} [${P}libShell option${N} [${V}value${N}] ] -- [${P}build option${N} [${V}value${N}] ]"
	echo -e "Options:"
	echo -e " ${P}--${N}    Separate parameters tageted to libShell (before '--') from build (after '--')."
	echo -e "     ${P}--help${N} <${V}parameter${N}>       Show help and syntax information about parameters."
	echo -e "  ${P}-h${N}|${P}--usage${N}                  Show help information about usage."
	echo -e "Build Options:"
	echo -e "     ${P}--clean${N}   [${V}dir${N}]          Clean all binary files from dir/, default is bin/"
	echo -e "     ${P}--build${N}   [${V}dir${N}]          Build all target files *.c into dir/, default is bin/"
	echo -e "     ${P}--install${N} [${V}src${N}] [${V}dest${N}]   Install all binary files from src/ to dest/ folders,"
	echo -e "                                default is from bin/* to \$HOME/bin/"
	echo -e "Note: Use all parameters at same time in order, make all steps autotmatically."
	echo -e "      ${F}$scriptName${N} ${P}--clean${N} [${V}dir${N}] ${P}--build${N} [${V}dir${N}] ${P}--install${N} [${V}src${N}] [${V}dest${N}]"
	return 0
}

################################################################################
# @fn		syntax($1)
# @brief	Print syntax message to screen.
# @param	$1	Command line parameter to get help about it.
# @return	0	Success
#			1	Unknown parameter.
function syntax
{
	local scriptName=$(getScriptName)
	local P=${HCYAN}
	local V=${HBLUE}
	local N=${NC}

	case "$1" in
	-h)
		echo -e "Show syntax information about the script use."
		echo -e "Details of command line parameters."
		;;
	help|--help)
		echo -e "Show Syntax information about any command line parameters."
		echo -e "Syntaxe $scriptName ${P}--help${N} <${V}parameter${N}>"
		;;
	-c|clean|--clean)
		echo -e "Remove all binary files from dir/, default is bin/"
		echo -e "Syntax $scriptName ${P}--clean${N} [${V}dir${N}]"
		;;
	-b|build|--build)
		echo -e "Build all source *.c files into dir/ folder, default target folder is bin/"
		echo -e "Syntax $scriptName ${P}--build${N} [${V}dir${N}]"
		;;
	-i|install|--install)
		echo -e "Install/Copy all target binary files from target/ to destine/ , default is from bin/ to ~/bin/"
		echo -e "Syntax $scriptName ${P}--install${N} [${V}target${N}] [${V}destine${N}]"
		;;
	*)
		if [ -z "$1" ] ; then
			echo -e "Empty value for parameter ${P}--help${N} <${V}value${N}>."
		else
			echo -e "Unknown parameter (${P}$1${N})."
		fi
		return 1
		;;
	esac
	return 0
}

################################################################################
# @fn		parseParameters()
# @brief	Parse parameters from command line to libShell.sh and build.sh script.
# @param	$@		All command line parameters.
# @return	0		Success
#			1..N	Error code.
function parseParameters()
{
	err=0

	# no parameters from commmand line?
	if ! [ -n "$1" ] ; then
		_help
		return 1
	fi

	# parse all parameters
	while [ -n "$1" ]
	do
		case "$1" in
		######################
		## parameters to libShell.sh
		   --libHelp)    printLibHelp      ; break ;;
		   --libVersion) printLibVersion   ; break ;;
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
		###################
		## Parameters to build.sh
		-h|--help)
			if isArgValue "$2"
			then
				syntax "$2"
			else
				_help
			fi
			break
			;;
		-V|--version) printVersion ; break ;;
		-c|--clean) logT "-c|--clean)"
			if [ $err -eq 0 ] ; then
				logD "Cleaning target files..."
				dir="bin"
				if isArgValue "$2" ; then
					shift
					dir="$1"
				fi
				if ! [ -d "$dir" ]
				then
						logF "Target folder ($dir) not found."
						err=$((err+1))
						unset -v dir
						break
				fi
				logD "Target folder is (${dir}/)"
				for target in ${tableTARGET[@]}
				do
					logD "Try to remove target file (${target})."
					[ -f "${dir}/$target" ] && rm -f "${dir}/$target" || logW "Target file (${target}) not found."
				done
				unset -v target
				unset -v dir
			else
				break
			fi
			;;
		-b|--build) logT "-b|--build)"
			if [ $err -eq 0 ] ; then
				logD "Buildinig source files..."
				binDir="bin"
				srcDir=src
				if isArgValue "$2" ; then
					shift
					binDir="$1"
				fi
				if ! [ -d "$binDir" ]
				then
					logT "mkdir $binDir"
					mkdir "$binDir"
					if [ $? -ne 0 ]
					then
						logF "Access to create ($binDir) target folder."
						err=$((err+1))
						unset -v dir
						break
					fi
				fi
				logD "Source folder is (${srcDir}/)"
				logD "Target folder is (${binDir}/)"
				for target in ${tableTARGET[@]}
				do
					if [ -f "${srcDir}/${target}.c" ] ; then
						printf -v message "Building source %16s into -> %s" "${srcDir}/${target}.c" "${binDir}/${target}"
						logD "${message}"
						gcc "${srcDir}/${target}.c" -o "${binDir}/${target}" || logE "Compile ${srcDir}/${target}.c"
					else
						logW "Source file (${srcDir}/${target}.c) not found."
					fi
				done
				unset -v binDir
				unset -v srcDir
				unset -v target
			else
				break
			fi
			;;
		-i|--install) logT "-i|--install)"
			if [ $err -eq 0 ] ; then
				logD "Installing target binary files..."
				source="bin"
				destine="$HOME/bin"
				if isArgValue "$2" ; then
					shift
					source="$1"
				fi
				if isArgValue "$2" ; then
					shift
					destine="$1"
				fi
				if ! [ -d "$src" ]
				then
						logF "Source folder ($source) not found."
						err=$((err+1))
						unset -v source
						unset -v dest
						break
				fi
				if ! [ -d "$destine" ]
				then
						logF "Destine folder ($destine) not found."
						err=$((err+1))
						unset -v source
						unset -v destine
						break
				fi
				logD "Install from source folder ${source}/ to target folder ${destine}/"
				for target in ${tableTARGET[@]}
				do
					logD "Try to install binary file ${source}/${target} into target folder ${destine}/"
					if [ -f "${source}/${target}" ] ; then
						cp -f "${source}/${target}" "${destine}/"
						if [ $? -ne 0 ] ; then
							err=$((err+1))
							logF "Copy target file ${source}/${target} to ${destine}/"
						else
							logS "Copy target file ${source}/${target} to ${destine}/"
						fi
					else
						logW "Target file ${source}/${target} not found."
					fi
				done
				unset -v source
				unset -v destine
				unset -v target
			else
				break
			fi
			;;
		#####################
		## Unknown parameters
		--) shift ; continue ;;
		-*) logE "Unknown $1" ; break ;;
		 ?) logE "Unknown $1" ; break ;;
		 *) logE "Unknown $1" ; break ;;
		esac
		#################
		# Next parameters
		shift
	done

	return $err
}

################################################################################
# @brief	Starting script program,
#			call parseParameters() function,
#			call _exit() function.
# @param	$@		Command line parameters.
# @return	0		Success
#			1..N	Error code.
################################################################################
parseParameters "$@"
RES=$?

logEnd  || logD "Call libEnd()"
libStop || logF "Call libStop()"

_exit $RES
################################################################################

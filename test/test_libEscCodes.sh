#!/usr/bin/env bash

################################################################################
# @file     test_libEscCodes.sh
# @brief    Test and check libEscCodes file.
# @parameter
#           -h|--help           Show help message.
#           -g|--debug          Set debug mode on.
#           -p|--path <dir>     Set libShell path.
#           -t|--type <0|1|2>   Set test type, 0 default.
#           -l|--load           Enable source libShell.
#              --               Let next parameters to setup libs.
# @return
#           0 : Success
#           1+: failure
################################################################################

# Local variables.
declare -a  typeTABLE=('notable' 'internal' 'external' 'load')
declare -i  testTYPE=1
declare -i  minTYPE=0
declare -i  maxTYPE=3
declare     flagLoadLib=false
declare -a  libLIST=(EscCodes)
declare -a  libLOADED=()
declare     libPATH="/home/${USER}/dev/libShell"
declare     testPATH="/home/${USER}/dev/libShell/test"

declare     flagDEBUG=false

declare -i LINE=0
declare -i _OK=0
declare -i _ERR=0
declare    _RES=''
declare    _RET=0
declare    _SUCCESS=true

# test table columns
declare -i columnID=0
declare -i columnRET=1
declare -i columnRES=2
declare -i columnFILE=3
declare -i columnP1=4
declare -i columnP2=5
declare -i columnP3=6
declare -i columnP4=7
declare -i maxCOLUMNS=8

# colors
declare _GRAY='\033[37m'
declare _RED='\033[31m'
declare _CYAN='\033[36m'
declare _GREEN='\033[32m'
declare _HRED='\033[91m'
declare _HCYAN='\033[96m'
declare _HGREEN='\033[92m'
declare _WHITE='\033[97m'
# no colors
declare _NC='\033[0m'

function logOk()   { echo -e "${_GRAY}Success${_NC}: $*" ; }
function logFail() { echo -e "${_RED}Failure${_NC}: $*"  ; }
function logWarn() { echo -e "${_CYAN}Warning${_NC}: $*" ; }
function logDebug(){ if $flagDEBUG ; then echo -e "${_GREEN}Debug${_NC}: $*" ; fi ; }

# unset local variables and functions
function _unsetVars
{
    # Unset Variables
    unset -v typeTABLE
    unset -v testTYPE
    unset -v minTYPE
    unset -v maxTYPE
    unset -v libLIST
    unset -v libLOADED
    unset -v libPATH
    unset -v testPATH
    unset -v flagDEBUG
    unset -v LINE
    unset -v _OK
    unset -v _ERR
    unset -v _RES
    unset -v _RET
    unset -v _SUCCESS
    unset -v columnID
    unset -v columnRET
    unset -v columnRES
    unset -v columnFILE
    unset -v columnP1
    unset -v columnP2
    unset -v columnP3
    unset -v columnP4
    unset -v maxCOLUMNS
    unset -v _GRAY
    unset -v _RED
    unset -v _CYAN
    unset -v _GREEN
    unset -v _HRED
    unset -v _HCYAN
    unset -v _HGREEN
    unset -v _WHITE
    unset -v _NC

    # Unset Function
    unset -f logOk
    unset -f logFail
    unset -f logWarn
    unset -f logDebug
    unset -f barGraph
    unset -f _isArg
    unset -f _isInt
    unset -f _isNum
    unset -f _unsetVars
    unset -f barGraph
    unset -f isArg
    # Return Code
    return 0
}

# unload libs, exit from bash script and return an error code
function _exit()
{
    local code=$([ -n "$1" ] && echo -n $1 || echo -n 0)

    # Stop logs
    [ -n "${logStop}" ] && logStop

    # Unload Libs
    if $flagLoadLib
    then
        for file in ${libLOADED[@]}
        do
            $(lib${file}Exit) || logFail "Unload lib${file}.sh"
        done
    fi

    # Unload local variables
    unset -v file

    # Unload Global Variables and Functions
    _unsetVars
    unset -f _exit

    exit $code
}

# draw a bar graph
function barGraph()
{
    local num=$1
    local ok=$2
    # print '*' green for ok and red for not ok.
    if $ok ; then printf "${_HGREEN}*${_NC}" ; else printf "${_HRED}*${_NC}" ; fi
    # print [N] each 10 and '|' each 5
    if   [ $((num % 10)) -eq 0 ] ; then printf "[%3d]" $num
    elif [ $((num %  5)) -eq 0 ] ; then printf '|' ; fi
    # echo a new line each 50
    if  [ $((num % 50)) -eq 0 ] ; then echo ; fi
}

# check command line arguments
function _isArg() { if [ -n "$1" ] ; then case $1 in -*) false ;; *) true ;; esac ; else false ; fi ; }
function _isInt() { if echo -n "${1}" | grep -aoP '^[+-]?\d+$' > /dev/null 2>&1 ; then true ; else false ; fi ; }
function _isNum() { if echo -n "${1}" | grep -aoP '^[-+]?(\d+\.?\d*|\d*\.\d+)$' > /dev/null 2>&1 ; then true ; else false ; fi ; }

# +--------------+---------------------------------------------------------------
# | Column       | Description
# +--------------+---------------------------------------------------------------
# | columnID     | Line number, '#' is a commented line.
# | columnRET    | Return success or error code (return n)
# | columnRES    | Result from function (echo '' or printf '')
# | columnFILE   | Function in lib or a local wapper test_Function
# | columnP1     | 1st parameter to function
# | columnP2     | 2nd parameter to function
# | columnP3     | 3th parameter to function
# | columnP4     | 4th parameter to function
# | maxCOLUMNS   | Max table columns
# +--------------+---------------------------------------------------------------

# test table
declare -a testTABLE=(\
'#ID'   return  result  function    parameter1  parameter2  parameter3  parameter4 \
)

# show help message
function usage()
{
    cat << EOT
Bash script to run a list of function for test.
Usage: $(basename "$0") [options] [-- libOptions]
Options:
  -h|--help               Show help message.
  -g|--debug)             Set debug mode for test file.
  -p|--path <directory/>  Set libShell path.
  -t|--type <0|1|2>       Set test type, default is 0.
                              0: Internal, call function from test table.
                              1: External, call test_libName.sh
                              2: Source libName.sh
     --                   Let pass next options to libSell script files.
libOptions:
  -h|--help               Show help message for libShell files.
  -t|--timeout <value>    Set timeout for libShell files.
EOT
    if [ -n "$logHelp" ] ; then logHelp ; fi
}

# Parse command line parameters until '--'
while [ $# -gt 0 ] && [ -n "$1" ]
do
    case $1 in
    -h|--help) usage ; _exit 0 ;;
    -p|--path)
        if _isArg "$2"
        then
            shift
            libPATH="$1"
        else
            logFail "Option -p|--path </directory>"
            _exit 1
        fi
        ;;
    -t|--type)
        if _isArg "$2" && _isInt "$2"
        then
            shift
            if [ $1 -ge $minTYPE ] && [ $1 -le $maxTYPE ]
            then
                testTYPE=$1
            else
                logFail "Argument for -t|--type <$minTYPE..$maxTYPE> is out of range."
                _exit 2
            fi
        else
            logFail "Empty or wrong argument for -t|--type <$minTYPE..$maxTYPE>"
            _exit 3
        fi
        ;;
    -g) flagDEBUG=true ;;
    -l|--load) flagLoadLib=true ;;
    --) shift ; break ;;
    -*) logFail "Option '$1' not available."        ; _exit 4 ;;
     *) logFail "Argument '$1' not available."      ; _exit 5 ;;
    esac
    shift
done

if [ $testTYPE -gt 0 ]
then
    flagLoadLib=true
fi

# Load Libs
if $flagLoadLib
then
    for file in ${libLIST[@]}
    do
        if [ -f "${libPATH}/lib${file}.sh" ]
        then
            source "${libPATH}/lib${file}.sh"
            if [ $? -eq 0 ]
            then
                libLOADED+=(${file})
            else
                logFail "Load lib${file}.sh"
                _exit 6
            fi
        else
            logFail "File ${libPATH}/lib${file}.sh not found."
            _exit 7
        fi
    done
fi

# Parse command line parameters after '--'
while [ $# -gt 0 ] && [ -n "$1" ]
do
    case $1 in
    -h|--help) [ -n "${logHelp}" ] && logHelp ; _exit 0 ;;
    -t|--timeout)
        if _isArg "$2"
        then
            if _isNum "$2"
            then
                libTimeSetup $1 $2
            else
                logFail "Invalid argument for -t|--timeout <time> option."
                _exit 8
            fi
            shift
        else
            logFail "Empty or wrong argument for -t|--timeout <time> option."
            exit 9
        fi
        ;;
    --) shift
        logInit "$@" || _exit 10
        break
        ;;
    -*) logFail "Option $1 not available."
        _exit 11
        ;;
     *) logFail "Argument $1 not available."
        _exit 12
        ;;
    esac
    shift
done

################################################################################
# Run TEST TABLE if enabled
################################################################################

# Start line counter and offset at 0
LINE=0
idxID=$columnID
# Calculate the first function column OFFSET.
idxFUNC=$((idxID+columnFILE))

# while not empty function name
if [ $testTYPE -gt 0 ]
then
    while [ -n "${testTABLE[$idxFUNC]}" ]
    do
        # skip commented lines.
        if [[ "${testTABLE[$idxID]:0:1}" != "#" ]]
        then
            # calculate return column offset
            idxRET=$((idxID+columnRET))
            # calculate result column offset
            idxRES=$((idxID+columnRES))
            # calculate parameter 1 column offset
            idxP1=$((idxID+columnP1))
            # calculate parameter 2 column offset
            idxP2=$((idxID+columnP2))
            # calculate parameter 3 column offset
            idxP3=$((idxID+columnP3))
            # calculate parameter 4 column offset
            idxP4=$((idxID+columnP4))

            # check test type and run it
            case ${typeTABLE[$testTYPE]} in
            notable)
                # no tests from table
                ;;
            internal)
                # Uncomment/Commant to enable/disable test functions from internal test table.
                if $flagDEBUG ; then echo -e -n "${escFGWHITE}Function${NC}: ${testTABLE[$idxFUNC]} ${testTABLE[$idxP1]} ${testTABLE[$idxP2]} ${testTABLE[$idxP3]} ${testTABLE[$idxP4]}\t-> " ; fi
                _RES="$(${testTABLE[$idxFUNC]} "${testTABLE[$idxP1]}" "${testTABLE[$idxP2]}" "${testTABLE[$idxP3]}" "${testTABLE[$idxP4]}")"
                ;;
            external)
                # Uncomment/Commant to enable/disable call extarnal tests files
                if $flagDEBUG ; then echo -e -n "${escFGWHITE}File${NC}: test_lib${testTABLE[$idxFUNC]}.sh\t-> " ; fi
                _RES="$(. ${testPATH}/test_lib${testTABLE[$idxFUNC]}.sh "${testTABLE[$idxP1]}" "${testTABLE[$idxP2]}" "${testTABLE[$idxP3]}" "${testTABLE[$idxP4]}")"
                ;;
            load)
                # Uncomment/Commant to enable/disable test source library
                if $flagDEBUG ; then echo -e -n "${escFGWHITE}File${NC}: lib${testTABLE[$idxFUNC]}.sh\t-> " ; fi
                _RES="$(source ${libPATH}/lib${testTABLE[$idxFUNC]}.sh "${testTABLE[$idxP1]}" "${testTABLE[$idxP2]}" "${testTABLE[$idxP3]}" "${testTABLE[$idxP4]}")"
                ;;
            *)
                logFail "Test type (${typeTABLE[$testTYPE]}) not available."
                _exit 13
                ;;
            esac

            # take returned code
            _RET=$?

            # preset result to true
            _SUCCESS=true

            # compare result and returned code from function according table to check success or error
            # increment success counter or error counter
            if [ -n "${testTABLE[ $idxRET ]}" ] && [ -n "${testTABLE[ $idxRES ]}" ]
            then
                if [ $_RET -eq ${testTABLE[ $idxRET ]} ] && [[ "$_RES" == "${testTABLE[ $idxRES ]}" ]]
                then
                    let _OK++
                else
                    let _ERR++
                    _SUCCESS=false
                fi
            elif [ -n "${testTABLE[ $idxRET ]}" ]
            then
                if [ $_RET -eq ${testTABLE[ $idxRET ]} ]
                then
                    let _OK++
                else
                    let _ERR++
                    _SUCCESS=false
                fi
            elif [ -n "${testTABLE[ $idxRES ]}" ]
            then
                if [[ "$_RES" == "${testTABLE[ $idxRES ]}" ]]
                then
                    let _OK++
                else
                    let _ERR++
                    _SUCCESS=false
                fi
            else
                logWarn "Bouth testTABLE[idxRES:$idxRES] and testTABLE[idxRET:$idxRET] columns are empty."
            fi

            # on debug mode, print a debug message on terminal
            if  $flagDEBUG && ! $_SUCCESS
            then
                echo
                logDebug "Line:$LINE"
                logDebug "Run:${testTABLE[$idxFUNC]}(${testTABLE[$idxP1]},${testTABLE[$idxP2]},${testTABLE[$idxP3]},${testTABLE[$idxP4]})"
                logDebug "Ret:'$_RET' compare to Table Ret: '${testTABLE[$idxRET]}' "
                logDebug "Res:'$_RES' compare to Table Res: '${testTABLE[$idxRES]}' "
            fi

            # show bar graph or result message.
            if ! $flagDEBUG ; then barGraph $LINE $_SUCCESS
            elif $_SUCCESS  ; then echo -e "${escFGDGREEN}success${NC}."
            else                   echo -e "${escFGDRED}failure${NC}."
            fi
        fi

        # next line
        let LINE++
        # next idxID offset from line counter
        idxID=$((LINE*maxCOLUMNS))
        # next function offset
        idxFUNC=$((idxID+columnFILE))
    done
else
    logOk "${escFGIGREEN}No tests from table${NC}"
fi

# new line after last bar graph
echo

# print success and error counters on terminal
if [ $_OK  -gt 0 ] ; then logOk   "${_HGREEN}$_OK${_NC} Test(s)" ; fi
if [ $_ERR -gt 0 ] ; then logFail "${_HRED}$_ERR${_NC} Test(s)"  ; fi

########################################
# This are is reserved for specific tests before exit from script.
# Check function parameter, function behaviors or result and returned code.

# Normal Text
echo -e "\033[${NORMAL}m NORMAL ${escDC}"
# Bold/Bright
echo -e "\033[${BRIGHT}m BRIGHT ${escDC}"
echo -e "\033[${NORMAL}m NORMAL ${escDC}"
# Fade/Dim
echo -e "\033[${FADE}m FADE ${escDC}"
echo -e "\033[${notFADE}m not FADE ${escDC}"
# Italic
echo -e "\033[${ITALIC}m ITALIC ${escDC}"
echo -e "\033[${notITALIC}m not ITALIC ${escDC}"
# Underline
echo -e "\033[${UNDERLINE}m UNDERLINE ${escDC}"
echo -e "\033[${notUNDERLINE}m not UNDERLINE ${escDC}"
# Blink
echo -e "\033[${BLINK}m BLINK ${escDC}"
echo -e "\033[${notBLINK}m not BLINK ${escDC}"
# Reversed
echo -e "\033[${REVERSE}m REVERSE ${escDC}"
echo -e "\033[${notREVERSE}m not REVERSE ${escDC}"
# Hidden
echo -e "\033[${HIDDEN}m HIDDEN ${escDC}"
echo -e "\033[${notHIDDEN}m not HIDDEN ${escDC}"
# Strike Throught
echo -e "\033[${STRIKETHR}m STRIKETHR ${escDC}"
echo -e "\033[${notSTRIKETHR}m not STRIKETHR ${escDC}"

# Dark Foreground Colors
echo -e "\033[$((DFG+RED))m Dark Red ${escDC}"
echo -e "\033[$((DFG+GREEN))m Dark Green ${escDC}"
echo -e "\033[$((DFG+BLUE))m Dark Blue ${escDC}"
echo -e "\033[$((DFG+YELLOW))m Dark Yellow ${escDC}"
echo -e "\033[$((DFG+MAGENTA))m Dark Magenta ${escDC}"
echo -e "\033[$((DFG+CYAN))m Dark Cyan ${escDC}"
echo -e "\033[$((DFG+WHITE))m Dark White ${escDC}"

# Dark Background Colors
echo -e "\033[$((DBG+RED))m Dark Red ${escDC}"
echo -e "\033[$((DBG+GREEN))m Dark Green ${escDC}"
echo -e "\033[$((DBG+BLUE))m Dark Blue ${escDC}"
echo -e "\033[$((DBG+YELLOW))m Dark Yellow ${escDC}"
echo -e "\033[$((DBG+MAGENTA))m Dark Magenta ${escDC}"
echo -e "\033[$((DBG+CYAN))m Dark Cyan ${escDC}"
echo -e "\033[$((DBG+WHITE))m Dark White ${escDC}"

# Intense/Bright Foreground Colors
echo -e "\033[$((IFG+BLACK))m Dark Black ${escDC}"
echo -e "\033[$((IFG+RED))m Dark Red ${escDC}"
echo -e "\033[$((IFG+GREEN))m Dark Green ${escDC}"
echo -e "\033[$((IFG+BLUE))m Dark Blue ${escDC}"
echo -e "\033[$((IFG+YELLOW))m Dark Yellow ${escDC}"
echo -e "\033[$((IFG+MAGENTA))m Dark Magenta ${escDC}"
echo -e "\033[$((IFG+CYAN))m Dark Cyan ${escDC}"
echo -e "\033[$((IFG+WHITE))m Dark White ${escDC}"

# Intense/Bright Background Colors
echo -e "\033[$((IBG+BLACK))m Dark Black ${escDC}"
echo -e "\033[$((IBG+RED))m Dark Red ${escDC}"
echo -e "\033[$((IBG+GREEN))m Dark Green ${escDC}"
echo -e "\033[$((IBG+BLUE))m Dark Blue ${escDC}"
echo -e "\033[$((IBG+YELLOW))m Dark Yellow ${escDC}"
echo -e "\033[$((IBG+MAGENTA))m Dark Magenta ${escDC}"
echo -e "\033[$((IBG+CYAN))m Dark Cyan ${escDC}"
echo -e "\033[$((IBG+WHITE))m Dark White ${escDC}"

# Dark Escape Code for Foreground Colors
echo -e "${escBLACK} Escape Dark Black ${escDC}"
echo -e "${escRED} Escape Dark Red ${escDC}"
echo -e "${escGREEN} Escape Dark Green ${escDC}"
echo -e "${escYELLOW} Escape Dark Yellow ${escDC}"
echo -e "${escBLUE} Escape Dark Blue ${escDC}"
echo -e "${escMAGENTA} Escape Dark Magenta ${escDC}"
echo -e "${escCYAN} Escape Dark Cyan ${escDC}"
echo -e "${escWHITE} Escape Dark White ${escDC}"

# Intense/Bright Escape Code for Foreground Colors
echo -e "${escIBLACK} Escape Dark Black ${escDC}"
echo -e "${escIRED} Escape Dark Red ${escDC}"
echo -e "${escIGREEN} Escape Dark Green ${escDC}"
echo -e "${escIYELLOW} Escape Dark Yellow ${escDC}"
echo -e "${escIBLUE} Escape Dark Blue ${escDC}"
echo -e "${escIMAGENTA} Escape Dark Magenta ${escDC}"
echo -e "${escICYAN} Escape Dark Cyan ${escDC}"
echo -e "${escIWHITE} Escape Dark White ${escDC}"

# Reverse all Screen (flash screen)
echo -e -n "${escIWHITE} Flashes Screen ${escDC}"
echo -e -n "${escScrRevON}"
sleep 0.1
echo -e -n "${escScrRevOFF}"
sleep 0.5
echo -e -n "${escScrRevON}"
sleep 0.1
echo -e -n "${escScrRevOFF}"
sleep 0.5
echo -e -n "${escScrRevON}"
sleep 0.1
echo -e -n "${escScrRevOFF}"


# Generate Escape Code for Foreground|Background Colors
echo -e "$(genEscSt ${BRIGHT}) genEscST(BRIGHT) $(genEscSt ${NORMAL})"
echo -e "$(genEscDFg ${GREEN}) escDFG(GREEN) $(genEscSt ${NORMAL})"
echo -e "$(genEscDBg ${YELLOW}) escDBG(YELLOW) $(genEscSt ${NORMAL})"
echo -e "$(genEscIFg ${BLUE}) escIFG(BLUE) $(genEscSt ${NORMAL})"
echo -e "$(genEscIBg ${CYAN}) escIBG(CYAN) $(genEscSt ${NORMAL})"
echo -e "$(genEscStFgBg ${UNDERLINE} $(genDFg $BLACK) $(genIBg $CYAN)) genEscStFgBg(UNDERLINE BLACK ((IBG+CYAN))) $(genEscSt ${NORMAL})"

echo -e "$(genExtFg ${WHITE}) escExtFg(WHITE) ${escNFG}"
echo -e "$(genExtBg ${GREEN}) escExtBg(GREEN) ${escNBG}"
echo -e "$(genExtStFgBg ${ITALIC} ${BLACK} ${CYAN}) escEscStFgBg(ITALIC BLACK CYAN) ${escNC}"

echo -e "$(genExtFgRGB 63 127 191) escFgRGB(63 127 191) ${escNC}"
echo -e "$(genExtFgRGB 255 255 0) escFgRGB(255 255 0) ${escNC}"

echo -e "$(genExtBgRGB 63 127 191) escBgRGB(63 127 191) ${escNC}"
echo -e "$(genExtBgRGB 255 255 0) escBgRGB(255 255 0) ${escNC}"

# Reset Screen modes
fullReset
echo -e "Testing after a full reset"
echo -e "Testing after a full reset"
echo -e "Testing after a full reset"
echo -e "Testing after a full reset"
echo -e "Testing after a full reset"
echo -e "End"
echo -e "$(genEscSt ${BRIGHT}) escST(BRIGHT) $(genEscSt ${NORMAL})"
echo -e "Testing after a full reset"
echo -e "Testing after a full reset"
echo -e "Testing after a full reset"
echo -e "Testing after a full reset"
echo -e "Testing after a full reset"
echo -e "End"

#escScreenFlashes
########################################

# Unload Libs, Variables and Functions.
_exit $_ERR

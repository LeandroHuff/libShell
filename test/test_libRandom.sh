#!/usr/bin/env bash

################################################################################
# @file     test_libTemplate.sh
# @brief    Test and check libTemplate file.
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
declare -a  typeTABLE=('internal' 'external' 'load')
declare -i  testTYPE=0
declare -i  minTYPE=0
declare -i  maxTYPE=3
declare     flagLoadLib=false
declare -a  libLIST=(EscCodes Random Regex)
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
    unset -f _unsetVars
    unset -f barGraph
    unset -f isArg

    return 0
}

# exit from bash script and return an error code
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

function test_genDateTimeAsCode()
{
    local _date="$(date '+%Y-%m-%d-%H-%M-%S-%3N')"
    local _gendate="$(genDateTimeAsCode)"
    # compare string size
    if [ ${#_date} = ${#_gendate} ]
    then
        # compare strigs content
        if [ "${_date:0:20}" = "${_gendate:0:20}" ]
        then
            return 0
        else
            return 1
        fi
    else
        return 2
    fi
}

function test_genRandom_asType()
{
    local _type=$1
    declare -i len=$2
    local str

    str=$(genRandom $_type $len)

    [ $? -eq 0 ] || return 1
    [ "${#str}" -eq $len ] || return 2

    declare -a typeRANDOM=(alpha digit alnum lowhex uphex mixhex graph space date)

    if [[ "${typeRANDOM[*]}" =~ "${_type}" ]]
    then
        case ${_type} in
        alpha)  isAlpha            "${str}" || return 3 ;;
        digit)  isDigit            "${str}" || return 3 ;;
        alnum)  isAlphaNumeric     "${str}" || return 3 ;;
        lowhex) isLowerHexadecimal "${str}" || return 3 ;;
        uphex)  isUpperHexadecimal "${str}" || return 3 ;;
        mixhex) isHexadecimal      "${str}" || return 3 ;;
        graph)  isGraph            "${str}" || return 3 ;;
        space)  isGraphSpace       "${str}" || return 3 ;;
        date)   isDateTimeAsCode   "${str}" || return 3 ;;
        esac
    else
        return 4
    fi

    return 0
}

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
'#ID'   return  result  function                        parameter1  parameter2  parameter3  parameter4 \
\
1       1       ''      _isArg                          ''          ''          ''          '' \
2       0       ''      _isArg                          'a'         ''          ''          '' \
3       1       ''      _isArg                          '-a'        ''          ''          '' \
\
4       1       ''      _isInt                          ''          ''          ''          '' \
5       0       ''      _isInt                          '1'         ''          ''          '' \
6       0       ''      _isInt                          '+1'        ''          ''          '' \
7       0       ''      _isInt                          '-1'        ''          ''          '' \
8       1       ''      _isInt                          'a'         ''          ''          '' \
9       1       ''      _isInt                          '+a'        ''          ''          '' \
10      1       ''      _isInt                          '-a'        ''          ''          '' \
11      1       ''      _isInt                          '1l1'       ''          ''          '' \
\
12      1       ''      _isNum                          ''          ''          ''          '' \
13      0       ''      _isNum                          '1'         ''          ''          '' \
14      0       ''      _isNum                          '+1'        ''          ''          '' \
15      0       ''      _isNum                          '-1'        ''          ''          '' \
16      0       ''      _isNum                          '.1'        ''          ''          '' \
17      0       ''      _isNum                          '+.1'       ''          ''          '' \
18      0       ''      _isNum                          '-.1'       ''          ''          '' \
19      0       ''      _isNum                          '1.'        ''          ''          '' \
20      0       ''      _isNum                          '+1.'       ''          ''          '' \
21      0       ''      _isNum                          '-1.'       ''          ''          '' \
22      1       ''      _isNum                          '1l'        ''          ''          '' \
23      1       ''      _isNum                          '+1l'       ''          ''          '' \
24      1       ''      _isNum                          '-1l'       ''          ''          '' \
25      1       ''      _isNum                          'a'         ''          ''          '' \
26      1       ''      _isNum                          '+a'        ''          ''          '' \
27      1       ''      _isNum                          '-a'        ''          ''          '' \
28      1       ''      _isNum                          '1l1'       ''          ''          '' \
\
29      1       ''      genRandomAlpha                  ''          ''          ''          '' \
30      1       ''      genRandomAlpha                  'a'         ''          ''          '' \
31      1       ''      genRandomAlpha                  '@'         ''          ''          '' \
32      1       ''      genRandomAlpha                  '1.2'       ''          ''          '' \
33      0       ''      genRandomAlpha                  '8'         ''          ''          '' \
\
34      1       ''      genRandomNumeric                ''          ''          ''          '' \
35      1       ''      genRandomNumeric                'a'         ''          ''          '' \
36      1       ''      genRandomNumeric                '@'         ''          ''          '' \
37      1       ''      genRandomNumeric                '1.2'       ''          ''          '' \
38      0       ''      genRandomNumeric                '8'         ''          ''          '' \
\
39      1       ''      genRandomAlphaNumeric           ''          ''          ''          '' \
40      1       ''      genRandomAlphaNumeric           'a'         ''          ''          '' \
41      1       ''      genRandomAlphaNumeric           '@'         ''          ''          '' \
42      1       ''      genRandomAlphaNumeric           '1.2'       ''          ''          '' \
43      0       ''      genRandomAlphaNumeric           '8'         ''          ''          '' \
\
44      1       ''      genRandomLowerHexadecimalNumber ''          ''          ''          '' \
45      1       ''      genRandomLowerHexadecimalNumber 'a'         ''          ''          '' \
46      1       ''      genRandomLowerHexadecimalNumber '@'         ''          ''          '' \
47      1       ''      genRandomLowerHexadecimalNumber '1.2'       ''          ''          '' \
48      0       ''      genRandomLowerHexadecimalNumber '8'         ''          ''          '' \
\
49      1       ''      genRandomUpperHexadecimalNumber ''          ''          ''          '' \
50      1       ''      genRandomUpperHexadecimalNumber 'a'         ''          ''          '' \
51      1       ''      genRandomUpperHexadecimalNumber '@'         ''          ''          '' \
52      1       ''      genRandomUpperHexadecimalNumber '1.2'       ''          ''          '' \
53      0       ''      genRandomUpperHexadecimalNumber '8'         ''          ''          '' \
\
54      1       ''      genRandomHexadecimalNumber      ''          ''          ''          '' \
55      1       ''      genRandomHexadecimalNumber      'a'         ''          ''          '' \
56      1       ''      genRandomHexadecimalNumber      '@'         ''          ''          '' \
57      1       ''      genRandomHexadecimalNumber      '1.2'       ''          ''          '' \
58      0       ''      genRandomHexadecimalNumber      '8'         ''          ''          '' \
\
59      1       ''      genRandomGraph                  ''          ''          ''          '' \
60      1       ''      genRandomGraph                  'a'         ''          ''          '' \
61      1       ''      genRandomGraph                  '@'         ''          ''          '' \
62      1       ''      genRandomGraph                  '1.2'       ''          ''          '' \
63      0       ''      genRandomGraph                  '8'         ''          ''          '' \
\
64      1       ''      genRandomGraphSpace             ''          ''          ''          '' \
65      1       ''      genRandomGraphSpace             'a'         ''          ''          '' \
66      1       ''      genRandomGraphSpace             '@'         ''          ''          '' \
67      1       ''      genRandomGraphSpace             '1.2'       ''          ''          '' \
68      0       ''      genRandomGraphSpace             '8'         ''          ''          '' \
\
69      0       ''      test_genDateTimeAsCode          ''          ''          ''          '' \
\
71      2       ''      genRandom                       ''          '8'         ''          '' \
71      3       ''      genRandom                       'wrong'     '8'         ''          '' \
72      4       ''      genRandom                       'alpha'     ''          ''          '' \
73      5       ''      genRandom                       'alpha'     'a'         ''          '' \
74      5       ''      genRandom                       'alpha'     '@'         ''          '' \
75      5       ''      genRandom                       'alpha'     '1.2'       ''          '' \
\
76      0       ''      genRandom                       'alpha'     '8'         ''          '' \
77      0       ''      genRandom                       'digit'     '8'         ''          '' \
78      0       ''      genRandom                       'alnum'     '8'         ''          '' \
79      0       ''      genRandom                       'lowhex'    '8'         ''          '' \
80      0       ''      genRandom                       'uphex'     '8'         ''          '' \
81      0       ''      genRandom                       'mixhex'    '8'         ''          '' \
82      0       ''      genRandom                       'graph'     '8'         ''          '' \
83      0       ''      genRandom                       'space'     '8'         ''          '' \
84      0       ''      genRandom                       'date'      ''          ''          '' \
\
85      0       ''      test_genRandom_asType           'alpha'     '8'         ''          '' \
86      0       ''      test_genRandom_asType           'digit'     '8'         ''          '' \
87      0       ''      test_genRandom_asType           'alnum'     '8'         ''          '' \
88      0       ''      test_genRandom_asType           'lowhex'    '8'         ''          '' \
89      0       ''      test_genRandom_asType           'uphex'     '8'         ''          '' \
90      0       ''      test_genRandom_asType           'mixhex'    '8'         ''          '' \
91      0       ''      test_genRandom_asType           'graph'     '8'         ''          '' \
92      0       ''      test_genRandom_asType           'space'     '8'         ''          '' \
93      0       ''      test_genRandom_asType           'date'      '23'        ''          '' \
\
94      2       ''      genUUID                         ''          '8'         ''          '' \
95      3       ''      genUUID                         'wrong'     '8'         ''          '' \
96      4       ''      genUUID                         'alpha'     ''          ''          '' \
97      5       ''      genUUID                         'alpha'     '&'         ''          '' \
98      6       ''      genUUID                         'alpha'     '4'         '&'         '' \
99      6       ''      genUUID                         'alpha'     '4'         '4'         '%' \
100     0       ''      genUUID                         'alpha'     '4'         ''          '' \
101     0       ''      genUUID                         'alpha'     '4'         '4'         '' \
102     0       ''      genUUID                         'alpha'     '4'         '4'         '4' \
\
103     0       ''      genUUID                         'digit'     '4'         '4'         '4' \
104     0       ''      genUUID                         'alnum'     '4'         '4'         '4' \
105     0       ''      genUUID                         'lowhex'    '4'         '4'         '4' \
106     0       ''      genUUID                         'uphex'     '4'         '4'         '4' \
107     0       ''      genUUID                         'mixhex'    '4'         '4'         '4' \
\
108     0       ''      libRandomExit                   ''          ''          ''          '' \
\
'#ID'   return  result  function                        parameter1  parameter2  parameter3  parameter4\
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

if [ $testTYPE -eq 0 ]
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
# Run TEST TABLE
################################################################################

# Start line counter and offset at 0
LINE=0
idxID=$columnID
# Calculate the first function column OFFSET.
idxFUNC=$((idxID+columnFILE))

# while not empty function name
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
            internal)
                # Uncomment/Commant to enable/disable test functions from internal test table.
                if $flagDEBUG ; then echo -e -n "${_WHITE}Function${_NC}: ${testTABLE[$idxFUNC]} ${testTABLE[$idxP1]} ${testTABLE[$idxP2]} ${testTABLE[$idxP3]} ${testTABLE[$idxP4]}\t-> " ; fi
                _RES="$(${testTABLE[$idxFUNC]} "${testTABLE[$idxP1]}" "${testTABLE[$idxP2]}" "${testTABLE[$idxP3]}" "${testTABLE[$idxP4]}")"
                ;;
            external)
                # Uncomment/Commant to enable/disable call extarnal tests files
                if $flagDEBUG ; then echo -e -n "${_WHITE}File${_NC}: test_lib${testTABLE[$idxFUNC]}.sh\t-> " ; fi
                _RES="$(. ${testPATH}/test_lib${testTABLE[$idxFUNC]}.sh "${testTABLE[$idxP1]}" "${testTABLE[$idxP2]}" "${testTABLE[$idxP3]}" "${testTABLE[$idxP4]}")"
                ;;
            load)
                # Uncomment/Commant to enable/disable test source library
                if $flagDEBUG ; then echo -e -n "${_WHITE}File${_NC}: lib${testTABLE[$idxFUNC]}.sh\t-> " ; fi
                _RES="$(source ${libPATH}/lib${testTABLE[$idxFUNC]}.sh "${testTABLE[$idxP1]}" "${testTABLE[$idxP2]}" "${testTABLE[$idxP3]}" "${testTABLE[$idxP4]}")"
                ;;
            *)  logFail "Test type (${typeTABLE[$testTYPE]}) not available."
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
        elif $_SUCCESS  ; then echo -e "${_GREEN}success${_NC}."
        else                   echo -e "${_RED}failure${_NC}."
        fi
    fi

    # next line
    let LINE++
    # next idxID offset from line counter
    idxID=$((LINE*maxCOLUMNS))
    # next function offset
    idxFUNC=$((idxID+columnFILE))
done

# new line after bar graph
echo

# print success and error counters on terminal
if [ $_OK  -gt 0 ] ; then logOk   "${_HGREEN}$_OK${_NC} Test(s)" ; fi
if [ $_ERR -gt 0 ] ; then logFail "${_HRED}$_ERR${_NC} Test(s)"  ; fi

########################################
# This are is reserved for specific tests before exit from script.
# Check function parameter, behaviors or results and returned code.



########################################

# Unload Libs, Variables and Functions.
_exit $_ERR

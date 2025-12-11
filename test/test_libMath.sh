#!/usr/bin/env bash

################################################################################
# @file     test_libMath.sh
# @brief    Test and check libMath file.
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
declare -i  maxTYPE=2
declare     flagLoadLib=false
declare -a  libLIST=(EscCodes Math)
declare -a  libLOADED=()
declare     libPATH="/home/${USER}/dev/libShell"
declare     testPATH="/home/${USER}/dev/libShell/test"

declare -i flagDEBUG=0

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
function logDebug(){ if [ $flagDEBUG -ne 0 ] ; then echo -e "${_GREEN}Debug${_NC}: $*" ; fi ; }

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
'#ID'   return  result      function                parameter1  parameter2  parameter3  parameter4 \
\
1       0       ''          isZero                  -0          ''          ''          '' \
2       0       ''          isZero                  +0          ''          ''          '' \
3       0       ''          isZero                  0           ''          ''          '' \
4       0       ''          isZero                  .0          ''          ''          '' \
5       0       ''          isZero                  0.          ''          ''          '' \
6       0       ''          isZero                  0.0         ''          ''          '' \
7       1       ''          isZero                  1           ''          ''          '' \
8       1       ''          isZero                  1.          ''          ''          '' \
9       1       ''          isZero                  .1          ''          ''          '' \
10      1       ''          isZero                  0.1         ''          ''          '' \
11      1       ''          isZero                  1.0         ''          ''          '' \
12      1       ''          isZero                  1d0         ''          ''          '' \
13      1       ''          isZero                  0d1         ''          ''          '' \
\
'#'  '0:Success/1:Error' '' 'Test Valid Numbers' 'Float Number' '' '' '' \
14      0       ''          isNumber                1           ''          ''          '' \
15      0       ''          isNumber                .1          ''          ''          '' \
16      0       ''          isNumber                1.          ''          ''          '' \
17      0       ''          isNumber                1.2         ''          ''          '' \
18      0       ''          isNumber                0.1         ''          ''          '' \
19      0       ''          isNumber                1.0         ''          ''          '' \
20      1       ''          isNumber                0d1         ''          ''          '' \
21      1       ''          isNumber                1d0         ''          ''          '' \
\
'#'  '0:Success/1:Error' 'Result' 'Normalize Number' 'Float Number' '' '' '' \
22      ''      0.1         normalizeNumber         .1          ''          ''          '' \
23      ''      1.0         normalizeNumber         1.          ''          ''          '' \
24      ''      0.0         normalizeNumber         0.0         ''          ''          '' \
25      ''      1.1         normalizeNumber         1.1         ''          ''          '' \
26      ''      11.0        normalizeNumber         11          ''          ''          '' \
27      1       NaN         normalizeNumber         abc         ''          ''          '' \
28      1       NaN         normalizeNumber         ''          ''          ''          '' \
\
'#'  '0:Success/1:Error' 'Result' 'Trim Left and Right Zeros from Number' 'Float Number' '' '' '' \
29      0       1.1         trimZeros               001.100     ''          ''          '' \
30      0       1.0         trimZeros               001.000     ''          ''          '' \
31      0       100.0       trimZeros               100.000     ''          ''          '' \
32      0       0.001       trimZeros               000.001     ''          ''          '' \
33      0       1.0         trimZeros               001.        ''          ''          '' \
34      0       0.1         trimZeros               .100        ''          ''          '' \
35      0       0.0         trimZeros               00.00       ''          ''          '' \
36      0       101.101     trimZeros               101.101     ''          ''          '' \
37      1       NaN         trimZeros               001d100     ''          ''          '' \
\
'#'  '0:Success/1:Error' 'Integer' 'Get Int from Float' 'Float Number' '' '' '' \
38      0       123         getIntegerFromFloat     123.456     ''          ''          '' \
39      0       0           getIntegerFromFloat     .456        ''          ''          '' \
40      0       123         getIntegerFromFloat     123.        ''          ''          '' \
41      0       0           getIntegerFromFloat     0.456       ''          ''          '' \
42      0       123         getIntegerFromFloat     123         ''          ''          '' \
43      1       NaN         getIntegerFromFloat     123d456     ''          ''          '' \
44      1       NaN         getIntegerFromFloat     ''          ''          ''          '' \
\
'#'  '0:Success/1:Error' 'Fraction' 'Get Fract from Float' 'Float Number' '' '' '' \
45      0       456         getFractionFromFloat    123.456     ''          ''          '' \
46      0       456         getFractionFromFloat    .456        ''          ''          '' \
47      0       0           getFractionFromFloat    123.        ''          ''          '' \
48      0       456         getFractionFromFloat    0.456       ''          ''          '' \
49      0       0           getFractionFromFloat    123         ''          ''          '' \
50      1       NaN         getFractionFromFloat    123d456     ''          ''          '' \
51      1       NaN         getFractionFromFloat    ''          ''          ''          '' \
\
'#'  '0:Success/1:Error' '' 'Is a EEE32 0 Float' 'EEE32 Number' '' '' '' \
52      0       ''          isFloatZero             0.0E12      ''          ''          '' \
53      0       ''          isFloatZero             0E12        ''          ''          '' \
54      0       ''          isFloatZero             .0E12       ''          ''          '' \
55      0       ''          isFloatZero             0.E12       ''          ''          '' \
56      0       ''          isFloatZero             0.          ''          ''          '' \
57      0       ''          isFloatZero             .0          ''          ''          '' \
58      0       ''          isFloatZero             0.0         ''          ''          '' \
59      1       ''          isFloatZero             .E12        ''          ''          '' \
60      1       ''          isFloatZero             E12         ''          ''          '' \
61      0       ''          isFloatZero             0           ''          ''          '' \
62      0       ''          isFloatZero             0           ''          ''          '' \
63      0       ''          isFloatZero             0.          ''          ''          '' \
64      0       ''          isFloatZero             0.0         ''          ''          '' \
65      1       ''          isFloatZero             1           ''          ''          '' \
66      1       ''          isFloatZero             1.          ''          ''          '' \
67      1       ''          isFloatZero             .1          ''          ''          '' \
68      1       ''          isFloatZero             0.1         ''          ''          '' \
69      1       ''          isFloatZero             1.0         ''          ''          '' \
70      1       ''          isFloatZero             1d0         ''          ''          '' \
71      1       ''          isFloatZero             0d1         ''          ''          '' \
\
'#'  '0:Success/1:Error' '' 'Is a EEE32 Float' 'EEE32 Number' '' '' '' \
72      0       ''          isFloat                 1.2E12      ''          ''          '' \
73      0       ''          isFloat                 1E12        ''          ''          '' \
74      0       ''          isFloat                 .1E12       ''          ''          '' \
75      0       ''          isFloat                 1.E12       ''          ''          '' \
76      0       ''          isFloat                 1.          ''          ''          '' \
77      0       ''          isFloat                 .1          ''          ''          '' \
78      0       ''          isFloat                 1.2         ''          ''          '' \
79      1       ''          isFloat                 .E12        ''          ''          '' \
80      1       ''          isFloat                 E12         ''          ''          '' \
81      0       ''          isFloat                 1           ''          ''          '' \
82      0       ''          isFloat                 0.1         ''          ''          '' \
83      0       ''          isFloat                 1.0         ''          ''          '' \
84      1       ''          isFloat                 1d0         ''          ''          '' \
85      1       ''          isFloat                 0d1         ''          ''          '' \
\
'#'  '0:Success/1:Error' '0:False/1:True|Result' 'Calculate Number' 'Number 1' 'Operator' 'Number 2' '' \
86      0       2.0         calcNumber              1          '+'          1           '' \
87      0       4.6         calcNumber              1.2        '+'          3.4         '' \
88      0       2.0         calcNumber              9          '-'          7           '' \
89      0       12.84       calcNumber              12.34      '+'          0.5         '' \
90      0       100.0       calcNumber              10         '*'          10          '' \
91      0       4.0         calcNumber              12         '/'          3           '' \
92      0       0.5         calcNumber              1          '/'          2           '' \
93      0       1           calcNumber              1          '=='         1           '' \
94      0       1           calcNumber              1          '<'          2           '' \
95      0       0           calcNumber              1          '>'          2           '' \
96      0       1           calcNumber              1          '<='         2           '' \
97      0       1           calcNumber              2.5        '>='         2.0         '' \
98      1       NaN         calcNumber              2d5        '>='         2.0         '' \
99      1       NaN         calcNumber              2d5        '<'          2.0         '' \
100     1       NaN         calcNumber              2d5        '*'          2.0         '' \
\
'#'  '0:Success/1:Error' '' 'Exit from libMath' '' '' '' '' '' \
101     0       ''          libMathExit             ''          ''          ''          '' \
'#ID'   return  result      function                parameter1  parameter2  parameter3  parameter4\
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
    -g) flagDEBUG=1 ;;
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
                _RES="$(${testTABLE[$idxFUNC]} "${testTABLE[$idxP1]}" "${testTABLE[$idxP2]}" "${testTABLE[$idxP3]}" "${testTABLE[$idxP4]}")"
                ;;
            external)
                # Uncomment/Commant to enable/disable call extarnal tests files
                _RES="$(. ${testPATH}/test_lib${testTABLE[$idxFUNC]}.sh "${testTABLE[$idxP1]}" "${testTABLE[$idxP2]}" "${testTABLE[$idxP3]}" "${testTABLE[$idxP4]}")"
                ;;
            load)
                # Uncomment/Commant to enable/disable test source library
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
        if [ $_SUCCESS = false ] && [ $flagDEBUG -ne 0 ]
        then
            echo
            logDebug "Line:$LINE"
            logDebug "Run:${testTABLE[$idxFUNC]}(${testTABLE[$idxP1]},${testTABLE[$idxP2]},${testTABLE[$idxP3]},${testTABLE[$idxP4]})"
            logDebug "Ret:'$_RET' compare to Table Ret: '${testTABLE[$idxRET]}' "
            logDebug "Res:'$_RES' compare to Table Res: '${testTABLE[$idxRES]}' "
        fi

        # show bar graph
        barGraph $LINE $_SUCCESS
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
# Check function parameter, behaviors or results / returned code.



########################################

# Unload Libs, Variables and Functions.
_exit $_ERR

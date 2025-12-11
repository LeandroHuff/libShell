#!/usr/bin/env bash

################################################################################
# @file     test_libTime.sh
# @brief    Test and check libTime file.
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
declare -a  libLIST=(EscCodes Time)
declare -a  libLOADED=()
declare     libPATH="/home/${USER}/dev/libShell"

declare -i testDEBUG=0

declare -i LINE=0
declare -i _OK=0
declare -i _ERR=0
declare    _RES=''
declare    _RET=0

# test table columns
declare -i columnID=0
declare -i columnRET=1
declare -i columnRES=2
declare -i columnFUNC=3
declare -i columnP1=4
declare -i columnP2=5
declare -i columnP3=6
declare -i columnP4=7
declare -i maxCOLUMNS=8

function logOk()   { echo -e "${GRAY}Success${NC}: $*" ; }
function logFail() { echo -e "${RED}Failure${NC}: $*" ; }
function logWarn() { echo -e "${CYAN}Warning${NC}: $*" ; }
function logDebug(){ if [ $testDEBUG -ne 0 ] ; then echo -e "${GREEN}Debug${NC}: $*" ; fi ; }

function _unsetVars
{
    # Unset Variables
    unset -v libLIST
    unset -v libLOADED
    unset -v libPATH
    unset -v testDEBUG
    unset -v LINE
    unset -v _OK
    unset -v _ERR
    unset -v _RES
    unset -v _RET
    unset -v columnID
    unset -v columnRET
    unset -v columnRES
    unset -v columnFUNC
    unset -v columnP1
    unset -v columnP2
    unset -v columnP3
    unset -v columnP4
    unset -v maxCOLUMNS

    # Unset Function
    unset -f logOk
    unset -f logFail
    unset -f logWarn
    unset -f logDebug
    unset -f _unsetVars
    unset -f _exit
    unset -f barGraph
    unset -f isArg

    return 0
}

function _exit()
{
    local code=$([ -n "$1" ] && echo -n $1 || echo -n 0)

    # Stop logs
    [ -n "${logStop}" ] && logStop

    # Unload Libs
    for file in ${libLOADED[@]} ; do $(lib${file}Exit) || logFail "Unload lib${file}.sh" ; done

    # Unload local variables
    unset -v file

    # Unload Global Variables and Functions
    _unsetVars

    exit $code
}

function barGraph()
{
    local num=$1
    local ok=$2
    # print '*' green for ok and red for not ok.
    if $ok ; then printf "${HGREEN}*${NC}" ; else printf "${HRED}*${NC}" ; fi
    # print [N] each 10 and '|' each 5
    if   [ $((num % 10)) -eq 0 ] ; then printf "[%3d]" $num
    elif [ $((num %  5)) -eq 0 ] ; then printf '|' ; fi
    # echo a new line each 50
    if  [ $((num % 50)) -eq 0 ] ; then echo ; fi
}

function isArg() { if [ -n "$1" ] ; then case $1 in -*) false ;; *) true ;; esac ; else false ; fi ; }

# +--------------+---------------------------------------------------------------
# | Column       | Description
# +--------------+---------------------------------------------------------------
# | ID           | Line number, '#' is a commented line.
# | columnRET    | Return success or error code (return n)
# | columnRES    | Result from function (echo '' or printf '')
# | columnFUNC   | Function in lib or a local wapper test_Function
# | columnP1     | 1st parameter to function
# | columnP2     | 2nd parameter to function
# | columnP3     | 3th parameter to function
# | columnP4     | 4th parameter to function
# | maxCOLUMNS   | Max table columns
# +--------------+---------------------------------------------------------------

declare -a -r testTABLE=(\
'#ID'   'return code'   'result string' 'function name' 'parameter 1'   'parameter 2'   'parameter 3'   'parameter 4' \
\
1       1               ''              isArg           ''              ''              ''              '' \
2       1               ''              isArg           -a              ''              ''              '' \
3       1               ''              isArg           -1              ''              ''              '' \
4       0               ''              isArg           a               ''              ''              '' \
5       0               ''              isArg           1               ''              ''              '' \
\
6       1               ''              _isNum          ''              ''              ''              '' \
7       1               ''              _isNum          a               ''              ''              '' \
8       1               ''              _isNum          '#'             ''              ''              '' \
9       0               ''              _isNum          0               ''              ''              '' \
10      0               ''              _isNum          .0              ''              ''              '' \
11      0               ''              _isNum          0.              ''              ''              '' \
12      0               ''              _isNum          0.0             ''              ''              '' \
13      0               ''              _isNum          123.456         ''              ''              '' \
14      0               ''              _isNum          123456          ''              ''              '' \
15      0               ''              _isNum          +123456         ''              ''              '' \
16      0               ''              _isNum          +123.456        ''              ''              '' \
17      0               ''              _isNum          -123.456        ''              ''              '' \
18      0               ''              _isNum          -123456         ''              ''              '' \
\
19      1               ''              _isInt          ''              ''              ''              '' \
20      1               ''              _isInt          a               ''              ''              '' \
21      1               ''              _isInt          '#'             ''              ''              '' \
22      0               ''              _isInt          0               ''              ''              '' \
23      1               ''              _isInt          .0              ''              ''              '' \
24      1               ''              _isInt          0.              ''              ''              '' \
25      1               ''              _isInt          0.0             ''              ''              '' \
26      1               ''              _isInt          123.456         ''              ''              '' \
27      0               ''              _isInt          123456          ''              ''              '' \
28      0               ''              _isInt          +123456         ''              ''              '' \
26      1               ''              _isInt          +123.456        ''              ''              '' \
30      1               ''              _isInt          -123.456        ''              ''              '' \
31      0               ''              _isInt          -123456         ''              ''              '' \
\
32      1               ''              _isNot          s               ''              ''              '' \
33      1               ''              _isNot          S               ''              ''              '' \
34      1               ''              _isNot          !               ''              ''              '' \
35      0               ''              _isNot          n               ''              ''              '' \
36      0               ''              _isNot          N               ''              ''              '' \
37      0               ''              _isNot          No              ''              ''              '' \
38      0               ''              _isNot          nO              ''              ''              '' \
39      0               ''              _isNot          NO              ''              ''              '' \
40      0               ''              _isNot          no              ''              ''              '' \
41      0               ''              _isNot          not             ''              ''              '' \
42      0               ''              _isNot          Not             ''              ''              '' \
43      0               ''              _isNot          nOt             ''              ''              '' \
44      0               ''              _isNot          noT             ''              ''              '' \
45      0               ''              _isNot          NOt             ''              ''              '' \
46      0               ''              _isNot          NoT             ''              ''              '' \
47      0               ''              _isNot          noT             ''              ''              '' \
48      0               ''              _isNot          NOT             ''              ''              '' \
49      1               ''              _isNot          noot            ''              ''              '' \
\
50      1               ''              _isYes          n               ''              ''              '' \
51      1               ''              _isYes          N               ''              ''              '' \
52      1               ''              _isYes          !               ''              ''              '' \
53      0               ''              _isYes          y               ''              ''              '' \
54      0               ''              _isYes          Y               ''              ''              '' \
55      0               ''              _isYes          yes             ''              ''              '' \
56      0               ''              _isYes          Yes             ''              ''              '' \
57      0               ''              _isYes          yES             ''              ''              '' \
58      0               ''              _isYes          yeS             ''              ''              '' \
59      0               ''              _isYes          YEs             ''              ''              '' \
60      0               ''              _isYes          YeS             ''              ''              '' \
61      0               ''              _isYes          yeS             ''              ''              '' \
62      0               ''              _isYes          YES             ''              ''              '' \
63      1               ''              _isYes          yees            ''              ''              '' \
\
64      2               ''              libTimeSetup    -x              ''              ''              '' \
65      3               ''              libTimeSetup    a               ''              ''              '' \
66      1               ''              libTimeSetup    -t              -x              ''              '' \
67      1               ''              libTimeSetup    -t              x               ''              '' \
68      0               ''              libTimeSetup    ''              ''              ''              '' \
69      0               ''              libTimeSetup    -t              30              ''              '' \
70      0               ''              libTimeSetup    -t              0               ''              '' \
71      0               ''              libTimeSetup    -t              -10             ''              '' \
\
72      1               ''              isArg           ''              ''              ''              '' \
73      1               ''              isArg           -a              ''              ''              '' \
74      1               ''              isArg           -1              ''              ''              '' \
75      0               ''              isArg           a               ''              ''              '' \
76      0               ''              isArg           1               ''              ''              '' \
\
77      0               ''              libTimeExit     ''              ''              ''              '' \
\
'#ID'   'return code'   'result string' 'function name' 'parameter 1'   'parameter 2'   'parameter 3'   'parameter 4'\
)

function usage()
{
    cat << EOT
Bash script to run a list of function for test.
Usage: $(basename "$0") [options] [-- libOptions]
Options:
-h|--help               Show help message.
-g|--debug)             Set debug mode for test file.
-p|--path <directory/>  Set libShell path.
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
    -h|--help) usage ; _exit ;;
    -p|--path)
        shift
        if isArg "$1"
        then
            libPATH="$1"
        else
            logFail "Option -p|--path </directory>"
            _exit 1
        fi
        ;;
    -g) testDEBUG=1 ;;
    --) shift ; break ;;
    -*) logFail "Option '$1' not available."        ; _exit 2 ;;
     *) logFail "Argument '$1' not available."      ; _exit 3 ;;
     ?) logFail "Empty argument from command line." ; _exit 4 ;;
    esac
    shift
done

if [ $testTYPE -eq 0 ]
then
    flagLoadLib=true
fi

# Load Libs
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
            _exit 5
        fi
    else
        logFail "File ${libPATH}/lib${file}.sh not found."
        _exit 6
    fi
done

# Parse command line parameters next '--'
while [ $# -gt 0 ] && [ -n "$1" ]
do
    case $1 in
    -h|--help) [ -n "${logHelp}" ] && logHelp ; _exit ;;
    -t|--timeout) shift
        if isArg "$1"
        then
            libShellSetup $1
        else
            logFail "Invalid argument for timeout option."
            exit 7
        fi
        ;;
    -*) shift
        logInit "$@" || _exit 8
        break
        ;;
     *) logFail "Argument $1 not available."        ; _exit 9  ;;
     ?) logFail "Empty argument from command line." ; _exit 10 ;;
    esac
    shift
done

################################################################################
# Run TEST TABLE
################################################################################
# Start line counter and offset at 0
LINE=0
columnID=0
# Calculate the first function column OFFSET.
idxFUNC=$((columnID+columnFUNC))
# while not empty function name
while [ -n "${testTABLE[$idxFUNC]}" ] ; do
    # skip commented lines.
    if [[ "${testTABLE[$columnID]:0:1}" != "#" ]]
    then
        # calculate return column offset
        idxRET=$((columnID+columnRET))
        # calculate result column offset
        idxRES=$((columnID+columnRES))
        # calculate parameter 1 column offset
        idxP1=$((columnID+columnP1))
        # calculate parameter 2 column offset
        idxP2=$((columnID+columnP2))
        # calculate parameter 3 column offset
        idxP3=$((columnID+columnP3))
        # calculate parameter 4 column offset
        idxP4=$((columnID+columnP4))

        # run test table at idxFUNC
        res="$(${testTABLE[$idxFUNC]} "${testTABLE[$idxP1]}" "${testTABLE[$idxP2]}" "${testTABLE[$idxP3]}" "${testTABLE[$idxP4]}")"

        # take returned code
        ret=$?

        # preset result to true
        _RES=true

        # compare result and returned code from function according table to check success or error
        # increment success counter or error counter and reset result flag
        if [ -n "${testTABLE[ $idxRET ]}" ] && [ -n "${testTABLE[ $idxRES ]}" ]
        then
            if [ $ret -eq ${testTABLE[ $idxRET ]} ] && [[ "$res" == "${testTABLE[ $idxRES ]}" ]]
            then
                let _OK++
            else
                let _ERR++
                _RES=false
            fi
        elif [ -n "${testTABLE[ $idxRET ]}" ]
        then
            if [ $ret -eq ${testTABLE[ $idxRET ]} ]
            then
                let _OK++
            else
                let _ERR++
                _RES=false
            fi
        elif [ -n "${testTABLE[ $idxRES ]}" ]
        then
            if [[ "$res" == "${testTABLE[ $idxRES ]}" ]]
            then
                let _OK++
            else
                let _ERR++
                _RES=false
            fi
        else
            logWarn "Bouth testTABLE[idxRES:$idxRES] and testTABLE[idxRET:$idxRET] columns are empty."
        fi

        # on debug mode, print a debug message on terminal
        if [ $_RES = false ] && [ $testDEBUG -ne 0 ]
        then
            echo
            logDebug "Line:$LINE"
            logDebug "Run:${testTABLE[$idxFUNC]}(${testTABLE[$idxP1]},${testTABLE[$idxP2]},${testTABLE[$idxP3]},${testTABLE[$idxP4]})"
            logDebug "Ret:'$ret' compare to Table Ret: '${testTABLE[$idxRET]}' "
            logDebug "Res:'$res' compare to Table Res: '${testTABLE[$idxRES]}' "
        fi

        # show bar graph
        barGraph $LINE $_RES
    fi
    # next line
    let LINE++
    # next column offset
    columnID=$((LINE*maxCOLUMNS))
    # next function offset
    idxFUNC=$((columnID+columnFUNC))
done

echo

# print success and error counters on terminal
if [ $_OK  -gt 0 ] ; then logOk   "${HGREEN}$_OK${NC} Test(s)" ; fi
if [ $_ERR -gt 0 ] ; then logFail "${HRED}$_ERR${NC} Test(s)"  ; fi

########################################
## Area 51 (restrict for special tests)

########################################

# Unload Libs, Variables and Functions.
_exit

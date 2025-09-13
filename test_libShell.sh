#!/usr/bin/env bash

##
# @brief        Shell script to test libShell Library                          #
# @file         test_libShell.sh                                               #
# @author       Leandro - leandrohuff@programmer.net                           #
# @date         2025-09-10                                                     #
# @version      2.0.2                                                          #
# @copyright    CC01 1.0 Universal                                             #
# @details      Run a set of tests stored in a tatble to call libShell         #
#               functions and pass some parameters to check its results.       #
#               Syntax: test_libShell.sh -v -l 1                               #
#               Where: -v  show more verbose message about test results        #
#               All command line parameters will be passed to libShell.        #
#               Functions or variables started with underline char (_) is a    #
#               local name and the underline is to avoid conflict with the     #
#               libShell name's.

declare -a -i -r testVERSION=(2 0 2)
declare -a -i -r testDATE=(2025 9 10)

# @brief    Local and unconditional log functions.
declare -i testDEBUG=0
function logOk()   { echo -e "\033[37mSuccess:\033[0m $*" ; }
function logFail() { echo -e "\033[31mFailure:\033[0m $*" ; }
function logDebug { [ $testDEBUG -eq 0 ] || echo -e "\033[32mDebug:\033[0m $*" ; }

## @brief	Set global variables for local use.
declare -i -r iLINE=0
declare -i -r iRET=1
declare -i -r iRES=2
declare -i -r iFUNC=3
declare -i -r iPARAM1=4
declare -i -r iPARAM2=5
declare -i -r iPARAM3=6
declare -i -r iMAX=7
declare -i    OK=0
declare -i    ERR=0
declare       RES
declare       RET

## @brief   Unset global test variables, not in libShell, for libShell call libEnd() function.
function _unsetVars
{
    unset -v OK
    unset -v ERR
    unset -v RES
    unset -v RET
    return 0
}

function test_genRandomAlpha()
{
    local str="$(genRandomAlpha $1)"
    local len=$(strLength "$str")
    echo -n $len
    if isAlpha "$str"
    then
        return 0
    else
        return 1
    fi
}

function test_genRandomNumeric()
{
    local str="$(genRandomNumeric $1)"
    local len=$(strLength "$str")
    echo -n $len
    if isDigit "$str"
    then
        return 0
    else
        return 1
    fi
}

function test_genRandomAlphaNumeric()
{
    local str="$(genRandomAlphaNumeric $1)"
    local len=$(strLength "$str")
    echo -n $len
    if isAlphaNumeric "$str"
    then
        return 0
    else
        return 1
    fi
}

function test_genRandomHexadecimalNumber()
{
    local str="$(genRandomHexadecimalNumber $1)"
    local len=$(strLength "$str")
    echo -n $len
    if isHexadecimalNumber "$str"
    then
        return 0
    else
        return 1
    fi
}

function test_genRandomLowerHexadecimalNumber()
{
    local str="$(genRandomLowerHexadecimalNumber $1)"
    local len=$(strLength "$str")
    echo -n $len
    if isLowerHexadecimalNumber "$str"
    then
        return 0
    else
        return 1
    fi
}

function test_genRandomUpperHexadecimalNumber()
{
    local str="$(genRandomLowerHexadecimalNumber $1)"
    local len=$(strLength "$str")
    echo -n $len
    if isLowerHexadecimalNumber "$str"
    then
        return 0
    else
        return 1
    fi
}

function test_genRandomString()
{
    local str="$(genRandomString $1)"
    local len=$(strLength "$str")
    echo -n $len
    if isAllGraphChar "$str"
    then
        return 0
    else
        return 1
    fi
}

function test_genRandomStringSpace()
{
    local str="$(genRandomStringSpace $1)"
    local len=$(strLength "$str")
    echo -n $len
    if isAllGraphChar "$str"
    then
        return 0
    else
        return 1
    fi
}

function test_genDateTimeAsCode()
{
    local str="$(genDateTimeAsCode)"
    echo -n $(strLength "$str")
    local later="$(genDateTimeAsCode)"
    if [ $(strCompare "$str" "$later") -lt 0 ]
    then
        return 0
    else
        return 1
    fi
}

function test_genRandom()
{
    local str="$(genRandom $*)"
    echo -n $(strLength "$str")
    if isAllGraphChar "$str"
    then
        return 0
    else
        return 1
    fi
}

function test_getDateTime()
{
    local str="$(getDateTime)"
    echo -n $(strLength "$str")
    local later="$(getDateTime)"
    if [ $(strCompare "$str" "$later") -lt 0 ]
    then
        return 0
    else
        return 1
    fi
}

function test_printLibVersion()
{
    local str="$(printLibVersion)"
    echo "$str"
    logDebug "$str"
    echo "libShell Version: ${WHITE}2.2.2${NC}"
    logDebug "libShell Version: ${WHITE}2.2.2${NC}"
    local -i res=$( strCompare "$str" "libShell Version: ${WHITE}2.2.2${NC}" )
    if [ $res -lt 0 ]
    then
        logDebug "Less Than 0"
    elif [ $res -gt 0 ]
    then
        logDebug "Greater Than 0"
    elif [ $res -eq 0 ]
    then
        logDebug "Equal 0"
    else
        logDebug "Not less, neither greater or equal"
    fi
}

function test_isGitChanged()
{
    if isGitChanged "$1"
    then
        echo -n true
        return 0
    else
        echo -n false
        return 1
    fi
}

function test_linkExist()
{
    if linkExist "$1"
    then
        echo -n true
        return 0
    else
        echo -n false
        return 1
    fi
}

function test_itExist()
{
    if itExist "$1"
    then
        echo -n true
        return 0
    else
        echo -n false
        return 1
    fi
}

function test_isLogQuiet()
{
    if isLogQuiet
    then
        echo -n true
        return 0
    else
        echo -n false
        return 1
    fi
}

function test_isLogDefault()
{
    if isLogDefault
    then
        echo -n true
        return 0
    else
        echo -n false
        return 1
    fi
}

function test_isLogVerbose()
{
    if isLogVerbose
    then
        echo -n true
        return 0
    else
        echo -n false
        return 1
    fi
}

##
# @brief    Test getRuntime() function.
# @param    none
# @return   0   Success
#           1   Error
# @details      Take 2 runtime value in 1 second interval,
#               check the interval time between runtimes,
#               compare, check the range and return the result.
function test_getRuntime()
{
    declare -i beforeSleep=$(getRuntime)
    sleep 1
    declare -i afterSleep=$(getRuntime)
    declare -i diff=$((afterSleep - beforeSleep))
    if [ $afterSleep -gt $beforeSleep ] && [ $diff -ge 1000 ] && [ $diff -lt 1020 ] ; then
        echo -n true
        return 0
    else
        echo -n false
        return 1
    fi
}

## @brief   Call isInteger() function passing a parameter and return 0 for success or 1 for error.
function test_isInteger()
{
    if isInteger "$1"
    then
        echo -n true
        return 0
    else
        echo -n false
        return 1
    fi
}

## @brief   Call isFloat() function passing a parameter and return 0 for success or 1 for error.
function test_isFloat()
{
    if isFloat   "$1"
    then
        echo -n true
        return 0
    else
        echo -n false
        return 1
    fi
}

## @brief   Call isYes() function passing a parameter and return 0 for success or 1 for error.
function test_isYes()
{
    if isYes "$1"
    then
        echo -n true
        return 0
    else
        echo -n false
        return 1
    fi
}

## @brief   Call isNot() function passing a parameter and return 0 for success or 1 for error.
function test_isNot()
{
    if isNot "$1"
    then
        echo -n true
        return 0
    else
        echo -n false
        return 1
    fi
}

##
# @brief    Call isConnected() function and compare with a local value.
# @param    none
# @return   0   Success
#           1   Error
function test_isConnected
{
    local connected=$(ping '8.8.8.8' -q -t 30 -c 1 > /dev/null 2>&1 && echo true || echo false)
    if $connected && isConnected ; then
        echo -n true
        return 0
    elif ! $connected && ! isConnected ; then
        echo -n true
        return 0
    else
        echo -n false
        return 1
    fi
}

##
# @brief   Test getRuntimeStr() function.
# @param    none
# @return   0   Success
#           1   Error
# @details      Take 2 runtime value in 1 second interval,
#               check the interval time between runtimes,
#               compare 2 float values using an external program,
#               check the range and return the result.
#               bin/subfloat is a binary program to compare 2
#               double parameters and return:
#               -1 for 1st less    than 2nd
#               0  for 1st equal   to 2nd
#               1  for 1st greater than 2nd
function test_getRuntimeStr()
{
    declare beforeSleep=$(getRuntimeStr)
    sleep 1
    declare afterSleep=$(getRuntimeStr)
    declare diff=$(subFloat "$afterSleep" "$beforeSleep")
    if [ $(compareFloat "$diff" "1.000000") -gt 0 ] && [ $(compareFloat '1.020000' "$diff") -gt 0 ] ; then
        echo -n true
        return 0
    else
        echo -n false
        return 1
    fi
}

## @brief   Call isParameter() function passing a parameter and return 0 for success or 1 for error.
function test_isParameter()
{
    if isParameter "$1"
    then
        echo -n true
        return 0
    else
        echo -n false
        return 1
    fi
}

## @brief   Call isArgValue() function passing a parameter and return 0 for success or 1 for error.
function test_isArgValue()
{
    if isArgValue "$1"
    then
        echo -n true
        return 0
    else
        echo -n false
        return 1
    fi
}
##
# @brief    Test logBegin() function and log filename presence.
# @param    none
# @return   0   Success
#           1   Error
# @details      Call libSetup() and pass some parameters to set log flags,
#               Call logStart() and check log flags and log file presence.
#               Return 0 for success and 1 for any error, these results
#               will be compared at end of test.

## @brief   Test logBegin() function by libSetup -l 0 parameters.
function test_logStart_0()
{
    libSetup -q -l 0 || return 2
    $(rm -f "$(getLogFilename)" > /dev/null 2>&1)
    logBegin
    #DISABLED=0	From libShell variables list.
    if [ $logLEVEL -eq $logQUIET ] && [ $logTARGET -eq $logQUIET ] && ! [ -f "${logFILE}" ] ; then
        echo -n true
        return 0
    else
        echo -n false
        return 1
    fi
}

## @brief   Test logStart() function by libSetup -l 1 parameters.
function test_logStart_1()
{
    libSetup -q -l 1 || return 2
    $(rm -f "$(getLogFilename)" > /dev/null 2>&1)
    logBegin
    #SCREEN=10	From libShell variables list.
    if [ $logLEVEL -eq $logQUIET ] && [ $logTARGET -eq $logTOSCREEN ] && ! [ -f "${logFILE}" ] ; then
        echo -n true
        return 0
    else
        echo -n false
        return 1
    fi
}

## @brief   Test logStart() function by libSetup -l 2 parameters.
function test_logStart_2()
{
    libSetup -q -l 2 || return 2
    $(rm -f "$(getLogFilename)" > /dev/null 2>&1)
    logBegin
    #FILE=20    From libShell variables list.
    if [ $logLEVEL -eq $logQUIET ] && [ $logTARGET -eq $logTOFILE ] && [ -f "${logFILE}" ] ; then
        echo -n true
        return 0
    else
        echo -n false
        return 1
    fi
}

## @brief   Test logStart() function by libSetup -l 3 parameters.
function test_logStart_3()
{
    libSetup -q -l 3 || return 2
    $(rm -f "$(getLogFilename)" > /dev/null 2>&1)
    logBegin
    #FULL=30    From libShell variables list.
    if [ $logLEVEL -eq $logQUIET ] && [ $logTARGET -eq $((logTOFILE + logTOSCREEN)) ] && [ -f "${logFILE}" ] ; then
        echo -n true
        return 0
    else
        echo -n false
        return 1
    fi
}

function test_isLogToScreenEnabled()
{
    if isLogToScreenEnabled
    then
        echo -n true
        return 0
    else
        echo -n false
        return 1
    fi
}

function test_isLogToFileEnabled()
{
    if isLogToFileEnabled
    then
        echo -n true
        return 0
    else
        echo -n false
        return 1
    fi
}

function test_isLogEnabled()
{
    if isLogEnabled
    then
        echo -n true
        return 0
    else
        echo -n false
        return 1
    fi
}

function test_genUUID()
{
    local str="$(genUUID $*)"
    echo -n $(strLength "$str")
    if isAllGraphChar "$str"
    then
        return 0
    else
        return 1
    fi
}

##
# @brief    Print a bar graph
# @param    $1      Line number
#           2       Test result
#           HGREEN  from libShell (highlight green)
#           HRED    from libShell (highlight red)
#           NC      from libShell
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

##
# @brief    Test Table
# @param    param1      1st parameter to function
#           param2      2nd parameter to function
# @return   true|0      Success
#           false|1..N  Error
# @details
#
#          +----------+------------------------------------------------------
#          | Column   | Description
#          +----------+------------------------------------------------------
#          | N        | Line number
#          | ret      | Return success or error code (return n)
#          | res      | Result from function (echo '' or printf '')
#          | function | Function in libShell or a local wapper test_Function
#          | param1   | 1st parameter to function
#          | param2   | 2nd parameter to function
#          | param3   | 3nd parameter to function
#          +----------+------------------------------------------------------

#+---+---------------------------+------------------------------------+------------------------------------------------------+--------+--------+
#| N | return | result           | function                           | param1                                               | param2 | param3 |
declare -a -r testTABLE=(\
01  0 test_libShell.sh             getScriptName                        ''                                                    ''       ''  \
02  0 test_libShell.sh             getFileName                          "/var/home/$USER/dev/libShell/test_libShell.sh"       ''       ''  \
03  1 ''                           getFileName                          ''                                                    ''       ''  \
04  0 test_libShell                getName                              test_libShell.sh                                      ''       ''  \
05  0 test_libShell                getName                              "/var/home/$USER/dev/libShell/test_libShell.sh"       ''       ''  \
06  1 ''                           getName                              ''                                                    ''       ''  \
07  0 sh                           getExt                               test_libShell.sh                                      ''       ''  \
08  0 doc                          getExt                               document.doc                                          ''       ''  \
09  1 ''                           getExt                               ''                                                    ''       ''  \
10  0 "/var/home/$USER/dev/script" getPath                              "/var/home/$USER/dev/script/test_libShell.sh"         ''       ''  \
\
11  0 "/var/home/$USER/dev/script" getPath                              "/var/home/$USER/dev/script/"                         ''       ''  \
12  0 "/var/home/$USER/dev"        getPath                              "/var/home/$USER/dev/script"                          ''       ''  \
13  1 ''                           getPath                              ''                                                    ''       ''  \
14  0 /tmp                         getTempDir                           ''                                                    ''       ''  \
15  0 8                            test_genRandomAlpha                  8                                                     ''       ''  \
16  0 32                           test_genRandomAlpha                  32                                                    ''       ''  \
17  1 0                            test_genRandomAlpha                  ''                                                    ''       ''  \
18  0 8                            test_genRandomNumeric                8                                                     ''       ''  \
19  0 32                           test_genRandomNumeric                32                                                    ''       ''  \
20  1 0                            test_genRandomNumeric                ''                                                    ''       ''  \
\
21  0 8                            test_genRandomAlphaNumeric           8                                                     ''       ''  \
22  0 32                           test_genRandomAlphaNumeric           32                                                    ''       ''  \
23  1 0                            test_genRandomAlphaNumeric           ''                                                    ''       ''  \
24  0 8                            test_genRandomLowerHexadecimalNumber 8                                                     ''       ''  \
25  0 32                           test_genRandomLowerHexadecimalNumber 32                                                    ''       ''  \
26  1 0                            test_genRandomLowerHexadecimalNumber ''                                                    ''       ''  \
27  0 8                            test_genRandomUpperHexadecimalNumber 8                                                     ''       ''  \
28  0 32                           test_genRandomUpperHexadecimalNumber 32                                                    ''       ''  \
29  1 0                            test_genRandomUpperHexadecimalNumber ''                                                    ''       ''  \
30  0 8                            test_genRandomHexadecimalNumber      8                                                     ''       ''  \
\
31  0 32                           test_genRandomHexadecimalNumber      32                                                    ''       ''  \
32  1 0                            test_genRandomHexadecimalNumber      ''                                                    ''       ''  \
33  0 8                            test_genRandomString                 8                                                     ''       ''  \
34  0 32                           test_genRandomString                 32                                                    ''       ''  \
35  1 0                            test_genRandomString                 ''                                                    ''       ''  \
36  0 8                            test_genRandomStringSpace            8                                                     ''       ''  \
37  0 32                           test_genRandomStringSpace            32                                                    ''       ''  \
38  0 64                           test_genRandomStringSpace            64                                                    ''       ''  \
39  0 128                          test_genRandomStringSpace            128                                                   ''       ''  \
40  1 0                            test_genRandomStringSpace            ''                                                    ''       ''  \
\
41  0 23                           test_genDateTimeAsCode               ''                                                    ''       ''  \
42  0 23                           test_genDateTimeAsCode               ''                                                    ''       ''  \
43  0 23                           test_getDateTime                     ''                                                    ''       ''  \
44  0 23                           test_getDateTime                     ''                                                    ''       ''  \
45  0 2.2.3                        getLibVersionStr                     ''                                                    ''       ''  \
46  0 223                          getLibVersionNum                     ''                                                    ''       ''  \
47  0 true                         test_getRuntime                      ''                                                    ''       ''  \
48  0 "/tmp/$(basename $0).log"    getLogFilename                       ''                                                    ''       ''  \
49  0 true                         test_isConnected                     ''                                                    ''       ''  \
50  0 true                         test_isConnected                     ''                                                    ''       ''  \
#\
51  0 true                         test_isYes                           y                                                     ''       ''  \
52  0 true                         test_isYes                           Y                                                     ''       ''  \
53  0 true                         test_isYes                           yes                                                   ''       ''  \
54  0 true                         test_isYes                           Yes                                                   ''       ''  \
55  0 true                         test_isYes                           yEs                                                   ''       ''  \
56  0 true                         test_isYes                           yeS                                                   ''       ''  \
57  0 true                         test_isYes                           YES                                                   ''       ''  \
58  1 false                        test_isYes                           yess                                                  ''       ''  \
59  1 false                        test_isYes                           yyes                                                  ''       ''  \
60  0 true                         test_isNot                           n                                                     ''       ''  \
\
61  0 true                         test_isNot                           N                                                     ''       ''  \
62  0 true                         test_isNot                           not                                                   ''       ''  \
63  0 true                         test_isNot                           Not                                                   ''       ''  \
64  0 true                         test_isNot                           nOt                                                   ''       ''  \
65  0 true                         test_isNot                           noT                                                   ''       ''  \
66  0 true                         test_isNot                           NOT                                                   ''       ''  \
67  1 false                        test_isNot                           nott                                                  ''       ''  \
68  1 false                        test_isNot                           nnot                                                  ''       ''  \
69  0 true                         test_isNot                           no                                                    ''       ''  \
70  0 true                         test_isNot                           No                                                    ''       ''  \
\
71  0 true                         test_isNot                           nO                                                    ''       ''  \
72  0 true                         test_isNot                           NO                                                    ''       ''  \
73  1 false                        test_isNot                           nno                                                   ''       ''  \
74  1 false                        test_isNot                           noo                                                   ''       ''  \
75  0 true                         test_isFloat                         2.1                                                   ''       ''  \
76  0 true                         test_isFloat                         123.456                                               ''       ''  \
77  0 true                         test_isFloat                         0.9                                                   ''       ''  \
78  0 true                         test_isFloat                         -1.2                                                  ''       ''  \
79  0 true                         test_isFloat                         +3.4                                                  ''       ''  \
80  1 false                        test_isFloat                         12                                                    ''       ''  \
\
81  1 false                        test_isFloat                         .12                                                   ''       ''  \
82  1 false                        test_isFloat                         12.                                                   ''       ''  \
83  0 true                         test_isInteger                       1                                                     ''       ''  \
84  1 false                        test_isInteger                       2.1                                                   ''       ''  \
85  1 false                        test_isInteger                       .2                                                    ''       ''  \
86  1 false                        test_isInteger                       1.                                                    ''       ''  \
87  0 true                         test_isInteger                       -1                                                    ''       ''  \
88  0 true                         test_isInteger                       +1                                                    ''       ''  \
89  1 false                        test_isInteger                       +.1                                                   ''       ''  \
90  1 false                        test_isInteger                       +1.                                                   ''       ''  \
\
91  0 ''                           isAlpha                              isAlha                                                ''       ''  \
92  0 ''                           isAlpha                              fHiaeWbnS                                             ''       ''  \
93  1 ''                           isAlpha                              fHiae5WbnS                                            ''       ''  \
94  0 ''                           isDigit                              12345678901234567890                                  ''       ''  \
95  0 ''                           isDigit                              09876543210987654321                                  ''       ''  \
96  1 ''                           isDigit                              123456789a1234567890                                  ''       ''  \
97  0 ''                           isAlphaNumeric                       123456789a1234567890                                  ''       ''  \
98  0 ''                           isAlphaNumeric                       abcdefghi5klmnoptqrt                                  ''       ''  \
99  1 ''                           isAlphaNumeric                       123456789#1234567890                                  ''       ''  \
100 0 ''                           isHexadecimalNumber                  0123456789abcdef                                      ''       ''  \
\
101 0 ''                           isHexadecimalNumber                  abcdef                                                ''       ''  \
102 0 ''                           isHexadecimalNumber                  ABCDEF                                                ''       ''  \
103 0 ''                           isHexadecimalNumber                  ABCDEFabcdef                                          ''       ''  \
104 0 ''                           isHexadecimalNumber                  0123456789ABCDEFabcdef                                ''       ''  \
105 1 ''                           isHexadecimalNumber                  ABCDEFG                                               ''       ''  \
106 1 ''                           isHexadecimalNumber                  abcdefg                                               ''       ''  \
107 1 ''                           isHexadecimalNumber                  0123456789ABCDEFabcdefg                               ''       ''  \
108 0 ''                           isHexadecimalNumber                  ABCDEFabcdef                                          ''       ''  \
109 0 ''                           isLowerHexadecimalNumber             0123456789abcdef                                      ''       ''  \
110 0 ''                           isLowerHexadecimalNumber             abcdef                                                ''       ''  \
\
111 1 ''                           isLowerHexadecimalNumber             0123456789ABCDEFabcdef                                ''       ''  \
112 1 ''                           isLowerHexadecimalNumber             abcdefg                                               ''       ''  \
113 1 ''                           isLowerHexadecimalNumber             0123456789abcdefA                                     ''       ''  \
114 1 ''                           isLowerHexadecimalNumber             abcdefA                                               ''       ''  \
115 1 ''                           isLowerHexadecimalNumber             0123456789abcdefA                                     ''       ''  \
116 0 ''                           isUpperHexadecimalNumber             0123456789ABCDEF                                      ''       ''  \
117 0 ''                           isUpperHexadecimalNumber             ABCDEF                                                ''       ''  \
118 1 ''                           isUpperHexadecimalNumber             0123456789ABCDEFabcdef                                ''       ''  \
119 1 ''                           isUpperHexadecimalNumber             abcdefg                                               ''       ''  \
120 1 ''                           isUpperHexadecimalNumber             0123456789ABCDEFa                                     ''       ''  \
\
121 1 ''                           isUpperHexadecimalNumber             ABCDEFa                                               ''       ''  \
122 1 ''                           isUpperHexadecimalNumber             0123456789ABCDEFa                                     ''       ''  \
123 0 ''                           isAllGraphChar                       "AZaz09'\"\`¹²³£¢¬§ªº°~^?!;:.,@#$%&{[(<>)]}_=+-*/\| " ''       ''  \
124 0 "$PWD/libShell.sh"           followLink                           testLink                                              ''       ''  \
125 1 ''                           followLink                           notExist                                              ''       ''  \
126 0 0                            strLength                            ''                                                    ''       ''  \
127 0 32                           strLength                            abcdefghijklmnopfqrstuvwxyz01234                      ''       ''  \
128 0 10                           strLength                            'A1b4@6^8<0'                                          ''       ''  \
129 0 -5                           strCompare                           one                                                   ten      ''  \
130 0 0                            strCompare                           xyz                                                   xyz      ''  \
\
131 0 14                           strCompare                           omega                                                 alpha    ''  \
132 0 -1                           compareFloat                         1.0                                                   2.0      ''  \
133 0 0                            compareFloat                         123.456                                               123.456  ''  \
134 0 1                            compareFloat                         987.654                                               321.987  ''  \
135 0 912.468000                   addFloat                             123.456                                               789.012  ''  \
136 0 123.456000                   addFloat                             123.456                                               0.0      ''  \
137 0 123.456000                   addFloat                             0.0                                                   123.456  ''  \
138 1 ''                           addFloat                             ''                                                    123.456  ''  \
139 0 665.667000                   subFloat                             987.654                                               321.987  ''  \
140 0 123.456000                   subFloat                             123.456                                               0.0      ''  \
\
141 0 -123.456000                  subFloat                             0.0                                                   123.456  ''  \
142 1 ''                           subFloat                             ''                                                    123.456  ''  \
143 0 10.000000                    multiplyFloat                        2.0                                                   5.0      ''  \
144 0 10.000000                    multiplyFloat                        5.0                                                   2.0      ''  \
145 0 -12.750000                   multiplyFloat                        -2.5                                                  5.1      ''  \
146 1 ''                           multiplyFloat                        2.0                                                   ''       ''  \
147 0 5.000000                     divFloat                             10.0                                                  2.0      ''  \
148 0 2.000000                     divFloat                             100.0                                                 50.0     ''  \
149 1 ''                           divFloat                             10.0                                                  0.0      ''  \
150 1 ''                           divFloat                             10.0                                                  ''       ''  \
\
151 0 true                         isFloatInRange                       1.2                                                   1.0      2.0 \
152 0 true                         isFloatInRange                       1.7                                                   2.0      1.0 \
153 0 false                        isFloatInRange                       2.1                                                   1.0      2.0 \
154 0 false                        isFloatInRange                       2.1                                                   2.0      1.0 \
155 0 true                         isFloatInRange                       -1.2                                                  -1.0    -2.0 \
156 0 true                         isFloatInRange                       -1.7                                                  -2.0    -1.0 \
157 0 false                        isFloatInRange                       -2.1                                                  -1.0    -2.0 \
158 0 false                        isFloatInRange                       -2.1                                                  -2.0    -1.0 \
159 1 ''                           isGitRepository                      /tmp                                                  ''       ''  \
160 1 ''                           isGitRepository                      ''                                                    ''       ''  \
\
161 0 ''                           isGitRepository                      "$PWD"                                                ''       ''  \
162 1 ''                           gitRepositoryName                    /tmp                                                  ''       ''  \
163 0 libShell                     gitRepositoryName                    "$PWD"                                                ''       ''  \
164 0 true                         test_isGitChanged                    "$PWD"                                                ''       ''  \
165 0 true                         test_isGitChanged                    "$HOME/dev/libShell"                                  ''       ''  \
166 1 false                        test_isGitChanged                    /tmp                                                  ''       ''  \
167 0 true                         test_linkExist                       testLink                                              ''       ''  \
168 1 false                        test_linkExist                       notLink                                               ''       ''  \
169 0 true                         test_itExist                         /tmp                                                  ''       ''  \
170 0 true                         test_itExist                         testLink                                              ''       ''  \
\
171 1 false                        test_itExist                         noLink                                                ''       ''  \
172 0 fedora                       getID                                ''                                                    ''       ''  \
173 0 1.2.3                        genVersionStr                        '1 2 3'                                               ''       ''  \
174 0 123                          genVersionNum                        '1 2 3'                                               ''       ''  \
175 1 ''                           libSetup                             -x                                                    ''       ''  \
176 0 ''                           libSetup                             -h                                                    ''       ''  \
177 0 ''                           libSetup                             -q                                                    ''       ''  \
178 1 ''                           libSetup                             -q                                                    1        ''  \
189 0 ''                           libSetup                             -d                                                    ''       ''  \
180 1 ''                           libSetup                             -d                                                    2        ''  \

181 0 ''                           libSetup                             -v                                                    ''       ''  \
182 1 ''                           libSetup                             -v                                                    3        ''  \
183 1 ''                           libSetup                             -l                                                   -err      ''  \
184 0 ''                           libSetup                             -l                                                    ''       ''  \
185 0 ''                           libSetup                             -l                                                   -v        ''  \
186 0 ''                           libSetup                             -l                                                    0        ''  \
187 0 ''                           libSetup                             -l                                                    1        ''  \
188 0 ''                           libSetup                             -l                                                    2        ''  \
189 0 ''                           libSetup                             -l                                                    3        ''  \
190 1 ''                           libSetup                             -l                                                    4        ''  \
\
191 1 ''                           libSetup                             -T                                                    ''       ''  \
292 1 ''                           libSetup                             -T                                                   -err      ''  \
193 1 ''                           libSetup                             -T                                                   -10       ''  \
194 0 ''                           libSetup                             -T                                                    10       ''  \
195 0 true                         test_isParameter                     -a                                                    ''       ''  \
196 0 true                         test_isParameter                     --a                                                   ''       ''  \
197 0 true                         test_isParameter                     ---a                                                  ''       ''  \
198 1 false                        test_isParameter                     a                                                     ''       ''  \
199 1 false                        test_isParameter                     1                                                     ''       ''  \
\
200 1 false                        test_isParameter                     ''                                                    ''       ''  \
201 0 true                         test_isArgValue                      1                                                     ''       ''  \
202 0 true                         test_isArgValue                      1.2                                                   ''       ''  \
203 1 false                        test_isArgValue                      -a                                                    ''       ''  \
204 1 false                        test_isArgValue                      --a                                                   ''       ''  \
205 1 false                        test_isArgValue                      ''                                                    ''       ''  \
206 0 8                            test_genRandom                       alpha                                                 8        ''  \
207 0 32                           test_genRandom                       alpha                                                 32       ''  \
208 0 128                          test_genRandom                       alpha                                                 128      ''  \
209 0 8                            test_genRandom                       digit                                                 8        ''  \
210 0 32                           test_genRandom                       digit                                                 32       ''  \
\
211 0 128                          test_genRandom                       digit                                                 128      ''  \
212 0 8                            test_genRandom                       alnum                                                 8        ''  \
213 0 32                           test_genRandom                       alnum                                                 32       ''  \
214 0 128                          test_genRandom                       alnum                                                 128      ''  \
215 0 8                            test_genRandom                       lowhex                                                8        ''  \
216 0 32                           test_genRandom                       lowhex                                                32       ''  \
217 0 128                          test_genRandom                       lowhex                                                128      ''  \
218 0 8                            test_genRandom                       uphex                                                 8        ''  \
219 0 32                           test_genRandom                       uphex                                                 32       ''  \
220 0 128                          test_genRandom                       uphex                                                 128      ''  \
\
221 0 8                            test_genRandom                       mixhex                                                8        ''  \
222 0 32                           test_genRandom                       mixhex                                                32       ''  \
223 0 128                          test_genRandom                       mixhex                                                128      ''  \
224 0 8                            test_genRandom                       random                                                8        ''  \
225 0 32                           test_genRandom                       random                                                32       ''  \
226 0 128                          test_genRandom                       random                                                128      ''  \
227 0 8                            test_genRandom                       space                                                 8        ''  \
228 0 32                           test_genRandom                       space                                                 32       ''  \
229 0 128                          test_genRandom                       space                                                 128      ''  \
230 0 23                           test_genRandom                       date                                                  0        ''  \
\
231 0 FAILURE                           genUUID                         ''                                                    ''       ''  \
232 0 8                            test_genUUID                         alpha                                                 8        ''  \
233 0 13                           test_genUUID                         alpha                                                 8        4   \
234 0 49                           test_genUUID                         alpha                                                 16       32  \
235 0 8                            test_genUUID                         digit                                                 8        ''  \
236 0 13                           test_genUUID                         digit                                                 8        4   \
237 0 49                           test_genUUID                         digit                                                 16       32  \
238 0 8                            test_genUUID                         alnum                                                 8        ''  \
239 0 13                           test_genUUID                         alnum                                                 8        4   \
240 0 49                           test_genUUID                         alnum                                                 16       32  \
\
241 0 8                            test_genUUID                         lowhex                                                8        ''  \
242 0 13                           test_genUUID                         lowhex                                                8        4   \
243 0 49                           test_genUUID                         lowhex                                                16       32  \
244 0 8                            test_genUUID                         uphex                                                 8        ''  \
245 0 13                           test_genUUID                         uphex                                                 8        4   \
246 0 49                           test_genUUID                         uphex                                                 16       32  \
247 0 8                            test_genUUID                         mixhex                                                8        ''  \
248 0 13                           test_genUUID                         mixhex                                                8        4   \
249 0 49                           test_genUUID                         mixhex                                                16       32  \
250 0 8                            test_genUUID                         random                                                8        ''  \
\
251 0 13                           test_genUUID                         random                                                8        4   \
252 0 49                           test_genUUID                         random                                                16       32  \
253 0 8                            test_genUUID                         space                                                 8        ''  \
254 0 13                           test_genUUID                         space                                                 8        4   \
255 0 49                           test_genUUID                         space                                                 16       32  \
256 0 23                           test_genUUID                         date                                                  0        ''  \
257 0 /media                       getMountDir                          ''                                                    ''       ''  \
258 0 ''                           libSetup                             -l                                                    0        ''  \
259 0 true                         test_logStart_0                      ''                                                    ''       ''  \
260 0 ''                           logBegin                             ''                                                    ''       ''  \
\
261 0 ''                           libSetup                             -l                                                    ''       ''  \
262 0 true                         test_logStart_1                      ''                                                    ''       ''  \
263 0 ''                           logBegin                             ''                                                    ''       ''  \
264 0 ''                           libSetup                             -l                                                    ''       ''  \
265 0 true                         test_logStart_2                      ''                                                    ''       ''  \
266 0 ''                           logBegin                             ''                                                    ''       ''  \
267 0 ''                           libSetup                             -l                                                    ''       ''  \
268 0 true                         test_logStart_3                      ''                                                    ''       ''  \
269 0 ''                           logBegin                             ''                                                    ''       ''  \
270 0 ''                           libStop                              ''                                                    ''       ''  \
\
271 1 ''                           libSetup                             -x                                                    ''       ''  \
272 0 ''                           libSetup                             -l                                                    ''       ''  \
273 1 ''                           libSetup                             -l                                                   -1        ''  \
274 0 ''                           libSetup                             -l                                                    0        ''  \
275 0 ''                           libSetup                             -l                                                    1        ''  \
276 0 ''                           libSetup                             -l                                                    2        ''  \
277 0 ''                           libSetup                             -l                                                    3        ''  \
278 1 ''                           libSetup                             -l                                                    4        ''  \
279 1 ''                           libSetup                             -l                                                    a        ''  \
280 1 ''                           libSetup                             -q                                                    a        ''  \
\
281 0 ''                           libSetup                             -q                                                    ''       ''  \
282 1 ''                           libSetup                             +q                                                    a        ''  \
283 1 ''                           libSetup                             +q                                                    ''       ''  \
284 1 ''                           libSetup                             -v                                                    a        ''  \
285 0 ''                           libSetup                             -v                                                    ''       ''  \
286 1 ''                           libSetup                             +v                                                    a        ''  \
287 1 ''                           libSetup                             +v                                                    ''       ''  \
288 1 ''                           libSetup                             -g                                                    a        ''  \
289 0 ''                           libSetup                             -g                                                    ''       ''  \
290 1 ''                           libSetup                             +g                                                    a        ''  \
\
291 1 ''                           libSetup                             +g                                                    ''       ''  \
292 1 ''                           libSetup                             -t                                                    a        ''  \
293 0 ''                           libSetup                             -t                                                    ''       ''  \
294 1 ''                           libSetup                             +t                                                    a        ''  \
295 1 ''                           libSetup                             +t                                                    ''       ''  \
296 1 ''                           libSetup                              a                                                    a        ''  \
207 1 ''                           libSetup                             -T                                                    ''       ''  \
298 1 ''                           libSetup                             -T                                                    a        ''  \
299 0 ''                           libSetup                             -T                                                    1        ''  \
300 1 ''                           libSetup                             -T                                                    -1       ''  \
\
301 1 ''                           libSetup                             -T                                                    1.0      ''  \
302 1 ''                           libSetup                             -T                                                    -q       ''  \
303 0 1234.56.78                   genDateVersionStr                    '1234 56 78'                                           ''      ''  \
304 0 8765043021                   genDateVersionNum                    '8765 43 21'                                           ''      ''  \
305 0 2025.09.10                   getLibDateVersionStr                 ''                                                     ''      ''  \
306 0 2025009010                   getLibDateVersionNum                 ''                                                     ''      ''  \
307 0 silverblue                   getDistroName                        ''                                                     ''      ''  \
308 0 ''                           libInit                              ''                                                     ''      ''  \
)
#| N | return | result           | function                           | param1                                               | param2 | param3 |
#+---+---------------------------+------------------------------------+------------------------------------------------------+--------+--------+

##
# @brief    Run main function to test libShell.sh library.
# @param    $@  All command line parameters.
# @return   0   Success
#           1   Error
# @details      Run a list of functions in a table and pass
#               some parameters to it and check its results.
#               Print a bar graph according to its results and
#               log message about the total of success or errors.

source libShell.sh || { logFail "Load libShell"   ; exit 1 ; }
libInit            || { logFail "Call libInit()"  ; exit 1 ; }
libSetup "$@"      ||   logFail "Call libSetup( $@ )"
logBegin           ||   logFail "Call logBegin()"

LINE=0
offset=0
iFunc=$((offset+iFUNC))
while [ -n "${testTABLE[ $iFunc ]}" ] ; do
    iRet=$((offset+iRET))
    iRes=$((offset+iRES))
    iParam1=$((offset+iPARAM1))
    iParam2=$((offset+iPARAM2))
    iParam3=$((offset+iPARAM3))
    # avoid commented lines.
    [[ "${testTABLE[offset]:0:1}" == "#" ]] && continue
    # log Debug
    logDebug "Line: $LINE"
    logDebug "Run: ${testTABLE[ $iFunc ]}() ${testTABLE[ $iParam1 ]} ${testTABLE[ $iParam2 ]} ${testTABLE[ $iParam3 ]}"
    res="$( ${testTABLE[ $iFunc ]} "${testTABLE[ $iParam1 ]}" "${testTABLE[ $iParam2 ]}" "${testTABLE[ $iParam3 ]}" )"
    ret=$?
    logDebug "Function Ret: '$ret' compare to Table Ret: '${testTABLE[ $iRet ]}' "
    logDebug "Function Res: '$res' compare to Table Res: '${testTABLE[ $iRes ]}' "
    RES=true
    if [ -n "${testTABLE[ $iRet ]}" ] && [ -n "${testTABLE[ $iRes ]}" ]
    then
        if [ $ret -eq ${testTABLE[ $iRet ]} ] && [[ "$res" == "${testTABLE[ $iRes ]}" ]]
        then
            let OK++
        else
            let ERR++
            RES=false
        fi
    elif [ -n "${testTABLE[ $iRet ]}" ]
    then
        if [ $ret -eq ${testTABLE[ $iRet ]} ]
        then
            let OK++
        else
            let ERR++
            RES=false
        fi
    elif [ -n "${testTABLE[ $iRes ]}" ]
    then
        if [[ "$res" == "${testTABLE[ $iRes ]}" ]]
        then
            let OK++
        else
            let ERR++
            RES=false
        fi
    else
        logFail "testTABLE iRES and iRET columns are empty."
    fi
    let LINE++
    barGraph $LINE $RES
    offset=$((LINE*iMAX))
    iFunc=$((offset+iFUNC))
done
echo

if [ $OK  -gt 0 ] ; then logOk "${HGREEN}$OK${NC} Test(s)" ; fi
if [ $ERR -gt 0 ] ; then logFail "${HRED}$ERR${NC} Test(s)"  ; fi

########################################
## Area 51 (restrict for special tests)

########################################

logEnd     || logFail "Call logEnd()"
libStop    || logFail "Call libStop()"
_unsetVars || logFail "Call _unsetVars()"

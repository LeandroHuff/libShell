#!/usr/bin/env bash

################################################################################
# @brief		Shell script to test libShell Library                          #
# @file			test_libShell.sh                                               #
# @author		Leandro - leandrohuff@programmer.net                           #
# @date			2025-08-25                                                     #
# @version		2.0.0                                                          #
# @copyright	CC01 1.0 Universal                                             #
# @details		Run a set of tests stored in a tatble to call libShell         #
#				functions and pass some parameters to check its results.       #
#				Syntax: test_libShell.sh -v                                    #
#				Where: -v  show more verbose message about test results        #
#				Functions or variables started with underline char (_) is a    #
#				local name and the underline is to avoid conflict with the     #
#				libShell name's.
################################################################################

## @brief	Load libShell file and its content, any error, log and exit.
source libShell.sh || { logF "Load libShell"   ; exit 1 ; }
## @brief	Start libShell and pass all command line parameters, any error, log and exit.
libStart -v        || { logF "Call libStart()" ; exit 1 ; }

## @brief	Set global variables for local use.
declare i iRES=1
declare i iFUNC=2
declare i iPARAM1=3
declare i iPARAM2=4
declare i iMAX=5
declare i LINE=0
declare i OK=0
declare i ERR=0
declare i RES=0

##
# @brief	Test Table
# @param	param1		1st parameter to function
#			param2		2nd parameter to function
# @return	true|0		Success
#			false|1..N	Error
# @details
#
#          +----------+------------------------------------------------------
#          | Column   | Description
#          +----------+------------------------------------------------------
#          | N        | Line number
#          | ret|res  | Return value or result from function
#          | function | Function in libShell
#          | param1   | 1st parameter to function
#          | param2   | 2nd parameter to function
#          +----------+------------------------------------------------------
#
#+---+---------------------------+--------------------+---------------------------------------------+--------+
#| N | return|result             | function           | param1                                      | param2 |
declare -a testTABLE=(\
01  'test_libShell.sh'           'getScriptName'      ''                                            '' \
02  'test_libShell.sh'           'getFileName'        "/var/home/$USER/dev/script/test_libShell.sh" '' \
03  'libShell.sh'                'getFileName'        "/var/home/$USER/dev/script/libShell.sh"      '' \
04  'test_libShell'              'getName'            'test_libShell.sh'                            '' \
05  'test_libShell'              'getName'            'test_libShell.sh'                            '' \
06  'sh'                         'getExt'             'test_libShell.sh'                            '' \
07  'doc'                        'getExt'             'document.doc'                                '' \
08  "/var/home/$USER/dev/script" 'getPath'            "/var/home/$USER/dev/script/test_libShell.sh" '' \
09  '2.0.0'                      'getVersionStr'      ''                                            '' \
10  200                          'getVersionNum'      ''                                            '' \
11  0                            'test_getRuntime'    ''                                            '' \
12  "/tmp/$(basename $0).log"    'getLogFilename'     ''                                            '' \
13  "$ID"                        'getID'              ''                                            '' \
14  0                            'test_isFloat'       2.1                                           '' \
15  0                            'test_isFloat'       123.456                                       '' \
16  0                            'test_isFloat'       0.9                                           '' \
17  0                            'test_isFloat'       -1.2                                          '' \
18  0                            'test_isFloat'       +3.4                                          '' \
19  1                            'test_isFloat'       12                                            '' \
20  1                            'test_isFloat'       .12                                           '' \
21  1                            'test_isFloat'       12.                                           '' \
22  0                            'test_isInteger'     1                                             '' \
23  1                            'test_isInteger'     2.1                                           '' \
24  1                            'test_isInteger'     .2                                            '' \
25  1                            'test_isInteger'     1.                                            '' \
26  0                            'test_isInteger'     -1                                            '' \
27  0                            'test_isInteger'     +1                                            '' \
28  1                            'test_isInteger'     +.1                                           '' \
29  1                            'test_isInteger'     +1.                                           '' \
30  0                            'test_isYes'         'y'                                           '' \
31  0                            'test_isYes'         'Y'                                           '' \
32  0                            'test_isYes'         'yes'                                         '' \
33  0                            'test_isYes'         'Yes'                                         '' \
34  0                            'test_isYes'         'yEs'                                         '' \
35  0                            'test_isYes'         'yeS'                                         '' \
36  0                            'test_isYes'         'YES'                                         '' \
37  1                            'test_isYes'         'yess'                                        '' \
38  1                            'test_isYes'         'yyes'                                        '' \
39  0                            'test_isNot'         'n'                                           '' \
40  0                            'test_isNot'         'N'                                           '' \
41  0                            'test_isNot'         'not'                                         '' \
42  0                            'test_isNot'         'Not'                                         '' \
43  0                            'test_isNot'         'nOt'                                         '' \
44  0                            'test_isNot'         'noT'                                         '' \
45  0                            'test_isNot'         'NOT'                                         '' \
46  1                            'test_isNot'         'nott'                                        '' \
47  1                            'test_isNot'         'nnot'                                        '' \
48  0                            'test_isNot'         'no'                                          '' \
49  0                            'test_isNot'         'No'                                          '' \
50  0                            'test_isNot'         'nO'                                          '' \
51  0                            'test_isNot'         'NO'                                          '' \
52  1                            'test_isNot'         'nno'                                         '' \
53  1                            'test_isNot'         'noo'                                         '' \
54  0                            'test_isConnected'   ''                                            '' \
55  0                            'test_isConnected'   ''                                            '' \
56  0                            'test_getRuntimeStr' ''                                            '' \
57  0                            'test_isParameter'   '-a'                                          '' \
58  0                            'test_isParameter'   '--a'                                         '' \
59  0                            'test_isParameter'   '---a'                                        '' \
60  1                            'test_isParameter'   'a'                                           '' \
61  1                            'test_isParameter'   '1'                                           '' \
62  1                            'test_isParameter'   ''                                            '' \
63  0                            'testt_isArgValue'   '1'                                           '' \
64  0                            'testt_isArgValue'   '1.2'                                         '' \
65  1                            'testt_isArgValue'   '-a'                                          '' \
66  1                            'testt_isArgValue'   '--a'                                         '' \
67  1                            'testt_isArgValue'   ''                                            '' \
68  '/media'                     'getMountDir'        ''                                            '' \
69  1                            'libStart'           '-x'                                          '' \
70  1                            'libStart'           '-l'                                          '' \
71  1                            'libStart'           '-l'                                          -1 \
72  0                            'libStart'           '-l'                                          0  \
73  0                            'libStart'           '-l'                                          1  \
74  0                            'libStart'           '-l'                                          2  \
75  0                            'libStart'           '-l'                                          3  \
76  1                            'libStart'           '-l'                                          4  \
77  1                            'libStart'           '-l'                                         'a' \
78  1                            'libStart'           '-q'                                         'a' \
79  0                            'libStart'           '-q'                                          '' \
80  1                            'libStart'           '+q'                                         'a' \
81  0                            'libStart'           '+q'                                          '' \
82  1                            'libStart'           '-v'                                         'a' \
83  0                            'libStart'           '-v'                                          '' \
84  1                            'libStart'           '+v'                                         'a' \
85  0                            'libStart'           '+v'                                          '' \
86  1                            'libStart'           '-g'                                         'a' \
87  0                            'libStart'           '-g'                                          '' \
88  1                            'libStart'           '+g'                                         'a' \
89  0                            'libStart'           '+g'                                          '' \
90  1                            'libStart'           '-t'                                         'a' \
91  0                            'libStart'           '-t'                                          '' \
92  1                            'libStart'           '+t'                                         'a' \
93  0                            'libStart'           '+t'                                          '' \
94  1                            'libStart'           'a'                                          'a' \
95  1                            'libStart'           '-T'                                          '' \
96  1                            'libStart'           '-T'                                         'a' \
97  0                            'libStart'           '-T'                                         '1' \
98  1                            'libStart'           '-T'                                        '-1' \
99  1                            'libStart'           '-T'                                       '1.0' \
100 1                            'libStart'           '-T'                                        '-q' \
101 0                            'libStart'           '-l'                                          0  \
102 0                            'test_logStart_0'    ''                                            '' \
103 0                            'logEnd'             ''                                            '' \
104 0                            'libStart'           '-l'                                          1  \
105 0                            'test_logStart_1'    ''                                            '' \
106 0                            'logEnd'             ''                                            '' \
107 0                            'libStart'           '-l'                                          2  \
108 0                            'test_logStart_2'    ''                                            '' \
109 0                            'logEnd'             ''                                            '' \
110 0                            'libStart'           '-l'                                          3  \
111 0                            'test_logStart_3'    ''                                            '' \
112 0                            'logEnd'             ''                                            '' \
113 0                            'libStop'            ''                                            '' \
)
#| N | return                    | function           | param1                                      | param2 |
#+---+---------------------------+--------------------+---------------------------------------------+--------+

## @brief	Unset global test variables, not in libShell, for libShell call libEnd() function.
function _unsetVars
{
	unset -v iRES
	unset -v iFUNC
	unset -v iPARAM1
	unset -v iPARAM2
	unset -v iMAX
	unset -v LINE
	unset -v OK
	unset -v ERR
	unset -v RES
	unset -v testTABLE
}

##
# @brief	Test getRuntime() function.
# @param	none
# @return	0	Success
# 			1	Error
# @details		Take 2 runtime value in 1 second interval,
#				check the interval time between runtimes,
#				compare, check the range and return the result.
function test_getRuntime()
{
	declare -i beforeSleep=$(getRuntime)
	sleep 1
	declare -i afterSleep=$(getRuntime)
	declare -i diff=$((afterSleep - beforeSleep))
	if [ $afterSleep -gt $beforeSleep ] && [ $diff -ge 1000 ] && [ $diff -lt 1020 ] ; then
		echo -n 0
	else
		echo -n 1
	fi
}

## @brief	Call isInteger() function passing a parameter and return 0 for success or 1 for error.
function test_isInteger() { if isInteger "$1" ; then echo -n 0 ; else echo -n 1 ; fi ; }

## @brief	Call isFloat() function passing a parameter and return 0 for success or 1 for error.
function test_isFloat()   { if isFloat   "$1" ; then echo -n 0 ; else echo -n 1 ; fi ; }

## @brief	Call isYes() function passing a parameter and return 0 for success or 1 for error.
function test_isYes()     { if isYes     "$1" ; then echo -n 0 ; else echo -n 1 ; fi ; }

## @brief	Call isNot() function passing a parameter and return 0 for success or 1 for error.
function test_isNot()     { if isNot     "$1" ; then echo -n 0 ; else echo -n 1 ; fi ; }

##
# @brief	Call isConnected() function and compare with a local value.
# @param	none
# @return	0	Success
#			1	Error
function test_isConnected
{
    local connected=$(ping 8.8.8.8 -q -t 10 -c 1 > /dev/null 2>&1 && true || false)
    if $connected && isConnected ; then
        echo -n 0
    elif ! $connected && ! isConnected ; then
        echo -n 0
    else
        echo -n 1
    fi
}

##
# @brief   Test getRuntimeStr() function.
# @param	none
# @return	0	Success
# 			1	Error
# @details		Take 2 runtime value in 1 second interval,
#               check the interval time between runtimes,
#               compare 2 float values using an external program,
#               check the range and return the result.
#				bin/subfloat is a binary program to compare 2
#               double parameters and return:
#				-1 for 1st less    than 2nd
#               0  for 1st equal   to 2nd
#				1  for 1st greater than 2nd
function test_getRuntimeStr()
{
    declare beforeSleep=$(getRuntimeStr)
	sleep 1
	declare afterSleep=$(getRuntimeStr)
	declare diff=$(bin/subfloat "$afterSleep" "$beforeSleep")
	if [ $(bin/cmpfloat "$diff" "1.000000") -gt 0 ] && [ $(bin/cmpfloat '1.020000' "$diff") -gt 0 ] ; then
		echo -n 0
	else
		echo -n 1
	fi
}

## @brief	Call isParameter() function passing a parameter and return 0 for success or 1 for error.
function test_isParameter() { if isParameter "$1" ; then echo 0 ; else echo 1 ; fi ; }

## @brief	Call isArgValue() function passing a parameter and return 0 for success or 1 for error.
function testt_isArgValue() { if isArgValue  "$1" ; then echo 0 ; else echo 1 ; fi ; }

## 
# @brief	Test logStart() function and log filename presence.
# @param	none
# @return	0	Success
#			1	Error
# @details		Call libStart() and pass some parameters to set log flags,
#				Call logStart() and check log flags and log file presence.
#				Return 0 for success and 1 for any error, these results
#				will be compared at end of test.

## @brief	Test logStart() function by libStart -l 0 parameters.
function test_logStart_0()
{
    libStart -q -l 0 || return 2
    $(rm -f "$(getLogFilename)" > /dev/null 2>&1)
    logStart
	#DISABLED=0	From libShell variables list.
    if [ $LOG -eq $DISABLED ] && ! [ -f "${LOGFILE}" ] ; then
        return 0
    else
        return 1
    fi
}

## @brief	Test logStart() function by libStart -l 1 parameters.
function test_logStart_1()
{
    libStart -q -l 1 || return 2
    $(rm -f "$(getLogFilename)" > /dev/null 2>&1)
    logStart
	#SCREEN=10	From libShell variables list.
    if [ $((LOG - (LOG % $SCREEN))) -eq $SCREEN ] && ! [ -f "${LOGFILE}" ] ; then
        return 0
    else
        return 1
    fi
}

## @brief	Test logStart() function by libStart -l 2 parameters.
function test_logStart_2()
{
    libStart -q -l 2 || return 2
    $(rm -f "$(getLogFilename)" > /dev/null 2>&1)
    logStart
	#FILE=20	From libShell variables list.
    if [ $((LOG - (LOG % $FILE))) -eq $FILE ] && [ -f "${LOGFILE}" ] ; then
        return 0
    else
        return 1
    fi
}

## @brief	Test logStart() function by libStart -l 3 parameters.
function test_logStart_3()
{
    libStart -q -l 3 || return 2
    $(rm -f "$(getLogFilename)" > /dev/null 2>&1)
    logStart
	#FULL=30	From libShell variables list.
    if [ $((LOG - (LOG % $FULL))) -eq $FULL ] && [ -f "${LOGFILE}" ] ; then
        return 0
    else
        return 1
    fi
}

##
# @brief	Print a bar graph
# @param	$1		Line number
#			$2		Test result
#			HGREEN	from libShell (highlight green)
#			HRED	from libShell (highlight red)
#			NC		from libShell
function barGraph()
{
	local num=$1
	local ok=$2
	# print '*' green for ok and red for not ok.
	if $ok ; then printf "${HGREEN}*${NC}" ; else printf "${HRED}*${NC}" ; fi
	# print [N] at module 10 and '|' at module 5
	if   [ $((num % 10)) -eq 0 ] ; then printf "[%3d]" $num
	elif [ $((num %  5)) -eq 0 ] ; then printf '|' ; fi
	# echo a new line at module 50
	if   [ $((num % 50)) -eq 0 ] ; then echo ; fi
}

##
# @brief	Run main function to test libShell.sh library.
# @param	$@	All command line parameters.
# @return	0	Success
#			1	Error
# @details		Run a list of functions in a table passing
#				some parameters and check its retults.
#				Print a bar graph according to its results and
#				a log message about the total of success or errors.
function runScript()
{
	local status res ret idx offset iRes iFunc iParam1 iParam2
	offset=$((LINE*iMAX))
	iRes=$((offset+iRES))
	iFunc=$((offset+iFUNC))
	iParam1=$((offset+iPARAM1))
	iParam2=$((offset+iPARAM2))
	while [ -n "${testTABLE[ $iFunc ]}" ] ; do
		let LINE++
		# log Trace
		logT "ret: ${testTABLE[ $iRes ]}"
		logT "function: ${testTABLE[ $iFunc ]}()"
		logT "param1: ${testTABLE[ $iParam1 ]}"
		logT "param2: ${testTABLE[ $iParam2 ]}"
		# log Debug
		logD "run ${testTABLE[ $iFunc ]}() ${testTABLE[ $iParam1 ]} ${testTABLE[ $iParam2 ]}"
		ret="$( ${testTABLE[ $iFunc ]} "${testTABLE[ $iParam1 ]}" "${testTABLE[ $iParam2 ]}" )"
		res=$?
		# log Trace
		logT "ret:'$ret'"
		logT "res: $res"
		logT "compared to:\"${testTABLE[ $iRes ]}\" "
		if [[ "$ret" == "${testTABLE[ $iRes ]}" ]] || [ $res -eq ${testTABLE[ $iRes ]} ]
		then
			let OK++
			RES=true
		else
			let ERR++
			RES=false
		fi
		barGraph $LINE $RES
		offset=$((LINE*iMAX))
		iRes=$((offset+iRES))
		iFunc=$((offset+iFUNC))
		iParam1=$((offset+iPARAM1))
		iParam2=$((offset+iPARAM2))
		sleep 0.1
	done
	echo
	# log Info
	if [ $OK  -gt 0 ] ; then logS "${HGREEN}$OK${NC} Test(s)" ; fi
	# log Failure
	if [ $ERR -gt 0 ] ; then logF "${HRED}$ERR${NC} Test(s)" ; fi

	return 0
}

## @brief	Call main function and pass all command line parameters.
runScript "$@"
RES=$?

# log result code message.
logI "Exit code ($RES) from runScript() function."

# call function to unset all global variables.
_unsetVars

# call libStop() function to finish libShell library.
libStop

# return error code from runScript()
exit $RES

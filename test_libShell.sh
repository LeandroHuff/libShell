#!/usr/bin/env bash

##
# @brief		Shell script to test libShell Library                          #
# @file			test_libShell.sh                                               #
# @author		Leandro - leandrohuff@programmer.net                           #
# @date			2025-08-25                                                     #
# @version		2.0.1                                                          #
# @date			2025-08-26                                                     #
# @version		2.0.1                                                          #
# @copyright	CC01 1.0 Universal                                             #
# @details		Run a set of tests stored in a tatble to call libShell         #
#				functions and pass some parameters to check its results.       #
#				Syntax: test_libShell.sh -v                                    #
#				Where: -v  show more verbose message about test results        #
#				Functions or variables started with underline char (_) is a    #
#				local name and the underline is to avoid conflict with the     #
#				libShell name's.

declare -a -i -r testVERSION=(2 0 1)

## @brief	Load libShell file and its content, any error, log and exit.
source libShell.sh || { logF "Load libShell"   ; exit 1 ; }
## @brief	Start libShell and pass all command line parameters, any error, log and exit.
libInit -v "$@"   || { logF "Call libInit()" ; exit 1 ; }

## @brief	Set global variables for local use.
declare -i -r iRES=1
declare -i -r iFUNC=2
declare -i -r iPARAM1=3
declare -i -r iPARAM2=4
declare -i -r iMAX=5
declare -i    LINE=0
declare -i    OK=0
declare -i    ERR=0
declare       RES

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
declare -a -r testTABLE=(\
01  'test_libShell'              'getScriptName'      ''                                            ''    \
02  'test_libShell.sh'           'getFileName'        "/var/home/$USER/dev/script/test_libShell.sh" ''    \
03  'libShell.sh'                'getFileName'        "/var/home/$USER/dev/script/libShell.sh"      ''    \
04  'test_libShell'              'getName'            'test_libShell.sh'                            ''    \
05  'test_libShell'              'getName'            'test_libShell.sh'                            ''    \
06  'sh'                         'getExt'             'test_libShell.sh'                            ''    \
07  'doc'                        'getExt'             'document.doc'                                ''    \
08  "/var/home/$USER/dev/script" 'getPath'            "/var/home/$USER/dev/script/test_libShell.sh" ''    \
09  1.2.3                        'genVersionStr'      '1 2 3'                                       ''    \
10  123                          'genVersionNum'      '1 2 3'                                       ''    \
11  2.2.0                        'getLibVersionStr'   ''                                            ''    \
12  220                          'getLibVersionNum'   ''                                            ''    \
13  0                            'test_getRuntime'    ''                                            ''    \
14  "/tmp/$(basename $0).log"    'getLogFilename'     ''                                            ''    \
15  "$ID"                        'getID'              ''                                            ''    \
16  0                            'test_isFloat'       2.1                                           ''    \
17  0                            'test_isFloat'       123.456                                       ''    \
18  0                            'test_isFloat'       0.9                                           ''    \
19  0                            'test_isFloat'       -1.2                                          ''    \
20  0                            'test_isFloat'       +3.4                                          ''    \
21  1                            'test_isFloat'       12                                            ''    \
22  1                            'test_isFloat'       .12                                           ''    \
23  1                            'test_isFloat'       12.                                           ''    \
24  0                            'test_isInteger'     1                                             ''    \
25  1                            'test_isInteger'     2.1                                           ''    \
26  1                            'test_isInteger'     .2                                            ''    \
27  1                            'test_isInteger'     1.                                            ''    \
28  0                            'test_isInteger'     -1                                            ''    \
29  0                            'test_isInteger'     +1                                            ''    \
30  1                            'test_isInteger'     +.1                                           ''    \
31  1                            'test_isInteger'     +1.                                           ''    \
32  0                            'test_isYes'         'y'                                           ''    \
33  0                            'test_isYes'         'Y'                                           ''    \
34  0                            'test_isYes'         'yes'                                         ''    \
35  0                            'test_isYes'         'Yes'                                         ''    \
36  0                            'test_isYes'         'yEs'                                         ''    \
37  0                            'test_isYes'         'yeS'                                         ''    \
38  0                            'test_isYes'         'YES'                                         ''    \
39  1                            'test_isYes'         'yess'                                        ''    \
40  1                            'test_isYes'         'yyes'                                        ''    \
41  0                            'test_isNot'         'n'                                           ''    \
42  0                            'test_isNot'         'N'                                           ''    \
43  0                            'test_isNot'         'not'                                         ''    \
44  0                            'test_isNot'         'Not'                                         ''    \
45  0                            'test_isNot'         'nOt'                                         ''    \
46  0                            'test_isNot'         'noT'                                         ''    \
47  0                            'test_isNot'         'NOT'                                         ''    \
48  1                            'test_isNot'         'nott'                                        ''    \
49  1                            'test_isNot'         'nnot'                                        ''    \
50  0                            'test_isNot'         'no'                                          ''    \
51  0                            'test_isNot'         'No'                                          ''    \
52  0                            'test_isNot'         'nO'                                          ''    \
53  0                            'test_isNot'         'NO'                                          ''    \
54  1                            'test_isNot'         'nno'                                         ''    \
55  1                            'test_isNot'         'noo'                                         ''    \
56  0                            'test_isConnected'   ''                                            ''    \
57  0                            'test_isConnected'   ''                                            ''    \
58  0                            'test_getRuntimeStr' ''                                            ''    \
59  0                            'test_isParameter'   '-a'                                          ''    \
60  0                            'test_isParameter'   '--a'                                         ''    \
61  0                            'test_isParameter'   '---a'                                        ''    \
62  1                            'test_isParameter'   'a'                                           ''    \
63  1                            'test_isParameter'   '1'                                           ''    \
64  1                            'test_isParameter'   ''                                            ''    \
65  0                            'test_isArgValue'    '1'                                           ''    \
66  0                            'test_isArgValue'    '1.2'                                         ''    \
67  1                            'test_isArgValue'    '-a'                                          ''    \
68  1                            'test_isArgValue'    '--a'                                         ''    \
69  1                            'test_isArgValue'    ''                                            ''    \
70  '/media'                     'getMountDir'        ''                                            ''    \
71  1                            'libInit'            '-x'                                          ''    \
72  0                            'libInit'            '-l'                                          ''    \
73  1                            'libInit'            '-l'                                          -1    \
74  0                            'libInit'            '-l'                                          0     \
75  0                            'libInit'            '-l'                                          1     \
76  0                            'libInit'            '-l'                                          2     \
77  0                            'libInit'            '-l'                                          3     \
78  1                            'libInit'            '-l'                                          4     \
79  1                            'libInit'            '-l'                                          'a'   \
80  1                            'libInit'            '-q'                                          'a'   \
81  0                            'libInit'            '-q'                                          ''    \
82  1                            'libInit'            '+q'                                          'a'   \
83  1                            'libInit'            '+q'                                          ''    \
84  1                            'libInit'            '-v'                                          'a'   \
85  0                            'libInit'            '-v'                                          ''    \
86  1                            'libInit'            '+v'                                          'a'   \
87  1                            'libInit'            '+v'                                          ''    \
88  1                            'libInit'            '-g'                                          'a'   \
89  0                            'libInit'            '-g'                                          ''    \
90  1                            'libInit'            '+g'                                          'a'   \
91  1                            'libInit'            '+g'                                          ''    \
92  1                            'libInit'            '-t'                                          'a'   \
93  0                            'libInit'            '-t'                                          ''    \
94  1                            'libInit'            '+t'                                          'a'   \
95  1                            'libInit'            '+t'                                          ''    \
96  1                            'libInit'            'a'                                           'a'   \
97  1                            'libInit'            '-T'                                          ''    \
98  1                            'libInit'            '-T'                                          'a'   \
99  0                            'libInit'            '-T'                                          '1'   \
100 1                            'libInit'            '-T'                                          '-1'  \
101 1                            'libInit'            '-T'                                          '1.0' \
102 1                            'libInit'            '-T'                                          '-q'  \
103 0                            'libInit'            '-l'                                          0     \
104 0                            'test_logStart_0'    ''                                            ''    \
105 0                            'logBegin'           ''                                            ''    \
106 0                            'libInit'            '-l'                                          1     \
107 0                            'test_logStart_1'    ''                                            ''    \
108 0                            'logBegin'           ''                                            ''    \
109 0                            'libInit'            '-l'                                          2     \
110 0                            'test_logStart_2'    ''                                            ''    \
111 0                            'logBegin'           ''                                            ''    \
112 0                            'libInit'            '-l'                                          3     \
113 0                            'test_logStart_3'    ''                                            ''    \
114 0                            'logBegin'           ''                                            ''    \
115 0                            'libStop'            ''                                            '')
#| N | return                    | function           | param1                                      | param2 |
#+---+---------------------------+--------------------+---------------------------------------------+--------+

## @brief	Unset global test variables, not in libShell, for libShell call libEnd() function.
function _unsetVars
{
	unset -v LINE
	unset -v OK
	unset -v ERR
	unset -v RES
	return 0
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
	local connected=$(ping 8.8.8.8 -q -t 30 -c 1 > /dev/null 2>&1 && true || false)
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
function test_isArgValue() { if isArgValue  "$1" ; then echo 0 ; else echo 1 ; fi ; }

##
# @brief	Test logBegin() function and log filename presence.
# @param	none
# @return	0	Success
#			1	Error
# @details		Call libInit() and pass some parameters to set log flags,
#				Call logStart() and check log flags and log file presence.
#				Return 0 for success and 1 for any error, these results
#				will be compared at end of test.

## @brief	Test logBegin() function by libInit -l 0 parameters.
function test_logStart_0()
{
	libInit -q -l 0 || return 2
	$(rm -f "$(getLogFilename)" > /dev/null 2>&1)
	logBegin
	#DISABLED=0	From libShell variables list.
	if [ $logLEVEL -eq $logQUIET ] && [ $logTARGET -eq $logQUIET ] && ! [ -f "${logFILE}" ] ; then
		return 0
	else
		return 1
	fi
}

## @brief	Test logStart() function by libInit -l 1 parameters.
function test_logStart_1()
{
	libInit -q -l 1 || return 2
	$(rm -f "$(getLogFilename)" > /dev/null 2>&1)
	logBegin
	#SCREEN=10	From libShell variables list.
	if [ $logLEVEL -eq $logQUIET ] && [ $logTARGET -eq $logTOSCREEN ] && ! [ -f "${logFILE}" ] ; then
		return 0
	else
		return 1
	fi
}

## @brief	Test logStart() function by libInit -l 2 parameters.
function test_logStart_2()
{
	libInit -q -l 2 || return 2
	$(rm -f "$(getLogFilename)" > /dev/null 2>&1)
	logBegin
	#FILE=20	From libShell variables list.
	if [ $logLEVEL -eq $logQUIET ] && [ $logTARGET -eq $logTOFILE ] && ! [ -f "${logFILE}" ] ; then
		return 0
	else
		return 1
	fi
}

## @brief	Test logStart() function by libInit -l 3 parameters.
function test_logStart_3()
{
	libInit -q -l 3 || return 2
	$(rm -f "$(getLogFilename)" > /dev/null 2>&1)
	logBegin
	#FULL=30	From libShell variables list.
	if [ $logLEVEL -eq $logQUIET ] && [ $logTARGET -eq $((logTOFILE + logTOSCREEN)) ] && ! [ -f "${logFILE}" ] ; then
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
	# print [N] each 10 and '|' each 5
	if   [ $((num % 10)) -eq 0 ] ; then printf "[%3d]" $num
	elif [ $((num %  5)) -eq 0 ] ; then printf '|' ; fi
	# echo a new line each 50
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
		sleep 0.05
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

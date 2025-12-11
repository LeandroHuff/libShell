#!/usr/bin/env bash

################################################################################
# @file     test_libRegex.sh
# @brief    Test and check libRegex file.
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
declare -i  maxTYPE=0
declare     flagLoadLib=false
declare -a  libLIST=(EscCodes Regex)
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
'#ID'   return  result  function            parameter1  parameter2  parameter3  parameter4 \
\
1       1       ''      _isArg              ''          ''          ''          '' \
2       0       ''      _isArg              'a'         ''          ''          '' \
3       1       ''      _isArg              '-a'        ''          ''          '' \
\
4       1       ''      _isInt              ''          ''          ''          '' \
5       0       ''      _isInt              '1'         ''          ''          '' \
6       0       ''      _isInt              '+1'        ''          ''          '' \
7       0       ''      _isInt              '-1'        ''          ''          '' \
8       1       ''      _isInt              'a'         ''          ''          '' \
9       1       ''      _isInt              '+a'        ''          ''          '' \
10      1       ''      _isInt              '-a'        ''          ''          '' \
11      1       ''      _isInt              '1l1'       ''          ''          '' \
\
12      1       ''      _isNum              ''          ''          ''          '' \
13      0       ''      _isNum              '1'         ''          ''          '' \
14      0       ''      _isNum              '+1'        ''          ''          '' \
15      0       ''      _isNum              '-1'        ''          ''          '' \
16      0       ''      _isNum              '.1'        ''          ''          '' \
17      0       ''      _isNum              '+.1'       ''          ''          '' \
18      0       ''      _isNum              '-.1'       ''          ''          '' \
19      0       ''      _isNum              '1.'        ''          ''          '' \
20      0       ''      _isNum              '+1.'       ''          ''          '' \
21      0       ''      _isNum              '-1.'       ''          ''          '' \
22      1       ''      _isNum              '1l'        ''          ''          '' \
23      1       ''      _isNum              '+1l'       ''          ''          '' \
24      1       ''      _isNum              '-1l'       ''          ''          '' \
25      1       ''      _isNum              'a'         ''          ''          '' \
26      1       ''      _isNum              '+a'        ''          ''          '' \
27      1       ''      _isNum              '-a'        ''          ''          '' \
28      1       ''      _isNum              '1l1'       ''          ''          '' \
\
29      1       ''      regexIt             ''          ''          ''          '' \
30      1       ''      regexIt             ''          '^[+-]?\d+$' ''         '' \
31      1       ''      regexIt             '1.0'       '^[+-]?\d+$' ''         '' \
32      0       ''      regexIt             '1'         '^[+-]?\d+$' ''         '' \
33      0       ''      regexIt             '+1'        '^[+-]?\d+$' ''         '' \
34      0       ''      regexIt             '-1'        '^[+-]?\d+$' ''         '' \
35      1       ''      regexIt             '1l'        '^[+-]?\d+$' ''         '' \
\
36      1       ''      isFloat             ''          ''          ''          '' \
37      1       ''      isFloat             'a'         ''          ''          '' \
38      1       ''      isFloat             '1.a'       ''          ''          '' \
39      0       ''      isFloat             '.1'        ''          ''          '' \
40      0       ''      isFloat             '1.'        ''          ''          '' \
41      0       ''      isFloat             '1'         ''          ''          '' \
42      0       ''      isFloat             '1.2'       ''          ''          '' \
43      0       ''      isFloat             '+.1'       ''          ''          '' \
44      0       ''      isFloat             '+1.'       ''          ''          '' \
45      0       ''      isFloat             '+1'        ''          ''          '' \
46      0       ''      isFloat             '+1.2'      ''          ''          '' \
47      0       ''      isFloat             '-.1'       ''          ''          '' \
48      0       ''      isFloat             '-1.'       ''          ''          '' \
49      0       ''      isFloat             '-1'        ''          ''          '' \
50      0       ''      isFloat             '-1.2'      ''          ''          '' \
51      0       ''      isFloat             '1.2e+10'   ''          ''          '' \
52      0       ''      isFloat             '+1.2e+10'  ''          ''          '' \
53      0       ''      isFloat             '-1.2e+10'  ''          ''          '' \
54      0       ''      isFloat             '1.2e-10'   ''          ''          '' \
55      0       ''      isFloat             '+1.2e-10'  ''          ''          '' \
56      0       ''      isFloat             '-1.2e-10'  ''          ''          '' \
57      0       ''      isFloat             '1.2E+10'   ''          ''          '' \
58      0       ''      isFloat             '+1.2E+10'  ''          ''          '' \
59      0       ''      isFloat             '-1.2E+10'  ''          ''          '' \
60      0       ''      isFloat             '1.2E-10'   ''          ''          '' \
61      0       ''      isFloat             '+1.2E-10'  ''          ''          '' \
62      0       ''      isFloat             '-1.2E-10'  ''          ''          '' \
\
63      1       ''      isInteger           ''          ''          ''          '' \
64      1       ''      isInteger           'a'         ''          ''          '' \
65      1       ''      isInteger           '1a'        ''          ''          '' \
66      1       ''      isInteger           '1.'        ''          ''          '' \
67      1       ''      isInteger           '.1'        ''          ''          '' \
68      1       ''      isInteger           '1.2'       ''          ''          '' \
69      0       ''      isInteger           '1'         ''          ''          '' \
70      0       ''      isInteger           '+1'        ''          ''          '' \
71      0       ''      isInteger           '-1'        ''          ''          '' \
\
72      1       ''      isAlpha             ''          ''          ''          '' \
73      1       ''      isAlpha             '1'         ''          ''          '' \
74      1       ''      isAlpha             '@'         ''          ''          '' \
75      0       ''      isAlpha             'a'         ''          ''          '' \
76      0       ''      isAlpha             'B'         ''          ''          '' \
\
77      1       ''      isDigit             ''          ''          ''          '' \
78      1       ''      isDigit             'a'         ''          ''          '' \
79      1       ''      isDigit             'B'         ''          ''          '' \
80      1       ''      isDigit             '@'         ''          ''          '' \
81      1       ''      isDigit             '1l1'       ''          ''          '' \
82      0       ''      isDigit             '111'       ''          ''          '' \
\
83      1       ''      isAlphaNumeric      ''          ''          ''          '' \
84      1       ''      isAlphaNumeric      '@'         ''          ''          '' \
85      1       ''      isAlphaNumeric      '1@'        ''          ''          '' \
86      1       ''      isAlphaNumeric      'a@'        ''          ''          '' \
87      0       ''      isAlphaNumeric      'a'         ''          ''          '' \
88      0       ''      isAlphaNumeric      'B'         ''          ''          '' \
89      0       ''      isAlphaNumeric      '1l1'       ''          ''          '' \
90      0       ''      isAlphaNumeric      '111'       ''          ''          '' \
\
91      1       ''      isHexadecimal       ''          ''          ''          '' \
92      1       ''      isHexadecimal       '.'         ''          ''          '' \
93      1       ''      isHexadecimal       '@'         ''          ''          '' \
94      1       ''      isHexadecimal       'g'         ''          ''          '' \
95      1       ''      isHexadecimal       'H'         ''          ''          '' \
96      0       ''      isHexadecimal       '1'         ''          ''          '' \
97      0       ''      isHexadecimal       'a'         ''          ''          '' \
98      0       ''      isHexadecimal       'A'         ''          ''          '' \
99      0       ''      isHexadecimal       '1a'        ''          ''          '' \
100     0       ''      isHexadecimal       '1A'        ''          ''          '' \
101     0       ''      isHexadecimal       '1Aa'       ''          ''          '' \
\
102     1       ''      isLowerHexadecimal  ''          ''          ''          '' \
103     1       ''      isLowerHexadecimal  '.'         ''          ''          '' \
104     1       ''      isLowerHexadecimal  '@'         ''          ''          '' \
105     1       ''      isLowerHexadecimal  'g'         ''          ''          '' \
106     1       ''      isLowerHexadecimal  'H'         ''          ''          '' \
107     1       ''      isLowerHexadecimal  'A'         ''          ''          '' \
108     1       ''      isLowerHexadecimal  '1A'        ''          ''          '' \
109     1       ''      isLowerHexadecimal  '1Aa'       ''          ''          '' \
110     0       ''      isLowerHexadecimal  '1'         ''          ''          '' \
111     0       ''      isLowerHexadecimal  'a'         ''          ''          '' \
112     0       ''      isLowerHexadecimal  '1a'        ''          ''          '' \
\
113     1       ''      isUpperHexadecimal  ''          ''          ''          '' \
114     1       ''      isUpperHexadecimal  '.'         ''          ''          '' \
115     1       ''      isUpperHexadecimal  '@'         ''          ''          '' \
116     1       ''      isUpperHexadecimal  'g'         ''          ''          '' \
117     1       ''      isUpperHexadecimal  'H'         ''          ''          '' \
118     1       ''      isUpperHexadecimal  'a'         ''          ''          '' \
119     1       ''      isUpperHexadecimal  '1a'        ''          ''          '' \
120     1       ''      isUpperHexadecimal  '1Aa'       ''          ''          '' \
121     0       ''      isUpperHexadecimal  '1'         ''          ''          '' \
122     0       ''      isUpperHexadecimal  'A'         ''          ''          '' \
123     0       ''      isUpperHexadecimal  '1A'        ''          ''          '' \
\
124     1       ''      isGraph             ''          ''          ''          '' \
125     0       ''      isGraph             '1'         ''          ''          '' \
126     0       ''      isGraph             'a'         ''          ''          '' \
127     0       ''      isGraph             'A'         ''          ''          '' \
128     0       ''      isGraph             '@!%'       ''          ''          '' \
129     0       ''      isGraph             '"1!2@3#4$%6¨7&8*9(0)-_=+§¹²³£¢¬qwertyuiopQWERTYUIOP[{asdfghjklç~]ASDFGHJKLÇ^}\zxcvbnm,.;/|ZXCVBNM<>:?' '' '' '' \
\
130     1       ''      isGraphSpace        ''          ''          ''          '' \
131     0       ''      isGraphSpace        '1'         ''          ''          '' \
132     0       ''      isGraphSpace        'a'         ''          ''          '' \
133     0       ''      isGraphSpace        'A'         ''          ''          '' \
134     0       ''      isGraphSpace        '@!%'       ''          ''          '' \
135     1       ''      isGraphSpace        ' @!%'      ''          ''          '' \
136     1       ''      isGraphSpace        '@!% '      ''          ''          '' \
137     0       ''      isGraphSpace        '"1!2 @3#4$% 6¨7&8*9( 0)-_=+§¹²³£¢¬qw ertyuiopQWERT YUIOP[{asd fghjklç~]ASDFGH JKLÇ^}\zxcvb nm,.;/|ZXCV BNM<>:?' '' '' '' \
\
138     1       ''      isDate              ''          ''          ''          '' \
139     1       ''      isDate              '1234.12.12' ''         ''          '' \
140     1       ''      isDate              '9999-88-77' ''         ''          '' \
141     1       ''      isDate              '1999-02-29' ''         ''          '' \
142     0       ''      isDate              '2000-02-29' ''         ''          '' \
143     0       ''      isDate              '2012-02-29' ''         ''          '' \
144     0       ''      isDate              '2024-02-29' ''         ''          '' \
145     0       ''      isDate              '2024/02/29' ''         ''          '' \
146     0       ''      isDate              '2024.02.29' ''         ''          '' \
147     0       ''      isDate              "$(date '+%Y-%m-%d')" '' ''         '' \
\
148     1       ''      isTime12            ''          ''          ''          '' \
149     1       ''      isTime12            '13:00:00'  ''          ''          '' \
150     1       ''      isTime12            '13:00:00am' ''         ''          '' \
151     1       ''      isTime12            '12:00:00'  ''          ''          '' \
152     0       ''      isTime12            '12:00:00am' ''         ''          '' \
153     0       ''      isTime12            '12:00:00pm' ''         ''          '' \
154     0       ''      isTime12            '12:00:00 am' ''        ''          '' \
155     0       ''      isTime12            '12:00:00 pm' ''        ''          '' \
156     1       ''      isTime12            '12:00:00  pm' ''       ''          '' \
157     0       ''      isTime12            '12:59:59 pm' ''        ''          '' \
158     1       ''      isTime12            '13:59:59 pm' ''        ''          '' \
159     0       ''      isTime12            '1:59:59 am' ''         ''          '' \
160     0       ''      isTime12            '01:59:59 am' ''        ''          '' \
161     1       ''      isTime12            "$(date '+%H:%M:%S')" '' ''         '' \
\
162     1       ''      isTime24            ''          ''          ''          '' \
163     0       ''      isTime24            '13:00:00'  ''          ''          '' \
164     1       ''      isTime24            '13:00:00am' ''         ''          '' \
165     0       ''      isTime24            '12:00:00'  ''          ''          '' \
166     0       ''      isTime24            '23:59:59'  ''          ''          '' \
167     1       ''      isTime24            '24:00:00'  ''          ''          '' \
168     0       ''      isTime24            '00:00:00'  ''          ''          '' \
169     0       ''      isTime24            '13:00:00'  ''          ''          '' \
170     1       ''      isTime24            '23:60:59'  ''          ''          '' \
171     1       ''      isTime24            '12.59.59'  ''          ''          '' \
172     1       ''      isTime24            '1:59:59'   ''          ''          '' \
173     0       ''      isTime24            '01:59:59'  ''          ''          '' \
174     0       ''      isTime24            "$(date '+%H:%M:%S')" '' ''         '' \
\
175     1       ''      isTime124           ''          ''          ''          '' \
176     0       ''      isTime124           '13:00:00'  ''          ''          '' \
177     1       ''      isTime124           '13:00:00am' ''         ''          '' \
178     0       ''      isTime124           '12:00:00'  ''          ''          '' \
179     0       ''      isTime124           '12:00:00am' ''         ''          '' \
180     0       ''      isTime124           '12:00:00pm' ''         ''          '' \
181     0       ''      isTime124           '12:00:00 am' ''        ''          '' \
182     0       ''      isTime124           '12:00:00 pm' ''        ''          '' \
183     1       ''      isTime124           '12:00:00  pm' ''       ''          '' \
184     0       ''      isTime124           '12:59:59 pm' ''        ''          '' \
185     1       ''      isTime124           '13:59:59 pm' ''        ''          '' \
186     0       ''      isTime124           '1:59:59 am' ''         ''          '' \
187     0       ''      isTime124           '01:59:59 am' ''        ''          '' \
188     0       ''      isTime124           "$(date '+%H:%M:%S')" '' ''         '' \
189     0       ''      isTime124           '13:00:00'  ''          ''          '' \
190     1       ''      isTime124           '13:00:00am' ''         ''          '' \
191     0       ''      isTime124           '12:00:00'  ''          ''          '' \
192     0       ''      isTime124           '23:59:59'  ''          ''          '' \
193     1       ''      isTime124           '24:00:00'  ''          ''          '' \
194     0       ''      isTime124           '00:00:00'  ''          ''          '' \
195     0       ''      isTime124           '13:00:00'  ''          ''          '' \
196     1       ''      isTime124           '23:60:59'  ''          ''          '' \
197     1       ''      isTime124           '12.59.59'  ''          ''          '' \
198     1       ''      isTime124           '1:59:59'   ''          ''          '' \
199     0       ''      isTime124           '01:59:59'  ''          ''          '' \
200     0       ''      isTime124           '00:00:00'  ''          ''          '' \
201     0       ''      isTime124           '23:59:59'  ''          ''          '' \
202     1       ''      isTime124           '24:00:00'  ''          ''          '' \
203     1       ''      isTime124           '23:60:00'  ''          ''          '' \
204     1       ''      isTime124           '23:59:60'  ''          ''          '' \
205     0       ''      isTime124           '23:59:59'  ''          ''          '' \
206     0       ''      isTime124           '12:00:00 pm' ''        ''          '' \
207     0       ''      isTime124           '12:00:00 am' ''        ''          '' \
208     0       ''      isTime124           '12:59:59 pm' ''        ''          '' \
209     0       ''      isTime124           '12:59:59 am' ''        ''          '' \
210     1       ''      isTime124           '13:00:00 am' ''        ''          '' \
211     1       ''      isTime124           '12:60:00 am' ''        ''          '' \
212     1       ''      isTime124           '12:59:60 am' ''        ''          '' \
213     1       ''      isTime124           '13:00:00 pm' ''        ''          '' \
214     1       ''      isTime124           '12:60:00 pm' ''        ''          '' \
215     1       ''      isTime124           '12:59:60 pm' ''        ''          '' \
\
216     1       ''      isDateTime12        ''          ''          ''          '' \
217     0       ''      isDateTime12        '2000-02-29 12:00:00 am' '' ''      '' \
218     0       ''      isDateTime12        '2000-02-29 12:00:00 pm' '' ''      '' \
219     0       ''      isDateTime12        '2001-02-29 12:00:00 am' '' ''      '' \
220     0       ''      isDateTime12        '2001-02-28 12:00:00 am' '' ''      '' \
221     1       ''      isDateTime12        '2000-02-29 13:00:00 am' '' ''      '' \
222     1       ''      isDateTime12        '2000-02-29 12:60:00 am' '' ''      '' \
223     1       ''      isDateTime12        '2000-02-29 12:59:60 am' '' ''      '' \
224     0       ''      isDateTime12        '2000-02-29 12:59:59 am' '' ''      '' \
225     1       ''      isDateTime12        '0000-00-00 00:00:00 am' '' ''      '' \
226     1       ''      isDateTime12        '0001-00-00 00:00:00 am' '' ''      '' \
227     1       ''      isDateTime12        '0001-01-00 00:00:00 am' '' ''      '' \
228     1       ''      isDateTime12        '0001-01-01 00:00:00 am' '' ''      '' \
229     0       ''      isDateTime12        '0001-01-01 01:00:00 am' '' ''      '' \
230     0       ''      isDateTime12        '9999-01-01 01:00:00 am' '' ''      '' \
231     0       ''      isDateTime12        '9999-12-01 01:00:00 am' '' ''      '' \
232     0       ''      isDateTime12        '9999-12-31 01:00:00 am' '' ''      '' \
233     0       ''      isDateTime12        '9999-12-31 12:00:00 am' '' ''      '' \
234     0       ''      isDateTime12        '9999-12-31 12:59:00 am' '' ''      '' \
235     0       ''      isDateTime12        '9999-12-31 12:59:59 am' '' ''      '' \
236     1       ''      isDateTime12        '9999-13-31 12:59:59 am' '' ''      '' \
237     1       ''      isDateTime12        '9999-12-32 12:59:59 am' '' ''      '' \
238     1       ''      isDateTime12        '9999-12-31 12:59:59  am' '' ''     '' \
239     0       ''      isDateTime12        '9999-12-31 12:59:59 Am' '' ''      '' \
240     0       ''      isDateTime12        '9999-12-31 12:59:59 AM' '' ''      '' \
241     1       ''      isDateTime12        '9999-12-31 12:59:59 xm' '' ''      '' \
242     1       ''      isDateTime12        '2000-00-00 12:59:59 am' '' ''      '' \
243     1       ''      isDateTime12        '2000-01-00 12:59:59 am' '' ''      '' \
244     0       ''      isDateTime12        '0000-01-01 01:00:00 am' '' ''      '' \
\
245     1       ''      isDateTime24        ''                      ''  ''      '' \
246     1       ''      isDateTime24        '0000-00-00 00:00:00'   ''  ''      '' \
247     1       ''      isDateTime24        '0000-01-00 00:00:00'   ''  ''      '' \
248     0       ''      isDateTime24        '0000-01-01 00:00:00'   ''  ''      '' \
249     0       ''      isDateTime24        '0000-01-01 23:00:00'   ''  ''      '' \
250     1       ''      isDateTime24        '0000-01-01 24:00:00'   ''  ''      '' \
251     0       ''      isDateTime24        '0000-01-01 23:59:00'   ''  ''      '' \
252     1       ''      isDateTime24        '0000-01-01 23:60:00'   ''  ''      '' \
253     0       ''      isDateTime24        '0000-01-01 23:59:59'   ''  ''      '' \
254     1       ''      isDateTime24        '0000-01-01 23:59:60'   ''  ''      '' \
255     0       ''      isDateTime24        '9999-01-01 23:59:59'   ''  ''      '' \
256     0       ''      isDateTime24        '9999-12-01 23:59:59'   ''  ''      '' \
257     1       ''      isDateTime24        '9999-13-01 23:59:59'   ''  ''      '' \
258     0       ''      isDateTime24        '9999-12-31 23:59:59'   ''  ''      '' \
259     1       ''      isDateTime24        '9999-12-32 23:59:59'   ''  ''      '' \
260     0       ''      isDateTime24        '9999-12-31 23:59:59'   ''  ''      '' \
\
261     1       ''      isDateTime124       ''          ''          ''          '' \
262     0       ''      isDateTime124       '2000-02-29 12:00:00 am' '' ''      '' \
263     0       ''      isDateTime124       '2000-02-29 12:00:00 pm' '' ''      '' \
264     0       ''      isDateTime124       '2001-02-29 12:00:00 am' '' ''      '' \
265     0       ''      isDateTime124       '2001-02-28 12:00:00 am' '' ''      '' \
266     1       ''      isDateTime124       '2000-02-29 13:00:00 am' '' ''      '' \
267     1       ''      isDateTime124       '2000-02-29 12:60:00 am' '' ''      '' \
268     1       ''      isDateTime124       '2000-02-29 12:59:60 am' '' ''      '' \
269     0       ''      isDateTime124       '2000-02-29 12:59:59 am' '' ''      '' \
270     1       ''      isDateTime124       '0000-00-00 00:00:00 am' '' ''      '' \
271     1       ''      isDateTime124       '0001-00-00 00:00:00 am' '' ''      '' \
272     1       ''      isDateTime124       '0001-01-00 00:00:00 am' '' ''      '' \
273     1       ''      isDateTime124       '0001-01-01 00:00:00 am' '' ''      '' \
274     0       ''      isDateTime124       '0001-01-01 01:00:00 am' '' ''      '' \
275     0       ''      isDateTime124       '9999-01-01 01:00:00 am' '' ''      '' \
276     0       ''      isDateTime124       '9999-12-01 01:00:00 am' '' ''      '' \
277     0       ''      isDateTime124       '9999-12-31 01:00:00 am' '' ''      '' \
278     0       ''      isDateTime124       '9999-12-31 12:00:00 am' '' ''      '' \
279     0       ''      isDateTime124       '9999-12-31 12:59:00 am' '' ''      '' \
280     0       ''      isDateTime124       '9999-12-31 12:59:59 am' '' ''      '' \
281     1       ''      isDateTime124       '9999-13-31 12:59:59 am' '' ''      '' \
282     1       ''      isDateTime124       '9999-12-32 12:59:59 am' '' ''      '' \
283     1       ''      isDateTime124       '9999-12-31 12:59:59  am' '' ''     '' \
284     0       ''      isDateTime124       '9999-12-31 12:59:59 Am' '' ''      '' \
285     0       ''      isDateTime124       '9999-12-31 12:59:59 AM' '' ''      '' \
286     1       ''      isDateTime124       '9999-12-31 12:59:59 xm' '' ''      '' \
287     1       ''      isDateTime124       '2000-00-00 12:59:59 am' '' ''      '' \
288     1       ''      isDateTime124       '2000-01-00 12:59:59 am' '' ''      '' \
289     0       ''      isDateTime124       '0000-01-01 01:00:00 am' '' ''      '' \
290     1       ''      isDateTime124       ''                      ''  ''      '' \
291     1       ''      isDateTime124       '0000-00-00 00:00:00'   ''  ''      '' \
292     1       ''      isDateTime124       '0000-01-00 00:00:00'   ''  ''      '' \
293     0       ''      isDateTime124       '0000-01-01 00:00:00'   ''  ''      '' \
294     0       ''      isDateTime124       '0000-01-01 23:00:00'   ''  ''      '' \
295     1       ''      isDateTime124       '0000-01-01 24:00:00'   ''  ''      '' \
296     0       ''      isDateTime124       '0000-01-01 23:59:00'   ''  ''      '' \
297     1       ''      isDateTime124       '0000-01-01 23:60:00'   ''  ''      '' \
298     0       ''      isDateTime124       '0000-01-01 23:59:59'   ''  ''      '' \
299     1       ''      isDateTime124       '0000-01-01 23:59:60'   ''  ''      '' \
300     0       ''      isDateTime124       '9999-01-01 23:59:59'   ''  ''      '' \
301     0       ''      isDateTime124       '9999-12-01 23:59:59'   ''  ''      '' \
302     1       ''      isDateTime124       '9999-13-01 23:59:59'   ''  ''      '' \
303     0       ''      isDateTime124       '9999-12-31 23:59:59'   ''  ''      '' \
304     1       ''      isDateTime124       '9999-12-32 23:59:59'   ''  ''      '' \
305     0       ''      isDateTime124       '9999-12-31 23:59:59'   ''  ''      '' \
\
306     1       ''      isDateTimeAsCode    ''          ''          ''          '' \
307     1       ''      isDateTimeAsCode    '0000-00-00-00-00-00-000' '' ''     '' \
308     1       ''      isDateTimeAsCode    '9999-00-00-00-00-00-000' '' ''     '' \
309     1       ''      isDateTimeAsCode    '9999-99-00-00-00-00-000' '' ''     '' \
310     1       ''      isDateTimeAsCode    '9999-12-99-00-00-00-000' '' ''     '' \
311     1       ''      isDateTimeAsCode    '9999-12-31-99-00-00-000' '' ''     '' \
312     1       ''      isDateTimeAsCode    '9999-12-31-23-99-00-000' '' ''     '' \
323     1       ''      isDateTimeAsCode    '9999-12-31-23-59-99-000' '' ''     '' \
324     0       ''      isDateTimeAsCode    '9999-12-31-23-59-59-999' '' ''     '' \
325     0       ''      isDateTimeAsCode    '1234-12-12-12-12-12-123' '' ''     '' \
316     1       ''      isDateTimeAsCode    '12345-12-12-12-12-12-123' '' ''    '' \
317     1       ''      isDateTimeAsCode    '1234-123-12-12-12-12-123' '' ''    '' \
318     1       ''      isDateTimeAsCode    '1234-12-123-12-12-12-123' '' ''    '' \
319     1       ''      isDateTimeAsCode    '1234-12-12-123-12-12-123' '' ''    '' \
320     1       ''      isDateTimeAsCode    '1234-12-12-12-123-12-123' '' ''    '' \
321     1       ''      isDateTimeAsCode    '1234-12-12-12-12-123-123' '' ''    '' \
322     1       ''      isDateTimeAsCode    '1234-12-12-12-12-12-1234' '' ''    '' \
\
323     0       ''      libRegexExit        ''          ''          ''          '' \
\
'#ID'   return  result  function            parameter1  parameter2  parameter3  parameter4\
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
    -g|--debug)
        flagDEBUG=true
        ;;
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
    if [[ "${testTABLE[$idxID]:0:1}" != '#' ]]
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
                if $flagDEBUG ; then echo -e -n "${_WHITE}Function${_NC}: ${testTABLE[$idxFUNC]} ${testTABLE[$idxP1]} ${testTABLE[$idxP2]} ${testTABLE[$idxP3]} ${testTABLE[$idxP4]} ... \t" ; fi
                _RES="$(${testTABLE[$idxFUNC]} "${testTABLE[$idxP1]}" "${testTABLE[$idxP2]}" "${testTABLE[$idxP3]}" "${testTABLE[$idxP4]}")"
                ;;
            external)
                # Uncomment/Commant to enable/disable call extarnal tests files
                if $flagDEBUG ; then echo -e -n "${_WHITE}File${_NC}: test_lib${testTABLE[$idxFUNC]}.sh ... \t" ; fi
                _RES="$(. ${testPATH}/test_lib${testTABLE[$idxFUNC]}.sh "${testTABLE[$idxP1]}" "${testTABLE[$idxP2]}" "${testTABLE[$idxP3]}" "${testTABLE[$idxP4]}")"
                ;;
            load)
                # Uncomment/Commant to enable/disable test source library
                if $flagDEBUG ; then echo -e -n "${_WHITE}File${_NC}: lib${testTABLE[$idxFUNC]}.sh ... \t" ; fi
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
        if   ! $flagDEBUG ; then barGraph $LINE $_SUCCESS
        elif $_SUCCESS    ; then echo -e "${_GREEN}success${_NC}."
        else                     echo -e "${_RED}failure${_NC}."
        fi
    fi

    _RET=
    _RES=
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

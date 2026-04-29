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
1       1       ''      reIsArg              ''          ''          ''          '' \
2       0       ''      reIsArg              'a'         ''          ''          '' \
3       1       ''      reIsArg              '-a'        ''          ''          '' \
4       1       ''      reIsParam            ''          ''          ''          '' \
5       1       ''      reIsParam            'a'         ''          ''          '' \
6       1       ''      reIsParam            '1'         ''          ''          '' \
7       1       ''      reIsParam            '_a'        ''          ''          '' \
8       1       ''      reIsParam            '-'         ''          ''          '' \
9       1       ''      reIsParam            '--a'       ''          ''          '' \
10      1       ''      reIsParam            '--a'       ''          ''          '' \
11      1       ''      reIsParam            '-aa'       ''          ''          '' \
12      0       ''      reIsParam            '-a'        ''          ''          '' \
13      0       ''      reIsParam            '-1'        ''          ''          '' \
14      0       ''      reIsParam            '--1'       ''          ''          '' \
15      0       ''      reIsParam            '--aaa'     ''          ''          '' \
16      0       ''      reIsParam            '--a_b_c'   ''          ''          '' \
17      0       ''      reIsParam            '--_a_b_c'  ''          ''          '' \
18      0       ''      reIsParam            '--__a_b_c' ''          ''          '' \
\
19      1       ''      reIsInteger          ''          ''          ''          '' \
20      0       ''      reIsInteger          '1'         ''          ''          '' \
21      0       ''      reIsInteger          '+1'        ''          ''          '' \
22      0       ''      reIsInteger          '-1'        ''          ''          '' \
23      1       ''      reIsInteger          'a'         ''          ''          '' \
24      1       ''      reIsInteger          '+a'        ''          ''          '' \
25      1       ''      reIsInteger          '-a'        ''          ''          '' \
26      1       ''      reIsInteger          '1l1'       ''          ''          '' \
\
27      1       ''      reIsNumber           ''          ''          ''          '' \
28      0       ''      reIsNumber           '1'         ''          ''          '' \
29      0       ''      reIsNumber           '+1'        ''          ''          '' \
30      0       ''      reIsNumber           '-1'        ''          ''          '' \
31      0       ''      reIsNumber           '.1'        ''          ''          '' \
32      0       ''      reIsNumber           '+.1'       ''          ''          '' \
33      0       ''      reIsNumber           '-.1'       ''          ''          '' \
34      0       ''      reIsNumber           '1.'        ''          ''          '' \
35      0       ''      reIsNumber           '+1.'       ''          ''          '' \
36      0       ''      reIsNumber           '-1.'       ''          ''          '' \
37      1       ''      reIsNumber           '1l'        ''          ''          '' \
38      1       ''      reIsNumber           '+1l'       ''          ''          '' \
39      1       ''      reIsNumber           '-1l'       ''          ''          '' \
40      1       ''      reIsNumber           'a'         ''          ''          '' \
41      1       ''      reIsNumber           '+a'        ''          ''          '' \
42      1       ''      reIsNumber           '-a'        ''          ''          '' \
43      1       ''      reIsNumber           '1l1'       ''          ''          '' \
\
44      1       ''      regexIt             ''          ''          ''          '' \
45      1       ''      regexIt             ''          '^[+-]?\d+$' ''         '' \
46      1       ''      regexIt             '1.0'       '^[+-]?\d+$' ''         '' \
47      0       ''      regexIt             '1'         '^[+-]?\d+$' ''         '' \
48      0       ''      regexIt             '+1'        '^[+-]?\d+$' ''         '' \
49      0       ''      regexIt             '-1'        '^[+-]?\d+$' ''         '' \
50      1       ''      regexIt             '1l'        '^[+-]?\d+$' ''         '' \
\
51      1       ''      reIsFloat             ''          ''          ''          '' \
52      1       ''      reIsFloat             'a'         ''          ''          '' \
53      1       ''      reIsFloat             '1.a'       ''          ''          '' \
54      0       ''      reIsFloat             '.1'        ''          ''          '' \
55      0       ''      reIsFloat             '1.'        ''          ''          '' \
56      0       ''      reIsFloat             '1'         ''          ''          '' \
57      0       ''      reIsFloat             '1.2'       ''          ''          '' \
58      0       ''      reIsFloat             '+.1'       ''          ''          '' \
59      0       ''      reIsFloat             '+1.'       ''          ''          '' \
60      0       ''      reIsFloat             '+1'        ''          ''          '' \
61      0       ''      reIsFloat             '+1.2'      ''          ''          '' \
62      0       ''      reIsFloat             '-.1'       ''          ''          '' \
63      0       ''      reIsFloat             '-1.'       ''          ''          '' \
64      0       ''      reIsFloat             '-1'        ''          ''          '' \
65      0       ''      reIsFloat             '-1.2'      ''          ''          '' \
66      0       ''      reIsFloat             '1.2e+10'   ''          ''          '' \
67      0       ''      reIsFloat             '+1.2e+10'  ''          ''          '' \
68      0       ''      reIsFloat             '-1.2e+10'  ''          ''          '' \
69      0       ''      reIsFloat             '1.2e-10'   ''          ''          '' \
70      0       ''      reIsFloat             '+1.2e-10'  ''          ''          '' \
71      0       ''      reIsFloat             '-1.2e-10'  ''          ''          '' \
72      0       ''      reIsFloat             '1.2E+10'   ''          ''          '' \
73      0       ''      reIsFloat             '+1.2E+10'  ''          ''          '' \
74      0       ''      reIsFloat             '-1.2E+10'  ''          ''          '' \
75      0       ''      reIsFloat             '1.2E-10'   ''          ''          '' \
76      0       ''      reIsFloat             '+1.2E-10'  ''          ''          '' \
77      0       ''      reIsFloat             '-1.2E-10'  ''          ''          '' \
\
78      1       ''      reIsInteger           ''          ''          ''          '' \
79      1       ''      reIsInteger           'a'         ''          ''          '' \
80      1       ''      reIsInteger           '1a'        ''          ''          '' \
81      1       ''      reIsInteger           '1.'        ''          ''          '' \
82      1       ''      reIsInteger           '.1'        ''          ''          '' \
83      1       ''      reIsInteger           '1.2'       ''          ''          '' \
84      0       ''      reIsInteger           '1'         ''          ''          '' \
85      0       ''      reIsInteger           '+1'        ''          ''          '' \
86      0       ''      reIsInteger           '-1'        ''          ''          '' \
\
87      1       ''      reIsAlpha             ''          ''          ''          '' \
88      1       ''      reIsAlpha             '1'         ''          ''          '' \
89      1       ''      reIsAlpha             '@'         ''          ''          '' \
90      0       ''      reIsAlpha             'a'         ''          ''          '' \
91      0       ''      reIsAlpha             'B'         ''          ''          '' \
\
92      1       ''      reIsDigit             ''          ''          ''          '' \
93      1       ''      reIsDigit             'a'         ''          ''          '' \
94      1       ''      reIsDigit             'B'         ''          ''          '' \
95      1       ''      reIsDigit             '@'         ''          ''          '' \
96      1       ''      reIsDigit             '1l1'       ''          ''          '' \
97      0       ''      reIsDigit             '111'       ''          ''          '' \
\
98      1       ''      reIsAlphaNumeric      ''          ''          ''          '' \
99      1       ''      reIsAlphaNumeric      '@'         ''          ''          '' \
100     1       ''      reIsAlphaNumeric      '1@'        ''          ''          '' \
101     1       ''      reIsAlphaNumeric      'a@'        ''          ''          '' \
102     0       ''      reIsAlphaNumeric      'a'         ''          ''          '' \
103     0       ''      reIsAlphaNumeric      'B'         ''          ''          '' \
104     0       ''      reIsAlphaNumeric      '1l1'       ''          ''          '' \
105     0       ''      reIsAlphaNumeric      '111'       ''          ''          '' \
\
106     1       ''      reIsHexadecimal       ''          ''          ''          '' \
107     1       ''      reIsHexadecimal       '.'         ''          ''          '' \
108     1       ''      reIsHexadecimal       '@'         ''          ''          '' \
109     1       ''      reIsHexadecimal       'g'         ''          ''          '' \
110     1       ''      reIsHexadecimal       'H'         ''          ''          '' \
111     0       ''      reIsHexadecimal       '1'         ''          ''          '' \
112     0       ''      reIsHexadecimal       'a'         ''          ''          '' \
113     0       ''      reIsHexadecimal       'A'         ''          ''          '' \
114     0       ''      reIsHexadecimal       '1a'        ''          ''          '' \
115     0       ''      reIsHexadecimal       '1A'        ''          ''          '' \
116     0       ''      reIsHexadecimal       '1Aa'       ''          ''          '' \
\
117     1       ''      reIsLowerHexadecimal  ''          ''          ''          '' \
118     1       ''      reIsLowerHexadecimal  '.'         ''          ''          '' \
119     1       ''      reIsLowerHexadecimal  '@'         ''          ''          '' \
120     1       ''      reIsLowerHexadecimal  'g'         ''          ''          '' \
121     1       ''      reIsLowerHexadecimal  'H'         ''          ''          '' \
122     1       ''      reIsLowerHexadecimal  'A'         ''          ''          '' \
123     1       ''      reIsLowerHexadecimal  '1A'        ''          ''          '' \
124     1       ''      reIsLowerHexadecimal  '1Aa'       ''          ''          '' \
124     0       ''      reIsLowerHexadecimal  '1'         ''          ''          '' \
125     0       ''      reIsLowerHexadecimal  'a'         ''          ''          '' \
126     0       ''      reIsLowerHexadecimal  '1a'        ''          ''          '' \
\
127     1       ''      reIsUpperHexadecimal  ''          ''          ''          '' \
128     1       ''      reIsUpperHexadecimal  '.'         ''          ''          '' \
129     1       ''      reIsUpperHexadecimal  '@'         ''          ''          '' \
130     1       ''      reIsUpperHexadecimal  'g'         ''          ''          '' \
131     1       ''      reIsUpperHexadecimal  'H'         ''          ''          '' \
132     1       ''      reIsUpperHexadecimal  'a'         ''          ''          '' \
133     1       ''      reIsUpperHexadecimal  '1a'        ''          ''          '' \
134     1       ''      reIsUpperHexadecimal  '1Aa'       ''          ''          '' \
135     0       ''      reIsUpperHexadecimal  '1'         ''          ''          '' \
136     0       ''      reIsUpperHexadecimal  'A'         ''          ''          '' \
137     0       ''      reIsUpperHexadecimal  '1A'        ''          ''          '' \
\
138     1       ''      reIsGraph             ''          ''          ''          '' \
139     0       ''      reIsGraph             '1'         ''          ''          '' \
140     0       ''      reIsGraph             'a'         ''          ''          '' \
141     0       ''      reIsGraph             'A'         ''          ''          '' \
142     0       ''      reIsGraph             '@!%'       ''          ''          '' \
143     0       ''      reIsGraph             '"1!2@3#4$%6¨7&8*9(0)-_=+§¹²³£¢¬qwertyuiopQWERTYUIOP[{asdfghjklç~]ASDFGHJKLÇ^}\zxcvbnm,.;/|ZXCVBNM<>:?' '' '' '' \
\
144     1       ''      reIsGraphSpace        ''          ''          ''          '' \
145     0       ''      reIsGraphSpace        '1'         ''          ''          '' \
146     0       ''      reIsGraphSpace        'a'         ''          ''          '' \
147     0       ''      reIsGraphSpace        'A'         ''          ''          '' \
148     0       ''      reIsGraphSpace        '@!%'       ''          ''          '' \
149     1       ''      reIsGraphSpace        ' @!%'      ''          ''          '' \
150     1       ''      reIsGraphSpace        '@!% '      ''          ''          '' \
151     0       ''      reIsGraphSpace        '"1!2 @3#4$% 6¨7&8*9( 0)-_=+§¹²³£¢¬qw ertyuiopQWERT YUIOP[{asd fghjklç~]ASDFGH JKLÇ^}\zxcvb nm,.;/|ZXCV BNM<>:?' '' '' '' \
\
152     1       ''      reIsDate              ''          ''          ''          '' \
153     1       ''      reIsDate              '1234.12.12' ''         ''          '' \
154     1       ''      reIsDate              '9999-88-77' ''         ''          '' \
155     1       ''      reIsDate              '1999-02-29' ''         ''          '' \
156     0       ''      reIsDate              '2000-02-29' ''         ''          '' \
157     0       ''      reIsDate              '2012-02-29' ''         ''          '' \
158     0       ''      reIsDate              '2024-02-29' ''         ''          '' \
159     0       ''      reIsDate              '2024/02/29' ''         ''          '' \
160     0       ''      reIsDate              '2024.02.29' ''         ''          '' \
161     0       ''      reIsDate              "$(date '+%Y-%m-%d')" '' ''         '' \
\
162     1       ''      reIsTime12            ''          ''          ''          '' \
163     1       ''      reIsTime12            '13:00:00'  ''          ''          '' \
164     1       ''      reIsTime12            '13:00:00am' ''         ''          '' \
165     1       ''      reIsTime12            '12:00:00'  ''          ''          '' \
166     0       ''      reIsTime12            '12:00:00am' ''         ''          '' \
167     0       ''      reIsTime12            '12:00:00pm' ''         ''          '' \
168     0       ''      reIsTime12            '12:00:00 am' ''        ''          '' \
169     0       ''      reIsTime12            '12:00:00 pm' ''        ''          '' \
170     1       ''      reIsTime12            '12:00:00  pm' ''       ''          '' \
171     0       ''      reIsTime12            '12:59:59 pm' ''        ''          '' \
172     1       ''      reIsTime12            '13:59:59 pm' ''        ''          '' \
173     0       ''      reIsTime12            '1:59:59 am' ''         ''          '' \
174     0       ''      reIsTime12            '01:59:59 am' ''        ''          '' \
175     1       ''      reIsTime12            "$(date '+%H:%M:%S')" '' ''         '' \
\
176     1       ''      reIsTime24            ''          ''          ''          '' \
177     0       ''      reIsTime24            '13:00:00'  ''          ''          '' \
178     1       ''      reIsTime24            '13:00:00am' ''         ''          '' \
179     0       ''      reIsTime24            '12:00:00'  ''          ''          '' \
180     0       ''      reIsTime24            '23:59:59'  ''          ''          '' \
181     1       ''      reIsTime24            '24:00:00'  ''          ''          '' \
182     0       ''      reIsTime24            '00:00:00'  ''          ''          '' \
183     0       ''      reIsTime24            '13:00:00'  ''          ''          '' \
184     1       ''      reIsTime24            '23:60:59'  ''          ''          '' \
185     1       ''      reIsTime24            '12.59.59'  ''          ''          '' \
186     1       ''      reIsTime24            '1:59:59'   ''          ''          '' \
187     0       ''      reIsTime24            '01:59:59'  ''          ''          '' \
188     0       ''      reIsTime24            "$(date '+%H:%M:%S')" '' ''         '' \
\
189     1       ''      reIsTime124           ''          ''          ''          '' \
190     0       ''      reIsTime124           '13:00:00'  ''          ''          '' \
191     1       ''      reIsTime124           '13:00:00am' ''         ''          '' \
192     0       ''      reIsTime124           '12:00:00'  ''          ''          '' \
193     0       ''      reIsTime124           '12:00:00am' ''         ''          '' \
194     0       ''      reIsTime124           '12:00:00pm' ''         ''          '' \
195     0       ''      reIsTime124           '12:00:00 am' ''        ''          '' \
196     0       ''      reIsTime124           '12:00:00 pm' ''        ''          '' \
197     1       ''      reIsTime124           '12:00:00  pm' ''       ''          '' \
198     0       ''      reIsTime124           '12:59:59 pm' ''        ''          '' \
199     1       ''      reIsTime124           '13:59:59 pm' ''        ''          '' \
200     0       ''      reIsTime124           '1:59:59 am' ''         ''          '' \
201     0       ''      reIsTime124           '01:59:59 am' ''        ''          '' \
202     0       ''      reIsTime124           "$(date '+%H:%M:%S')" '' ''         '' \
203     0       ''      reIsTime124           '13:00:00'  ''          ''          '' \
204     1       ''      reIsTime124           '13:00:00am' ''         ''          '' \
205     0       ''      reIsTime124           '12:00:00'  ''          ''          '' \
206     0       ''      reIsTime124           '23:59:59'  ''          ''          '' \
207     1       ''      reIsTime124           '24:00:00'  ''          ''          '' \
208     0       ''      reIsTime124           '00:00:00'  ''          ''          '' \
209     0       ''      reIsTime124           '13:00:00'  ''          ''          '' \
210     1       ''      reIsTime124           '23:60:59'  ''          ''          '' \
211     1       ''      reIsTime124           '12.59.59'  ''          ''          '' \
212     1       ''      reIsTime124           '1:59:59'   ''          ''          '' \
213     0       ''      reIsTime124           '01:59:59'  ''          ''          '' \
214     0       ''      reIsTime124           '00:00:00'  ''          ''          '' \
215     0       ''      reIsTime124           '23:59:59'  ''          ''          '' \
216     1       ''      reIsTime124           '24:00:00'  ''          ''          '' \
217     1       ''      reIsTime124           '23:60:00'  ''          ''          '' \
218     1       ''      reIsTime124           '23:59:60'  ''          ''          '' \
219     0       ''      reIsTime124           '23:59:59'  ''          ''          '' \
220     0       ''      reIsTime124           '12:00:00 pm' ''        ''          '' \
221     0       ''      reIsTime124           '12:00:00 am' ''        ''          '' \
222     0       ''      reIsTime124           '12:59:59 pm' ''        ''          '' \
223     0       ''      reIsTime124           '12:59:59 am' ''        ''          '' \
224     1       ''      reIsTime124           '13:00:00 am' ''        ''          '' \
225     1       ''      reIsTime124           '12:60:00 am' ''        ''          '' \
226     1       ''      reIsTime124           '12:59:60 am' ''        ''          '' \
227     1       ''      reIsTime124           '13:00:00 pm' ''        ''          '' \
228     1       ''      reIsTime124           '12:60:00 pm' ''        ''          '' \
229     1       ''      reIsTime124           '12:59:60 pm' ''        ''          '' \
\
230     1       ''      reIsDateTime12        ''          ''          ''          '' \
231     0       ''      reIsDateTime12        '2000-02-29 12:00:00 am' '' ''      '' \
232     0       ''      reIsDateTime12        '2000-02-29 12:00:00 pm' '' ''      '' \
233     0       ''      reIsDateTime12        '2001-02-29 12:00:00 am' '' ''      '' \
234     0       ''      reIsDateTime12        '2001-02-28 12:00:00 am' '' ''      '' \
235     1       ''      reIsDateTime12        '2000-02-29 13:00:00 am' '' ''      '' \
236     1       ''      reIsDateTime12        '2000-02-29 12:60:00 am' '' ''      '' \
237     1       ''      reIsDateTime12        '2000-02-29 12:59:60 am' '' ''      '' \
238     0       ''      reIsDateTime12        '2000-02-29 12:59:59 am' '' ''      '' \
239     1       ''      reIsDateTime12        '0000-00-00 00:00:00 am' '' ''      '' \
240     1       ''      reIsDateTime12        '0001-00-00 00:00:00 am' '' ''      '' \
241     1       ''      reIsDateTime12        '0001-01-00 00:00:00 am' '' ''      '' \
242     1       ''      reIsDateTime12        '0001-01-01 00:00:00 am' '' ''      '' \
243     0       ''      reIsDateTime12        '0001-01-01 01:00:00 am' '' ''      '' \
244     0       ''      reIsDateTime12        '9999-01-01 01:00:00 am' '' ''      '' \
245     0       ''      reIsDateTime12        '9999-12-01 01:00:00 am' '' ''      '' \
246     0       ''      reIsDateTime12        '9999-12-31 01:00:00 am' '' ''      '' \
247     0       ''      reIsDateTime12        '9999-12-31 12:00:00 am' '' ''      '' \
248     0       ''      reIsDateTime12        '9999-12-31 12:59:00 am' '' ''      '' \
249     0       ''      reIsDateTime12        '9999-12-31 12:59:59 am' '' ''      '' \
250     1       ''      reIsDateTime12        '9999-13-31 12:59:59 am' '' ''      '' \
251     1       ''      reIsDateTime12        '9999-12-32 12:59:59 am' '' ''      '' \
252     1       ''      reIsDateTime12        '9999-12-31 12:59:59  am' '' ''     '' \
253     0       ''      reIsDateTime12        '9999-12-31 12:59:59 Am' '' ''      '' \
254     0       ''      reIsDateTime12        '9999-12-31 12:59:59 AM' '' ''      '' \
255     1       ''      reIsDateTime12        '9999-12-31 12:59:59 xm' '' ''      '' \
256     1       ''      reIsDateTime12        '2000-00-00 12:59:59 am' '' ''      '' \
257     1       ''      reIsDateTime12        '2000-01-00 12:59:59 am' '' ''      '' \
258     0       ''      reIsDateTime12        '0000-01-01 01:00:00 am' '' ''      '' \
\
259     1       ''      reIsDateTime24        ''                      ''  ''      '' \
260     1       ''      reIsDateTime24        '0000-00-00 00:00:00'   ''  ''      '' \
261     1       ''      reIsDateTime24        '0000-01-00 00:00:00'   ''  ''      '' \
262     0       ''      reIsDateTime24        '0000-01-01 00:00:00'   ''  ''      '' \
263     0       ''      reIsDateTime24        '0000-01-01 23:00:00'   ''  ''      '' \
264     1       ''      reIsDateTime24        '0000-01-01 24:00:00'   ''  ''      '' \
265     0       ''      reIsDateTime24        '0000-01-01 23:59:00'   ''  ''      '' \
266     1       ''      reIsDateTime24        '0000-01-01 23:60:00'   ''  ''      '' \
267     0       ''      reIsDateTime24        '0000-01-01 23:59:59'   ''  ''      '' \
268     1       ''      reIsDateTime24        '0000-01-01 23:59:60'   ''  ''      '' \
269     0       ''      reIsDateTime24        '9999-01-01 23:59:59'   ''  ''      '' \
270     0       ''      reIsDateTime24        '9999-12-01 23:59:59'   ''  ''      '' \
271     1       ''      reIsDateTime24        '9999-13-01 23:59:59'   ''  ''      '' \
272     0       ''      reIsDateTime24        '9999-12-31 23:59:59'   ''  ''      '' \
273     1       ''      reIsDateTime24        '9999-12-32 23:59:59'   ''  ''      '' \
274     0       ''      reIsDateTime24        '9999-12-31 23:59:59'   ''  ''      '' \
\
275     1       ''      reIsDateTime124       ''          ''          ''          '' \
276     0       ''      reIsDateTime124       '2000-02-29 12:00:00 am' '' ''      '' \
277     0       ''      reIsDateTime124       '2000-02-29 12:00:00 pm' '' ''      '' \
278     0       ''      reIsDateTime124       '2001-02-29 12:00:00 am' '' ''      '' \
279     0       ''      reIsDateTime124       '2001-02-28 12:00:00 am' '' ''      '' \
280     1       ''      reIsDateTime124       '2000-02-29 13:00:00 am' '' ''      '' \
281     1       ''      reIsDateTime124       '2000-02-29 12:60:00 am' '' ''      '' \
282     1       ''      reIsDateTime124       '2000-02-29 12:59:60 am' '' ''      '' \
283     0       ''      reIsDateTime124       '2000-02-29 12:59:59 am' '' ''      '' \
284     1       ''      reIsDateTime124       '0000-00-00 00:00:00 am' '' ''      '' \
285     1       ''      reIsDateTime124       '0001-00-00 00:00:00 am' '' ''      '' \
286     1       ''      reIsDateTime124       '0001-01-00 00:00:00 am' '' ''      '' \
287     1       ''      reIsDateTime124       '0001-01-01 00:00:00 am' '' ''      '' \
288     0       ''      reIsDateTime124       '0001-01-01 01:00:00 am' '' ''      '' \
289     0       ''      reIsDateTime124       '9999-01-01 01:00:00 am' '' ''      '' \
290     0       ''      reIsDateTime124       '9999-12-01 01:00:00 am' '' ''      '' \
291     0       ''      reIsDateTime124       '9999-12-31 01:00:00 am' '' ''      '' \
292     0       ''      reIsDateTime124       '9999-12-31 12:00:00 am' '' ''      '' \
293     0       ''      reIsDateTime124       '9999-12-31 12:59:00 am' '' ''      '' \
294     0       ''      reIsDateTime124       '9999-12-31 12:59:59 am' '' ''      '' \
295     1       ''      reIsDateTime124       '9999-13-31 12:59:59 am' '' ''      '' \
296     1       ''      reIsDateTime124       '9999-12-32 12:59:59 am' '' ''      '' \
297     1       ''      reIsDateTime124       '9999-12-31 12:59:59  am' '' ''     '' \
298     0       ''      reIsDateTime124       '9999-12-31 12:59:59 Am' '' ''      '' \
299     0       ''      reIsDateTime124       '9999-12-31 12:59:59 AM' '' ''      '' \
300     1       ''      reIsDateTime124       '9999-12-31 12:59:59 xm' '' ''      '' \
301     1       ''      reIsDateTime124       '2000-00-00 12:59:59 am' '' ''      '' \
302     1       ''      reIsDateTime124       '2000-01-00 12:59:59 am' '' ''      '' \
303     0       ''      reIsDateTime124       '0000-01-01 01:00:00 am' '' ''      '' \
304     1       ''      reIsDateTime124       ''                      ''  ''      '' \
305     1       ''      reIsDateTime124       '0000-00-00 00:00:00'   ''  ''      '' \
306     1       ''      reIsDateTime124       '0000-01-00 00:00:00'   ''  ''      '' \
307     0       ''      reIsDateTime124       '0000-01-01 00:00:00'   ''  ''      '' \
308     0       ''      reIsDateTime124       '0000-01-01 23:00:00'   ''  ''      '' \
309     1       ''      reIsDateTime124       '0000-01-01 24:00:00'   ''  ''      '' \
310     0       ''      reIsDateTime124       '0000-01-01 23:59:00'   ''  ''      '' \
311     1       ''      reIsDateTime124       '0000-01-01 23:60:00'   ''  ''      '' \
312     0       ''      reIsDateTime124       '0000-01-01 23:59:59'   ''  ''      '' \
313     1       ''      reIsDateTime124       '0000-01-01 23:59:60'   ''  ''      '' \
314     0       ''      reIsDateTime124       '9999-01-01 23:59:59'   ''  ''      '' \
315     0       ''      reIsDateTime124       '9999-12-01 23:59:59'   ''  ''      '' \
316     1       ''      reIsDateTime124       '9999-13-01 23:59:59'   ''  ''      '' \
317     0       ''      reIsDateTime124       '9999-12-31 23:59:59'   ''  ''      '' \
318     1       ''      reIsDateTime124       '9999-12-32 23:59:59'   ''  ''      '' \
319     0       ''      reIsDateTime124       '9999-12-31 23:59:59'   ''  ''      '' \
\
306     1       ''      reIsDateTimeAsCode    ''          ''          ''          '' \
307     1       ''      reIsDateTimeAsCode    '0000-00-00-00-00-00-000' '' ''     '' \
308     1       ''      reIsDateTimeAsCode    '9999-00-00-00-00-00-000' '' ''     '' \
309     1       ''      reIsDateTimeAsCode    '9999-99-00-00-00-00-000' '' ''     '' \
310     1       ''      reIsDateTimeAsCode    '9999-12-99-00-00-00-000' '' ''     '' \
311     1       ''      reIsDateTimeAsCode    '9999-12-31-99-00-00-000' '' ''     '' \
312     1       ''      reIsDateTimeAsCode    '9999-12-31-23-99-00-000' '' ''     '' \
323     1       ''      reIsDateTimeAsCode    '9999-12-31-23-59-99-000' '' ''     '' \
324     0       ''      reIsDateTimeAsCode    '9999-12-31-23-59-59-999' '' ''     '' \
325     0       ''      reIsDateTimeAsCode    '1234-12-12-12-12-12-123' '' ''     '' \
316     1       ''      reIsDateTimeAsCode    '12345-12-12-12-12-12-123' '' ''    '' \
317     1       ''      reIsDateTimeAsCode    '1234-123-12-12-12-12-123' '' ''    '' \
318     1       ''      reIsDateTimeAsCode    '1234-12-123-12-12-12-123' '' ''    '' \
319     1       ''      reIsDateTimeAsCode    '1234-12-12-123-12-12-123' '' ''    '' \
320     1       ''      reIsDateTimeAsCode    '1234-12-12-12-123-12-123' '' ''    '' \
321     1       ''      reIsDateTimeAsCode    '1234-12-12-12-12-123-123' '' ''    '' \
322     1       ''      reIsDateTimeAsCode    '1234-12-12-12-12-12-1234' '' ''    '' \
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

#!/usr/bin/env bash

################################################################################
# @file     test_libFile.sh
# @brief    Test and check libFile file.
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
declare -a  libLIST=(EscCodes Log String File)
declare -a  libLOADED=()
declare     libPATH="$HOME/dev/libShell"
declare     testPATH="$HOME/dev/libShell/test"

# Load Libs
for name in ${libLIST[@]}
do
    if [ -f "${libPATH}/lib${name}.sh" ]
    then
        source "${libPATH}/lib${name}.sh"
        if [ $? -eq 0 ]
        then
            libLOADED+=(${name})
        else
            echo -e "\033[91mfailure\033[0m: Load lib${name}.sh"
            exit 1
        fi
    else
        echo -e "\033[91mfailure\033[0m: File ${libPATH}/lib${name}.sh not found."
        exit 1
    fi
done

declare flagDebug=false

declare mapperDir="$(getMapperDir)"
declare mountDir="$(getMountDir)"

declare -i countLINE=0
declare -i countSUCCESS=0
declare -i countERROR=0
declare    RESULT=''
declare    RETURN=0
declare    flagSUCCESS=false
declare    flagRetOnFailure=false

# test table columns
declare -i columnID=0
declare -i columnRET=0
declare -i columnRES=1
declare -i columnFILE=2
declare -i columnP1=4
declare -i columnP2=5
declare -i columnP3=6
declare -i columnP4=7
declare -i maxCOLUMNS=3

# unset local variables and functions
function removeVars
{
    # Unset Variables
    unset -v libLIST
    unset -v libLOADED
    unset -v libPATH
    unset -v testPATH
    unset -v countLINE
    unset -v countTEST
    unset -v countSUCCESS
    unset -v countERROR
    unset -v RESULT
    unset -v RETURN
    unset -v SUCCESS
    unset -v columnID
    unset -v columnRET
    unset -v columnRES
    unset -v columnFILE
    unset -v columnP1
    unset -v columnP2
    unset -v columnP3
    unset -v columnP4
    unset -v maxCOLUMNS

    # Unset Function
    unset -f barGraph
    unset -f removeVars

    # Return Code
    return 0
}

# unload libs, exit from bash script and return an error code
function _exit()
{
    declare -i code="${1:-0}"

    # Stop logs
    if ! [ -z "${libLog}" ] ; then logStop ; fi

    # Unload Libs
    for file in "${libLOADED[@]}"
    do
        $(lib${file}Exit) || echo -e "\033[91mfailure\033[0m: Unload lib${file}.sh"
    done

    # Unload local variables
    unset -v file

    # Unload Global Variables and Functions
    removeVars
    unset -f _exit

    exit $code
}

# call _exit() function for some sign int.
trap _exit INT HUP TERM QUIT

# show help message
function usage()
{
    cat << EOT
Bash script to run a list of function for test.
Usage: $(basename "$0") [options] [-- libOptions]
Options:
-h|--help       Show usage message.
-g|--debug)     Enable debug messages.
-e|--error)     Return on error.
   --           Let pass next options to libLog
libLog Options:
EOT
    logHelp
}

# Parse parameters from command line.
while [ $# -gt 0 ] && [ -n "$1" ]
do
    case $1 in
    -h|--help) usage ; _exit 0 ;;
    -g|--debug) flagDebug=true ; logSetup "$1" || _exit $? ;;
    -e|--error) flagRetOnFailure=true ;;
    --) shift ; logInit "$@" || _exit $? ; break ;;
    -*) logSetup "$1" || _exit $? ;;
     *) logF "Unknown option ($1)." ; _exit $? ;;
    esac
    shift
done

# draw a bar graph
function barGraph()
{
    local testNum=$1
    local success=$2
    # print green "*" for success and red for failure.
    if $success ; then printf "${escIGREEN}*${escDC}" ; else printf "${escIRED}*${escDC}" ; fi
    # print [N] each 10 and "|" each 5
    if   [ $((testNum % 10)) -eq 0 ] ; then printf "[%3d]" $testNum
    elif [ $((testNum %  5)) -eq 0 ] ; then printf "|" ; fi
    # echo a new line each 50
    if  [ $((testNum % 50)) -eq 0 ] ; then echo ; fi
}

function _wait() { sleep $1 ; }

function _close()
{
    if [ -b "${mountDir}/$1"  ] ; then sudo umount -l "${mountDir}/$1"             ; fi
    if [ -d "${mountDir}/$1"  ] ; then sudo rmdir "${mountDir}/$1"                 ; fi
    if [ -b "${mapperDir}/$1" ] ; then sudo cryptsetup luksClose "${mapperDir}/$1" ; fi
}

# +--------------+---------------------------------------------------------------
# | Column       | Description
# +--------------+---------------------------------------------------------------
# | columnID     | Line number, "#" is a commented line.
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
#ID   return  result              function            parameter1  parameter2  parameter3  parameter4
declare -a testTABLE=(\
1 '' file_regexIt \
1 '' "file_regexIt 123 ''" \
1 '' "file_regexIt '' '^[-+]?\d+$'" \
1 '' "file_regexIt 123 '^[-+]?\d+$' --error" \
0 123 "file_regexIt 123 '^[-+]?\d+$'" \
0 '' "file_regexIt 123 '^[-+]?\d+$' -q" \
0 abyz "file_regexIt 123abyz 'abyz'" \
0 abyz "file_regexIt 123abyz123 'abyz'" \
1 '' "file_regexIt .456 '^[+-]?(\d+|\d+\.\d+)$'" \
0 '456' "file_regexIt 456 '^[+-]?(\d+|\d+\.\d+)$'" \
0 123.456 "file_regexIt 123.456 '^[-+]?(\d+|\d+\.\d+)$'" \
0 -123.456 "file_regexIt -123.456 '^[-+]?(\d+|\d+\.\d+)$'" \
0 +123.456 "file_regexIt +123.456 '^[-+]?(\d+|\d+\.\d+)$'" \
'#' '' 13
0 $(basename $0) getScriptName \
1 '' getFileName \
0 "$(basename $0)" "getFileName $0" \
'#' '' 17 \
1 '' getName \
0 'test_libFile' "getName $(basename $0)" \
'#' '' 19 \
1 '' getExt \
0 'sh' "getExt $(basename $0)" \
'#' '' 21 \
1 '' getPath \
1 '' "getPath ''" \
0 "$PWD" "getPath $PWD/$(basename $0)" \
'#' '' 24 \
1 '' isLink \
1 '' "isLink ''" \
1 '' "isLink /tmp" \
0 '' "isLink linkNotExist" \
0 '' "isLink linkToDir" \
'#' '' 29 \
1 '' isFile \
1 '' "isFile ''" \
1 '' "isFile /tmp" \
1 '' "isFile linkNotExist" \
0 '' "isFile $(basename $0)" \
0 '' "isFile $PWD/$(basename $0)" \
'#' '' 35 \
1 '' isDir \
1 '' "isDir ''" \
1 '' "isDir $(basename $0)" \
1 '' "isDir linkToFile" \
1 '' "isDir linkNotExist" \
0 '' "isDir $PWD" \
0 '' "isDir linkToDir" \
'#' '' 42 \
1 '' isBlockDevice \
1 '' "isBlockDevice linkToDir" \
1 '' "isBlockDevice $(basename $0)" \
1 '' "isBlockDevice $PWD" \
1 '' "isBlockDevice /tmp" \
0 '' "isBlockDevice /dev/sda1" \
'#' '' 48 \
0 '' "echo teste > /tmp/file" \
0 '' "[ -L linkToFile ] || ln -sf /tmp/file linkToFile" \
0 '' "[ -L linkToDir ] || ln -sf /tmp linkToDir" \
1 '' isLink \
1 '' "isLink ''" \
1 '' "isLink /tmp" \
1 '' "isLink /tmp/file" \
0 '' "isLink linkNotExist" \
0 '' "isLink linkToFile" \
0 '' "isLink linkToDir" \
'#' '' 58 \
1 '' getTarget \
1 '' "getTarget ''" \
0 '/tmp' "getTarget /tmp" \
0 '/tmp/file' "getTarget /tmp/file" \
1 '' "getTarget linkNotExist" \
0 '/tmp' "getTarget linkToDir" \
0 '/tmp/file' "getTarget linkToFile" \
'#' '' 65 \
1 '' targetExist \
1 '' "targetExist ''" \
1 '' "targetExist linkNotExist" \
0 '' "targetExist /tmp" \
0 '' "targetExist /tmp/file" \
0 '' "targetExist linkToDir" \
0 '' "targetExist linkToFile" \
'#' '' 72 \
1 '' tryRun \
1 '' "tryRun ''" \
1 '' "tryRun -x" \
1 '' "tryRun -r 1" \
1 '' "tryRun -r 1 -w 1" \
1 '' "tryRun -r 1 -w 1 -g" \
1 '' "tryRun -r 1 -w 1 -g -x" \
0 '' "tryRun -r 1 -w 1 sleep 0.1" \
0 '' 'tryRun -r 3 -w 1 sleep 0.1' \
'#' 81 "buildFindCmd( dir ext '>|>>' hash )" \
0 '' 'if [ -f /tmp/sha256sum ] ; then rm -f /tmp/sha256sum ; else true ; fi' \
1 '' '[ -f /tmp/sha256sum ] && true || false' \
1 '' "buildFindCmd '' '' '' ''" \
1 '' "buildFindCmd dir '' '' ''" \
1 '' "buildFindCmd dir '>' '' ''" \
2 '' "buildFindCmd '/not/exist' '>' '/tmp/sha256sum' '*.sh'" \
2 '' "buildFindCmd '/dir/error**.**' '>' '/tmp/sha256sum' '*.sh'" \
3 '' "buildFindCmd /tmp/ '>>>' '/tmp/sha256sum' '*.sh'" \
4 '' "buildFindCmd /tmp/ '>' '/tmp/sha256sum??error' '*.sh'" \
5 '' "buildFindCmd /tmp/ '>' '/tmp/sha256sum' '**filter.error**'" \
0 '' "buildFindCmd /tmp/ '>' '/tmp/sha256sum' '*.sh'" \
0 '' "buildFindCmd /tmp/ '>>' '/tmp/sha256sum' '*.sh'" \
0 "find $PWD/* -type f -not -path '.git' -exec sha256sum {} + > /tmp/sha256sum" "buildFindCmd $PWD/ '>' '/tmp/sha256sum'" \
0 "find $PWD/* -type f -name '*.sh' -not -path '.git' -exec sha256sum {} + > /tmp/sha256sum" "buildFindCmd $PWD/ '>' '/tmp/sha256sum' '*.sh'" \
0 "find $PWD/* -type f -not -path '.git' -exec sha256sum {} + | sha256sum >> /tmp/sha256sum" "buildFindCmd $PWD '>>' '/tmp/sha256sum'" \
0 "find $PWD/* -type f -name '*.sh' -not -path '.git' -exec sha256sum {} + | sha256sum >> /tmp/sha256sum" "buildFindCmd $PWD '>>' '/tmp/sha256sum' '*.sh'" \
'#' '' 97 \
1 '' "calcChecksum '' '' ''" \
1 '' "calcChecksum $PWD '' ''" \
1 '' "calcChecksum $PWD '' ''" \
2 '' "calcChecksum $PWD/**.error '/tmp/sha256sum' '*.sh'" \
2 '' "calcChecksum $PWD/notExist '/tmp/sha256sum' '*.sh'" \
4 '' "calcChecksum $PWD '/tmp/**error**' '*.sh'" \
5 '' "calcChecksum $PWD '/tmp/sha256sum' '**.error**'" \
0 '' '[ -f /tmp/sha256sum ] && rm /tmp/sha256sum || true' \
0 '' "calcChecksum $PWD '/tmp/sha256sum' '*.sh'" \
0 '' '[ -f /tmp/sha256sum ] && true || false' \
0 '' '[ -f /tmp/sha256sum ] && rm /tmp/sha256sum || true' \
0 '' "calcChecksum $PWD '/tmp/sha256sum' '*.sh'" \
0 '' '[ -f /tmp/sha256sum ] && true || false' \
0 '' '[ -f /tmp/sha256sum ] && rm /tmp/sha256sum || true' \
'#' '' 111 \
0 '' 'if [ -f /tmp/sha256sum ] ; then rm -f /tmp/sha256sum ; else true ; fi' \
1 '' "addChecksum" \
1 '' "addChecksum $PWD" \
2 '' "addChecksum $PWD/notFound /tmp/sha256sum" \
4 '' "addChecksum $PWD/ /tmp/**error**.**" \
5 '' "addChecksum $PWD /tmp/sha256sum '**.**error**'" \
0 '' '[ -f /tmp/sha256sum ] && rm /tmp/sha256sum || true' \
0 '' "addChecksum $PWD /tmp/sha256sum" \
0 '' '[ -f /tmp/sha256sum ] && true || false' \
0 '' '[ -f /tmp/sha256sum ] && rm /tmp/sha256sum || true' \
0 '' "addChecksum $PWD /tmp/sha256sum '*.sh'" \
0 '' '[ -f /tmp/sha256sum ] && true || false' \
0 '' '[ -f /tmp/sha256sum ] && rm /tmp/sha256sum || true' \
'#' '' 124 \
0 '' "echo 'a' > $PWD/teste.sh" \
0 '' "calcChecksum $PWD/ /tmp/sha256sum '*.sh'" \
0 '' '[ -f /tmp/sha256sum ] && true || false' \
1 '' "verifyChecksum" \
2 '' "verifyChecksum /tmp" \
2 '' "verifyChecksum /tmp/notFound" \
0 '' "verifyChecksum /tmp/sha256sum" \
0 '' "echo 'b' > $PWD/teste.sh" \
1 '' "verifyChecksum /tmp/sha256sum" \
'#' '' 133 \
1 '' haveChanges \
2 '' "haveChanges /tmp/notFound" \
0 '' "haveChanges /tmp/sha256sum" \
0 '' "echo 'a' > $PWD/teste.sh" \
1 '' "haveChanges /tmp/sha256sum" \
0 '' "echo 'b' > $PWD/teste.sh" \
0 '' "haveChanges /tmp/sha256sum" \
0 '' "if [ -f $PWD/teste.sh  ] ; then rm -f $PWD/teste.sh  ; else true ; fi" \
0 '' "if [ -f /tmp/sha256sum ] ; then rm -f /tmp/sha256sum ; else true ; fi" \
'#' '' 142 \
0 "/run/media/$USER" getMountDir \
0 '/dev/mapper' getMapperDir \
1 '' stripPunct \
0 'test' "stripPunct '@.test.!'" \
1 '' stripPathPunct \
0 'test' "stripPathPunct '/path/@.test.!'" \
1 '' genDeviceName \
0 'luks-test' "genDeviceName '/path/@.test.!'" \
'#' '' 150 \
1 '' setMode \
2 '' "setMode /tmp/notFound" \
0 '' "[ -d /tmp/test ] || mkdir /tmp/test" \
3 '' "setMode /tmp/test 1755" \
0 '' "setMode /tmp/test" \
0 '' "setMode /tmp/test 0755" \
0 '' "[ -d '/tmp/test' ] && rm -rf '/tmp/test'" \
'#' '' 157 \
1 '' setOwner \
2 '' "setOwner '/tmp/notFound'" \
0 '' "[ -d /tmp/test ] || mkdir /tmp/test" \
0 '' "setOwner /tmp/test" \
0 '' "setOwner /tmp/test $USER" \
0 '' "[ -d /tmp/test ] && rm -rf /tmp/test" \
'#' '' 163 \
1 '' makeDir \
2 '' "makeDir /tmp/test 1755" \
0 '' "makeDir /tmp/test" \
0 '' "[ -d /tmp/test ] && true || false" \
0 '' "[ -d /tmp/test ] && rm -rf /tmp/test" \
0 '' "makeDir /tmp/test 0755" \
0 '' "[ -d /tmp/test ] && true || false" \
0 '' "[ -d /tmp/test ] && rm -rf /tmp/test" \
"#" '' 171 \
1 '' removeDir \
1 '' "removeDir ''" \
0 '' "[ -d /tmp/test ] && rm -rf /tmp/test || true" \
1 '' "[ -d /tmp/test ] && true || false" \
1 '' "removeDir /tmp/test" \
0 '' "makeDir /tmp/test" \
0 '' "removeDir /tmp/test" \
1 '' "[ -d /tmp/test ] && true || false" \
"#" '' 179 \
1 '' getFS \
1 '' "getFS ''" \
1 '' "getFS '' ''" \
2 '' "getFS /tmp/notExist" \
3 '' "getFS /dev/sda1 notExist" \
3 '' "getFS luks.test notExist" \
0 'ext4' "getFS /dev/sda1" \
0 'ext4' "getFS luks.test" \
"#" '' 187 \
1 '' hasFS \
2 '' "hasFS notExist" \
2 '' "hasFS notExist ext4" \
3 '' "hasFS /dev/sda1 notExist" \
3 '' "hasFS luks.test notExist" \
0 '' "hasFS /dev/sda1" \
0 '' "hasFS luks.test" \
0 '' "hasFS /dev/sda1 ext4" \
0 '' "hasFS luks.test ext4" \
"#" '' 196 \
1 '' isLuksDevice \
1 '' "isLuksDevice ''" \
2 '' "isLuksDevice /tmp/notExist" \
0 '' "isLuksDevice /dev/sda1" \
0 '' "isLuksDevice luks.test" \
3 '' "isLuksDevice /tmp" \
"#" '' 202 \
1 '' format \
2 '' "format notExist" \
3 '' "format luks.test notExist" \
0 '' "format luks.test <<< `tr < /dev/urandom -d -c [:alnum:] | head --bytes=8`" \
0 '' "format luks.test password.txt" \
"#" '' 207 \
1 '' open \
2 '' "open notExist" \
3 '' "open luks.test" \
4 '' "open luks.test luks-test notExist" \
0 '' "open luks.test luks-test password.txt" \
0 '' '[ -e /dev/mapper/luks-test ] && true || false' \
"#" '' 213 \
0 '' '_wait 2' \
1 '' close \
2 '' "close notExist" \
0 '' "close luks-test" \
1 '' '[ -e /dev/mapper/luks-test ] && true || false' \
0 '' 'sudo mkdir /dev/mapper/luks-test' \
3 '' "close luks-test" \
0 '' 'sudo rmdir /dev/mapper/luks-test' \
"#" '' 221 \
1 '' formatFS \
2 '' "formatFS notExist" \
0 '' "open luks.test luks-test password.txt" \
3 '' "formatFS /dev/mapper/luks-test notExist" \
0 '' "formatFS /dev/mapper/luks-test" \
0 '' '_wait 2' \
0 '' "hasFS /dev/mapper/luks-test btrfs" \
0 '' "formatFS /dev/mapper/luks-test ext4" \
0 '' '_wait 2' \
0 '' "hasFS /dev/mapper/luks-test ext4" \
0 '' "close luks-test" \
"#" '' 232 \
1 '' mountDevice \
1 '' umountDevice \
1 '' setAccess \
1 '' openDrive \
"#" '' 237 \
1 '' closeDevice \
1 '' formatDrive \
0 '' libFileExit
"#" '' 240)

################################################################################
# Run countTEST TABLE if enabled.
################################################################################

# Start line counter and offset at 0.
countLINE=0
countTEST=0
idxID=$columnID
# Calculate the first function column OFFSET.
idxFUNC=$((idxID+columnFILE))

# while function name is not empty.
while [ -n "${testTABLE[$idxFUNC]}" ]
do
    if [[ "${testTABLE[$idxID]:0:1}" != "#" ]]
    then
        # inc test counter
        ((countTEST++))
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

        if $flagDebug ; then echo -e -n "${escIWHITE}   test${escDC}: ${testTABLE[$idxFUNC]} ${escIWHITE}->${escDC} " ; fi

        # run test from table and get the result.
        RESULT="$(eval "${testTABLE[$idxFUNC]}")"

        # take returned code from test.
        RETURN=$?

        # preset result to true.
        flagSUCCESS=true

        # compare result and returned code from function according table to check
        # for success or error and increment the respective counters.

        if [ "x${testTABLE[ $idxRES ]}" != 'x' ]
        then
            if [ "${RESULT}" != "${testTABLE[ $idxRES ]}" ]
            then
                flagSUCCESS=false
            fi
        fi

        # check only result
        if [ "x${testTABLE[ $idxRET ]}" != 'x' ]
        then
            if [ "${RETURN}" != "${testTABLE[ $idxRET ]}" ]
            then
                flagSUCCESS=false
            fi
        fi
        
        if $flagSUCCESS
        then
            ((countSUCCESS++))
        else
            ((countERROR++))
        fi

        # on debug mode, for any error, print the result on terminal.
        if $flagDebug
        then
            # for success...
            if $flagSUCCESS
            then
                echo -e "${escIGREEN}success${escDC}."
            # for failure...
            else
                echo
                logD "Test: $countTEST"
                #logD "Run: ${testTABLE[$idxFUNC]}(${testTABLE[$idxP1]},${testTABLE[$idxP2]},${testTABLE[$idxP3]},${testTABLE[$idxP4]})"
                logD "Run: ${testTABLE[$idxFUNC]}"
                logD "Ret: $RETURN compare to Table Ret: ${testTABLE[$idxRET]}"
                logD "Res: ${RESULT} compare to Table Res: ${testTABLE[$idxRES]}"
                echo -e "         ${escIRED}failure${escDC}."
                if $flagRetOnFailure ; then _exit $? ; fi
            fi
        # not in debug mode.
        else
            # show a bar graph,
            barGraph $countTEST $flagSUCCESS
        fi
    fi

    # inc line counter
    ((countLINE++))
    # next idxID offset from line counter.
    idxID=$((countLINE*maxCOLUMNS))
    # next function offset
    idxFUNC=$((idxID+columnFILE))
done

# new line after last bar graph.
echo

# print success and error counters on terminal.
if [ $countSUCCESS  -gt 0 ] ; then logS "${escIGREEN}$countSUCCESS${escDC} Test(s)" ; fi
if [ $countERROR    -gt 0 ] ; then logE "${escIRED}$countERROR${escDC} Test(s)"     ; fi

########################################
# This are is reserved for specific tests before exit from script.
# Check function parameter, function behaviors or result and returned code.



########################################

# Unload Libs, Variables and Functions.
_exit $countERROR


# libShell

**Description**: Shell Script Library.
**File**       : libShell.sh
**Author**     : Leandro - leandrohuff@programmer.net
**Date**       : 2025-09-10
**Version**    : 2.2.3
**Copyright**  : CC01 1.0 Universal
**Details**    : Formatted script file to service as a shell function library.
           Let a rapid shell script development with a list of common and
           most used functions.

### Constants

*integer* **libSTARTIME** = *timeseconds*
*vector integer* **libVERSION** = *(2 2 3)*
*vector integer* **libDATE** = *(2025 9 10)*
*integer* **logQUIET** = *0*
*integer* **logDEFAULT** = *1*
*integer* **logVERBOSE** = *2*
*integer* **logFULL** = *3*
*integer* **logTOSCREEN** = *16*
*integer* **logTOFILE** = *32*
*vector string* **typeRANDOM** = *(alpha digit alnum lowhex uphex mixhex random space date)*

#### Color Codes

*string* **NC** = *'033[0m'*
*string* **BLACK** = *'033[30m'*
*string* **RED** = *'033[31m'*
*string* **GREEN** = *'033[32m'*
*string* **YELLOW** = *'033[33m'*
*string* **BLUE** = *'033[34m'*
*string* **MAGENTA** = *'033[35m'*
*string* **CYAN** = *'033[36m'*
*string* **GRAY** = *'033[37m'*
*string* **DGRAY** = *'033[90m'*
*string* **HRED** = *'033[91m'*
*string* **HGREEN** = *'033[92m'*
*string* **HYELLOW** = *'033[93m'*
*string* **HBLUE** = *'033[94m'*
*string* **HMAGENTA** = *'033[95m'*
*string* **HCYAN** = *'033[96m'*
*string* **WHITE** = *'033[97m'*

### Variables

*boolean* **flagDEBUG** = *false*
*boolean* **flagTRACE** = *false*
*integer* **logTARGET** = *$logQUIET*
*integer* **logLEVEL** = *$logQUIET*
*string* **libTMP** = *''*
*string* **logFILE** = *''*
*integer* **libTIMEOUT** = *10*

### Functions

*none* **getScriptName**( **none** ) : *string*    - Get script name.
*integer* **getFileName**( *string* **path/filename.extension** ) : *string*    - Get file name from parameter.
*integer* **getName**( **none** ) : *string*    - Get only name from a filename parameter.
*integer* **getExt**( *string* **filename.extension** ) : *string*    - Get only extension from filename parameter.
*integer* **getPath**( *string* **path/filename** ) : *string*    - Get only path from filename parameter.
*none* **getTempDir**( **none** ) : *string*    - Get temporary directory.
*integer* **genRandomAlpha**( *integer* **length** ) : *string*    - Generate randomic alpha string.
*integer* **genRandomNumeric**( *integer* **length** ) : *string*    - Generate randomic numeric string.
*integer* **genRandomAlphaNumeric**( *integer* **length** ) : *string*    - Generate randomic alpha numeric string.
*integer* **genRandomLowerHexadecimalNumber**( *integer* **length** ) : *string*    - Generate randomic lower case hexadecimal number string.
*integer* **genRandomUpperHexadecimalNumber**( *integer* **length** ) : *string*    - Generate randomic upper caes hexadecimal number string.
*integer* **genRandomHexadecimalNumber**( *integer* **length** ) : *string*    - Generate randomic mixed lower and upper case hexadecimal number string.
*integer* **genRandomString**( *integer* **length** ) : *string*    - Generate Randomic graph char string.
*integer* **genRandomStringSpace**( *integer* **length** ) : *string*    - Generate randomic graph char and space string.
*none* **genDateTimeAsCode**( **none** ) : *string*    - Generate a formatted date and time string code.
*none* **getDateTime**( **none** ) : *string*    - Generate a formatted date string.
*none* **getDateTime**( **none** ) : *string*    - Generate a formatted time string.
*none* **getDateTime**( **none** ) : *string*    - Generate a formatted date and time string.
*none* **getLibVersionStr**( **none** ) : *string*    - Get libShell version number as string
*none* **getLibVersionNum**( **none** ) : *string*    - Get libShell version as a numer.
*none* **printLibVersion**( **none** ) : *string*    - Print formatted libShell string version.
*none* **getLibDateVersionStr**( **none** ) : *string*    - Get libShell date number as string.
*none* **getLibDateVersionNum**( **none** ) : *string*    - Get libShell date as a numer.
*none* **printLibDate**( **none** ) : *string*   - Print formatted libShell string date.
*none* **getRuntime**( **param** ) : *string*    - Get runtime number.
*none* **getLogFilename**( **none** ) : *string*    - Get log path and filename.
*boolean* **isConnected**( **none** ) : *none*   - Check is the internet connecton ative.
*boolean* **isEmpty**( *string* **variable** ) : *none*    - Check empty parameter.
*boolean* **notEmpty**( *string* **variable** ) : *none*    - Check not empty parameter.
*boolean* **isLink**( *string* **link** ) : *none*    - Check if parameter is a link to file or directory.
*boolean* **isFile**( *string* **file** ) : *none*    - Check parameter is a regualr file.
*boolean* **isDir**( *string* **dir** ) : *none*    - Check if parameter is a directory
*boolean* **isBlockDevice**( *string* **device** ) : *none*    - Check if parameter for block device.
*integer* **followLink**( *string* **link** ) : *string*    - Follow link and get target file.
*boolean* **isYes**( *string* **variable** ) : *none*    - Check parameter is affirmative.
*boolean* **isNot**( *string* **variable** ) : *none*    - Check parameter is negative.
*boolean* **isFloat**( *string* **variable** ) : *none*    - Check parameter is fa float or double number.
*boolean* **isInteger**( *string* **variable** ) : *none*    - Check parameter is an integer number.
*boolean* **isAlpha**( *string* **variable** ) : *none*    - Check parameter is an alphabetic string.
*boolean* **isDigit**( *string* **variable** ) : *none*    - Check parameter is a digit number.
*boolean* **isAlphaNumeric**( *string* **variable** ) : *none*    - Check parameter is alphabetic and numberic.string.
*boolean* **isHexadecimalNumber**( *string* **variable** ) : *none*    - Check parameter is a hexadecimal string
*boolean* **isLowerHexadecimalNumber**( *string* **variable** ) : *none*    - Check parameter is a lower case hexadecimal string.
*boolean* **isUpperHexadecimalNumber**( *string* **variable** ) : *none*    - Check parameter is a upper case hexadecimal string.
*boolean* **isAllGraphChar**( *string* **variable** ) : *none*    - Check parameter is all graphical character into the string.
*integer err* **strLength**( *string* **variable** ) : *integer length*    - Get string length.
*integer* **strCompare**( *string* **text 1** , *string* **text 2** ) : *integer*    - Compare string and return -N, 0 , +N
*integer* **compareFloat**( *string* **number 1** , *string* **number 2** ) : *integer*    - Compare float numbers and return -1,0,1
*integer* **subFloat**( *string* **number 1** , *string* **number 2** ) : *string*    - Add 2 flaot numbers.
*integer* **subFloat**( *string* **number 1** , *string* **number 2** ) : *string*    - Subtract 2 float number.
*integer* **multiplyFloat**( *string* **float number** , *string* **float divisor** ) : *string*    - Multiply 2 float numbers.
*integer* **divFloat**( *string* **float number** , *string* **float divisor** ) : *string*    - Divide 2 float numbers.
*integer* **isFloatInRange**( *string* **float number** , *string* **float min** , *string* **float max** ) : *integer*    - Check is float number between 2 float min and max numbers value.
*integer* **gitBranchName**( *string* **repository** ) : *string*    - Get current git branch name.
*integer* **gitCountAdded**( *string* **repository** ) : *integer*    - Get git added files counter.
*integer* **gitCountModified**( *string* **repository** ) : *integer*    - Get git modified files counter.
*integer* **gitCountDeleted**( *string* **repository** ) : *integer*    - Get git deleted files counter.
*boolean* **isGitRepository**( *string* **repository** ) : *none*    - Check is a git repository.
*inreger* **gitRepositoryName**( *string* **repository** ) : *string*    - Get git repository name.
*boolean* **isGitChanged**( *string* **repository** ) : *none*    - Check repository git files changed.
*boolean* **existBranch**( *string* **branch** ) : *none*    - Check repository have branch in its list.
*boolean* **inBranch**( *string* **branch** ) : *none*    - Check if respository is current branch.
*integer* **gitAdd**( *string* **files** ) : *none*    - Git add files to repository.
*integer* **gitCommitNotSigned**( *string* **message** ) : *none*    - Git not signed commit repository with a message.
*integer* **gitCommitSigned**( *string* **message** ) : *none*    - Git signed commit repository with a message.
*integer* **gitFetch**( **none** ) : *none*    - Git fetch current branch.
*integer* **gitPull**( **none** ) : *none*    - Git pull current branch.
*integer* **gitPush**( **none** ) : *none*    - Git push current branch.
*integer* **gitSetUpstream**( **none** ) : *none*    - Set branch up stream for push commands.
*integer* **newBranch**( *string* **branch** ) : *none*    - Createt new branch.
*integer* **gitSwitch**( *string* **branch** ) : *none*    - Switch to branch name.
*integer* **createBranch**( *string* **branch** ) : *none*    - Create a new git branch and switch to it.
*boolean* **linkExist**( *string* **link** ) : *none*    - Check if link referenced exist.
*boolean* **itExist**( *string* **link** ) : *none*    - Check if file or directory or link reference exist.
*integer* **getID**( **none** ) : *string*    - Get ID from os-release file.
*integer* **genVersionStr**( *vector integer* **version** ) : *result*    - Generate version string from parameter.
*integer* **genVersionNum**( *vector integer* **version** ) : *result*    - Generate version number from parameter.
*integer* **genDateVersionStr**( *vector integer* **date_version** ) : *string*    - Generate date version string from parameter.
*integer* **genDateVersionNum**( *vector integer* **date_version** ) : *integer*    - Generate date version number from parameter.
*boolean* **isLogQuiet**( **none** ) : *none*    - Check is log quiet enabled.
*boolean* **isLogDefault**( **none** ) : *none*    - Check is log default enabled.
*boolean* **isLogVerbose**( **none** ) : *none*    - Check verbose log enabled.
*boolean* **isLogToScreenEnabled**( **none** ) : *none*    - Check log to screen enabled.
*boolean* **isLogToFileEnabled**( **none** ) : *none*    - Check log to file enabled.
*boolean* **isLogEnabled**( **none** ) : *none*    - Check log enabled (screen or file and not quiet).

### Log Functions Table

| Function | Description   | Level   |
|:--------:|:-------------:|:-------:|
| logU     | Unconditional | none    |
| logIt    | Anything      | enabled |
| logI     | Info          | normal  |
| logR     | Runtime       | normal  |
| logE     | Error         | normal  |
| logF     | Failure       | normal  |
| logS     | Success       | verbose |
| logV     | Verbose Info  | verbose |
| logW     | Warning       | verbose |
| logD     | Debug         | debug   |
| logT     | Trace         | trace   |

*none* **logU**( *string* **message** ) : *string*    - Log anything unconditional to screen and file.
*none* **logIt**( *string* **message** ) : *string*    - Log anything according to log flags.
*none* **logI**( *string* **message** ) : *string*    - Info logs.
*none* **logE**( *string* **message** ) : *string*    - Error logs.
*none* **logF**( *string* **message** ) : *string*    - Failure logs.
*none* **logR**( *string* **message** ) : *string*    - Runtime logs.
*none* **logS**( *string* **message** ) : *string*    - Success logs.
*none* **logV**( *string* **message** ) : *string*    - Verbose info logs.
*none* **logW**( *string* **message** ) : *string*    - Warning logs.
*none* **logD**( *string* **message** ) : *string*    - Debug logs.
*none* **logT**( *string* **message** ) : *string*    - Trace logs.
*integer* **getRuntimeStr**( **none** ) : *string*    - Generate|Get runtime string.
*boolean* **isParameter**( *string* **parameter** ) : *result*    - Check command line parameter is a true parameter.
*boolean* **isArgValue**( *string* **argv** ) : *none*    - Check command line parameter is a true value.
*integer* **unsetLibVars**( **none** ) : *none*    - Unset library variables.
*integer* **libStop**( **none** ) : *none*    - Stop|End library execution.
*integer* **printLibHelp**( **none** ) : *string*    - Print library help information.
*integer* **genRandom**( *string* **type** , *integer* **length** ) : *string*    - Generate an random string according parameter length.
*integer* **genUUID**( *string* **type** , *integer* **length** ) : *string*    - Generate an random string according parameters.
*none* **getMountDir**( **none** ) : *string*    - Get mount directory string.
*integer* **logBegin**( **none** ) : *none*    - Begin|Start log to file.
*integegr* **logEnd**( **none** ) : *result*    - End|Stop log to file.
*integer* **askToContinue**( *integer* **timetou** , *string* **message** ) : *none*    - Print a message and ask user to continue and get the answer.
*integer* **wait**( *integer* **timeout** , *string* **message** ) : *none*    - Print a message and wait user to continue.
*integer* **loadID**( **none** ) : *result*    - Source /etc/os-release file.
*integer* **function**( **none** ) : *string*    - Get Linux distro name.
*integer* **libSetup**( *vector string* **[@]** ) : *none*    - Setup libShell.
*integer* **libInit**( *vector string* **[@]** ) : *none*    - Initialize libShell.

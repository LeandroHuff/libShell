# libShell - Shell Script Library

### File: libShell.sh

### Date: 2025-09-10

### Version: 2.2.3

Shell Script Library is a formatted shell script file to service resource to rapidly develop programs in bash script.

Many variables and functions are ready to use without the need to re-write it again, the purpose of this library is to reuse source code that are usually written.

## Constants (read only)

**libSTARTIME**: Timestampo at the beginning of libShell running.

**libVERSION(2 2 3)**: libShell version number.

**libDATE(2025 9 10)**: Date for use as a libShell version.

**logQUIET = 0**: Quiet code, no log messages.

**logDEVAULT = 1**: Log default messages.

**logVERBOSE = 2**: Log more messages on screen or file.

**logFULL = 3**: Log bouth for level or screen + file.

**logTOSCREEN = 16**: Enable log to screen or terminal|console.

**logTOFILE = 32**: Enable log to file stored into *logFILE* variable.

**typeRANDOM = (alpha digit alnum lowhex uphex mixhex random space date)**: Array to store random IDs to use on functions to get randomic strings.

## Variables (read and write)

**flagDEBUG = false**: Enable debug mode (true).

**flagTRACE = false**: Enable trace messages (true).

**logTARGET = $logQUIET**: Set log target to logTOSCREEN and/or logTOFILE flags, can be individual or bougth together.

**logLEVEL = $logQUIET** : Set log level to quiet, default or verbose flags.

**libTMP**: Store temporary directory.

**logFILE = /tmp/shellscriptname.sh.log**: Store path and filename to save log messages.

**libTIMEOUT = 10** : Start timeout value for use in functions that require wait state.

### Color Constants (read only)

| Name     | Code       | Description       |
| -------- | ---------- | ----------------- |
| NC       | '\033[0m'  | No Color          |
| BLACK    | '\033[30m' | Black             |
| RED      | '\033[31m' | Red               |
| GREEN    | '\033[32m' | Green             |
| YELLOW   | '\033[33m' | Yellow            |
| BLUE     | '\033[34m' | Blue              |
| MAGENTA  | '\033[35m' | Magenta           |
| CYAN     | '\033[36m' | Cyan              |
| GRAY     | '\033[37m' | Gray              |
| DGRAY    | '\033[90m' | Dark Gray         |
| HRED     | '\033[91m' | Highlight Red     |
| HGREEN   | '\033[92m' | Highlight Green   |
| HYELLOW  | '\033[93m' | Highlight Yellow  |
| HBLUE    | '\033[94m' | Highlight Blue    |
| HMAGENTA | '\033[95m' | Highlight Magenta |
| HCYAN    | '\033[96m' | Highlight Cyan    |
| WHITE    | '\033[97m' | Highlight White   |

## Functions (sorted by name)

| Return      | Result      | Function                            | Param 1                  | Param 2           | Param 3         |
|:-----------:|:-----------:|:-----------------------------------:|:------------------------:|:-----------------:|:---------------:|
| 0\|N        | float       | **addFloat**                        | num1:$1:float            | num2:$2:float     | -               |
| 0\|N        | -           | **askToContinue**                   | timeout:$1:integer       | message:$2:string | -               |
| 0\|N        | float       | **compareFloat**                    | num1:$1:float            | num2:$2:float     | -               |
| 0\|N        | -           | **createBranch**                    | branch:$1:string         | -                 | -               |
| 0\|N        | float       | **divFloat**                        | num1:$1:float            | num2:$2:float     | -               |
| true\|false | -           | **existBranch**                     | branch:$1:string         | -                 | -               |
| 0\|N        | string      | **followLink**                      | link:$1:string           | -                 | -               |
| 0           | string      | **genDateTimeAsCode**               | -                        | -                 | -               |
| 0\|1        | integer     | **genDateVersionNum**               | vector:$[@]:integer      | -                 | -               |
| 0\|1        | string      | **genDateVersionStr**               | vector:$[@]:integer      | -                 | -               |
| 0\|N        | string      | **genRandom**                       | type:$1:string           | len:$2:integer    | -               |
| 0\|1        | string      | **genRandomAlpha**                  | len:$1:integer           | -                 | -               |
| 0\|1        | string      | **genRandomAlphaNumeric**           | len:$1:integer           | -                 | -               |
| 0\|1        | string      | **genRandomHexadecimalNumber**      | len:$1:integer           | -                 | -               |
| 0\|1        | string      | **genRandomLowerHexadecimalNumber** | len:$1:integer           | -                 | -               |
| 0\|1        | string      | **genRandomNumeric**                | len:$1:integer           | -                 | -               |
| 0\|1        | string      | **genRandomString**                 | len:$1:integer           | -                 | -               |
| 0\|1        | string      | **genRandomStringSpace**            | len:$1:integer           | -                 | -               |
| 0\|1        | string      | **genRandomUpperHexadecimalNumber** | len:$1:integer           | -                 | -               |
| 0\|1        | string      | **genUUID**                         | type:$1:string           | len:$2:integer    | -               |
| 0\|1        | integer     | **genVersionNum**                   | vector:$[@]:integer      | -                 | -               |
| 0\|1        | string      | **genVersionStr**                   | vector:$[@]:integer      | -                 | -               |
| 0\|1        | string      | **getDate**                         | -                        | -                 | -               |
| 0\|1        | string      | **getTime**                         | -                        | -                 | -               |
| 0\|1        | string      | **getDateTime**                     | -                        | -                 | -               |
| 0\|1        | string      | **getDistroName**                   | \$ID                     | -                 | -               |
| 0\|1        | string      | **getEXT**                          | filename:\$1:string      | -                 | -               |
| 0\|1        | string      | **getFileName**                     | path/filename:\$1:string | -                 | -               |
| 0\|1        | string      | **getID**                           | \$ID                     | -                 | -               |
| 0\|1        | integer     | **getLibDateVersionNum**            | libDATE[@]               | -                 | -               |
| 0\|1        | string      | **getLibDateVersionStr**            | libDATE[@]               | -                 | -               |
| 0\|1        | integer     | **getLibVersionNum**                | libVERSION[@]            | -                 | -               |
| 0\|1        | string      | **getLibVersionStr**                | libVERSION[@]            | -                 | -               |
| 0\|1        | string      | **getLogFilename**                  | -                        | -                 | -               |
| 0\|1        | string      | **getMountDir**                     | -                        | -                 | -               |
| 0\|1        | string      | **getName**                         | filename:\$1:string      | -                 | -               |
| 0\|1        | string      | **getPath**                         | filename:\$1:string      | -                 | -               |
| 0\|1        | integer     | **getRuntime**                      | -                        | -                 | -               |
| 0\|1        | string      | **getRuntimeStr**                   | -                        | -                 | -               |
| 0\|1        | string      | **getScriptName**                   | -                        | -                 | -               |
| 0\|1        | string      | **getTempDir**                      | -                        | -                 | -               |
| 0\|1        | string      | **getTime**                         | -                        | -                 | -               |
| 0\|N        | -           | **gitAdd**                          | files:\$1:string         | -                 | -               |
| 0\|N        | string      | **gitBranchName**                   | repository:\$1:string    | -                 | -               |
| 0\|N        | -           | **gitCommitNotSigned**              | -                        | -                 | -               |
| 0\|N        | -           | **gitCommitSigned**                 | -                        | -                 | -               |
| 0\|N        | integer     | **gitCountAdded**                   | repository:\$1:string    | -                 | -               |
| 0\|N        | integer     | **gitCountDeleted**                 | repository:\$1:string    | -                 | -               |
| 0\|N        | integer     | **gitCountModified**                | repository:\$1:string    | -                 | -               |
| 0\|N        | -           | **gitFetch**                        | -                        | -                 | -               |
| 0\|N        | -           | **gitPull**                         | -                        | -                 | -               |
| 0\|N        | -           | **gitPush**                         | -                        | -                 | -               |
| 0\|N        | string      | **gitRepositoryName**               | repository:\$1:string    | -                 | -               |
| 0\|N        | -           | **gitSetUpstream**                  | -                        | -                 | -               |
| 0\|N        | -           | **gitSwitch**                       | branch:\$1:string        | -                 | -               |
| 0\|N        | true\|false | **inBranch**                        | branch:\$1:string        | -                 | -               |
| 0\|N        | true\|false | **isAllGraphChar**                  | \$1:string               | -                 | -               |
| 0\|N        | true\|false | **isAlpha**                         | \$1:string               | -                 | -               |
| 0\|N        | true\|false | **isAlphaNumeric**                  | \$1:string               | -                 | -               |
| 0\|N        | true\|false | **isArgValue**                      | \$1:string               | -                 | -               |
| 0\|N        | true\|false | **isBlockDevice**                   | \$1:string               | -                 | -               |
| 0\|N        | true\|false | **isConnected**                     | -                        | -                 | -               |
| 0\|N        | true\|false | **isDigit**                         | \$1:string               | -                 | -               |
| 0\|N        | true\|false | **isDir**                           | \$1:string               | -                 | -               |
| 0\|N        | true\|false | **isEmpty**                         | \$1:string               | -                 | -               |
| 0\|N        | true\|false | **isFile**                          | \$1:string               | -                 | -               |
| 0\|N        | true\|false | **isFloat**                         | num:\$1:string           | -                 | -               |
| 0\|1        | true\|false | **isFloatInRange**                  | num1:\$1:string          | num2:\$2:string   | num3:\$3:string |
| 0\|1        | true\|false | **isGitChanged**                    | repository:\$1:string    | -                 | -               |
| 0\|N        | true\|false | **isGitRepository**                 | repository:\$1:string    | -                 | -               |
| 0\|N        | true\|false | **isHexadecimalNumber**             | num:\$1:string           | -                 | -               |
| 0\|N        | true\|false | **isInteger**                       | num:\$1:string           | -                 | -               |
| 0\|N        | true\|false | **isLink**                          | link:\$1:string          | -                 | -               |
| -           | true\|false | **isLogDefault**                    | -                        | -                 | -               |
| -           | true\|false | **isLogEnabled**                    | -                        | -                 | -               |
| -           | true\|false | **isLogQuiet**                      | -                        | -                 | -               |
| -           | true\|false | **isLogToFileEnabled**              | -                        | -                 | -               |
| -           | true\|false | **isLogToScreenEnabled***           | -                        | -                 | -               |
| -           | true\|false | **isLogVerbose**                    | -                        | -                 | -               |
| -           | true\|false | **isLowerHexadecimalNumber**        | num:\$1:string           | -                 | -               |
| -           | true\|false | **isNot**                           | $1:string                | -                 | -               |
| -           | true\|false | **isUpperHexadecimalHumber**        | num:\$1:string           | -                 | -               |
| -           | true\|false | **isYes**                           | $1:string                | -                 | -               |
| -           | true\|false | **itExist**                         | $1:string                | -                 | -               |
| -           | true\|false | **linkExist**                       | link:\$1:string          | -                 | -               |
| -           | -           | **logE**                            | $1:string                | -                 | -               |
| -           | -           | **logF**                            | $1:string                | -                 | -               |
| -           | -           | **logI**                            | $1:string                | -                 | -               |
| -           | -           | **logIt**                           | $1:string                | -                 | -               |
| -           | -           | **logR**                            | $1:string                | -                 | -               |
| -           | -           | **logS**                            | $1:string                | -                 | -               |
| -           | -           | **logU**                            | $1:string                | -                 | -               |
| 0\|N        | float       | **multiplyFloat**                   | num1:\$1:float           | num2:\$2:float    | -               |
| 0\|N        | -           | **newBranch**                       | branch:\$1:string        | -                 | -               |
| -           | true\|false | **notEmpty**                        | $1:string                | -                 | -               |
| -           | string      | **printLIbDate**                    | -                        | -                 | -               |
| -           | string      | **printLibVersion**                 | -                        | -                 | -               |
| 0\|N        | -1\|0\|+1   | **strCompare**                      | $1:string                | $2:string         | -               |
| 0\|N        | integer     | **strLength**                       | $1:string                | -                 | -               |
| 0\|N        | float       | **subFloat**                        | num1:\$1:float           | num2:\$1:float    |                 |
|             |             |                                     |                          |                   |                 |
|             |             |                                     |                          |                   |                 |
|             |             |                                     |                          |                   |                 |
|             |             |                                     |                          |                   |                 |

## Functions (grouped by use)

### Strings

| Return | Result      | Function                            | Param 1         | Param 2 | Param 3 |
|:------:|:-----------:|:-----------------------------------:|:---------------:|:-------:|:-------:|
| 0 \| 1 | String      | **getScriptName**                   |                 |         |         |
| 0 \| 1 | String      | **getName**                         | String Filename |         |         |
| 0 \| 1 | String      | **getExt**                          | String Filename |         |         |
| 0 \| 1 | String      | **getPath**                         | String Filename |         |         |
| 0 \| 1 | String      | **getRandomAlpha**                  | Integer Length  |         |         |
| 0 \| 1 | String      | **genRandomNumberic**               | Integer Length  |         |         |
| 0 \| 1 | String      | **genRandomAlphaNumeric**           | Integer Length  |         |         |
| 0 \| 1 | String      | **genRandomLowerHexadecimalNumber** | Integer Length  |         |         |
| 0 \| 1 | String      | **genRandomUpperHexadecimalNumber** | Integer Length  |         |         |
| 0 \| 1 | String      | **genRandomHexadecimalNumber**      | Integer Length  |         |         |
| 0 \| 1 | String      | **genRandomString**                 | Integer Length  |         |         |
| 0 \| 1 | String      | **genRandomStringSpace**            | Integer Length  |         |         |
| 0 \| 1 | String      | **genDateTimeAsCode**               |                 |         |         |
| 0 \| 1 | String      | **getDate**                         |                 |         |         |
| 0 \| 1 | String      | **getTime**                         |                 |         |         |
| 0 \| 1 | String      | **getDateTime**                     |                 |         |         |
| 0 \| 1 | String      | **getLibVersionStr**                |                 |         |         |
| 0 \| 1 | String      | **getLibVersionNum**                |                 |         |         |
| 0 \| 1 | String      | **printLibVersion**                 |                 |         |         |
| 0 \| 1 | String      | **getLibDateVersionStr**            |                 |         |         |
| 0 \| 1 | String      | **printLibDate**                    |                 |         |         |
| 0 \| 1 | String      | **getRuntime**                      |                 |         |         |
| 0 \| 1 | true\|false | **isAlpha**                         | String          |         |         |
| 0 \| 1 | true        | false                               | **isDigit**     | String  |         |
| 0 \| 1 | true\|false | **isAlphaNumeric**                  | String          |         |         |
| 0 \| 1 | true\|false | **isHexadecimalNumber**             | String          |         |         |
| 0 \| 1 | true\|false | **isLowerHexadecimalNumber**        | String          |         |         |
| 0 \| 1 | true\|false | **isUpperHexadecimalNumber**        | String          |         |         |
| 0 \| 1 | true\|false | **isAllGraphChar**                  | String          |         |         |
| 0 \| 1 | Integer     | **strLength**                       | String          |         |         |
| 0 \| 1 | -N\|0\|+N   | **strCompare**                      | String          |         |         |
| 0 \| 1 | -N\|0\|+N   | **strCompare**                      | String          |         |         |
| 0 \| 1 | String      | **genVersionStr**                   | Integer Vector  |         |         |
| 0 \| 1 | Integer     | **genVersionNum**                   | Integer Vector  |         |         |
| 0 \| 1 | String      | **genDateVersionStr**               | Integer Vector  |         |         |
| 0 \| 1 | Integer     | **genDateVersionNum**               | Integer Vector  |         |         |
| 0 \| 1 | String      | **getRuntimeStr**                   |                 |         |         |
| 0 \| 1 | String      | **genRandom**                       | String          | Integer |         |
| 0 \| 1 | String      | **genUUID**                         | String          | Integer |         |

### Math

| Return | Result      | Function           | Param 1 | Param 2 | Param 3 |
|:------:|:-----------:|:------------------:|:-------:|:-------:|:-------:|
|        | true\|false | **isFloat**        | String  |         |         |
|        | true\|false | **isInteger**      | String  |         |         |
|        | -1\|0\|+1   | **compareFloat**   | Float   | Float   |         |
|        | Float       | **addFloat**       | Float   | Float   |         |
|        | Float       | **subFloat**       | Float   | Float   |         |
|        | Float       | **multiplyFloat**  | Float   | Float   |         |
|        | Float       | **divFloat**       | Float   | Float   |         |
|        | true\|false | **isFloatInRange** | Float   | Float   | Float   |

### Shell

| Return  | Result      | Function          | Param 1 | Param 2 | Param 3 |
|:-------:|:-----------:|:-----------------:|:-------:|:-------:|:-------:|
|         | true\|false | **isFloat**       | String  |         |         |
|         | true\|false | **isEmpty**       | $1      |         |         |
|         | true\|false | **notEmpty**      |         |         |         |
|         | true\|false | **notEmpty**      |         |         |         |
|         | true\|false | **isYes**         | String  |         |         |
|         | true\|false | **isNot**         | String  |         |         |
|         | ID          | **getID**         |         |         |         |
|         | true\|false | **isParameter**   | String  |         |         |
|         | true\|false | **isArgValue**    | String  |         |         |
| 0       |             | **unsetLibVars**  |         |         |         |
| 0       |             | **libStop**       |         |         |         |
| 0       |             | **printHelp**     |         |         |         |
| 0\|1\|2 |             | **askToContinue** | Integer | String  |         |
| 0\|1\|2 |             | **wait**          | Integer | String  |         |
| 0\|1    |             | **loadID**        |         |         |         |
| 0\|1    | String      | **getDistroName** |         |         |         |

### libShell

| Return | Result | Function                 | Param 1 | Param 2 | Param 3 |
|:------:|:------:|:------------------------:|:-------:|:-------:|:-------:|
| 0 \| 1 |        | **libSetup**             | $[@]    |         |         |
| 0 \| 1 |        | **libInit**              | $[@]    |         |         |
| 0 \| 1 | String | **getLibVersionStr**     |         |         |         |
| 0 \| 1 | String | **getLibVersionNum**     |         |         |         |
| 0 \| 1 | String | **printLibVersion**      |         |         |         |
| 0 \| 1 | String | **getLibDateVersionStr** |         |         |         |
| 0 \| 1 | String | **printLibDate**         |         |         |         |
| 0      |        | **unsetLibVars**         |         |         |         |
| 0      |        | **libStop**              |         |         |         |
| 0      |        | **printHelp**            |         |         |         |

### Log

| Return | Result        | Function                 | Param 1 | Param 2 | Param 3 |
|:------:|:-------------:|:------------------------:|:-------:|:-------:|:-------:|
|        | true or false | **isLogQuiet**           |         |         |         |
|        | true or false | **isLogDefault**         | String  |         |         |
|        | true or false | **isLogVerbose**         | String  |         |         |
|        | true or false | **isLogToScreenEnabled** | String  |         |         |
|        | true or false | **isLogToFileEnabled**   | String  |         |         |
|        | true or false | **isLogEnabled**         | String  |         |         |
| 0 \| 1 | String        | **getLogFilename**       |         |         |         |
|        |               | **logIt**                | String  |         |         |
|        |               | **logI**                 | String  |         |         |
|        |               | **logE**                 | String  |         |         |
|        |               | **logF**                 | String  |         |         |
|        |               | **logR**                 | String  |         |         |
|        |               | **logS**                 | String  |         |         |
|        |               | **logV**                 | String  |         |         |
|        |               | **logW**                 | String  |         |         |
|        |               | **logD**                 | String  |         |         |
|        |               | **logT**                 | String  |         |         |
|        |               | **logBegin**             |         |         |         |
|        |               | **logEnd**               |         |         |         |

### Git

| Return | Result        | Function               | Param 1 | Param 2 | Param 3 |
|:------:|:-------------:|:----------------------:|:-------:|:-------:|:-------:|
|        | String        | **gitBranchName**      | String  |         |         |
|        | Integer       | **gitCountAdded**      | String  |         |         |
|        | Integer       | **gitCountModified**   | String  |         |         |
|        | Integer       | **gitCountDeleted**    | String  |         |         |
|        | true or false | **isGitRepository**    | String  |         |         |
|        | String        | **gitRepositoryName**  | String  |         |         |
|        | true or false | **isGitChanged**       |         |         |         |
|        | true or false | **existBranch**        | String  |         |         |
|        | true or false | **inBranch**           | String  |         |         |
| 0\|1   |               | **gitAdd**             | String  |         |         |
| 0\|1   |               | **gitCommitNotSigned** | String  |         |         |
| 0\|1   |               | **gitCommitSigned**    | String  |         |         |
| 0\|1   |               | **gitFetch**           |         |         |         |
| 0\|1   |               | **gitPull**            |         |         |         |
| 0\|1   |               | **gitPush**            |         |         |         |
| 0\|1   |               | **gitSetUpstream**     |         |         |         |
| 0\|1   |               | **newBranch**          | String  |         |         |
| 0\|1   |               | **gitSwitch**          | String  |         |         |
| 0\|1   |               | **createBranch**       | String  |         |         |

### File System

| Return | Result        | Function           | Param 1 | Param 2 | Param 3 |
|:------:|:-------------:|:------------------:|:-------:| ------- | ------- |
| 0 \| 1 | String        | **getScriptName**  | String  |         |         |
| 0 \| 1 | String        | **getTempDir**     |         |         |         |
| 0 \| 1 | String        | **getLogFilename** |         |         |         |
| 0 \| 1 | true or false | **isLink**         | String  |         |         |
| 0 \| 1 | true or false | **isFile**         | String  |         |         |
| 0 \| 1 | true or false | **isDir**          | String  |         |         |
| 0 \| 1 | true or false | **isBlockDevice**  | String  |         |         |
| 0 \| 1 | String        | **folowLink**      | String  |         |         |
| 0 \| 1 | true or false | **linkExist**      | String  |         |         |
| 0 \| 1 | true or false | **itExist**        | String  |         |         |
| 0 \| 1 | String        | **getMountDir**    |         |         |         |

### Connection

| Return | Result      | Function        | Param 1 | Param 2 | Param 3 |
|:------:|:-----------:|:---------------:|:-------:| ------- | ------- |
|        | true\|false | **isConnected** |         |         |         |

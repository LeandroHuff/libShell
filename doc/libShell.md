# libShell

**Description**: Shell Script Library.
       **File**: libShell.sh
     **Author**: Leandro - leandrohuff@programmer.net
       **Date**: 2025-09-10
    **Version**: 2.2.3
  **Copyright**: CC01 1.0 Universal
Formatted script file to service as a shell function library.
Let a rapid shell script development with a list of common and
most used functions.

## Constants

*integer* **libSTARTIME** = *timeseconds*
*integer*[] **libVERSION** = *(2 2 3)*
*integer*[] **libDATE** = *(2025 9 10)*
*integer* **logQUIET** = *0*
*integer* **logDEFAULT** = *1*
*integer* **logVERBOSE** = *2*
*integer* **logFULL** = *3*
*integer* **logTOSCREEN** = *16*
*integer* **logTOFILE** = *32*
*string*[] **typeRANDOM** = *(alpha digit alnum lowhex uphex mixhex random space date)*

## Color Codes

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

## Variables

*boolean* **flagDEBUG** = *false*
*boolean* **flagTRACE** = *false*
*integer* **logTARGET** = *logQUIET*
*integer* **logLEVEL** = *logQUIET*
*string* **libTMP** = *''*
*string* **logFILE** = *''*
*integer* **libTIMEOUT** = *10*

## Functions

### Shell

#### isYes()

**Function**:
*none* **isYes**( *string* ) : *boolean*
Check for affirmative parameter.
**Parameter**:
*string*    Value to check.
**Result**:
*boolean*    **true**: Is an affirmative parameter value.
*boolean*   **false**: Is not an affirmative parameter value.
**Return**:
*none*

#### isNot()

**Function**:
*none* **isNot**( *string* ) : *boolean*
Check for negative parameter.
**Parameter**:
*string*    Value to check.
**Result**:
*boolean*    **true**: Is an negative parameter value.
*boolean*   **false**: Is not an negative parameter value.
**Return**:
*none*

#### isEmpty()

**Function**:
*none* **isEmpty**( *string* ) : *boolean*
Check empty parameter.
**Parameter**:
*string*    Value to check.
**Result**:
*boolean*    **true**: Is empty.
*boolean*   **false**: Is not empty.
**Return**:
*none*

#### notEmpty()

**Function**:
*none* **notEmpty**( *string* ) : *boolean*
Check not empty parameter.
**Parameter**:
*string*    Value to check.
**Result**:
*boolean*    **true**: Is not empty.
*boolean*   **false**: Is empty.
**Return**:
*none*

#### isParameter()

**Function**:
*none* **isParameter**( *string* ) : *boolean*
Check for a valid command line parameter tag.
**Parameter**:
*string*    Parameter to check.
**Result**:
*boolean*    **true**: Is a valid parameter tag.
*boolean*   **false**: Is not a valid parameter tag.
**Return**:
*none*

#### isArgValue()

**Function**:
*none* **isArgValue**( *string* ) : *boolean*
Check for a valid command line parameter argument|value.
**Parameter**:
*string*    Parameter to check.
**Result**:
*boolean*    **true**: Is a valid arg value.
*boolean*   **false**: Is not a valid arg value.
**Return**:
*none*

#### getScriptName()

**Function**:
*none* **getScriptName**( *none* ) : *string*
Get shell script filename.
**Parameter**:
*none*
**Result**:
*string*    Shell script filename.
**Return**:
*none*

#### getFileName()

**Function**:
*integer* **getFileName**( *string* ) : *string*
Filter filename from parameter string and return only the filename.
**Parameter**:
*string*    Path and filename.
**Result**:
*string*    Only filename.
**Return**:
*integer*   **0**   : Success
*integer*   **1..N**: Failure

#### getName()

**Function**:
*integer* **getName**( *string* ) : *string*
Filter name from filename parameter string and return only the name.
**Parameter**:
*string*    Filename
**Result**:
*string*    Only name from filenames.
**Return**:
*integer*   **0**: Success
*integer*   **1**: Failure

#### getExt()

**Function**:
*integer* **getExt**( *string* ) : *string*
Filter extension from filename parameter string and return only the extension.
**Parameter**:
*string*    Extension
**Result**:
*string*    Only extension from filenames.
**Return**:
*integer*   **0**: Success
*integer*   **1**: Failure

#### getPath()

**Function**:
*integer* **getPath**( *string* ) : *string*
Filter path from filename parameter string and return only the path.
**Parameter**:
*string*    Path/Filename
**Result**:
*string*    Only path from filename.
**Return**:
*integer*   **0**: Success
*integer*   **1**: Failure

#### askToContinue()

**Function**:
*integer* **askToContinue**( *integer* , *string* ) : *string*
Print a message and ask user to continue and get the answer.
**Parameter**:
*integer*   Timeout value, if empty, assume a default value.
*string*    Message, if empty, assume a default message.
**Result**:
*string*    Print a message for question.
**Return**:
*integer*   **0**: Accepted
*integer*   **1**: Rejected
*integer*   **2**: Timeout

#### wait()

**Function**:
*integer* **wait**( *integer* , *string* ) : *string*
Print a message and wait user to continue.
**Parameter**:
*integer*   Timeout value, if empty, assume a default value.
*string*    Message, if empty, assume a default message.
**Result**:
*string*    Print a message.
**Return**:
*integer*   **0**: No wait.
*integer*   **2**: Timeout

#### loadID()

**Function**:
*integer* **loadID**( *none* ) : *string*
Source /etc/os-release file.
**Parameter**:
*none*
**Result**:
*none*
**Return**:
*integer*   **0**: Success
*integer*   **1**: Failure, empty ID or file /etc/os-release not found.

#### getID()

**Function**:
*integer* **getID**( *none* ) : *string*
Get ID from os-release file.
**Parameter**:
*none*
**Result**:
*string*    System ID;
**Return**:
*integer*   **0**: Success
*integer*   **1**: Failure, empty ID or file /etc/os-release not found.

#### getDistroName()

**Function**:
*integer* **getDistroName**( *none* ) : *string*
Get Linux distro name.
**Parameter**:
*none*
**Result**:
*string*    Distro name.
**Return**:
*integer*   **0**: Success
*integer*   **1**: Failure, empty ID or empty Variant ID.

### File System

#### isLink()

**Function**:
*none* **isLink**( *string* ) : *boolean*
Check if parameter is a link to file or directory.
**Parameter**:
*string*    Link to file.
**Result**:
*boolean*    **true**: Is a link to file.
*boolean*   **false**: Is not a link to file.
**Return**:
*none*

#### isFile()

**Function**:
*none* **isFile**( *string* ) : *boolean*
Check if parameter is a regular file.
**Parameter**:
*string*    Path and|or Filename
**Result**:
*boolean*    **true**: Is a file.
*boolean*   **false**: Is not a file.
**Return**:
*none*

#### isDir()

**Function**:
*none* **isDir**( *string* ) : *boolean*
Check if parameter is a directory.
**Parameter**:
*string*    Path and|or Filename
**Result**:
*boolean*    **true**: Is a directory.
*boolean*   **false**: Is not a directory.
**Return**:
*none*

#### isBlockDevice()

**Function**:
*none* **isBlockDevice**( *string* ) : *boolean*
Check if parameter is a block device.
**Parameter**:
*string*    Path and|or block device.
**Result**:
*boolean*    **true**: Is a block device.
*boolean*   **false**: Is not a block device.
**Return**:
*none*

#### followLink()

**Function**:
*integer* **followLink**( *string* ) : *string*
Follow target from link.
**Parameter**:
*string*    Link to target.
**Result**:
*string*    Target name.
**Return**:
*integer*   **0**: Success
*integer*   **1**: Failure

#### linkExist()

**Function**:
*none* **linkExist**( *string* ) : *boolean*
Check if link referenced exist.
**Parameter**:
*string*    Link to target.
**Result**:
*boolean*    **true**: Exist
*boolean*   **false**: Not Exist
**Return**:
*none*

#### itExist()

**Function**:
*none* **itExist**( *string* ) : *boolean*
Check if file or directory or link reference exist.
**Parameter**:
*string*    Link to target.
**Result**:
*boolean*    **true**: Exist
*boolean*   **false**: Not Exist
**Return**:
*none*

#### getTempDir()

**Function**:
*none* **getTempDir**( *none* ) : *string*
Get a valid and accessible temporary directory and return it.
**Parameter**:
*none*
**Result**:
*string*    Temporary directory.
**Return**:
*none*

#### getMountDir()

**Function**:
*none* **getMountDir**( *none* ) : *string*
Get mount directory.
**Parameter**:
*none*
**Result**:
*string*    Mount directory.
**Return**:
*none*

### Git

#### gitBranchName()

**Function**:
*integer* **gitBranchName**( *string* ) : *string*
Get current git branch name.
**Parameter**:
*string*    Repository name|dir.
**Result**:
*string*    Branch name.
**Return**:
*integer*   **0**: Success
*integer*   **1**: Failure

#### gitCountAdded()

**Function**:
*integer* **gitCountAdded**( *string* ) : *integer*
Get git added files counter.
**Parameter**:
*string*    Repository name|dir.
**Result**:
*integer*   Added itens counter.
**Return**:
*integer*   **0**: Success
*integer*   **1**: Failure

#### gitCountModified()

**Function**:
*integer* **gitCountModified**( *string* ) : *integer*
Get git modified files counter.
**Parameter**:
*string*    Repository name|dir.
**Result**:
*integer*   Modified itens counter.
**Return**:
*integer*   **0**: Success
*integer*   **1**: Failure

#### gitCountDeleted()

**Function**:
*integer* **gitCountDeleted**( *string* ) : *integer*
Get git deleted files counter.
**Parameter**:
*string*    Repository name|dir.
**Result**:
*integer*   Deleted itens counter.
**Return**:
*integer*   **0**: Success
*integer*   **1**: Failure

#### gitCountDeleted()

**Function**:
*none* **isGitRepository**( *string* ) : *boolean*
Check is a git repository.
**Parameter**:
*string*    Repository name|dir.
**Result**:
*boolean*    **true**: Is a git repository.
*boolean*   **false**: Is not a git repository.
**Return**:
*none*

#### gitRepositoryName()

**Function**:
*inreger* **gitRepositoryName**( *string* ) : *string*
Get git repository name.
**Parameter**:
*string*    Repository dir.
**Result**:
*boolean*    **true**: Is a git repository.
*boolean*   **false**: Is not a git repository.
**Return**:
*none*

#### isGitChanged()

**Function**:
*none* **isGitChanged**( *string* ) : *boolean*
Check repository git files changed.
**Parameter**:
*string*    Repository name|dir.
**Result**:
*boolean*    **true**: Git repository has changes.
*boolean*   **false**: Git repository has not changes.
**Return**:
*none*

#### existBranch()

**Function**:
*none* **existBranch**( *string* ) : *boolean*
Check if branch exist.
**Parameter**:
*string*    Branch name.
**Result**:
*boolean*    **true**: Branch exist.
*boolean*   **false**: Branch not exist.
**Return**:
*none*

#### inBranch()

**Function**:
*none* **inBranch**( *string* ) : *boolean*
Check if respository is current branch.
**Parameter**:
*string*    Branch name.
**Result**:
*boolean*    **true**: Branch is current.
*boolean*   **false**: Branch is not current.
**Return**:
*none*

#### gitAdd()

**Function**:
*integer* **gitAdd**( *string* ) : *none*
Git add files to repository.
**Parameter**:
*string*    Add files to repository.
**Result**:
*none*
**Return**:
*integer*   **0**: Success
*integer*   **1**: Failure

#### gitCommitNotSigned()

**Function**:
*integer* **gitCommitNotSigned**( *string* ) : *none*
Not signed commit repository with a message.
**Parameter**:
*string*    Add a message to commit.
**Result**:
*none*
**Return**:
*integer*   **0**: Success
*integer*   **1**: Failure

#### gitCommitSigned()

**Function**:
*integer* **gitCommitSigned**( *string* ) : *none*
Signed commit repository with a message.
**Parameter**:
*string*    Add a message to commit.
**Result**:
*none*
**Return**:
*integer*   **0**: Success
*integer*   **1**: Failure

#### gitFetch()

**Function**:
*integer* **gitFetch**( *none* ) : *none*
Git fetch current branch.
**Parameter**:
*none*
**Result**:
*none*
**Return**:
*integer*   **0**: Success
*integer*   **1**: Failure

#### gitPull()

**Function**:
*integer* **gitPull**( *none* ) : *none*
Git pull current branch.
**Parameter**:
*none*
**Result**:
*none*
**Return**:
*integer*   **0**: Success
*integer*   **1**: Failure

#### gitPush()

**Function**:
*integer* **gitPush**( *none* ) : *none*
Git push current branch.
**Parameter**:
*none*
**Result**:
*none*
**Return**:
*integer*   **0**: Success
*integer*   **1**: Failure

#### gitSetUpstream()

**Function**:
*integer* **gitSetUpstream**( *none* ) : *none*
Set branch up stream for push commands.
**Parameter**:
*none*
**Result**:
*none*
**Return**:
*integer*   **0**: Success
*integer*   **1**: Failure

#### newBranch()

**Function**:
*integer* **newBranch**( *string* ) : *none*
Createt new branch.
**Parameter**:
*string*    Branch name.
**Result**:
*none*
**Return**:
*integer*   **0**: Success
*integer*   **1**: Failure

#### gitSwitch()

**Function**:
*integer* **gitSwitch**( *string* ) : *none*
Switch to branch name.
**Parameter**:
*string*    Branch name.
**Result**:
*none*
**Return**:
*integer*   **0**: Success
*integer*   **1**: Failure

#### createBranch()

**Function**:
*integer* **createBranch**( *string* ) : *none*
Create a new git branch and switch to it.
**Parameter**:
*string*    Branch name.
**Result**:
*none*
**Return**:
*integer*   **0**: Success
*integer*   **1**: Failure

### Math

#### compareFloat()

**Function**:
*integer* **compareFloat**( *double* , *double* ) : *integer*
Compare float numbers and return -1, 0, 1
**Parameter**:
*double*    1st number
*double*    2nd number
**Result**:
*integer*   **-1**  1st number is less than 2nd number
*integer*    **0**  1st number is equal than 2nd number
*integer*    **1**  1st number is greater than 2nd number
**Return**:
*integer*   **0**: Success
*integer*   **1**: Failure

#### addFloat()

**Function**:
*integer* **addFloat**( *double* , *double* ) : *double*
Add 2 float numbers.
**Parameter**:
*double*    1st number
*double*    2nd number
**Result**:
*double*    1st number + 2nd number
**Return**:
*integer*   **0**: Success
*integer*   **1**: Failure

#### subFloat()

**Function**:
*integer* **subFloat**( *double* , *double* ) : *double*
Subtract 2 floating point numbers.
**Parameter**:
*double*    1st number
*double*    2nd number
**Result**:
*double*    1st number - 2nd number
**Return**:
*integer*   **0**: Success
*integer*   **1**: Failure

#### multiplyFloat()

**Function**:
*integer* **multiplyFloat**( *double* , *double* ) : *double*
Multiply 2 float numbers.
*double*    1st number
*double*    2nd number
**Result**:
*double*    1st number * 2nd number
**Return**:
*integer* **0** Success
*integer* **1** Failure

#### divFloat()

**Function**:
*integer* **divFloat**( *double* , *double* ) : *double*
Divide 2 float numbers.
*double*    1st number
*double*    2nd divisor
**Result**:
*double*    number / divisor
**Return**:
*integer*   **0**: Success
*integer*   **1**: Failure, divisor is 0.

#### isFloatInRange()

**Function**:
*integer* **isFloatInRange**( *double* value , *double* min , *double* max ) : *boolean*
Check is float number between 2 float min and max numbers value.
**Parameter**:
*double*    value   Number to check in range.
*double*     min    Min value of range.
*double*     max    Max value of range.
**Result**:
*boolean*    **true**: Number is in min and max range.
*boolean*   **false**: Number is out of range min and max.
**Return**:
*integer*   **0**: Success
*integer*   **1**: Failure

### libShells

#### getLibVersionStr()

**Function**:
*none* **getLibVersionStr**( *none* ) : *string*
Get libShell version in string format.
**Parameter**:
*none*
**Result**:
*string*    libShell version in string format.
**Return**:
*none*

#### getLibVersionNum()

**Function**:
*none* **getLibVersionNum**( *none* ) : *string*
Get libShell version in number format.
**Parameter**:
*none*
**Result**:
*string*    libShell version in number format.
**Return**:
*none*

#### printLibVersion()

**Function**:
*none* **printLibVersion**( *none* ) : *string*
Print formatted libShell string version.
**Parameter**:
*none*
**Result**:
*string*    libShell version in number format.
**Return**:
*none*

#### getLibDateVersionStr()

**Function**:
*none* **getLibDateVersionStr**( *none* ) : *string*
Get libShell date number as string.
**Parameter**:
*none*
**Result**:
*string*    libShell date number as string.
**Return**:
*none*

#### getLibDateVersionNum()

**Function**:
*none* **getLibDateVersionNum**( *none* ) : *string*
Get libShell date as a numer.
**Parameter**:
*none*
**Result**:
*string*    libShell libShell string date.
**Return**:
*none*

#### printLibDate()

**Function**:
*none* **printLibDate**( *none* ) : *string*
Print formatted libShell string date.
**Parameter**:
*none*
**Result**:
*string*    Formatted libShell string date.
**Return**:
*none*

#### libSetup()

**Function**:
*integer* **libSetup**( *string*[] ) : *none*
Setup libShell.
**Parameter**:
*string*[]  Command line parameter list.
**Result**:
*none*
**Return**:
*integer*   **0**: Success
*integer*   **1**: Failure

#### libInit()

**Function**:
*integer* **libInit**( *string*[] ) : *none*
Initialize libShell.
**Parameter**:
*string*[]  Command line parameter list.
**Result**:
*none*
**Return**:
*integer*   **0**: Success
*integer*   **1**: Failure

#### unsetLibVars()

**Function**:
*integer* **unsetLibVars**( *none* ) : *none*
Unset global libShell variables.
**Parameter**:
*none*
**Result**:
*none*
**Return**:
*integer*   **0**: Success

#### libStop()

**Function**:
*integer* **libStop**( *none* ) : *none*
Stop|End library execution.
**Parameter**:
*none*
**Result**:
*none*
**Return**:
*integer*   **0**: Success


#### printLibHelp()

**Function**:
*integer* **printLibHelp**( *none* ) : *string*
Print library help information.
**Parameter**:
*none*
**Result**:
*string*    Help message and syntax information.
**Return**:
*integer*   **0**: Success

### Log

#### functiongetLogFilename()

**Function**:
*none* **getLogFilename**( *none* ) : *string*
Get log path and filename.
**Parameter**:
*none*
**Result**:
*string*    Temporary directory.
**Return**:
*none*

#### logBegin()

**Function**:
*integer* **logBegin**( *none* ) : *none*
Begin|Start log to file.
**Parameter**:
*none*
**Result**:
*none*
**Return**:
*integer*   **0**: Success

#### logEnd()

**Function**:
*integer* **logEnd**( *none* ) : *none*
End|Stop log to file.
**Parameter**:
*none*
**Result**:
*none*
**Return**:
*integer*   **0**: Success

#### isLogQuiet()

**Function**:
*none* **isLogQuiet**( *none* ) : *boolean*
Check is log quiet enabled.
**Parameter**:
*none*
**Result**:
*boolean*    **true**: Is log quiet enabled.
*boolean*   **false**: Is log quiet disabled.
**Return**:
*none*

#### isLogDefault()

**Function**:
*none* **isLogDefault**( *none* ) : *boolean*
Check is log default enabled.
**Parameter**:
*none*
**Result**:
*boolean*    **true**: Is log default enabled.
*boolean*   **false**: Is log default disabled.
**Return**:
*none*

#### isLogVerbose()

**Function**:
*none* **isLogDefaultVerbose**( *none* ) : *boolean*
Check is log verbose enabled.
**Parameter**:
*none*
**Result**:
*boolean*    **true**: Is log verbose enabled.
*boolean*   **false**: Is log verbose disabled.
**Return**:
*none*

#### isLogToScreenEnabled()

**Function**:
*none* **isLogToScreenEnabled**( *none* ) : *boolean*
Check is log to screen enabled.
**Parameter**:
*none*
**Result**:
*boolean*    **true**: Is log to screen enabled.
*boolean*   **false**: Is log to screen disabled.
**Return**:
*none*

#### isLogToFileEnabled()

**Function**:
*none* **isLogToFileEnabled**( *none* ) : *boolean*
Check is log to file enabled.
**Parameter**:
*none*
**Result**:
*boolean*    **true**: Is log to file enabled.
*boolean*   **false**: Is log to file disabled.
**Return**:
*none*

#### isLogEnabled()

**Function**:
*none* **isLogEnabled**( *none* ) : *boolean*
Check is log enabled.
**Parameter**:
*none*
**Result**:
*boolean*    **true**: Is log enabled.
*boolean*   **false**: Is log disabled.
**Return**:
*none*

#### Log Functions Table

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


#### logU()

**Function**:
*none* **logU**( *string* ) : *string*
Log anything unconditional to screen and file.
**Parameter**:
*string*    Send unconditional and unformatted messages to screen.
**Result**:
*none*
**Return**:
*none*

#### logIt()

**Function**:
*none* **logIt**( *string* ) : *string*
Log anything according to log flags.
**Parameter**:
*string*    Send unformatted messages to screen and|or file.
**Result**:
*none*
**Return**:
*none*

#### logI()

**Function**:
*none* **logI**( *string* ) : *string*
Log information messages.
**Parameter**:
*string*    Send formatted messages to screen and|or file.
**Result**:
*none*
**Return**:
*none*

#### logE()

**Function**:
*none* **logE**( *string* ) : *string*
Log error messages.
**Parameter**:
*string*    Send formatted messages to screen and|or file.
**Result**:
*none*
**Return**:
*none*

#### logF()

**Function**:
*none* **logF**( *string* ) : *string*
Log failure messages.
**Parameter**:
*string*    Send formatted messages to screen and|or file.
**Result**:
*none*
**Return**:
*none*

#### logR()

**Function**:
*none* **logR**( *string* ) : *string*
Log runtime messages.
**Parameter**:
*string*    Send formatted messages to screen and|or file.
**Result**:
*none*
**Return**:
*none*

#### logS()

**Function**:
*none* **logS**( *string* ) : *string*
Log success messages.
**Parameter**:
*string*    Send formatted messages to screen and|or file.
**Result**:
*none*
**Return**:
*none*

#### logV()

**Function**:
*none* **logV**( *string* ) : *string*
Log verbose messages.
**Parameter**:
*string*    Send formatted messages to screen and|or file.
**Result**:
*none*
**Return**:
*none*

#### logW()

**Function**:
*none* **logW**( *string* ) : *string*
Log warning messages.
**Parameter**:
*string*    Send formatted messages to screen and|or file.
**Result**:
*none*
**Return**:
*none*

#### logD()

**Function**:
*none* **logD**( *string* ) : *string*
Log debug messages.
**Parameter**:
*string*    Send formatted messages to screen and|or file.
**Result**:
*none*
**Return**:
*none*

#### logT()

**Function**:
*none* **logT**( *string* ) : *string*
Log trace messages.
**Parameter**:
*string*    Send formatted messages to screen and|or file.
**Result**:
*none*
**Return**:
*none*

#### getRuntimeStr()

**Function**:
*integer* **getRuntimeStr**( *none* ) : *string*
Generate|Get runtime string.
**Parameter**:
*none*
**Result**:
*string*    Formatted runtime timestamp.
**Return**:
*integer*   **0**: Success

### String

#### genRandomAlpha()

**Function**:
*integer* **genRandomAlpha**( *integer* ) : *string*
Generate a randomic alphabetic string.
**Parameter**:
*integer*   Length in bytes.
**Result**:
*string*    Randomic alphabetic characters.
**Return**:
*integer*   **0**: Success
*integer*   **1**: Failure

#### genRandomNumeric()

**Function**:
*integer* **genRandomNumeric**( *integer* ) : *string*
Generate a randomic numeric string.
**Parameter**:
*integer*   Length in bytes.
**Result**:
*string*    Randomic numeric string.
**Return**:
*integer*   **0**: Success
*integer*   **1**: Failure

#### genRandomAlphaNumeric()

**Function**:
*integer* **genRandomAlphaNumeric**( *integer* ) : *string*
Generate a randomic alphanumeric string.
**Parameter**:
*integer*   Length in bytes.
**Result**:
*string*    Randomic alphanumeric string.
**Return**:
*integer*   **0**: Success
*integer*   **1**: Failure

#### genRandomLowerHexadecimalNumber()

**Function**:
*integer* **genRandomLowerHexadecimalNumber**( *integer* ) : *string*
Generate a randomic low case char hexadecimal string.
**Parameter**:
*integer*   Length in bytes.
**Result**:
*string*    Randomic hexadecimal string.
**Return**:
*integer*   **0**: Success
*integer*   **1**: Failure

#### genRandomUpperHexadecimalNumber()

**Function**:
*integer* **genRandomUpperHexadecimalNumber**( *integer* ) : *string*
Generate a randomic upper case char hexadecimal string.
**Parameter**:
*integer*   Length in bytes.
**Result**:
*string*    Randomic hexadecimal string.
**Return**:
*integer*   **0**: Success
*integer*   **1**: Failure

#### genRandomHexadecimalNumber()

**Function**:
*integer* **genRandomHexadecimalNumber**( *integer* ) : *string*
Generate a randomic mixed case hexadecimal string.
**Parameter**:
*integer*   Length in bytes.
**Result**:
*string*    Randomic hexadecimal string.
**Return**:
*integer*   **0**: Success
*integer*   **1**: Failure

#### genRandomString()

**Function**:
*integer* **genRandomString**( *integer* ) : *string*
Generate a randomic string with no space.
**Parameter**:
*integer*   Length in bytes.
**Result**:
*string*    Randomic string.
**Return**:
*integer*   **0**: Success
*integer*   **1**: Failure

#### genRandomStringSpace()

**Function**:
*integer* **genRandomStringSpace**( *integer* ) : *string*
Generate a randomic string with space.
**Parameter**:
*integer*   Length in bytes.
**Result**:
*string*    Randomic string.
**Return**:
*integer*   **0**: Success
*integer*   **1**: Failure

#### genDateTimeAsCode()

**Function**:
*none* **genDateTimeAsCode**( *none* ) : *string*
Generate a date and time as code number.
**Parameter**:
*none*
**Result**:
*string*    Date and Time as code number.
**Return**:
*none*

#### getDate()

**Function**:
*none* **getDate**( *none* ) : *string*
Generate a date string.
**Parameter**:
*none*
**Result**:
*string*    Date string.
**Return**:
*none*

#### getTime()

**Function**:
*none* **getTime**( *none* ) : *string*
Generate a time string.
**Parameter**:
*none*
**Result**:
*string*    Time string
**Return**:
*none*

#### getDateTime()

**Function**:
*none* **getDateTime**( *none* ) : *string*
Generate a date and time string.
**Parameter**:
*none*
**Result**:
*string*    Date and Time string.
**Return**:
*none*

#### genRandom()

**Function**:
*integer* **genRandom**( *string* , *integer* ) : *string*
Generate an random string according parameter length.
**Parameter**:
*string*    Randomic string type acording to typeRANDOM[] vector.
*integer*   Randomic string length.
**Result**:
*string*    Randomic string.
**Return**:
*integer*   **0**: Success
*integer*   **1**: Failure

#### genUUID()

**Function**:
*integer* **genUUID**( *string* , *integer* ) : *string*
Generate an random UUID string accorgin to type and length|eschema[]=(12 4 4 4 8)
**Parameter**:
*string*    Randomic type acording to typeRANDOM[] vector.
*integer*   Randomic string length|eschema[]=(12 4 4 4 8)
**Result**:
*string*    Randomic UUID string.
**Return**:
*integer*   **0**: Success
*integer*   **1**: Failure

#### getRuntime()

**Function**:
*none* **getRuntime**( *none* ) : *string*
Get instantaneous timestamp in milleseconds.
**Parameter**:
*none*
**Result**:
*string*    Timestamp in milleseconds
**Return**:
*none*

#### isFloat()

**Function**:
*none* **isFloat**( *string* ) : *boolean*
Check parameter is a floating point number.
**Parameter**:
*string*    String parameter.
**Result**:
*boolean*    **true**: Parameter is a floating point number.
*boolean*   **false**: Parameter is not a floating point number.
**Return**:
*none*

#### isInteger()

**Function**:
*none* **isInteger**( *string* ) : *boolean*
Check parameter is an integer number.
**Parameter**:
*string*    String parameter.
**Result**:
*boolean*    **true**: Parameter is an integer number.
*boolean*   **false**: Parameter is not an integer number.
**Return**:
*none*

#### isAlpha()

**Function**:
*none* **isAlpha**( *string* ) : *boolean*
Check parameter is an alphabetic string only.
**Parameter**:
*string*    String parameter.
**Result**:
*boolean*    **true**: Parameter is an alphabetic string only.
*boolean*   **false**: Parameter is not an alphabetic string only.
**Return**:
*none*

#### isDigit()

**Function**:
*none* **isDigit**( *string* ) : *boolean*
Check parameter is a digit string only.
**Parameter**:
*string*    String parameter.
**Result**:
*boolean*    **true**: Parameter is a digit string only.
*boolean*   **false**: Parameter is not a digit string only.
**Return**:
*none*

#### isAlphaNumeric()

**Function**:
*none* **isAlphaNumeric**( *string* ) : *boolean*
Check parameter is an alphanumeric string only.
**Parameter**:
*string*    String parameter.
**Result**:
*boolean*    **true**: Parameter is an alphanumeric string only.
*boolean*   **false**: Parameter is not an alphanumeric string only.
**Return**:
*none*

#### isHexadecimalNumber()

**Function**:
*none* **isHexadecimalNumber**( *string* ) : *boolean*
Check parameter is an hexadecimal string only.
**Parameter**:
*string*    String parameter.
**Result**:
*boolean*    **true**: Parameter is an hexadecimal string only.
*boolean*   **false**: Parameter is not an hexadecimal string only.
**Return**:
*none*

#### isLowerHexadecimalNumber()

**Function**:
*none* **isLowerHexadecimalNumber**( *string* ) : *boolean*
Check parameter is a low case hexadecimal string only.
**Parameter**:
*string*    String parameter.
**Result**:
*boolean*    **true**: Parameter is a low case hexadecimal string only.
*boolean*   **false**: Parameter is not a low case hexadecimal string only.
**Return**:
*none*

#### isUpperHexadecimalNumber()

**Function**:
*none* **isUpperHexadecimalNumber**( *string* ) : *boolean*
Check parameter is an upper case hexadecimal string only.
**Parameter**:
*string*    String parameter.
**Result**:
*boolean*    **true**: Parameter is an upper case hexadecimal string only.
*boolean*   **false**: Parameter is not an upper case hexadecimal string only.
**Return**:
*none*

#### isGraphString()

**Function**:
*none* **isGraphString**( *string* ) : *boolean*
Check parameter is a graph char string.
**Parameter**:
*string*    String parameter.
**Result**:
*boolean*    **true**: Parameter is a graph char string.
*boolean*   **false**: Parameter is not a graph char string.
**Return**:
*none*

#### strLength()

**Function**:
*integer* **strLength**( *string* ) : *integer*
Get string length.
**Parameter**:
*string*    String parameter.
**Result**:
*integer*   String length.
**Return**:
*integer*   **0**: Success
*integer*   **1**: Failure

#### strCompare()

**Function**:
*integer* **strCompare**( *string* , *string* ) : *integer*
Compare string and return -N, 0 , +N
**Parameter**:
*string*    1st String parameter.
*string*    2nd String parameter.
**Result**:
*integer*   **-N**: 1st String parameter is N char lower than 2nd String parameter.
*integer*    **0**: 1st String parameter is equal to 2nd String parameter.
*integer*    **N**: 1st String parameter is N char upper than 2nd String parameter.
**Return**:
*integer*   **0**: Success
*integer*   **1**: Failure

#### genVersionStr()

**Function**:
*integer* **genVersionStr**( *integer*[] ) : *string*
Generate version string from parameter.
Description
**Parameter**:
*integer*[]     Version
**Result**:
*string*        String version.
**Return**:
*integer*   **0**: Success
*integer*   **1**: Failure

#### genVersionNum()

**Function**:
*integer* **genVersionNum**( *integer*[] ) : *ingeter*
Generate version number from parameter.
Description
**Parameter**:
*integer*[]     Description
**Result**:
*integer*       Version integer number nnn from array parameter (n n n).
**Return**:
*integer*   **0**: Success
*integer*   **1**: Failure

#### genDateVersionStr()

**Function**:
*integer* **genDateVersionStr**( *integer*[] ) : *string*
Generate date version string from parameter.
**Parameter**:
*integer*[]     Date array (YYYY MM DD)
**Result**:
*string*        Formatted string date YYYY-MM-DD
**Return**:
*integer*   **0**: Success
*integer*   **1**: Failure

#### genDateVersionNum()

**Function**:
*integer* **genDateVersionNum**( *integer*[] ) : *integer*
Generate date version number from parameter.
**Parameter**:
*integer*[]     Date array (YYYY MM DD)
**Result**:
*integer*       Formatted integer date  YYYYMMDD
**Return**:
*integer*   **0**: Success
*integer*   **1**: Failure

### Connection

#### isConnected()

**Function**:
*none* **isConnected**( *none* ) : *boolean*
Check internet connecton available and ative.
**Parameter**:
*none*
**Result**:
*boolean*    **true**: Internet connectio is available and active.
*boolean*   **false**: Internet connectio is not available neither active.
**Return**:
*none*

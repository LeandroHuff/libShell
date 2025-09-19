test_libShell

**Description**: Shell script to test libShell Library
       **file**: test_libShell.sh
     **Author**: Leandro - leandrohuff@programmer.net
       **Date**: 2025-09-10
    **Version**: 2.0.3
  **Copyright**: CC01 1.0 Universal
    **Details**: Run a set of tests stored in a tatble to call libShell functions and pass some parameters to check its results.
     **Syntax**: test_libShell.sh -v -l 1
      **Where**: -v  show more verbose message about test results.
All command line parameters will be passed to libShell.
Functions or variables started with underline char (_) is a
local name and the underline is to avoid conflict with the
libShell name's.

## Constants

*integer*[] **testVERSION**: Test version number.
*integer*[] **testDATE**: Test version date.
*integer* **iLINE**: Index line value in testTABLE.
*integer* **iRET**: Index ret value in testTABLE.
*integer* **iRES**: Index res value in testTABLE.
*integer* **iFUNC**: Index func value in testTABLE.
*integer* **iPARAM1**: Index 1st testTABLE parameter.
*integer* **iLINE**: Index 2nd testTABLE parameter.
*integer* **iLINE**: Index 3rd testTABLE parameter.
*integer* **iLINE**: Maximum index testTABLE items.

## Variables

*integer* **testDEBUG**: Enable internal debug messages.
*integer* **OK**: Success counter.
*integer* **ERR**: Error counter.
*integer* **RES**: Store results from testTABLE function.
*integer* **RET**: Store return values from testTABLE function.

## Functions

### logOk()

Function:
*none* **logOk**() : *string*
Send success messages to screen.
Parameter:
*string* **message**    String message to sendo as success.
Result:
*string* **message**    Formatted message to send to screen.
Return:
*none*

### logFail()

Function:
*none* **logFail**() : *string*
Send failure messages to screen.
Parameter:
*string* **message**    String message to sendo as failure.
Result:
*string* **message**    Formatted message to send to failure.
Return:
*none*

### logDebug()

Function:
*none* **logDebug**() : *string*
Send debug messages to screen.
Parameter:
*string* **message**    String message to sendo as debug.
Result:
*string* **message**    Formatted message to send to screen.
Return:
*none*

### _unsetVars()

Function:
*integer* **_unsetVars**( *none* ) : *none*
Unset global test variables, not in libShell, for libShell call libEnd() function.
Parameter:
*none* **none**
Result:
*none*
Return:
*integer* **0** Success

### _exit()

Function:
*integer* **_exit**( *integer* **code** ) : *none*
End program and exit code to system.
Parameter:
*integer* **code** Code number to exit it to system.
Result:
*none*
Return:
*integer* **0**    Success
*integer* **1..N** Error code.

### test_genRandomAlpha()

Function:
*integer* **test_genRandomAlpha**( *integer* **length** ) : *integer*
Test genRandomAlpha() function and return its result.
Parameter:
*integer* **length** Length parameter passed to tested function.
Result:
*integer* **length** String length returned from tested function.
Return:
*integer* **0**    Success
*integer* **1..N** Error code.

### test_genRandomNumeric()

Function:
*integer* **test_genRandomNumeric**( *integer* **length** ) : *integer*
Test genRandomNumeric() function and return its result.
Parameter:
*integer* **length** Length parameter passed to tested function.
Result:
*integer* **length** String length returned from tested function.
Return:
*integer* **0**    Success
*integer* **1..N** Error code.

### test_genRandomAlphaNumeric()

Function:
*integer* **test_genRandomAlphaNumeric**( *integer* **length** ) : *integer*
Test genRandomAlphaNumeric() function and return its result.
Parameter:
*integer* **length** Length parameter passed to tested function.
Result:
*integer* **length** String length returned from tested function.
Return:
*integer* **0**    Success
*integer* **1..N** Error code.

### test_genRandomHexadecimalNumber()

Function:
*integer* **test_genRandomHexadecimalNumber**( *integer* **length** ) : *integer*
Test genRandomHexadecimalNumber() function and return its result.
Parameter:
*integer* **length** Length parameter passed to tested function.
Result:
*integer* **length** String length returned from tested function.
Return:
*integer* **0**    Success
*integer* **1..N** Error code.

### test_genRandomLowerHexadecimalNumber()

Function:
*integer* **genRandomLowerHexadecimalNumber**( *integer* **length** ) : *integer*
Test genRandomLowerHexadecimalNumber() function and return its result.
Parameter:
*integer* **length** Length parameter passed to tested function.
Result:
*integer* **length** String length returned from tested function.
Return:
*integer* **0**    Success
*integer* **1..N** Error code.

### test_genRandomUpperHexadecimalNumber()

Function:
*integer* **genRandomUpperHexadecimalNumber**( *integer* **length** ) : *integer*
Test genRandomUpperHexadecimalNumber() function and return its result.
Parameter:
*integer* **length** Length parameter passed to tested function.
Result:
*integer* **length** String length returned from tested function.
Return:
*integer* **0**    Success
*integer* **1..N** Error code.

### test_genRandomString()

Function:
*integer* **genRandomString**( *integer* **length** ) : *integer*
Test genRandomString() function and return its result.
Parameter:
*integer* **length** Length parameter passed to tested function.
Result:
*integer* **length** String length returned from tested function.
Return:
*integer* **0**    Success
*integer* **1..N** Error code.

### test_genRandomStringSpace()

Function:
*integer* **genRandomStringSpace**( *integer* **length** ) : *integer*
Test genRandomStringSpace() function and return its result.
Parameter:
*integer* **length** Length parameter passed to tested function.
Result:
*integer* **length** String length returned from tested function.
Return:
*integer* **0**    Success
*integer* **1..N** Error code.

### test_genDateTimeAsCode()

Function:
*integer* **genDateTimeAsCode**( *integer* **length** ) : *integer*
Test genDateTimeAsCode() function and return its result.
Parameter:
*integer* **length** Length parameter passed to tested function.
Result:
*integer* **length** String length returned from tested function.
Return:
*integer* **0**    Success
*integer* **1..N** Error code.

### test_genRandom()

Function:
*integer* **genRandom**( *integer* **length** ) : *integer*
Test genRandom() function and return its result.
Parameter:
*integer* **length** Length parameter passed to tested function.
Result:
*integer* **length** String length returned from tested function.
Return:
*integer* **0**    Success
*integer* **1..N** Error code.

### test_getDateTime()

Function:
*integer* **getDateTime**( *integer* **length** ) : *integer*
Test getDateTime() function and return its result.
Parameter:
*integer* **length** Length parameter passed to tested function.
Result:
*integer* **length** String length returned from tested function.
Return:
*integer* **0**    Success
*integer* **1..N** Error code.

### test_printLibVersion()

Function:
*none* **printLibVersion**( *none* ) : *string*
Test printLibVersion() function and return its result.
Parameter:
*none*
Result:
*string* **message** Debug string messages.
Return:
*none*

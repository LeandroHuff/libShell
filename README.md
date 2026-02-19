# libShell

libShell is a group of bash script files to service as a resource [library](#Libraries),
these files help developers to write bash script programs without to re-write most of
source code again.

The purpose is to resource most common variables and functions to avoid re-write|re-invent
the most used source code for shell scripts, this approach accelerate the development of
shell scripts.

Every shell library must be sourced and do not called to run as an usually shell script.

Usage:

```sh
source libName.sh
```

Where:

'libName' is the library's name to be sourced, look at [Libraries](#Libraries) list.

<a id="Libraries"></a>
## Libraries List

| Library Name | Description |
|:--------|:------------|
| [libCompress](libCompress.sh) | Functions to compress/uncompress files. |
| [libConfig](libConfig.sh) | Functions to save and load user configuration in/from local files. |
| [libConn](libConn.sh) | Functions to check available internet connection. |
| [libEscCodes](libEscCodes.sh) | Functions to resource escape codes for colors and fonts. |
| [libFile](libFile.sh) | Functions to treat files on file system. |
| [libFlatpak](libFlatpak.sh) | Functions to manage flagpak packaegs. |
| [libGit](libGit.sh) | Functions to manage git repositories. |
| [libKbHit](libKbHit.sh) | Functions to detect keyboard key pressed. |
| [libLog](libLog.sh) | Function to print log messages on terminal or file. |
| [libMath](libmath.sh) | Functions to calculate most common mathematics espressions. |
| [libRandom](libRandom.sh) | Functions to generate randomic strings. |
| [libRegex](libRegex.sh) | Functions to validate strings by regex string. |
| [libString](libString.sh) | Functions to treat and validate strings. |
| [libTime](libTime.sh) | Functions to add wait states and ask for user confirmation in a bash source code. |
| [libVersion](libVersion.sh) | Functions to store and get libShell version. |

<a id="Tests"></a>
## Tests List

| Test | Description |
|:-----|:------------|
| [start_libTest](test/start_libTest.sh) | Manager call all shell script tests. |
| [test_libConfig](test/test_libConfig.sh) | Tests for libConfig.sh |
| [test_libConn](test/test_libConn.sh) | Tests for libConn.sh |
| [test_libEscCodes](test/test_libEscCodes.sh) | Tests for libEscCodes.sh |
| [test_libFile](test/test_libFile.sh) | Tests fro libFile.sh |
| [test_libGit](test/test_libGit.sh) | Tests for libGit.sh |
| [test_libLog](test/test_libLog.sh) | Tests for libLog.sh |
| [test_libMath](test/test_libMath.sh) | Tests for libMath.sh |
| [test_libRandom](test/test_libRandom.sh) | Tests for libRandom.sh |
| [test_libRegex](test/test_libRegex.sh) | Tests for libRegex.sh |
| [test_libString](test/test_libString.sh) | Tests for libString.sh |
| [test_libTemplate](test/test_libTemplate.sh) | Tests for libTemplate.sh |
| [test_libTime](test/test_libTime.sh) | Tests for libTime.sh |

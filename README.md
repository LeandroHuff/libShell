# libShell

Version: **2**.**2**.**7**

libShell is a group of bash script files to service as a resource [library](#Libraries),
these files help developers to write bash script programs without to re-write most of
source code again.

The purpose is to resource most common variables and functions to avoid re-write|re-invent
the most used source code for shell scripts, this approach accelerate the development of
shell scripts.

Every shell library must be sourced and do not called to run as an usuall shell script.

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
| [libCompress](#libCompress) | Compress/uncompress files. |
| [unCompress](#unCompress) | Estract files from filename. |
| [compress](#compress) | Compress files into filename. |
| [libCompressExit](#libCompressExit) | Unload and exit from libCompress. |
| | |
| [libConfig](#libConfig) | Save and load user configuration in/from local files. |
| [saveConfigToFile](#saveConfigToFile) | Save configurations 'tag=value' into file. |
| [readTagsFromFile](#readTagsFromFile) | Read only tags from configuration file. |
| [readValuesFromFile](#readValuesFromFile) | Read only values from configuration file. |
| [loadConfigFromFile](#loadConfigFromFile) | Load tags and values from configuration file. |
| [libConfigExit](#libConfigExit) | Unload and exit from libConfig. |
| | |
| [libConn](#libConn) | Check available internet connection. |
| [isConnected](#isConnected) | Check for internet connection. |
| [libConnExit](#libConnExit) | Unload and exit from libConn. |
| | |
| [libLuks](#libLuks) | Encrypt and Decrypt Luks devices. |
| [libLuksGetMountDir](#libLuksGetMountDir) | Get base mount directory. |
| [libLuksStripPunct](#libLuksStripPunct) | Remove paths and strip ponctuation from filenames. |
| [libLuksFollowLink](#libLuksFollowLink) | Follow links to get target. |
| [libLuksHasFS](#libLuksHasFS) | Verify device for a specific file system presence on it. |
| [libLuksHasAnyFS](#libLuksHasAnyFS) | Verify a device for any file system presence on it. |
| [libLuksSetDeviceName](#libLuksSetDeviceName) | Extract file name from drive path/name and set a prefix 'luks-' on it. |
| [libLuksGetDeviceName](#libLuksGetDeviceName) | Extract path and punctioation from file name. |
| [libLuksEncryptDrive](#libLuksEncryptDrive) | Encrypt a block device to luks format. |
| [libLuksOpenDrive](#libLuksOpenDrive) | Open an encrypted deivce by luks. |
| [libLuksCloseDevice](#libLuksCloseDevice) | Close an opened encrypted device by luks. |
| [libLuksFormatDevice](#libLuksFormatDevice) | Format an opened device by luks to a file system. |
| [libLuksMountDevice](#libLuksMountDevice) | Mount an opened luks device as a local device. |
| [libLuksSetOwner](#libLuksSetOwner) | Set owner and access rights for a mounted device. |
| [libLuksUmountDevice](#libLuksUmountDevice) | Umount a mounted device from local file system. |
| [libLuksSetDeviceOwner](#libLuksSetDeviceOwner) | Set device owner and file system mode. |
| [libLuksSetDeviceAccess](#libLuksSetDeviceAccess) | Set device owner, file system mode and verify file system access rights. |
| [libLuksMakeDir](#libLuksMakeDir) | Make a directory into path and optionaly  set a access mode for it. |
| [libLuksRemoveDir](#libLuksRemoveDir) | Remove a directory from file system. |
| [libLuksCreateDrive](#libLuksCreateDrive) | Create an encrypted device from a block device, open, formatt fs, mount and set access rights on it. |
| [libLuksOpenDevice](#libLuksOpenDevice) | Open an encrypted deivce, mount and set access rights on it. |
| [libLuksCloseDevice](#libLuksCloseDevice) | Close and umount an encrypted device from filesystem. |
| | |
| [libEscCodes](#libEscCodes) | Resource escape codes for colors and fonts. |
| | |
| [libFile](libFile.sh) | Treat files on file system. |
| [libFlatpak](libFlatpak.sh) | Manage flagpak packages. |
| [libGit](libGit.sh) | Manage git repositories. |
| [libKbHit](libKbHit.sh) | Detect keyboard key pressed. |
| [libLog](libLog.sh) | Print log messages on terminal or file. |
| [libMath](libMath.sh) | Calculate most common mathematics espressions. |
| [libRandom](libRandom.sh) | Generate randomic strings. |
| [libString](libString.sh) | Treat and validate strings. |
| [libTime](libTime.sh) | Add wait states and ask for user confirmation in a bash source code. |
| [libVersion](libVersion.sh) | Store and get libShell version. |

<a id="Tests"></a>
## Tests List

| Test | Description |
|:-----|:------------|
| [start_libTest](test/start_libTest.sh) | Call all shell script tests. |
| [test_libConfig](test/test_libConfig.sh) | Tests for libConfig.sh |
| [test_libConn](test/test_libConn.sh) | Tests for libConn.sh |
| [test_libEscCodes](test/test_libEscCodes.sh) | Tests for libEscCodes.sh |
| [test_libFile](test/test_libFile.sh) | Tests fro libFile.sh |
| [test_libGit](test/test_libGit.sh) | Tests for libGit.sh |
| [test_libLog](test/test_libLog.sh) | Tests for libLog.sh |
| [test_libMath](test/test_libMath.sh) | Tests for libMath.sh |
| [test_libRandom](test/test_libRandom.sh) | Tests for libRandom.sh |
| [test_libString](test/test_libString.sh) | Tests for libString.sh |
| [test_libTemplate](test/test_libTemplate.sh) | Tests for libTemplate.sh |
| [test_libTime](test/test_libTime.sh) | Tests for libTime.sh |

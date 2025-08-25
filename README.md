# libShell

Shell script library is a script file that service as a library of functions and variables and help to develop shell script programs without the need to write much source code.

Most used functions are ready to use and the developer do not need to write it again.

## libShell content

Variables:

Version: 2.0.0

Debug on|off

Trace on|off

Log levels [0,1,2]

Log target [0,1,2,3]

Log filename

Functions:

getScriptName    Return the script filename and extension without path.

getFileName    Return the parameter filename and extension without path.

|                           |         |                                   |     |
| ------------------------- | ------- | --------------------------------- | --- |
| **getScriptName**         |         | Return the script filename.       |     |
| param                     | none    |                                   |     |
| return                    | string  | Script filename.                  |     |
|                           |         |                                   |     |
| **getFileName**           |         | Return the filename of parameter. |     |
| param                     | string  | path and filename                 |     |
| return                    | string  | filename                          |     |
|                           |         |                                   |     |
| **getName**               |         | Get name of filename.             |     |
| param                     | string  | Filename                          |     |
| return                    | string  | Name of filename.                 |     |
|                           |         |                                   |     |
| **getExt**                |         | Return filename extension.        |     |
| param                     | string  | Filename                          |     |
| return                    | string  | Filename extension.               |     |
|                           |         |                                   |     |
| **getPath**               |         | Return only path of path/filename |     |
| param                     | string  | Path plus filename.               |     |
| return                    | string  | Path only.                        |     |
|                           |         |                                   |     |
| **genRandomAlphaNumeric** |         | Generate alpha numeric string     |     |
| param                     | integer | Length                            |     |
| return                    | string  | Alpha numeric string.             |     |
|                           |         |                                   |     |
|                           |         |                                   |     |
|                           |         |                                   |     |
|                           |         |                                   |     |



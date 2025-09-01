# libShell

Shell script library is a script file that service as a functions and variables library,
this file help to develop shell script programs without to re-write source code again.

The purpose is to avoid re-write|re-invent the most used source code for shell scripts,
this approach accelerate the developmet of many common tasks for write script programs.

Most used functions are ready to use and the developer do not need to re-write it again.



## Tools

In the src folder are some C source files to build into bin as resources to add some float math capabilities to libShell.

As shell script do not have float functions and commands, it was added as an external binary program that can be called as a command line program.

**libShell.sh**: Shell script library.

**test_libShell.sh**: Test almost all libShell functions.

**build.sh**: Compile C source files from src/ folder to bin/ folder.



### Resource List

**addfloat.c**: Add 2 float parameters and return the result.

Syntax:

```shell
addfloat 1.2 3.4
4.6
```



**cmpfloat.c**: Compare 2 float numbers and return the result.

Syntax:

```shell
cmpfloat 1.2 3.4
-1
cmpfloat 3.0 2.0
1
cmpfloat 1.5 1.5
0
```

-1: 1st number is lower than 2nd number.

 0: bouth is equal.

+1: 1st number is greater than 2nd number.



**divfloat.c**: Divide 2 float numbers and return the result.

Syntax:

```shell
divfloat 4.2 2.0
2.1
```

Obs.: 2nd float must be different than zero.



**multifloat.c**: Multiply 2 float numbers and return the result.

Syntax:

```shell
multifloat 5.0 2.0
10.0
```



**rangefloat.c**: Check if float number is in the range and return true or false.

Syntax:

```shell
rangefloat 1.5 0.5 2.5
true
rangefloat 0.1 1.0 2.0
false
```



**strcmp.c**: Compare strings and return.

Syntax:

```shell
strcmp "delta" "kilo"
-1

strcmp "charlie" "charlie"
0

strcmp "alpha" "bravo"
-1
```



**strlen.c**: Return the string lenght of parameter.

Syntax:

```shell
strlen "string"
6
```



**subfloat.c**: Subtract 2 flaot numbers and return the result.

Syntax:

```shell
subfloat 3.5 1.2
2.3
```

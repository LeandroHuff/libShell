# libShell

## Tools

Source src/ folder have some C source files as resources and add float math capabilities to libShell.
As shell script do not have native float functions and commands, these tools add some external binaries program to be called as a command line program.

### Resource List

List of resources|tools available in binary bin/ from source src/ folder.

### 1. - Double Numbers

Functions to operate over 2 double numbers.

#### 1.1 - Add

Add 2 double numbers from command line parameters and return the result.

Syntax: **addfloat.c** <double> <double>

```shell
addfloat 1.2 3.4
4.6
```

#### 1.2 - Compare

Compare 2 float numbers and return the result.

Syntax: **cmpfloat.c** <double> <double>

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


#### 1.3 - Div

Divide 2 float numbers and return the result, the 2nd parameter must be different than zero.

Syntax: **divfloat.c** <double> <double>

```shell
divfloat 4.2 2.0
2.1
```

#### 1.4 - Multiply

Multiply 2 float numbers and return the result.

Syntax: **multifloat.c** <double> <double>

```shell
multifloat 5.0 2.0
10.0
```

#### 1.5 - Subtract

Subtract 2 flaot numbers and return the result.

Syntax: **subfloat.c** <double> <double>

```shell
subfloat 3.5 1.2
2.3
```

#### 1.6 - Range

Check if float number is in the range and return true or false.

Syntax: **rangefloat.c** <double> <double>

```shell
rangefloat 1.5 0.5 2.5
true
rangefloat 0.1 1.0 2.0
false
```

### 2. - Strings

Functions to operate over 1 or 2 strings.

#### 2.1 - Compare

Compare strings and return.

Syntax: **strcmp.c** <'1st string'> <'2nd string'>

```shell
strcmp "delta" "kilo"
-1

strcmp "charlie" "charlie"
0

strcmp "alpha" "bravo"
-1
```

-1: 1st string is lower than 2nd.

 0: bouth is equal.

+1: 1st string is greater than 2nd.

#### 2.2 - Lenght

Return the string lenght of parameter.

Syntax: **strlen.c** <"string">

```shell
strlen "string"
6
```

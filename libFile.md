# libFile

Source variables and functions to treat files on file system.

## Functions

### Index

| Function | Description |
|:---------|:------------|
| [getIDNumber](#getIDNumber) | Get ID number from distro name. |
| [getScriptName](#getScriptName) | Get current script filename. |
| [getFileName](#getFileName) | Get filename+extension from parameter. |
| [getName](#getName) | Get name from filename.ext parameter. |
| [getExt](#getExt) | Get extension from file name.ext parameter. |
| [getPath](#getPath) | Get path from file path+name.ext parameter. |

<a id=getIDNumber></a>
### getIDNumber( _$1_ )
Get ID number according to Linux distro name.

**Parameters**:  
**$1**: String with distro name

Valid names:  
_fedora_|_toolbx_  
_silverblue_|_kinoite_  
_debian_|_ubuntu_|_mint_  
_slackware_  
_arch_|_manjaro_  
_SUSE_|_openSUSE_  

**Result**:  
**0**: for fedora or toolbx  
**1**: for silverblue or kinoite  
**2**: for debian or ubuntu or mint  
**3**: for slackware  
**4**: for arch or manjaro  
**5**: for SUSE or openSUSE or suse or opensuse  

**Return**:  
**0**: Success  
**1**: Invalid distro name.  

**Sintaxe**:  

``` sh
getIDNumber 'fedora'
0
0
getIDNumber 'slackware'
3
0
getIDNumber 'invalid distro'

1
```

<a id=getScriptName></a>
### getScriptName( _none_ )
Get the current script file name.ext from where the functions was called.

**Parameter**:  
_none_  

**Result**:  
_String_: Current script file name.ext  

**Return**:  
_0_: Success  

**Sintaxe**:  

``` sh
getScriptName
filename.sh
0
```

<a id=getFileName></a>
### getFileName( _$1_ )
Get file name+extension from parameter.  
Path is optional and will be striped from parameter.  

**Parameters**:  
_$1_: String with [path/]name.ext  

**Result**:  
_name.ext_: Filtered file name.ext from parameter.  

**Return**:  
_0_: Success  

**Sintaxe**:  

``` sh
getFileName '~/Documents/filename.ext'
filename.ext
0
```

<a id=getName></a>
### getName( _$1_ )
Get name from file name.ext parameter.  
Path is avoid, only name.ext on parameter.  
This function can be combined with getFileName() to strip path if needed.  

**Parameters**:  
_$1_: String file name.ext  

**Result**:  
_name_: Filtered 'name' from file name.ext  

**Return**:  
_0_: Success  

**Sintaxe**:  

``` sh
# only single function.
getName 'filename.ext'
filename
0

# nested functions.
getName "$(getFilename 'path/name.ext')"
name
0
```

<a id=getExt></a>
### getExt( $1 )
Get extension from file name.ext parameter.  
Path is avoid, only name.ext on parameter.  
This function can be combined with getFileName() to strip path if needed.  

**Parameters**:  
_$1_: String file name.ext  

**Result**:  
_ext_: Filtered 'name' from file name.ext  

**Return**:  
_0_: Success  

**Sintaxe**:  

``` sh
# only single function.
getExt 'filename.ext'
ext
0

# nested functions.
getExt "$(getFilename '~/Documents/filename.ext')"
ext
0
```

<a id=getPath></a>
### getPath( parameters )
Get path from file path/name.ext parameter.  

**Parameters**:  
_$1_: String with path/name.ext  

**Result**:  
_path_: Filtered 'path' from file path/name.ext  

**Return**:  
_0_: Success  

**Sintaxe**:  

``` sh
getPath 'Documents/filename.ext'
Documents
0

getPath '/etc/profile.d/profile'
/etc/profile.d
0
```

### functionName( parameters )
Description.  

**Parameters**:  
_none_  

**Result**:  
_none_  

**Return**:  
_none_  

**Sintaxe**:  

``` sh
functionName
res
code
```

### functionName( parameters )
Description.  

**Parameters**:  
_none_  

**Result**:  
_none_  

**Return**:  
_none_  

**Sintaxe**:  

``` sh
functionName
res
code
```

### functionName( parameters )
Description.  

**Parameters**:  
_none_  

**Result**:  
_none_  

**Return**:  
_none_  

**Sintaxe**:  

``` sh
functionName
res
code
```

### functionName( parameters )
Description.  

**Parameters**:  
_none_  

**Result**:  
_none_  

**Return**:  
_none_  

**Sintaxe**:  

``` sh
functionName
res
code
```

### functionName( parameters )
Description.  

**Parameters**:  
_none_  

**Result**:  
_none_  

**Return**:  
_none_  

**Sintaxe**:  

``` sh
functionName
res
code
```

### functionName( parameters )
Description.  

**Parameters**:  
_none_  

**Result**:  
_none_  

**Return**:  
_none_  

**Sintaxe**:  

``` sh
functionName
res
code
```

### functionName( parameters )
Description.  

**Parameters**:  
_none_  

**Result**:  
_none_  

**Return**:  
_none_  

**Sintaxe**:  

``` sh
functionName
res
code
```

### functionName( parameters )
Description.  

**Parameters**:  
_none_  

**Result**:  
_none_  

**Return**:  
_none_  

**Sintaxe**:  

``` sh
functionName
res
code
```

### functionName( parameters )
Description.  

**Parameters**:  
_none_  

**Result**:  
_none_  

**Return**:  
_none_  

**Sintaxe**:  

``` sh
functionName
res
code
```

### functionName( parameters )
Description.  

**Parameters**:  
_none_  

**Result**:  
_none_  

**Return**:  
_none_  

**Sintaxe**:  

``` sh
functionName
res
code
```

### functionName( parameters )
Description.  

**Parameters**:  
_none_  

**Result**:  
_none_  

**Return**:  
_none_  

**Sintaxe**:  

``` sh
functionName
res
code
```

### functionName( parameters )
Description.  

**Parameters**:  
_none_  

**Result**:  
_none_  

**Return**:  
_none_  

**Sintaxe**:  

``` sh
functionName
res
code
```

### functionName( parameters )
Description.  

**Parameters**:  
_none_  

**Result**:  
_none_  

**Return**:  
_none_  

**Sintaxe**:  

``` sh
functionName
res
code
```

### functionName( parameters )
Description.  

**Parameters**:  
_none_  

**Result**:  
_none_  

**Return**:  
_none_  

**Sintaxe**:  

``` sh
functionName
res
code
```

### functionName( parameters )
Description.  

**Parameters**:  
_none_  

**Result**:  
_none_  

**Return**:  
_none_  

**Sintaxe**:  

``` sh
functionName
res
code
```

### functionName( parameters )
Description.  

**Parameters**:  
_none_  

**Result**:  
_none_  

**Return**:  
_none_  

**Sintaxe**:  

``` sh
functionName
res
code
```

### functionName( parameters )
Description.  

**Parameters**:  
_none_  

**Result**:  
_none_  

**Return**:  
_none_  

**Sintaxe**:  

``` sh
functionName
res
code
```

### functionName( parameters )
Description.  

**Parameters**:  
_none_  

**Result**:  
_none_  

**Return**:  
_none_  

**Sintaxe**:  

``` sh
functionName
res
code
```

### functionName( parameters )
Description.  

**Parameters**:  
_none_  

**Result**:  
_none_  

**Return**:  
_none_  

**Sintaxe**:  

``` sh
functionName
res
code
```

### functionName( parameters )
Description.  

**Parameters**:  
_none_  

**Result**:  
_none_  

**Return**:  
_none_  

**Sintaxe**:  

``` sh
functionName
res
code
```

### functionName( parameters )
Description.  

**Parameters**:  
_none_  

**Result**:  
_none_  

**Return**:  
_none_  

**Sintaxe**:  

``` sh
functionName
res
code
```

### functionName( parameters )
Description.  

**Parameters**:  
_none_  

**Result**:  
_none_  

**Return**:  
_none_  

**Sintaxe**:  

``` sh
functionName
res
code
```

### functionName( parameters )
Description.  

**Parameters**:  
_none_  

**Result**:  
_none_  

**Return**:  
_none_  

**Sintaxe**:  

``` sh
functionName
res
code
```

### functionName( parameters )
Description.  

**Parameters**:  
_none_  

**Result**:  
_none_  

**Return**:  
_none_  

**Sintaxe**:  

``` sh
functionName
res
code
```

### functionName( parameters )
Description.  

**Parameters**:  
_none_  

**Result**:  
_none_  

**Return**:  
_none_  

**Sintaxe**:  

``` sh
functionName
res
code
```

### functionName( parameters )
Description.  

**Parameters**:  
_none_  

**Result**:  
_none_  

**Return**:  
_none_  

**Sintaxe**:  

``` sh
functionName
res
code
```

### functionName( parameters )
Description.  

**Parameters**:  
_none_  

**Result**:  
_none_  

**Return**:  
_none_  

**Sintaxe**:  

``` sh
functionName
res
code
```

### functionName( parameters )
Description.  

**Parameters**:  
_none_  

**Result**:  
_none_  

**Return**:  
_none_  

**Sintaxe**:  

``` sh
functionName
res
code
```

### functionName( parameters )
Description.  

**Parameters**:  
_none_  

**Result**:  
_none_  

**Return**:  
_none_  

**Sintaxe**:  

``` sh
functionName
res
code
```

### functionName( parameters )
Description.  

**Parameters**:  
_none_  

**Result**:  
_none_  

**Return**:  
_none_  

**Sintaxe**:  

``` sh
functionName
res
code
```

### functionName( parameters )
Description.  

**Parameters**:  
_none_  

**Result**:  
_none_  

**Return**:  
_none_  

**Sintaxe**:  

``` sh
functionName
res
code
```

### functionName( parameters )
Description.  

**Parameters**:  
_none_  

**Result**:  
_none_  

**Return**:  
_none_  

**Sintaxe**:  

``` sh
functionName
res
code
```

### functionName( parameters )
Description.  

**Parameters**:  
_none_  

**Result**:  
_none_  

**Return**:  
_none_  

**Sintaxe**:  

``` sh
functionName
res
code
```

### functionName( parameters )
Description.  

**Parameters**:  
_none_  

**Result**:  
_none_  

**Return**:  
_none_  

**Sintaxe**:  

``` sh
functionName
res
code
```

### functionName( parameters )
Description.  

**Parameters**:  
_none_  

**Result**:  
_none_  

**Return**:  
_none_  

**Sintaxe**:  

``` sh
functionName
res
code
```

### functionName( parameters )
Description.  

**Parameters**:  
_none_  

**Result**:  
_none_  

**Return**:  
_none_  

**Sintaxe**:  

``` sh
functionName
res
code
```

### functionName( parameters )
Description.  

**Parameters**:  
_none_  

**Result**:  
_none_  

**Return**:  
_none_  

**Sintaxe**:  

``` sh
functionName
res
code
```

### functionName( parameters )
Description.  

**Parameters**:  
_none_  

**Result**:  
_none_  

**Return**:  
_none_  

**Sintaxe**:  

``` sh
functionName
res
code
```

### functionName( parameters )
Description.  

**Parameters**:  
_none_  

**Result**:  
_none_  

**Return**:  
_none_  

**Sintaxe**:  

``` sh
functionName
res
code
```

### functionName( parameters )
Description.  

**Parameters**:  
_none_  

**Result**:  
_none_  

**Return**:  
_none_  

**Sintaxe**:  

``` sh
functionName
res
code
```

### functionName( parameters )
Description.  

**Parameters**:  
_none_  

**Result**:  
_none_  

**Return**:  
_none_  

**Sintaxe**:  

``` sh
functionName
res
code
```

### functionName( parameters )
Description.  

**Parameters**:  
_none_  

**Result**:  
_none_  

**Return**:  
_none_  

**Sintaxe**:  

``` sh
functionName
res
code
```

### functionName( parameters )
Description.  

**Parameters**:  
_none_  

**Result**:  
_none_  

**Return**:  
_none_  

**Sintaxe**:  

``` sh
functionName
res
code
```

### functionName( parameters )
Description.  

**Parameters**:  
_none_  

**Result**:  
_none_  

**Return**:  
_none_  

**Sintaxe**:  

``` sh
functionName
res
code
```

### functionName( parameters )
Description.  

**Parameters**:  
_none_  

**Result**:  
_none_  

**Return**:  
_none_  

**Sintaxe**:  

``` sh
functionName
res
code
```

### functionName( parameters )
Description.  

**Parameters**:  
_none_  

**Result**:  
_none_  

**Return**:  
_none_  

**Sintaxe**:  

``` sh
functionName
res
code
```

### functionName( parameters )
Description.  

**Parameters**:  
_none_  

**Result**:  
_none_  

**Return**:  
_none_  

**Sintaxe**:  

``` sh
functionName
res
code
```

### functionName( parameters )
Description.  

**Parameters**:  
_none_  

**Result**:  
_none_  

**Return**:  
_none_  

**Sintaxe**:  

``` sh
functionName
res
code
```

### functionName( parameters )
Description.  

**Parameters**:  
_none_  

**Result**:  
_none_  

**Return**:  
_none_  

**Sintaxe**:  

``` sh
functionName
res
code
```

### functionName( parameters )
Description.  

**Parameters**:  
_none_  

**Result**:  
_none_  

**Return**:  
_none_  

**Sintaxe**:  

``` sh
functionName
res
code
```

### functionName( parameters )
Description.  

**Parameters**:  
_none_  

**Result**:  
_none_  

**Return**:  
_none_  

**Sintaxe**:  

``` sh
functionName
res
code
```

### functionName( parameters )
Description.  

**Parameters**:  
_none_  

**Result**:  
_none_  

**Return**:  
_none_  

**Sintaxe**:  

``` sh
functionName
res
code
```

### functionName( parameters )
Description.  

**Parameters**:  
_none_  

**Result**:  
_none_  

**Return**:  
_none_  

**Sintaxe**:  

``` sh
functionName
res
code
```

### functionName( parameters )
Description.  

**Parameters**:  
_none_  

**Result**:  
_none_  

**Return**:  
_none_  

**Sintaxe**:  

``` sh
functionName
res
code
```

### functionName( parameters )
Description.  

**Parameters**:  
_none_  

**Result**:  
_none_  

**Return**:  
_none_  

**Sintaxe**:  

``` sh
functionName
res
code
```

### functionName( parameters )
Description.  

**Parameters**:  
_none_  

**Result**:  
_none_  

**Return**:  
_none_  

**Sintaxe**:  

``` sh
functionName
res
code
```

### functionName( parameters )
Description.  

**Parameters**:  
_none_  

**Result**:  
_none_  

**Return**:  
_none_  

**Sintaxe**:  

``` sh
functionName
res
code
```

### functionName( parameters )
Description.  

**Parameters**:  
_none_  

**Result**:  
_none_  

**Return**:  
_none_  

**Sintaxe**:  

``` sh
functionName
res
code
```

### functionName( parameters )
Description.  

**Parameters**:  
_none_  

**Result**:  
_none_  

**Return**:  
_none_  

**Sintaxe**:  

``` sh
functionName
res
code
```

### functionName( parameters )
Description.  

**Parameters**:  
_none_  

**Result**:  
_none_  

**Return**:  
_none_  

**Sintaxe**:  

``` sh
functionName
res
code
```

### functionName( parameters )
Description.  

**Parameters**:  
_none_  

**Result**:  
_none_  

**Return**:  
_none_  

**Sintaxe**:  

``` sh
functionName
res
code
```


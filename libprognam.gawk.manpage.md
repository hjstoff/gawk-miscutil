# libprognam.gawk manual page

## Name
libprognam.gawk - retrieve program name of currently executing gawk script

## Library, repository
[gawk-miscutil](https://github.com/hjstoff/gawk-miscutil]), a small repository of
gawk-specific includable library files containing miscellaneous general purpose functions.

## Synopsis

```awk
#
# The AWKPATH environment variable must contain the path where 'libprognam.gawk' file to be included resides.
#
	@include "libprognam.gawk"

	program_invocation_name();

	program_invocation_short_name();

	errmsgprefix();
```
## Description

**program_invocation_name()**   
Return the - relative or absolute - pathname that was used to invoke the executing gawk script.  
If the executing gawk code, is not invoked from an executable gawk script,
or the function fails to retrieve the script name,
a diagnostic message is printed to the standard error channel and program is terminated.

**program_invocation_short_name()**
Return the basename of that was used used to invoke the executing gawk script.
If the executing gawk code, is not invoked from an executable gawk script,
or the function fails to retrieve the script name,
a diagnostic message is printed to the standard error channel and program is terminated.

**errmsgprefix()**
Return a string consisting of the program invocation basename, followed by an opening square
bracket, followed by the process' PID number, followed by a closing square bracket, e.g., like so:  
` myscript[1234]`   
If the executing gawk code, is not invoked from an executable gawk script,
or the function fails to retrieve the script name,
a diagnostic message is printed to the standard error channel and program is terminated.

# Notes
Awk program scripts, like scripts written in many other script languages, can be made into
self-contained executable utilities by means of the '**#!**' script mechanism, e.g. like so:
```
#! /bin/gawk -f
BEGIN {  print "hello world"; }
```
How, contrary to most other script languages, there is no standard way for an awk script to
retrieve the name it was invoked with, not in `gawk`, and neither in other awk implementations.
This is so, because there need not even be such a name!
Historically, awk was developed to write filter scripts that were directly entered as a one-liner
on the command line, or to be directly inlined in a program script written in another
language - mostly shell scripts.

The following - contrived - example of a inlined gawk script will fail, exit with exit value 1,
as function `program_invocation_short_name()` will of course not be able to find a program invocation
name for the currently executing gawk script where there is none to be found:

```sh
#! /bin/bash
PROGNAM=${BASH_SOURCE##*/}

gawk '
@include "libprognam.gawk";
BEGIN {
  print program_invocation_short_name();
}
'
```




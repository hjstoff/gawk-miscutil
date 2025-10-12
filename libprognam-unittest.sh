#! /usr/bin/bash
readonly PROGNAM="${BASH_SOURCE##*/}"
readonly CAT='/usr/bin/cat'
readonly GAWK='/usr/bin/gawk'

mktestprog()
{
"${CAT}" <<EOF
#! ${GAWK}  $1
@include "libprognam.gawk";
BEGIN {
	gawkscriptname = "$2"
	if (program_invocation_name() != gawkscriptname) {
		print program_invocation_name(), "!=", name "!" > "/dev/stderr"; 
		exit(1);
	}
	sub(/^.*\//, "", gawkscriptname); # Strip the path prefix from the script.
	if (program_invocation_short_name() != gawkscriptname) {
		print program_invocation_short_name(), "!=", gawkscriptname "!" > "/dev/stderr"; 
		exit(1);
	}
	msgprefix = gawkscriptname "[" PROCINFO["pid"] "]";
	if (errmsgprefix() != msgprefix) {
		print program_invocation_short_name(), "!=", msgprefix "!" > "/dev/stderr"; 
		exit(1);
	}
	exit(0);
}
EOF
}

NTESTS=0
NFAILED=0
for arg in "-f" "-tsbnrOSf" "-bf" "-E" "-bE" "-bsrnOE" "--file" "--exec" 
do
	let NTESTS=NTESTS+1
	testprogfile="./libprognam-testprog.${arg}"
	mktestprog ${arg} ${testprogfile} >  "${testprogfile}"
	chmod 755 "${testprogfile}"
	if ! "${testprogfile}"
	then
		echo "${PROGNAM}: Test '${testprogfile}' failed!" >&2 
		let NFAILED=NFAILED+1
	else
		echo "${PROGNAM}: Test '${testprogfile}' passed!"  >&2
	fi	
	rm "${testprogfile}"
done

#
# The gawk script inlined between single quotes below obviously has no program
# invocation script. The program invocation name is expeced to be set to an
# empty string while the error message prefix is based on the interpreter's
# name (most likely "gawk").
#
let NTESTS=NTESTS+1
"${GAWK}" -v gawkname="${GAWK##*/}" '
@include "libprognam.gawk";
BEGIN {
	for (i = 0; i < length(PROCINFO["argv"]); ++i) {
		printf("%2d: %s\n", i, PROCINFO["argv"][i]);
	}
	if (program_invocation_short_name() != "") {
		print program_invocation_short_name() " != empty string!" > "/dev/stderr";
		exit(1);
	}
	prefix = gawkname "[" PROCINFO["pid"] "]";
	if (errmsgprefix() != prefix) {
		print errmsgprefix() " != " prefix "!" > "/dev/stderr";
		exit(1);
	}
}
'
if [[ $? -ne 0 ]]
then
	echo "${PROGNAM}: Test with inline gawk program text failed!" 
	let NFAILED=NFAILED+1
else
	echo "${PROGNAM}: Test with inline gawk program text passed!" >&2
fi
echo $NTESTS tests, $NFAILED failed.
if [[ $NFAILED -ne 0 ]]
then
	exit 1
fi

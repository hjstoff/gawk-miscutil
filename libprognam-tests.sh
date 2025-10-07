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
	name = "$2"
	if (program_invocation_name() != name) {
		print program_invocation_name(), "!=", name "!"; 
		exit(1);
	}
	sub(/^.*\//, "", name); 
	if (program_invocation_short_name() != name) {
		print program_invocation_short_name(), "!=", name "!"; 
		exit(1);
	}
	exit(0);
}
EOF
}

NTESTS=0
NFAILED=0
# These succeed when exit status == 0 ...
for arg in "-f" "-bf" "-E" "-bE" "--file" "--exec" 
do
	let NTESTS=NTESTS+1
	testprogfile="./libprognam-testprog.${arg}"
	mktestprog ${arg} ${testprogfile} >  "${testprogfile}"
	chmod 755 "${testprogfile}"
	if ! "${testprogfile}"
	then
		echo "${PROGNAM}: Test '${testprogfile}' failed!" 
		let NFAILED=NFAILED+1
	else
		echo "${PROGNAM}: Test '${testprogfile}' passed!" 
	fi	
	rm "${testprogfile}"
done

#
# This succeeds when exit status == 1 and a proper diagnostic is printed
# on stderr.
#
let NTESTS=NTESTS+1
"${GAWK}" '
@include "libprognam.gawk";
BEGIN {
  	print program_invocation_short_name();
	#
	# This should never be reached as program_invocation_short_name
	# is supposed to call exit(1) on failure.
	#
	exit(0);
}
'
if [[ $? -ne 1 ]]
then
	echo "${PROGNAM}: Test with inline gawk program text failed!" 
	let NFAILED=NFAILED+1
else
	echo "${PROGNAM}: Test with inline gawk program text passed!" 
fi
echo $NTESTS tests, $NFAILED failed.
if [[ $NFAILED -ne 0 ]]
then
	exit 1
fi

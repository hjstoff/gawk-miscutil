#
# The code in this file is considered library code, to be included
# (using @include) by other scripts. Therefore this file itself is NOT
# made executable.
#
@namespace "libprognam";

function awk::program_invocation_name(	argc) {
	if (awk::typeof(program_invocation_name) == "untyped") {
		program_invocation_name = "";
		if (argc = length(PROCINFO["argv"]) >= 3) {
			if (PROCINFO["argv"][1] ~ /^(-b?[fE])|(--file)|(--exec)$/) {
				program_invocation_name = PROCINFO["argv"][2];
			}
		}
	}
	if (! (awk::typeof(program_invocation_name) == "string" && length(program_invocation_name) > 0)) {
		printf("[PID=%s]: [E] Failed to deduce program invocation name from \047PROCINFO[\"argv\"]\047!\n",
		PROCINFO["pid"]) > "/dev/stderr"; 
		exit(1);
	}
	return program_invocation_name;
}

function awk::program_invocation_short_name() {
	if (awk::typeof(program_invocation_short_name) == "untyped") {
		program_invocation_short_name = awk::program_invocation_name();
		sub(/^.*\//, "", program_invocation_short_name);
	}
	return program_invocation_short_name;
}

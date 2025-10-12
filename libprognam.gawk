#
# The code in this file is considered library code, to be included
# (using @include) by other scripts. Therefore this file itself is NOT
# made executable.
#
@namespace "libprognam";

function set_program_invocation_names(	argc) {
	argc = length(PROCINFO["argv"]);
	if (argc >= 3 && (PROCINFO["argv"][1] ~ /^(-[bnrstOS]*[fE])|(--file)|(--exec)$/)) {
		#
		# Experimenting with gawk 5.1.0 determined that --file and --exec
		# as such work to make the script executable, but without any
		# additional options. The short options that do not take an option
		# argument work, concatenated if there are more, as long as f or E
		# the last one.
		# 
		program_invocation_name = PROCINFO["argv"][2];
		program_invocation_short_name = program_invocation_name;
		sub(/^.*\//, "", program_invocation_short_name);
		return 1;
	}
	program_invocation_short_name = program_invocation_name = "";
	return 0;
}

function awk::program_invocation_name() {
	if (awk::typeof(program_invocation_name) == "untyped") {
		set_program_invocation_names();
	}
	return program_invocation_name;
}

function awk::program_invocation_short_name() {
	if (awk::typeof(program_invocation_short_name) == "untyped") {
		set_program_invocation_names();
	}
	return program_invocation_short_name;
}

function set_errmsgprefix(	tmp) {
	if (awk::typeof(program_invocation_short_name) == "untyped") {
		set_program_invocation_names();
	}
	if (program_invocation_short_name == "") {
		tmp = PROCINFO["argv"][0];
		sub(/^.*\//, "", tmp);
	}
	else {
		tmp = program_invocation_short_name;
	}
	errmsgprefix = tmp "["  PROCINFO["pid"] "]";
}

function awk::errmsgprefix() {
	if (awk::typeof(errmsgprefix) == "untyped") {
		set_errmsgprefix();
	}
	return errmsgprefix;
}

__SKIP__=77

skip()
{
	echo "$@"
	exit ${__SKIP__}
}

remove_commit_id()
{
    # Remove a commit id embedded in tags file
    sed -i -e '/!_TAG_PROGRAM_VERSION.*/s#/[^/]*/#//#' $1
}

filesize()
{
    wc -c < "$1"
}

is_feature_available()
{
    local ctags=$1
	local tmp=$2
	local neg
	local feat

	if [ "${tmp}" = '!' ]; then
		neg=1
		feat=$3
	else
		feat=$2
	fi

	if [ "${neg}" = 1 ]; then
		if ${ctags} --list-features | grep -q "$feat"; then
			skip "feature \"$feat\" is available in $ctags"
		fi
	else
		if ! ${ctags} --list-features | grep -q "$feat"; then
			skip "feature \"$feat\" is not available in $ctags"
		fi
	fi
}

exit_if_no_coproc()
{
    is_feature_available $1 coproc
}

exit_if_win32()
{
	is_feature_available $1 '!' win32
}

run_with_format()
{
    echo '#' $*
    local format=$1
    shift
    ${CTAGS} --quiet --options=NONE --output-format=$format "$@" -o - input.*
}

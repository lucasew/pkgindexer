#!/usr/bin/env bash

set -eu

report_error() {
	local msg="$1"
	local code="${2:-1}"
	echo "ERROR: $msg" >&2
	# In the future, this could be extended to send reports to a central system like Sentry
	exit "$code"
}

TMPDIR=${TMPDIR:-"$(dirname "$(mktemp)")"}
TMPDIR="$TMPDIR/pkgindexer"
mkdir -p "$TMPDIR"

echo "$TMPDIR"

handle_worktree() {
	local BRANCH="$1"
	shift
	local WORKTREE_DIR="$TMPDIR/$BRANCH"

	if [ ! -d "$WORKTREE_DIR" ]; then
		git worktree add -b "$BRANCH" "$WORKTREE_DIR" blank || git worktree add "$WORKTREE_DIR" "$BRANCH" || report_error "Failed to create or add git worktree for branch '$BRANCH'."
	fi

	pushd "$WORKTREE_DIR" >/dev/null || report_error "Failed to pushd to '$WORKTREE_DIR'."
	bash "$1" || report_error "Execution of script in worktree failed."
	popd >/dev/null || report_error "Failed to popd."
}

if [ $# -eq 0 ]; then
	report_error "No command provided."
fi

CMD="$1"
shift

case "$CMD" in
worktree) # ./ctl worktree hello <(echo 'echo eoq > teste && git add -A && git commit -sm "test" --allow-empty')
	if [ $# -lt 2 ]; then
		report_error "Usage: $0 worktree <branch> <script_path>"
	fi
	handle_worktree "$@"
	;;
*)
	report_error "Unknown command: $CMD"
	;;
esac

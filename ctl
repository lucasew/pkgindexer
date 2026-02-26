#!/usr/bin/env bash
#
# PkgIndexer Control Script (ctl)
#
# This script manages git worktrees for package indexing tasks. It provides
# a mechanism to execute scripts within isolated worktrees, ensuring
# clean environments for indexing operations.
#
# Environment Variables:
#   TMPDIR: The base directory for temporary files. Defaults to the system
#           temporary directory if not set. Worktrees are created in
#           $TMPDIR/pkgindexer.
#
# Usage:
#   ./ctl <command> [arguments...]
#
# Commands:
#   worktree <branch_name> <script_path>
#     Creates or reuses a git worktree for the specified branch and executes
#     the given script within that worktree.
#
#     Arguments:
#       branch_name: The name of the branch to use for the worktree.
#                    If the branch does not exist, it is created from 'blank'.
#       script_path: Path to the bash script to execute inside the worktree.
#                    This is typically passed as a process substitution or file path.
#
#     Example:
#       ./ctl worktree my-feature <(echo 'echo "update" > status && git add status && git commit -m "Update"')
#

set -eu

# Set up temporary directory for worktrees
# Uses system temp dir by default, creates a 'pkgindexer' subdirectory
TMPDIR=${TMPDIR:-"$(dirname "$(mktemp)")"}
TMPDIR="$TMPDIR/pkgindexer"
mkdir -p "$TMPDIR"

echo "$TMPDIR"

CMD="$1"
shift

case "$CMD" in
worktree)
	# Usage: ./ctl worktree <branch> <script>
	BRANCH="$1"
	shift
	WORKTREE_DIR="$TMPDIR/$BRANCH"

	# Create worktree if it doesn't exist
	# Tries to create a new branch from 'blank' or checks out existing branch
	if [ ! -d "$WORKTREE_DIR" ]; then
		git worktree add -b "$BRANCH" "$WORKTREE_DIR" blank || git worktree add "$WORKTREE_DIR" "$BRANCH"
	fi

	# Execute script inside worktree
	pushd "$WORKTREE_DIR"
	bash "$1"
	popd
	;;
*)
	echo "Unknown command: $CMD"
	exit 1
	;;
esac

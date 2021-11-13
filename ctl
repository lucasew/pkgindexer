#!/usr/bin/env bash

set -eu

TMPDIR=${TMPDIR:-"$(dirname $(mktemp))"}
TMPDIR="$TMPDIR/pkgindexer"
mkdir -p "$TMPDIR"

echo $TMPDIR

CMD="$1";shift

case "$CMD" in
    worktree)
        BRANCH="$1"; shift
        WORKTREE_DIR="$TMPDIR/$BRANCH"
        if [ ! -d "$WORKTREE_DIR" ]; then
            git worktree add -b "$BRANCH" "$WORKTREE_DIR" blank || git worktree add "$WORKTREE_DIR" "$BRANCH"
        fi
        pushd "$WORKTREE_DIR"
        bash "$1"
        popd
    ;;
esac


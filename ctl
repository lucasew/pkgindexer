#!/usr/bin/env bash

set -eu

: "${XDG_CACHE_HOME:=$HOME/.cache}"
# Use XDG_CACHE_HOME for persistence and security, unless TMPDIR is explicitly set
BASE_DIR="${TMPDIR:-$XDG_CACHE_HOME}"
TMPDIR="$BASE_DIR/pkgindexer"
mkdir -p "$TMPDIR"
chmod 700 "$TMPDIR"

echo $TMPDIR

CMD="$1";shift

case "$CMD" in
    worktree) # ./ctl worktree hello <(echo 'echo eoq > teste && git add -A && git commit -sm "test" --allow-empty')
        BRANCH="$1"; shift
        # SECURITY: prevent path traversal
        if [[ "$BRANCH" == *".."* ]] || [[ "$BRANCH" == /* ]]; then
            echo "Error: Branch name cannot contain '..' or start with '/'" >&2
            exit 1
        fi
        WORKTREE_DIR="$TMPDIR/$BRANCH"
        if [ ! -d "$WORKTREE_DIR" ]; then
            git worktree add -b "$BRANCH" "$WORKTREE_DIR" blank || git worktree add "$WORKTREE_DIR" "$BRANCH"
        fi
        pushd "$WORKTREE_DIR"
        bash "$1"
        popd
    ;;
esac


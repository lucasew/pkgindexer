# PkgIndexer

A way to vendor references to packages to be used as a single point of truth about where are the indexes.

Should work in the constrained environment [Nix](https://nixos.org) provides for building but without passing one hash for each package.

This thing should be as lazy as possible to download stuff. If you are using python stuff you shouldn't download NodeJS stuff if you do not need but if you do you will have this option!

## Usage

The `ctl` script is used to manage git worktrees for package indexing tasks.

### Running a script in a worktree

To run a script within a git worktree (creating it from the `blank` branch if it doesn't exist), use the `worktree` command:

```bash
./ctl worktree <branch_name> <script_path>
```

Example:

```bash
./ctl worktree my-feature-branch <(echo "echo 'doing work' && git commit --allow-empty -m 'work done'")
```

This will:

1. Create a worktree for `my-feature-branch` in a temporary directory (`$TMPDIR/pkgindexer/my-feature-branch`).
2. If the branch doesn't exist, it creates it starting from `blank`.
3. Execute the provided script inside that worktree.

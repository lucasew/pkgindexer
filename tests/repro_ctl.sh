#!/usr/bin/env bash
set -e

# Setup
TEST_DIR=$(mktemp -d)
cp ctl "$TEST_DIR/ctl"
chmod +x "$TEST_DIR/ctl"

echo "Running tests in $TEST_DIR"

cd "$TEST_DIR"
git init >/dev/null
git config user.email "you@example.com"
git config user.name "Your Name"
git commit --allow-empty -m "Init" >/dev/null
git branch blank >/dev/null

# Mock mktemp
mkdir -p "$TEST_DIR/bin"
cat > "$TEST_DIR/bin/mktemp" <<EOF
#!/bin/sh
echo "$TEST_DIR/system_tmp/random_file"
EOF
chmod +x "$TEST_DIR/bin/mktemp"
mkdir -p "$TEST_DIR/system_tmp"
export PATH="$TEST_DIR/bin:$PATH"

# Test 1: Insecure Directory Creation
unset TMPDIR
echo "Running ctl (Test 1: Insecure Dir)..."
"$TEST_DIR/ctl" worktree "testbranch" "true" 2>/dev/null || true

if [ -d "$TEST_DIR/system_tmp/pkgindexer" ]; then
    echo "VULNERABILITY CONFIRMED: Predictable directory created."
    rm -rf "$TEST_DIR"
    exit 1
else
    echo "PASS: Predictable directory avoided."
fi

# Test 2: Path Traversal Blocked
echo "Running ctl (Test 2: Path Traversal Blocked)..."
# Attempt to use "../pwned"
output=$("$TEST_DIR/ctl" worktree "../pwned" "true" 2>&1 || true)

if echo "$output" | grep -q "Error: Branch name cannot contain"; then
    echo "PASS: Path Traversal blocked."
else
    echo "FAIL: Path Traversal NOT blocked. Output: $output"
    rm -rf "$TEST_DIR"
    exit 1
fi

# Test 3: Valid Slashed Branch Allowed
echo "Running ctl (Test 3: Valid Slash Allowed)..."
# Branch name: feature/foo
# Should succeed (or fail with git error if branch doesn't exist, but NOT with our security error)
output=$("$TEST_DIR/ctl" worktree "feature/foo" "true" 2>&1 || true)

if echo "$output" | grep -q "Error: Branch name cannot contain"; then
    echo "FAIL: Valid branch name 'feature/foo' was blocked."
    rm -rf "$TEST_DIR"
    exit 1
else
    echo "PASS: Valid branch name 'feature/foo' allowed."
fi

rm -rf "$TEST_DIR"
exit 0

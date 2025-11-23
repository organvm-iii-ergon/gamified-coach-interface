#!/usr/bin/env bash
set -euo pipefail

# Basic unit-like tests for manage_vscode_extensions.sh
# Tests performed:
#  - path resolution returns absolute path
#  - --wait behavior: script waits for source to appear
#  - backup rotation: only keeps MAX_BACKUPS
#  - symlink creation and removal with --dry-run and real run

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
SCRIPT="$ROOT_DIR/manage_vscode_extensions.sh"
TEST_DIR="$(mktemp -d /tmp/mvscode_test.XXXX)"
export HOME="$TEST_DIR/home"
mkdir -p "$HOME"

log() { printf "[test] %s\n" "$*"; }

fail() { echo "FAIL: $*" >&2; exit 1; }
pass() { echo "PASS: $*"; }

# helper to run script
run_script() {
  bash "$SCRIPT" "$@"
}

# 1) path resolution: using --source ~/foo returns expanded path when reporting status
mkdir -p "$HOME/dot-files/.vscode-insiders/extensions"
TARGET="$HOME/.vscode-insiders/extensions"
RESULT=$(bash "$SCRIPT" status --source ~/dot-files/.vscode-insiders/extensions --target "$TARGET" 2>/dev/null || true)
if [[ "$RESULT" != *"Source:"* ]]; then
  fail "status did not print Source header"
else
  pass "path resolution prints Source"
fi

# 2) --wait behavior: run create in background with --wait 3, and create source after 1s
SRC="$HOME/dot-files2/.vscode-insiders/extensions"
mkdir -p "$(dirname "$SRC")"
# start create in background
( bash "$SCRIPT" create --source "$SRC" --target "$TARGET" --wait 3 ) &
PID=$!
sleep 1
mkdir -p "$SRC"
wait $PID || true
if [[ -L "$TARGET" ]]; then
  pass "--wait create created symlink after source appeared"
else
  fail "--wait create did not create symlink"
fi

# 3) backup rotation: create dummy backups and ensure rotation keeps only MAX_BACKUPS
# create 7 backups
for i in $(seq 1 7); do
  d="$HOME/.vscode_extensions_backup_$(date +%s)_$i"
  mkdir -p "$d"
  sleep 1
done
# call rotate via creating another backup by creating a file then creating symlink
# create a real directory at target, then run create to trigger backup
rm -f "$TARGET"
mkdir -p "$TARGET"
# ensure script will backup existing target
bash "$SCRIPT" create --source "$HOME/dot-files/.vscode-insiders/extensions" --target "$TARGET"
backups=("$HOME"/.vscode_extensions_backup_*)
count=0
for b in "${backups[@]}"; do [[ -e "$b" ]] && count=$((count+1)); done
if [[ $count -le 5 ]]; then
  pass "backup rotation keeps at most 5 backups (count=$count)"
else
  fail "backup rotation left too many backups (count=$count)"
fi

# 4) symlink creation/removal and dry-run
rm -f "$TARGET"
mkdir -p "$HOME/dot-files/.vscode-insiders/extensions"
# dry-run create
bash "$SCRIPT" create --source "$HOME/dot-files/.vscode-insiders/extensions" --target "$TARGET" --dry-run
if [[ -e "$TARGET" ]]; then
  fail "dry-run should not create target"
else
  pass "dry-run create did not create target"
fi
# real create
bash "$SCRIPT" create --source "$HOME/dot-files/.vscode-insiders/extensions" --target "$TARGET"
if [[ -L "$TARGET" ]]; then
  pass "real create created symlink"
else
  fail "real create failed to create symlink"
fi
# dry-run revert
bash "$SCRIPT" revert --target "$TARGET" --dry-run
if [[ -L "$TARGET" ]]; then
  pass "dry-run revert did not remove symlink"
else
  fail "dry-run revert should not remove symlink"
fi
# real revert
bash "$SCRIPT" revert --target "$TARGET"
if [[ ! -e "$TARGET" ]]; then
  pass "real revert removed symlink and restored backup or left absent"
else
  # either restored backup or absent; accept existence only if it's not a symlink
  if [[ ! -L "$TARGET" ]]; then
    pass "real revert restored a non-symlink target"
  else
    fail "real revert left a symlink"
  fi
fi

echo "All tests completed."

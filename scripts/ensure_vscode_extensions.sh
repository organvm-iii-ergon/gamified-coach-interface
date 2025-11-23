#!/usr/bin/env bash
set -euo pipefail

# Ensure VS Code / VS Code Insiders extensions are present in the expected location
# Can create a symlink from a dot-files managed location, or copy (rsync) files there.
# Safe: does not delete your existing data unless you explicitly pass --replace
#
# Usage:
#  ./ensure_vscode_extensions.sh --help
#  ./ensure_vscode_extensions.sh --from ~/dot-files/.vscode-insiders/extensions --mode symlink
#  ./ensure_vscode_extensions.sh --from ~/dot-files/.vscode-insiders/extensions --mode copy --replace
#

DOT_SRC=""
MODE="symlink" # symlink | copy
TARGET_BASE="$HOME/.vscode-insiders/extensions"
ALT_TARGET_BASE="$HOME/.vscode/extensions"
REPLACE=false
DRY=false

print_help(){
  cat <<EOF
Usage: $0 [--from PATH] [--mode symlink|copy] [--target insiders|stable] [--replace] [--dry]

Options:
  --from PATH        Source directory where your dotfiles store extensions (required)
  --mode MODE        'symlink' (default) or 'copy' (rsync)
  --target WHICH     'insiders' (default) or 'stable' to target ~/.vscode-insiders/extensions or ~/.vscode/extensions
  --replace          When using --mode copy, allow replacing existing files in target (rsync --delete).
  --dry              Do a dry-run (print actions, do not modify filesystem)
  --help             Show this help

Examples:
  $0 --from ~/dot-files/.vscode-insiders/extensions --mode symlink
  $0 --from ~/dot-files/.vscode-insiders/extensions --mode copy --replace --target insiders

EOF
}

while [[ ${1:-} != "" ]]; do
  case "$1" in
    --from) DOT_SRC="$2"; shift 2;;
    --mode) MODE="$2"; shift 2;;
    --target) if [[ "$2" == "stable" ]]; then TARGET_BASE="$ALT_TARGET_BASE"; fi; shift 2;;
    --replace) REPLACE=true; shift;;
    --dry) DRY=true; shift;;
    --help|-h) print_help; exit 0;;
    *) echo "Unknown arg: $1"; print_help; exit 2;;
  esac
done

if [[ -z "$DOT_SRC" ]]; then
  echo "Error: --from PATH is required. Use --help for usage." >&2
  exit 3
fi

DOT_SRC="${DOT_SRC/#\~/$HOME}"
TARGET_BASE="${TARGET_BASE/#\~/$HOME}"

echo "Source: $DOT_SRC"
echo "Target: $TARGET_BASE"
echo "Mode: $MODE"
echo "Replace enabled: $REPLACE"
echo "Dry-run: $DRY"
echo

if [[ ! -d "$DOT_SRC" ]]; then
  echo "Source directory not found: $DOT_SRC" >&2
  exit 4
fi

mkdir -p "$(dirname "$TARGET_BASE")"

if [[ "$MODE" == "symlink" ]]; then
  if [[ -L "$TARGET_BASE" ]]; then
    echo "Target is already a symlink: $TARGET_BASE -> $(readlink "$TARGET_BASE")"
    exit 0
  fi

  if [[ -e "$TARGET_BASE" && ! -L "$TARGET_BASE" ]]; then
    echo "Target exists and is not a symlink: $TARGET_BASE"
    echo "To proceed, move it aside or run with --replace (copy mode) to overwrite."
    exit 5
  fi

  echo "Will create symlink: $TARGET_BASE -> $DOT_SRC"
  if [[ "$DRY" == true ]]; then
    echo "DRY RUN: not creating symlink"
    exit 0
  fi

  ln -svf "$DOT_SRC" "$TARGET_BASE"
  echo "Symlink created. Verify in VS Code and reload (Cmd+Shift+P → Developer: Reload Window)."

elif [[ "$MODE" == "copy" ]]; then
  # Use rsync to copy contents; be conservative unless --replace is specified
  RSYNC_OPTS=( -a --no-perms --no-owner --no-group )
  if [[ "$REPLACE" == true ]]; then
    RSYNC_OPTS+=( --delete )
  fi

  echo "Will sync from $DOT_SRC/ to $TARGET_BASE/ with options: ${RSYNC_OPTS[*]}"
  if [[ "$DRY" == true ]]; then
    echo "DRY RUN: rsync -n ${RSYNC_OPTS[*]} \"$DOT_SRC/\" \"$TARGET_BASE/\""
    rsync -n "${RSYNC_OPTS[@]}" "$DOT_SRC/" "$TARGET_BASE/"
    exit 0
  fi

  mkdir -p "$TARGET_BASE"
  rsync "${RSYNC_OPTS[@]}" "$DOT_SRC/" "$TARGET_BASE/"
  echo "Sync complete. Verify extension permissions and reload VS Code."
else
  echo "Unknown mode: $MODE" >&2
  exit 6
fi

exit 0

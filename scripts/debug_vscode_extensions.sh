#!/usr/bin/env bash
set -euo pipefail

# Debug helper for VS Code / VS Code Insiders extensions folder
# Usage:
#   ./debug_vscode_extensions.sh                -> scan for extensions missing package.json
#   ./debug_vscode_extensions.sh <ext-folder>   -> inspect specific extension folder
#   ./debug_vscode_extensions.sh <ext-folder> --remove -> prompt to remove the folder
#   ./debug_vscode_extensions.sh --help         -> show this help

EXT_BASE="${HOME}/.vscode-insiders/extensions"
ALT_EXT_BASE="${HOME}/.vscode/extensions"
MODE="insiders" # insiders | stable | both
REPORT_JSON=""
NOTIFY=false
SCAN_DIR_OVERRIDE=""

# Helper: validate JSON file. Returns 0 if valid JSON, non-zero otherwise.
is_valid_json() {
  local f="$1"
  if command -v jq >/dev/null 2>&1; then
    jq -e . "$f" >/dev/null 2>&1
    return $?
  fi
  if command -v python3 >/dev/null 2>&1; then
    python3 - <<PYCODE
import json,sys
try:
    json.load(open('$f'))
except Exception as e:
    sys.exit(1)
sys.exit(0)
PYCODE
    return $?
  fi
  # Last resort: try python
  if command -v python >/dev/null 2>&1; then
    python - <<PYCODE
import json,sys
try:
    json.load(open('$f'))
except Exception:
    sys.exit(1)
sys.exit(0)
PYCODE
    return $?
  fi
  # Can't validate - assume invalid
  return 2
}

print_help() {
  cat <<EOF
Debug VS Code Insiders / stable extensions folders

Default Insiders folder: $EXT_BASE
Stable folder: $ALT_EXT_BASE

Usage:
  $0                        Scan the default (Insiders) extensions folder
  $0 --stable               Scan stable VS Code extensions folder (~/.vscode/extensions)
  $0 --both                 Scan both folders
  $0 <folder-name>          Inspect a specific extension folder in the selected folder
  $0 <folder-name> --remove Prompt to remove the folder (safe)

Examples:
  $0
  $0 atishay-jain.all-autocomplete-0.0.26
  $0 atishay-jain.all-autocomplete-0.0.26 --remove
  Debug VS Code Insiders / stable extensions folders

  Default Insiders folder: $EXT_BASE

Notes:
  - This script is read-only by default. Use --remove to delete an extension folder after verifying.
  - It operates on the VS Code Insiders extensions folder. If you use stable VS Code, check ~/.vscode/extensions instead.
EOF
}

if [[ ${1:-} == "--help" || ${1:-} == "-h" ]]; then
  print_help
  exit 0
fi

# Parse flags. Keep simple parsing for --stable, --both, --report [path], --notify
while [[ ${1:-} != "" ]]; do
  case "$1" in
    --stable)
      MODE="stable"
      shift
      ;;
    --both)
      MODE="both"
      shift
      ;;
    --report)
      # optional path next
      if [[ ${2:-} != "" && ${2:0:1} != "-" ]]; then
        REPORT_JSON="$2"
        shift 2
      else
        REPORT_JSON="$HOME/Library/Logs/extension_package_report.json"
        shift
      fi
      ;;
    --notify)
      NOTIFY=true
      shift
      ;;
    --extensions-dir)
      SCAN_DIR_OVERRIDE="$2"
      shift 2
      ;;
    --help|-h)
      print_help
      exit 0
      ;;
    *)
      # stop parsing flags when we hit a non-flag (target folder name)
      break
      ;;
  esac
done

if [[ -z "$SCAN_DIR_OVERRIDE" ]]; then
  if [[ "$MODE" == "insiders" && ! -d "$EXT_BASE" ]]; then
    echo "Insiders extensions directory not found: $EXT_BASE"
    echo "If you use stable VS Code instead of Insiders, run with --stable or --both"
    exit 2
  fi
  if [[ "$MODE" == "stable" && ! -d "$ALT_EXT_BASE" ]]; then
    echo "Stable extensions directory not found: $ALT_EXT_BASE"
    echo "If you use Insiders instead, run without --stable"
    exit 2
  fi
fi

# No args: scan
scan_dir() {
  local DIR="$1"
  echo "Scanning extensions in: $DIR"
  report_items=()
  problems_count=0
  echo
  missing=0
  for d in "$DIR"/*; do
    [[ -d "$d" ]] || continue
    base=$(basename "$d")
    pkg="$d/package.json"
    if [[ -f "$pkg" ]]; then
      # validate JSON
      if ! is_valid_json "$pkg"; then
        echo "[INVALID_JSON] $base - package.json is not valid JSON"
        report_items+=("$base:invalid_json")
        missing=$((missing+1))
      else
        # check name and version
        if command -v jq >/dev/null 2>&1; then
          name_field=$(jq -r '.name // empty' "$pkg") || name_field=""
          version_field=$(jq -r '.version // empty' "$pkg") || version_field=""
        else
          name_field=$(grep -m1 '"name"' "$pkg" | sed -E 's/.*"name"\s*:\s*"([^"]+)".*/\1/' || true)
          version_field=$(grep -m1 '"version"' "$pkg" | sed -E 's/.*"version"\s*:\s*"([^"]+)".*/\1/' || true)
        fi
        if [[ -z "$name_field" || -z "$version_field" ]]; then
          echo "[INVALID] $base - package.json missing name or version"
          report_items+=("$base:missing_name_or_version")
          missing=$((missing+1))
        else
          echo "[OK]      $base"
        fi
      fi
    else
      echo "[MISSING] $base - package.json not found"
      report_items+=("$base:missing")
      missing=$((missing+1))
    fi
  done
  echo
  echo "Scan complete for $DIR. Problems found: $missing"
  echo

  if [[ -n "$REPORT_JSON" ]]; then
    mkdir -p "$(dirname "$REPORT_JSON")"
    # build JSON safely
    printf '{"problems":[' > "$REPORT_JSON"
    first=1
    for it in "${report_items[@]}"; do
      if [[ $first -eq 0 ]]; then
        printf ',' >> "$REPORT_JSON"
      fi
      first=0
      name=${it%%:*}
      kind=${it##*:}
      # escape name and kind for JSON
      esc_name=$(printf '%s' "$name" | python3 -c 'import json,sys;print(json.dumps(sys.stdin.read().rstrip()))')
      esc_kind=$(printf '%s' "$kind" | python3 -c 'import json,sys;print(json.dumps(sys.stdin.read().rstrip()))')
      # esc_name and esc_kind are JSON strings (with quotes) so strip outer quotes
      esc_name=${esc_name#"}
      esc_name=${esc_name%"}
      esc_kind=${esc_kind#"}
      esc_kind=${esc_kind%"}
      printf '{"extension":"%s","problem":"%s"}' "$esc_name" "$esc_kind" >> "$REPORT_JSON"
    done
    printf ']}' >> "$REPORT_JSON"
    echo "Wrote report: $REPORT_JSON"
  fi

  if [[ "$NOTIFY" == true && ${#report_items[@]} -gt 0 ]]; then
    # build a short summary for notification
    total=${#report_items[@]}
    msg="Found $total problem(s) in $DIR"
    # Use osascript to display notification on macOS
    if command -v osascript >/dev/null 2>&1; then
      # Title and message. Escape double quotes in message.
      esc_msg=${msg//"/\"}
      osascript -e "display notification \"$esc_msg\" with title \"VSCode Extensions Scan\""
    fi
  fi
  echo
}

if [[ $# -eq 0 ]]; then
  if [[ -n "$SCAN_DIR_OVERRIDE" ]]; then
    scan_dir "$SCAN_DIR_OVERRIDE"
  else
    if [[ "$MODE" == "both" ]]; then
      scan_dir "$EXT_BASE"
      scan_dir "$ALT_EXT_BASE"
    elif [[ "$MODE" == "stable" ]]; then
      scan_dir "$ALT_EXT_BASE"
    else
      scan_dir "$EXT_BASE"
    fi
  fi
  echo "If you find corrupted or partially-installed extensions, consider uninstalling via the Extensions view or deleting the folder after backing up."
  exit 0
fi

# Inspect specific folder
TARGET="$1"
REMOVE=false
if [[ ${2:-} == "--remove" ]]; then
  REMOVE=true
fi

EXT_PATH="$EXT_BASE/$TARGET"
if [[ ! -d "$EXT_PATH" ]]; then
  echo "Extension folder not found: $EXT_PATH"
  echo "Make sure you provided the exact folder name (e.g. atishay-jain.all-autocomplete-0.0.26)"
  exit 3
fi

echo "Inspecting: $EXT_PATH"
echo
if [[ -f "$EXT_PATH/package.json" ]]; then
  echo "package.json exists. Showing basic info:"
  jq '{name: .name, version: .version, publisher: .publisher, displayName: .displayName}' "$EXT_PATH/package.json" || true
else
  echo "package.json not found in $EXT_PATH"
fi

# list other files
echo
echo "Directory listing (top level):"
ls -la --group-directories-first "$EXT_PATH" || ls -la "$EXT_PATH"

if [[ "$REMOVE" == true ]]; then
  echo
  echo "You passed --remove. About to prompt for deletion of $EXT_PATH"
  read -r -p "Are you sure you want to delete this folder? This cannot be undone. (yes/[no]) " answer
  if [[ "$answer" == "yes" ]]; then
    echo "Deleting $EXT_PATH ..."
    rm -rf -- "$EXT_PATH"
    echo "Deleted. You may need to reload VS Code / VS Code Insiders and reinstall the extension if desired."
  else
    echo "Aborted. No changes made."
  fi
fi

exit 0

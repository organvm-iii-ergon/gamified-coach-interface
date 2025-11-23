#!/usr/bin/env bash
set -euo pipefail

# Test for debug_vscode_extensions.sh --report and --notify
ROOT_DIR=$(cd "$(dirname "$0")/../.." && pwd)
SCRIPT="$ROOT_DIR/scripts/debug_vscode_extensions.sh"

# create a temp extensions dir
TMPDIR=$(mktemp -d)
EXT_DIR="$TMPDIR/extensions"
mkdir -p "$EXT_DIR"

# case 1: extension with no package.json
mkdir -p "$EXT_DIR/first.ext-0.0.1"

# case 2: extension with invalid JSON package.json
mkdir -p "$EXT_DIR/second.ext-0.0.2"
cat > "$EXT_DIR/second.ext-0.0.2/package.json" <<EOF
{ invalid json
EOF

# case 3: extension with missing name/version
mkdir -p "$EXT_DIR/third.ext-0.0.3"
cat > "$EXT_DIR/third.ext-0.0.3/package.json" <<EOF
{
  "description": "no name or version"
}
EOF

# case 4: valid extension
mkdir -p "$EXT_DIR/fourth.ext-1.2.3"
cat > "$EXT_DIR/fourth.ext-1.2.3/package.json" <<EOF
{
  "name": "fourth.ext",
  "version": "1.2.3"
}
EOF

# Prepare a fake osascript to capture notification (placed earlier in PATH)
FAKE_BIN_DIR="$TMPDIR/bin"
mkdir -p "$FAKE_BIN_DIR"
cat > "$FAKE_BIN_DIR/osascript" <<'SH'
#!/usr/bin/env bash
# Write args to a file for inspection
echo "$@" >> "$FAKE_BIN_DIR/osascript.called"
# Also print a recognizable line
echo "OSASCRIPT-CALLED"
SH
chmod +x "$FAKE_BIN_DIR/osascript"

# Run the script with REPORT_JSON pointing to a temp file and PATH patched
REPORT_JSON="$TMPDIR/report.json"
PATH="$FAKE_BIN_DIR:$PATH" "$SCRIPT" --report "$REPORT_JSON" --extensions-dir "$EXT_DIR" --notify > "$TMPDIR/out.log" 2>&1 || true

cat "$TMPDIR/out.log"

# Validate report
if [[ ! -f "$REPORT_JSON" ]]; then
  echo "Report not generated"
  exit 2
fi

jq '.' "$REPORT_JSON" > /dev/null || (echo "Report is not valid JSON" && exit 3)

# Expect 3 problems (first, second, third). fourth is OK.
PROBLEMS_COUNT=$(jq '.problems | length' "$REPORT_JSON")
if [[ "$PROBLEMS_COUNT" -ne 3 ]]; then
  echo "Expected 3 problems, got $PROBLEMS_COUNT"
  jq '.' "$REPORT_JSON"
  exit 4
fi

# check types
types_sorted=$(jq -r '.problems[].problem' "$REPORT_JSON" | sort | tr '\n' ',' )
if [[ "$types_sorted" != *"invalid_json"* || "$types_sorted" != *"missing"* || "$types_sorted" != *"missing_name_or_version"* ]]; then
  echo "Unexpected problem types: $types_sorted"
  jq '.' "$REPORT_JSON"
  exit 5
fi

# check that fake osascript was called
if [[ ! -f "$FAKE_BIN_DIR/osascript.called" ]]; then
  echo "osascript was not called"
  exit 6
fi

echo "TEST PASSED"

# Print report for human inspection
cat "$REPORT_JSON"

# Cleanup
rm -rf "$TMPDIR"
exit 0

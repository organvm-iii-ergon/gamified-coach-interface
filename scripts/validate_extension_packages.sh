#!/usr/bin/env bash
set -euo pipefail

EXT_DIR="${1:-$HOME/.vscode-insiders/extensions}"
OUT_JSON="$HOME/Library/Logs/extension_package_validation.json"

report=()
for d in "$EXT_DIR"/*; do
  [[ -d "$d" ]] || continue
  base=$(basename "$d")
  pkg="$d/package.json"
  if [[ -f "$pkg" ]]; then
    if command -v jq >/dev/null 2>&1; then
      if ! jq -e '.name and .version' "$pkg" >/dev/null 2>&1; then
        report+=("{\"extension\":\"$base\",\"problem\":\"invalid-package-json\"}")
      fi
    else
      if ! (grep -q '"name"' "$pkg" && grep -q '"version"' "$pkg"); then
        report+=("{\"extension\":\"$base\",\"problem\":\"missing-name-version\"}")
      fi
    fi
  else
    report+=("{\"extension\":\"$base\",\"problem\":\"missing-package-json\"}")
  fi
done

mkdir -p "$(dirname "$OUT_JSON")"
printf '{"problems":[' > "$OUT_JSON"
first=1
for item in "${report[@]}"; do
  if [[ $first -eq 0 ]]; then
    printf ',' >> "$OUT_JSON"
  fi
  first=0
  printf '%s' "$item" >> "$OUT_JSON"
done
printf ']}' >> "$OUT_JSON"

echo "Wrote extension package validation to: $OUT_JSON"
exit 0

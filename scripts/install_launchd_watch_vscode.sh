#!/usr/bin/env bash
#set -euo pipefail

TEMPLATE="$(pwd)/scripts/launchd_watch_vscode.plist.template"
PLIST_DEST="$HOME/Library/LaunchAgents/com.user.manage_vscode_extensions.watch.plist"

WATCH_PATH=${1:-"$HOME/dot-files"}

if [[ ! -f "$TEMPLATE" ]]; then
  echo "Template not found: $TEMPLATE" >&2
  exit 1
fi

echo "Installing Watch LaunchAgent plist to: $PLIST_DEST"
mkdir -p "$(dirname "$PLIST_DEST")"

REPO_ABS="$(pwd)"
# Replace placeholder with repo absolute path and watch path
sed "s#REPO_ABSOLUTE_PATH#$REPO_ABS#g; s#WATCH_PATH#${WATCH_PATH}#g; s#\$HOME#${HOME}#g" "$TEMPLATE" > "$PLIST_DEST"

echo "Loading Watch LaunchAgent..."
launchctl unload "$PLIST_DEST" 2>/dev/null || true
launchctl load "$PLIST_DEST"

echo "Installed and loaded. Logs: ~/Library/Logs/manage_vscode_extensions_watch.*.log"

echo "You can inspect the plist at: $PLIST_DEST"

exit 0

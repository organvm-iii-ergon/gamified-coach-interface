#!/usr/bin/env bash
set -euo pipefail

# Installer for the LaunchAgent to ensure the VS Code extensions symlink exists.
# It writes a plist to ~/Library/LaunchAgents and loads it with launchctl.

TEMPLATE="$(pwd)/scripts/launchd_manage_vscode.plist.template"
PLIST_DEST="$HOME/Library/LaunchAgents/com.user.manage_vscode_extensions.plist"

WAIT_SECONDS=${1:-300}
WAIT_INTERVAL=${2:-10}

if [[ ! -f "$TEMPLATE" ]]; then
  echo "Template not found: $TEMPLATE" >&2
  exit 1
fi

echo "Installing LaunchAgent plist to: $PLIST_DEST"
mkdir -p "$(dirname "$PLIST_DEST")"

# Replace placeholder with repo absolute path and inject wait values
REPO_ABS="$(pwd)"
sed "s#REPO_ABSOLUTE_PATH#$REPO_ABS#g; s#\$HOME#${HOME}#g; s#WAIT_SECONDS#${WAIT_SECONDS}#g; s#WAIT_INTERVAL#${WAIT_INTERVAL}#g" "$TEMPLATE" > "$PLIST_DEST"

echo "Loading LaunchAgent..."
launchctl unload "$PLIST_DEST" 2>/dev/null || true
launchctl load "$PLIST_DEST"

echo "Installed and loaded. Logs: ~/Library/Logs/manage_vscode_extensions.*.log"
echo "You can inspect the plist at: $PLIST_DEST"

echo "Installed with WAIT_SECONDS=${WAIT_SECONDS}, WAIT_INTERVAL=${WAIT_INTERVAL}"

exit 0

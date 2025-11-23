# Manage VS Code Extensions on an External Drive

This document explains the problem this repo solves and exactly how to use the helper scripts in `scripts/` to keep your VS Code (or VS Code Insiders) extensions directory on an external drive or dotfiles repository. The instructions are copy-paste ready and use absolute paths based on this repository layout.

Repository absolute path used in examples:

  /Users/4jp/Development/organization/gamified-coach-interface

Relevant scripts and templates (present in `scripts/`):

- `/Users/4jp/Development/organization/gamified-coach-interface/scripts/manage_vscode_extensions.sh`
- `/Users/4jp/Development/organization/gamified-coach-interface/scripts/install_launchd_manage_vscode.sh`
- `/Users/4jp/Development/organization/gamified-coach-interface/scripts/launchd_manage_vscode.plist.template`
- (optional) `launchd_manage_vscode_watchpath.plist.template` — NOT present in this repo. See the WatchPaths section for a sample you can create.

## Problem statement

When you keep your VS Code extensions on an external drive (or inside a dot-files repo that may not always be mounted), VS Code expects the extensions directory to be at `~/.vscode/extensions` (stable) or `~/.vscode-insiders/extensions` (Insiders). If the source is on a drive that is not always mounted the folder may disappear, move, or be recreated by VS Code — leading to partial installs, corrupted extensions, or lost custom extensions.

This solution provides:

- A safe symlink mechanism that backs up an existing local extensions directory before creating a symlink to your dot-files or external drive.
- A LaunchAgent (user-level launchd plist) that runs at login and periodically to ensure the symlink exists (useful when the drive mounts later).
- Guidance and optional WatchPaths advice so launchd can trigger on mount events.

Design choices

- Symlink-first: The scripts default to creating a symlink from the expected target (e.g. `~/.vscode-insiders/extensions`) to a source directory you control (e.g. `~/dot-files/.vscode-insiders/extensions`). Symlinks are simple, reversible, and work well with extension IDs and paths.
- LaunchAgent: A user LaunchAgent (stored in `~/Library/LaunchAgents`) runs the `create` command at login and at a periodic interval. This makes the symlink resilient when the drive is not immediately available at login.
- WatchPaths (optional): If you want a more responsive approach, a launchd plist can include `WatchPaths` to trigger when a mountpoint or directory appears. This template is optional — see the WatchPaths section below.

Summary of behavior

- `create`: waits (optionally) for the source to become available, backups any existing target directory (non-symlink) to `~/.vscode_extensions_backup_YYYYMMDD_HHMMSS`, rotates old backups (default keep 5), and then creates the symlink.
- `copy`: copies contents from source to target (non-destructive) — useful if you prefer to keep a local copy.
- `revert`: removes the symlink and restores the most recent backup if one exists.

----

Quick reference — absolute path commands

Install the LaunchAgent (default WAIT_SECONDS=300 WAIT_INTERVAL=10):

  /Users/4jp/Development/organization/gamified-coach-interface/scripts/install_launchd_manage_vscode.sh 300 10

Run the manage script directly (create symlink):

  /bin/bash /Users/4jp/Development/organization/gamified-coach-interface/scripts/manage_vscode_extensions.sh create --source /Users/4jp/dot-files/.vscode-insiders/extensions --target /Users/4jp/.vscode-insiders/extensions

Run the manage script with a wait time (useful if source is on external drive and may mount later):

  /bin/bash /Users/4jp/Development/organization/gamified-coach-interface/scripts/manage_vscode_extensions.sh create --source /Volumes/ExternalDrive/dot-files/.vscode-insiders/extensions --target /Users/4jp/.vscode-insiders/extensions --wait 300 --wait-interval 10

Copy mode (safe copy instead of symlink):

  /bin/bash /Users/4jp/Development/organization/gamified-coach-interface/scripts/manage_vscode_extensions.sh copy --source /Users/4jp/dot-files/.vscode-insiders/extensions --target /Users/4jp/.vscode-insiders/extensions

Check status:

  /bin/bash /Users/4jp/Development/organization/gamified-coach-interface/scripts/manage_vscode_extensions.sh status --target /Users/4jp/.vscode-insiders/extensions

Revert (remove symlink and restore the most recent backup):

  /bin/bash /Users/4jp/Development/organization/gamified-coach-interface/scripts/manage_vscode_extensions.sh revert --target /Users/4jp/.vscode-insiders/extensions

----

Installation and uninstallation (detailed)

Install LaunchAgent (copy the plist template into ~/Library/LaunchAgents and load it):

1. From the repository run the installer script which edits the template and sets WAIT values. Example installs with a 5 minute wait and 10s interval:

     /Users/4jp/Development/organization/gamified-coach-interface/scripts/install_launchd_manage_vscode.sh 300 10

   This will write the plist to:

     /Users/4jp/Library/LaunchAgents/com.user.manage_vscode_extensions.plist

   And load it with launchctl.

2. Verify the LaunchAgent is loaded:

     launchctl print gui/$(id -u) | grep com.user.manage_vscode_extensions || launchctl list | grep com.user.manage_vscode_extensions

3. Check logs (see Troubleshooting below) in:

     ~/Library/Logs/manage_vscode_extensions.out.log
     ~/Library/Logs/manage_vscode_extensions.err.log

Uninstall / remove the LaunchAgent:

  # unload it
  launchctl unload ~/Library/LaunchAgents/com.user.manage_vscode_extensions.plist || true

  # remove the plist file
  rm -f ~/Library/LaunchAgents/com.user.manage_vscode_extensions.plist

  # (optional) remove logs
  rm -f ~/Library/Logs/manage_vscode_extensions.*.log

----

How WAIT_SECONDS, WAIT_INTERVAL and StartInterval work

- WAIT_SECONDS and WAIT_INTERVAL are used by `manage_vscode_extensions.sh create --wait N --wait-interval M` to poll for the source directory to appear. They are passed into the LaunchAgent installer and substituted into the generated plist. Example:

    /Users/4jp/Development/organization/gamified-coach-interface/scripts/install_launchd_manage_vscode.sh 600 5

  This installs the LaunchAgent with `--wait 600 --wait-interval 5` arguments embedded in the ProgramArguments in the plist.

- StartInterval is the periodic run interval (in seconds) encoded in the plist `<key>StartInterval</key>` element. The template currently sets it to 3600 (1 hour). To change it:

  - Preferred: edit the plist after installation and reload the LaunchAgent. Example to change to 10 minutes (600s):

      /usr/bin/sed -i '' 's#<integer>3600</integer>#<integer>600</integer>#' ~/Library/LaunchAgents/com.user.manage_vscode_extensions.plist
      launchctl unload ~/Library/LaunchAgents/com.user.manage_vscode_extensions.plist
      launchctl load ~/Library/LaunchAgents/com.user.manage_vscode_extensions.plist

  - Alternative: edit `scripts/launchd_manage_vscode.plist.template` before running the installer and change the `<integer>3600</integer>` value.

Note: the installer does not currently accept StartInterval as an argument, only WAIT_SECONDS and WAIT_INTERVAL.

----

Backup rotation and restoration

- When `create` runs and a non-symlink target directory exists, it is moved to a timestamped backup under your home directory, e.g.:

    /Users/4jp/.vscode_extensions_backup_20251123_153045

- Rotation: the script keeps `MAX_BACKUPS=5` (defined inside `manage_vscode_extensions.sh`) and will remove older backups when creating a new one. To change the number of backups, edit the script and change the `MAX_BACKUPS` value.

- Reverting: run `revert` to remove the symlink and attempt to restore the most recent backup automatically:

    /bin/bash /Users/4jp/Development/organization/gamified-coach-interface/scripts/manage_vscode_extensions.sh revert --target /Users/4jp/.vscode-insiders/extensions

----

Safety notes

- The scripts are conservative by default:
  - `create` moves an existing non-symlink target to a backup instead of deleting it.
  - `copy` will not `--delete` (overwrite) unless you explicitly choose `--replace` in `ensure_vscode_extensions.sh` or use rsync with `--delete`.
- Always inspect backups before removing them. Backups are timestamped and removed only when rotation logic decides there are too many.
- Avoid running multiple instances of the LaunchAgent simultaneously—unload before reloading to avoid race conditions.

----

WatchPaths (optional, more responsive than StartInterval)

The repository does not include `launchd_manage_vscode_watchpath.plist.template`. If you want launchd to react as soon as a mountpoint appears (for example `/Volumes/ExternalDrive`), create a plist that contains a `WatchPaths` array with that mountpoint or parent path. Example minimal plist snippet you can save as `~/Library/LaunchAgents/com.user.manage_vscode_extensions.watchpath.plist`:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>Label</key>
    <string>com.user.manage_vscode_extensions.watchpath</string>
    <key>ProgramArguments</key>
    <array>
      <string>/bin/bash</string>
      <string>/Users/4jp/Development/organization/gamified-coach-interface/scripts/manage_vscode_extensions.sh</string>
      <string>create</string>
      <string>--source</string>
      <string>/Volumes/ExternalDrive/dot-files/.vscode-insiders/extensions</string>
      <string>--target</string>
      <string>/Users/4jp/.vscode-insiders/extensions</string>
      <string>--wait</string>
      <string>300</string>
      <string>--wait-interval</string>
      <string>5</string>
    </array>
    <key>WatchPaths</key>
    <array>
      <string>/Volumes/ExternalDrive</string>
      <string>/Volumes</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>StandardOutPath</key>
    <string>/Users/4jp/Library/Logs/manage_vscode_extensions.watchpath.out.log</string>
    <key>StandardErrorPath</key>
    <string>/Users/4jp/Library/Logs/manage_vscode_extensions.watchpath.err.log</string>
  </dict>
</plist>
```

Install and load the WatchPath LaunchAgent with:

  launchctl load ~/Library/LaunchAgents/com.user.manage_vscode_extensions.watchpath.plist

----

Troubleshooting

Check that the source directory exists and is accessible:

  ls -la /Volumes/ExternalDrive/dot-files/.vscode-insiders/extensions
  stat /Volumes/ExternalDrive/dot-files/.vscode-insiders/extensions

If `manage_vscode_extensions.sh` reports the source directory missing, the drive may not be mounted. Useful checks:

  # list mounted volumes
  mount

  # list /Volumes contents
  ls -la /Volumes

  # get disk identifiers
  diskutil list

  # get info about a volume (replace diskXsY with actual id)
  diskutil info /Volumes/ExternalDrive

Check launchd and script logs:

  # standard out / err from the installed plist
  tail -n 200 ~/Library/Logs/manage_vscode_extensions.out.log
  tail -n 200 ~/Library/Logs/manage_vscode_extensions.err.log

  # if using the watchpath variant
  tail -n 200 ~/Library/Logs/manage_vscode_extensions.watchpath.out.log
  tail -n 200 ~/Library/Logs/manage_vscode_extensions.watchpath.err.log

Check the installed plist for embedded arguments and paths:

  cat ~/Library/LaunchAgents/com.user.manage_vscode_extensions.plist

If the plist contains placeholders like `WAIT_SECONDS` or an incorrect path for `REPO_ABSOLUTE_PATH`, re-run the installer from the repo root (the installer substitutes absolute repo path and wait values):

  cd /Users/4jp/Development/organization/gamified-coach-interface
  /Users/4jp/Development/organization/gamified-coach-interface/scripts/install_launchd_manage_vscode.sh 300 10

If the Drive mounts after login but launchd didn't run the job, try unloading and reloading the agent:

  launchctl unload ~/Library/LaunchAgents/com.user.manage_vscode_extensions.plist || true
  launchctl load ~/Library/LaunchAgents/com.user.manage_vscode_extensions.plist

If the symlink was created but VS Code still shows missing or corrupted extensions, use the debug helper to scan for broken extensions:

  /bin/bash /Users/4jp/Development/organization/gamified-coach-interface/scripts/debug_vscode_extensions.sh

And optionally write a JSON report:

  /bin/bash /Users/4jp/Development/organization/gamified-coach-interface/scripts/debug_vscode_extensions.sh --stable --report

Common fixes

- If the external volume auto-mounts at a different path, update the `--source` used by the plist or use a stable symlink from a predictable mountpoint.
- Ensure the repository path (`REPO_ABSOLUTE_PATH`) is correct in `~/Library/LaunchAgents/com.user.manage_vscode_extensions.plist`. If not, re-run the installer from the repo root.
- If the backup rotation removed a needed backup, check your trash/other backups. Consider increasing `MAX_BACKUPS` in `manage_vscode_extensions.sh` before running `create`.

----

Example workflows

1) Dotfiles approach (you keep extensions in `~/dot-files` and want a symlink):

  /bin/bash /Users/4jp/Development/organization/gamified-coach-interface/scripts/manage_vscode_extensions.sh create --source /Users/4jp/dot-files/.vscode-insiders/extensions --target /Users/4jp/.vscode-insiders/extensions

  # Install LaunchAgent so it runs at login and periodically
  /Users/4jp/Development/organization/gamified-coach-interface/scripts/install_launchd_manage_vscode.sh 300 10

2) External drive that mounts occasionally (use --wait so create waits for the drive):

  /bin/bash /Users/4jp/Development/organization/gamified-coach-interface/scripts/manage_vscode_extensions.sh create --source /Volumes/ExternalDrive/dot-files/.vscode-insiders/extensions --target /Users/4jp/.vscode-insiders/extensions --wait 600 --wait-interval 5

  # Or install the LaunchAgent so it runs automatically at login with the same wait values
  cd /Users/4jp/Development/organization/gamified-coach-interface
  /Users/4jp/Development/organization/gamified-coach-interface/scripts/install_launchd_manage_vscode.sh 600 5

----

Where to modify behavior

- Change backup rotation: edit `MAX_BACKUPS` in `/Users/4jp/Development/organization/gamified-coach-interface/scripts/manage_vscode_extensions.sh`.
- Change StartInterval: edit `StartInterval` in `/Users/4jp/Development/organization/gamified-coach-interface/scripts/launchd_manage_vscode.plist.template` before installing, or edit `~/Library/LaunchAgents/com.user.manage_vscode_extensions.plist` after install and reload the agent.
- Change default SOURCE/TARGET: edit `SOURCE_DEFAULT` and `TARGET_DEFAULT` at the top of `manage_vscode_extensions.sh` or pass `--source` / `--target` on the CLI.

----

Notes

- The scripts shipped with this repository aim to be conservative and safe. Read them before running if you need to adapt behavior for your environment.
- If you want me to create a `launchd_manage_vscode_watchpath.plist.template` in `scripts/` in this repo (pre-filled with your repo absolute path and an example WatchPaths array), tell me what mountpoint(s) you want to watch (for example `/Volumes/ExternalDrive`) and I will add it.

----

Files referenced in this README (for convenience):

- /Users/4jp/Development/organization/gamified-coach-interface/scripts/manage_vscode_extensions.sh — main manager script
- /Users/4jp/Development/organization/gamified-coach-interface/scripts/install_launchd_manage_vscode.sh — installer that writes plist to ~/Library/LaunchAgents
- /Users/4jp/Development/organization/gamified-coach-interface/scripts/launchd_manage_vscode.plist.template — template used by the installer

----

End of document.

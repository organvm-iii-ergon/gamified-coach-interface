Tasks and status for VS Code extensions management automation

- [x] Create `manage_vscode_extensions.sh` (create/copy/revert/status, backups)
- [x] Add `debug_vscode_extensions.sh` (scan and inspect, reporting)
- [x] Add `install_launchd_manage_vscode.sh` (installer for recurring LaunchAgent)
- [x] Add `launchd_manage_vscode.plist.template` (recurring agent template)
- [x] Add `install_launchd_watch_vscode.sh` (installer for WatchPaths agent)
- [x] Add `launchd_watch_vscode.plist.template` (WatchPaths template)
- [x] Add `validate_extension_packages.sh` (package.json validator)
- [x] Add `README-manage-vscode-extensions.md` (usage docs)
- [x] Install recurring LaunchAgent and verify (completed)
- [ ] Install WatchPaths LaunchAgent (optional, awaiting confirmation/default install)
- [x] Add backup rotation (keep last 5)
- [x] Add --wait support to `manage_vscode_extensions.sh`
- [x] Add report generation to `debug_vscode_extensions.sh` and `validate_extension_packages.sh`

Next actions:
- Install WatchPaths LaunchAgent now to trigger on `$HOME/dot-files` (will do by default)
- Run validation and produce reports
- Optionally adjust StartInterval or WatchPaths per user preference

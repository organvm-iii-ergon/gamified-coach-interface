Extension management helper

This workspace includes helper scripts to diagnose and make VS Code / VS Code Insiders extensions available at the expected path(s).

Files:
- `scripts/debug_vscode_extensions.sh` - scan and inspect extensions in Insiders or stable extension directories.
- `scripts/ensure_vscode_extensions.sh` - ensure extensions exist at `~/.vscode-insiders/extensions` or `~/.vscode/extensions` by creating a symlink to a dot-files managed directory or copying files.

Recommended usage:
1. If your extensions live inside a dotfiles repo (e.g. `~/dot-files/.vscode-insiders/extensions`), create a symlink so VS Code always finds them:

```bash
# create symlink (dry-run first to see action)
./scripts/ensure_vscode_extensions.sh --from ~/dot-files/.vscode-insiders/extensions --mode symlink --dry
# then actually create
./scripts/ensure_vscode_extensions.sh --from ~/dot-files/.vscode-insiders/extensions --mode symlink
```

2. If you prefer to copy/sync a managed location to the standard place, use copy mode:

```bash
./scripts/ensure_vscode_extensions.sh --from ~/dot-files/.vscode-insiders/extensions --mode copy --dry
./scripts/ensure_vscode_extensions.sh --from ~/dot-files/.vscode-insiders/extensions --mode copy --replace
```

Notes:
- Symlink mode is preferred for dotfiles-managed extension sets because it ensures a single authoritative source and is easy to revert.
- Copy mode is useful when you want VS Code to own the extension folder but keep a backup in your dotfiles.
- The scripts are conservative and require explicit flags to replace existing data.

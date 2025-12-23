# Prototypes Directory

⚠️ **DEPRECATED**: This directory contains legacy HTML prototype experiments. These files are kept for historical reference but are no longer actively maintained.

## Contents

### Legacy Interface Files

#### `client.html`
- **Status**: Deprecated, superseded by current `client.html` in root
- **Purpose**: V2 client-facing interface prototype
- **Note**: Use the root-level `client.html` for current version

#### `index.html`
- **Status**: Deprecated, superseded by current `index.html` in root
- **Purpose**: V2 command center interface prototype
- **Note**: Use the root-level `index.html` for current version

#### `legion-command-center-evolved.html`
- **Status**: Deprecated, superseded by `legion-v3.html` in root
- **Purpose**: Early V3 holographic interface experiment
- **Note**: Use `legion-v3.html` in root for the latest V3 interface

#### `legion-command-center-evolved 2.html`
- **Status**: Deprecated duplicate
- **Purpose**: Duplicate of legion-command-center-evolved.html
- **Note**: This is a duplicate file and can be safely ignored

#### `Rok_Gym.html`
- **Status**: Experimental prototype
- **Purpose**: Early fitness interface concept
- **Note**: Experimental UI concepts, not used in production

## Current Active Files

All active development uses the files in the repository root:

- **V3 Primary Interface**: `/legion-v3.html` (with `/src/` components)
- **V2 Command Center**: `/index.html`
- **V2 Client View**: `/client.html`

## Migration Notes

The prototypes in this directory were created during early development phases and have since been:
1. Refined and moved to root-level files
2. Integrated with the proper build system (Vite)
3. Enhanced with modular JavaScript architecture
4. Connected to backend API

## Should I Use These Files?

**No.** These files are kept for reference only. For development:

1. Use `/legion-v3.html` for the V3 holographic interface
2. Use `/index.html` for the V2 command center
3. Use `/client.html` for the V2 client interface
4. Check [ARCHITECTURE.md](../ARCHITECTURE.md) for the current project structure

## Future Plans

This directory may be removed in a future cleanup once:
- Feature parity is confirmed in current interfaces
- All useful concepts have been migrated
- Historical reference is no longer needed

## Questions?

See the main project documentation:
- [README.md](../README.md) - Project overview
- [ARCHITECTURE.md](../ARCHITECTURE.md) - Architecture guide
- [docs/REPO_STRUCTURE.md](../docs/REPO_STRUCTURE.md) - Repository organization

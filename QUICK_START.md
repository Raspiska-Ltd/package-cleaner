# Quick Start Guide

## What is Package Cleaner?

Package Cleaner is a native macOS application that helps developers reclaim disk space by finding and removing package dependency directories (like `node_modules`, `vendor`, etc.) from old projects.

## Installation

### Option 1: Build from Source

1. Clone the repository:
   ```bash
   git clone https://github.com/YOUR_USERNAME/package-cleaner.git
   cd package-cleaner
   ```

2. Open in Xcode and build:
   - See [BUILD_INSTRUCTIONS.md](BUILD_INSTRUCTIONS.md) for detailed steps

### Option 2: Download Release

Download the latest release from the GitHub releases page (coming soon).

## First Run

1. Launch Package Cleaner
2. Grant Full Disk Access when prompted:
   - System Settings > Privacy & Security > Full Disk Access
   - Add Package Cleaner to the list

## Basic Usage

### Scanning for Package Directories

1. Click the **Scan** button in the toolbar
2. Wait for the scan to complete
3. Review the list of found package directories

### Deleting Directories

**Manual Selection:**
1. Select directories from the list (Cmd+Click for multiple)
2. Click **Delete Selected**
3. Confirm the deletion

**Auto-Cleanup (6+ months old):**
1. Click **Auto-Cleanup** button
2. Review the list of old directories
3. Confirm to delete all

## Features

### Sidebar Filters

- **Language**: Filter by programming language
- **Package Type**: Filter by directory type
- **Quick Actions**: Select all, deselect, or select old projects

### Sorting

Click the **Sort** menu to sort by:
- Name
- Size (default)
- Last Activity
- Language

### Search

Use the search box to find specific projects by name or path.

### Settings

Access settings (Cmd+,) to configure:
- **Auto-cleanup threshold**: Days before considering a project old (default: 180)
- **Move to Trash**: Use Trash instead of permanent deletion (recommended)
- **Scan directories**: Choose which directories to scan
- **Package types**: Enable/disable specific package types

## Supported Package Types

| Directory | Languages |
|-----------|-----------|
| `node_modules` | JavaScript, TypeScript |
| `vendor` | PHP, Go, Ruby |
| `.gradle`, `build` | Java, Kotlin, Android |
| `target` | Rust, Java/Maven |
| `Pods` | Swift/iOS |
| `venv`, `.venv`, `__pycache__` | Python |
| `packages` | .NET |
| `.pub-cache` | Dart, Flutter |

## Tips

1. **Start with Trash mode**: Keep "Move to Trash" enabled so you can recover if needed
2. **Review before deleting**: Check the last activity date to avoid deleting active projects
3. **Use filters**: Filter by language to focus on specific project types
4. **Regular cleanup**: Run monthly to keep disk space under control
5. **Backup important projects**: Always have backups of important work

## Keyboard Shortcuts

- `Cmd+R`: Start scan
- `Cmd+Delete`: Delete selected directories
- `Cmd+,`: Open settings
- `Cmd+A`: Select all (in list)

## Safety Features

Package Cleaner includes multiple safety checks:
- Only deletes recognized package directory types
- Validates paths before deletion
- Prevents deletion of system directories
- Moves to Trash by default (recoverable)
- Requires confirmation before deletion

## Troubleshooting

### Scan finds nothing

- Grant Full Disk Access permission
- Check that scan directories are configured in Settings
- Verify package types are enabled in Settings

### Cannot delete directories

- Check file permissions
- Ensure directories are not in use
- Try closing IDEs and terminal windows

### App won't launch

- Check macOS version (requires 12.0+)
- Verify app is not quarantined: `xattr -d com.apple.quarantine PackageCleaner.app`

## Getting Help

- Check the [documentation](docs/)
- Report issues on GitHub
- Read the [Contributing Guide](docs/CONTRIBUTING.md)

## Privacy

Package Cleaner:
- Works entirely offline
- Collects no telemetry
- Sends no data anywhere
- Is fully open source

## Next Steps

- Explore the Settings to customize behavior
- Set up regular cleanup schedule
- Star the project on GitHub if you find it useful

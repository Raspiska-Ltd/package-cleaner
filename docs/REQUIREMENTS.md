# Package Cleaner - Requirements Document

## Overview

Package Cleaner is a native macOS application designed to help developers reclaim disk space by identifying and removing package dependency directories (such as `node_modules`, `vendor`, etc.) from development projects. The application works entirely offline without requiring internet connectivity.

---

## Problem Statement

Developers accumulate significant disk space usage from package dependency directories across multiple projects. These directories can be safely deleted and regenerated when needed, but manually tracking and cleaning them is time-consuming.

---

## Functional Requirements

### FR-1: Directory Scanning

| ID | Requirement | Priority |
|----|-------------|----------|
| FR-1.1 | Scan user-specified directories or entire filesystem for package directories | High |
| FR-1.2 | Support detection of the following package directory types: | High |
| | - `node_modules` (Node.js/JavaScript) | |
| | - `vendor` (PHP Composer, Go, Ruby Bundler) | |
| | - `.gradle` and `build` (Gradle/Android) | |
| | - `target` (Rust Cargo, Java Maven) | |
| | - `Pods` (iOS CocoaPods) | |
| | - `venv`, `.venv`, `__pycache__` (Python) | |
| | - `packages` (.NET/NuGet) | |
| | - `.pub-cache` (Dart/Flutter) | |
| FR-1.3 | Calculate and display the size of each detected directory | High |
| FR-1.4 | Identify the development language/framework based on manifest files | Medium |
| FR-1.5 | Allow users to exclude specific directories from scanning | Medium |
| FR-1.6 | Support incremental/background scanning | Low |

### FR-2: Project Information Display

| ID | Requirement | Priority |
|----|-------------|----------|
| FR-2.1 | Display project name extracted from manifest files: | High |
| | - `package.json` (Node.js) | |
| | - `composer.json` (PHP) | |
| | - `build.gradle` / `settings.gradle` (Gradle) | |
| | - `Cargo.toml` (Rust) | |
| | - `pom.xml` (Maven) | |
| | - `Podfile` (CocoaPods) | |
| | - `requirements.txt` / `pyproject.toml` (Python) | |
| | - `pubspec.yaml` (Dart/Flutter) | |
| FR-2.2 | Fall back to parent directory name if manifest is unavailable | High |
| FR-2.3 | Display the full path to the project directory | High |
| FR-2.4 | Show the detected language/framework with appropriate icon | Medium |

### FR-3: Last Activity Detection

| ID | Requirement | Priority |
|----|-------------|----------|
| FR-3.1 | Determine last activity time for each project using multiple methods: | High |
| | - Git: Last commit date (`git log -1 --format=%ci`) | |
| | - SVN: Last revision date | |
| | - File system: Most recent modification time in project directory | |
| FR-3.2 | Prioritize VCS-based timestamps over filesystem timestamps | High |
| FR-3.3 | Display last activity in human-readable format (e.g., "3 months ago") | Medium |
| FR-3.4 | Allow sorting by last activity date | Medium |

### FR-4: Manual Cleanup

| ID | Requirement | Priority |
|----|-------------|----------|
| FR-4.1 | Allow selection of individual directories for deletion | High |
| FR-4.2 | Allow bulk selection of multiple directories | High |
| FR-4.3 | Display total size of selected directories before deletion | High |
| FR-4.4 | Require confirmation before deletion | High |
| FR-4.5 | Move to Trash instead of permanent deletion (configurable) | High |
| FR-4.6 | Show progress indicator during deletion | Medium |
| FR-4.7 | Provide undo capability (when using Trash) | Low |

### FR-5: Auto Cleanup

| ID | Requirement | Priority |
|----|-------------|----------|
| FR-5.1 | Automatically identify directories older than configurable threshold (default: 6 months) | High |
| FR-5.2 | Preview auto-cleanup candidates before execution | High |
| FR-5.3 | Execute auto-cleanup with single confirmation | High |
| FR-5.4 | Allow exclusion of specific projects from auto-cleanup | Medium |
| FR-5.5 | Support scheduled auto-cleanup (optional background service) | Low |

---

## Non-Functional Requirements

### NFR-1: Offline Operation

| ID | Requirement | Priority |
|----|-------------|----------|
| NFR-1.1 | Application must function entirely without internet connectivity | High |
| NFR-1.2 | No telemetry or analytics data collection | High |
| NFR-1.3 | No external API calls | High |

### NFR-2: Performance

| ID | Requirement | Priority |
|----|-------------|----------|
| NFR-2.1 | Scanning should utilize efficient filesystem traversal | High |
| NFR-2.2 | UI must remain responsive during scanning operations | High |
| NFR-2.3 | Support cancellation of long-running operations | High |
| NFR-2.4 | Cache scan results for faster subsequent access | Medium |

### NFR-3: Security

| ID | Requirement | Priority |
|----|-------------|----------|
| NFR-3.1 | Request only necessary filesystem permissions | High |
| NFR-3.2 | Respect macOS sandbox and security guidelines | High |
| NFR-3.3 | Never delete files outside of recognized package directories | High |
| NFR-3.4 | Implement safeguards against accidental deletion of important files | High |

### NFR-4: Usability

| ID | Requirement | Priority |
|----|-------------|----------|
| NFR-4.1 | Native macOS look and feel | High |
| NFR-4.2 | Support macOS Dark Mode | Medium |
| NFR-4.3 | Keyboard shortcuts for common actions | Medium |
| NFR-4.4 | Accessibility support (VoiceOver compatible) | Medium |

### NFR-5: Compatibility

| ID | Requirement | Priority |
|----|-------------|----------|
| NFR-5.1 | Support macOS 12 (Monterey) and later | High |
| NFR-5.2 | Support both Intel and Apple Silicon architectures | High |

---

## User Interface Requirements

### UI-1: Main Window

- **Toolbar**: Scan button, Auto-cleanup button, Settings button
- **Sidebar**: Quick filters (by language, by age, by size)
- **Main Content**: Table/list view of detected package directories
- **Status Bar**: Total space used, number of directories found

### UI-2: Directory List Columns

| Column | Description |
|--------|-------------|
| Project Name | Name from manifest or directory name |
| Path | Full path to project directory |
| Package Type | Type of package directory (node_modules, vendor, etc.) |
| Language | Detected development language/framework |
| Size | Size of the package directory |
| Last Activity | Last modification/commit date |
| Age | Time since last activity |

### UI-3: Settings Panel

- Default scan directories
- Auto-cleanup threshold (days/months)
- Excluded directories list
- Delete behavior (Trash vs permanent)
- Package types to scan for

---

## Data Requirements

### Manifest File Parsing

The application must parse the following manifest files to extract project information:

| File | Language/Framework | Fields to Extract |
|------|-------------------|-------------------|
| `package.json` | Node.js | name, version, description |
| `composer.json` | PHP | name, description |
| `build.gradle` | Gradle/Android | project name |
| `Cargo.toml` | Rust | name, version |
| `pom.xml` | Maven/Java | artifactId, name |
| `Podfile` | CocoaPods/iOS | project name |
| `pyproject.toml` | Python | name, version |
| `pubspec.yaml` | Dart/Flutter | name, version |

---

## Constraints

1. **No Internet Required**: All functionality must work offline
2. **macOS Only**: Initial release targets macOS exclusively
3. **Open Source**: Code must be maintainable and well-documented
4. **Privacy First**: No data leaves the user's machine

---

## Glossary

| Term | Definition |
|------|------------|
| Package Directory | A directory containing downloaded dependencies (e.g., node_modules) |
| Manifest File | A configuration file describing project metadata (e.g., package.json) |
| VCS | Version Control System (Git, SVN, etc.) |
| Auto-cleanup | Automatic deletion of package directories based on age threshold |

---

## Document History

| Version | Date | Author | Description |
|---------|------|--------|-------------|
| 1.0 | 2026-03-17 | - | Initial requirements document |

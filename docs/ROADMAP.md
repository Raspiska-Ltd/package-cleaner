# Package Cleaner - Development Roadmap

## Overview

This document outlines the development phases, milestones, and timeline for Package Cleaner.

---

## Phase 1: Foundation (MVP)

**Goal**: Deliver a functional application that can scan, display, and delete package directories.

### Milestone 1.1: Project Setup

| Task | Description | Status |
|------|-------------|--------|
| Initialize Xcode project | Create Swift/SwiftUI project with proper structure | Pending |
| Configure build settings | Set deployment target, signing, entitlements | Pending |
| Set up Git repository | Initialize repo, add .gitignore, LICENSE | Pending |
| Create README | Basic project description and build instructions | Pending |

### Milestone 1.2: Core Scanning

| Task | Description | Status |
|------|-------------|--------|
| Implement ScannerService | Filesystem traversal for package directories | Pending |
| Package type detection | Identify node_modules, vendor, etc. | Pending |
| Size calculation | Calculate directory sizes efficiently | Pending |
| Progress reporting | Report scan progress to UI | Pending |

### Milestone 1.3: Project Detection

| Task | Description | Status |
|------|-------------|--------|
| JSON manifest parser | Parse package.json, composer.json | Pending |
| TOML manifest parser | Parse Cargo.toml, pyproject.toml | Pending |
| YAML manifest parser | Parse pubspec.yaml | Pending |
| XML manifest parser | Parse pom.xml | Pending |
| Gradle parser | Extract project name from build.gradle | Pending |

### Milestone 1.4: Activity Detection

| Task | Description | Status |
|------|-------------|--------|
| Git integration | Detect .git and get last commit date | Pending |
| SVN integration | Detect .svn and get last revision date | Pending |
| Filesystem fallback | Use modification time as fallback | Pending |

### Milestone 1.5: Basic UI

| Task | Description | Status |
|------|-------------|--------|
| Main window layout | Toolbar, sidebar, content area | Pending |
| Directory list view | Table showing all detected directories | Pending |
| Directory row component | Display project info, size, date | Pending |
| Scan button and progress | Trigger scan with progress indicator | Pending |

### Milestone 1.6: Cleanup Operations

| Task | Description | Status |
|------|-------------|--------|
| Single directory deletion | Delete selected directory | Pending |
| Bulk deletion | Delete multiple selected directories | Pending |
| Move to Trash | Use Trash instead of permanent delete | Pending |
| Confirmation dialog | Require confirmation before deletion | Pending |

**Deliverable**: Working application that can scan home directory, display results, and delete selected package directories.

---

## Phase 2: Enhanced Features

**Goal**: Add auto-cleanup, filtering, and improved user experience.

### Milestone 2.1: Auto-Cleanup

| Task | Description | Status |
|------|-------------|--------|
| Age threshold configuration | Setting for cleanup threshold (default 6 months) | Pending |
| Auto-cleanup preview | Show directories that qualify for auto-cleanup | Pending |
| Batch auto-cleanup | Delete all qualifying directories with confirmation | Pending |
| Exclusion list | Allow excluding specific projects from auto-cleanup | Pending |

### Milestone 2.2: Filtering and Sorting

| Task | Description | Status |
|------|-------------|--------|
| Filter by language | Show only specific language projects | Pending |
| Filter by package type | Show only specific package types | Pending |
| Filter by age | Show directories older than X days | Pending |
| Sort options | Sort by name, size, date, language | Pending |
| Search functionality | Search by project name or path | Pending |

### Milestone 2.3: Settings

| Task | Description | Status |
|------|-------------|--------|
| Settings window | Dedicated settings panel | Pending |
| Scan directory configuration | Choose which directories to scan | Pending |
| Package type toggles | Enable/disable specific package types | Pending |
| Persistence | Save and restore user preferences | Pending |

### Milestone 2.4: UI Polish

| Task | Description | Status |
|------|-------------|--------|
| Dark mode support | Proper dark mode appearance | Pending |
| Language icons | Visual icons for each language/framework | Pending |
| Size formatting | Human-readable size display (KB, MB, GB) | Pending |
| Relative dates | "3 months ago" style date display | Pending |
| Status bar | Total space, directory count | Pending |

**Deliverable**: Feature-complete application with auto-cleanup and polished interface.

---

## Phase 3: Production Ready

**Goal**: Prepare for public release with documentation, testing, and distribution.

### Milestone 3.1: Testing

| Task | Description | Status |
|------|-------------|--------|
| Unit tests | Test core logic and services | Pending |
| Integration tests | Test service interactions | Pending |
| UI tests | Test user interactions | Pending |
| Performance testing | Verify scan performance targets | Pending |

### Milestone 3.2: Documentation

| Task | Description | Status |
|------|-------------|--------|
| User guide | How to use the application | Pending |
| Contributing guide | How to contribute to the project | Pending |
| API documentation | Code documentation for developers | Pending |
| Changelog | Version history and changes | Pending |

### Milestone 3.3: Distribution

| Task | Description | Status |
|------|-------------|--------|
| App icon | Design and implement app icon | Pending |
| Code signing | Sign application for distribution | Pending |
| Notarization | Notarize for Gatekeeper | Pending |
| DMG creation | Create distributable disk image | Pending |
| GitHub releases | Set up release workflow | Pending |
| Homebrew formula | Create Homebrew cask (optional) | Pending |

### Milestone 3.4: Accessibility

| Task | Description | Status |
|------|-------------|--------|
| VoiceOver support | Ensure VoiceOver compatibility | Pending |
| Keyboard navigation | Full keyboard accessibility | Pending |
| Dynamic type | Support system font size settings | Pending |

**Deliverable**: Production-ready application available for download.

---

## Phase 4: Future Enhancements (Post-Release)

| Feature | Description | Priority |
|---------|-------------|----------|
| Menu bar mode | Lightweight menu bar presence | Medium |
| Scheduled cleanup | Background cleanup agent | Low |
| Statistics | Track space saved over time | Low |
| Localization | Support multiple languages | Low |
| Custom patterns | User-defined package directory patterns | Low |
| Workspace support | Detect monorepo/workspace structures | Low |

---

## Timeline Estimate

| Phase | Duration | Target |
|-------|----------|--------|
| Phase 1: Foundation | 2-3 weeks | MVP Release |
| Phase 2: Enhanced Features | 2 weeks | Beta Release |
| Phase 3: Production Ready | 1-2 weeks | v1.0 Release |
| Phase 4: Future | Ongoing | Post v1.0 |

**Total estimated time to v1.0**: 5-7 weeks

---

## Success Criteria

### MVP (Phase 1)
- Can scan user's home directory for package directories
- Displays results with project name, size, and last activity
- Can delete selected directories
- Works entirely offline

### Beta (Phase 2)
- Auto-cleanup functionality working
- Filtering and sorting implemented
- Settings persistence working
- No critical bugs

### v1.0 (Phase 3)
- All tests passing
- Documentation complete
- Application signed and notarized
- Available for download

---

## Risk Assessment

| Risk | Impact | Mitigation |
|------|--------|------------|
| Full Disk Access permission issues | High | Clear user guidance, graceful degradation |
| Performance on large filesystems | Medium | Efficient algorithms, progress feedback, cancellation |
| Accidental deletion of important files | High | Multiple safety checks, Trash by default, confirmation |
| macOS version compatibility | Medium | Test on multiple versions, document requirements |

---

## Document History

| Version | Date | Author | Description |
|---------|------|--------|-------------|
| 1.0 | 2026-03-17 | - | Initial roadmap |

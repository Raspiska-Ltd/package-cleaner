# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-03-17

### Added
- 🎨 Modern macOS UI with two-row toolbar system
- 🔍 Multi-directory scanning for package folders (node_modules, vendor, etc.)
- 📊 Real-time statistics: project count, total size, and age tracking
- 🎯 Smart filtering by language (JavaScript, PHP, Python, etc.) and package type
- 🔄 Sort by name, size, date, or language with ascending/descending toggle
- 💾 Persistent cache - scan results saved between sessions
- 🗑️ Safe deletion with Trash support (recoverable)
- ⚡ Quick actions: Select All, Deselect All, Select Old Projects
- ⌨️ Keyboard shortcuts for power users (⌘R scan, ⌘⌫ delete, ⌘F search)
- 🌓 Full dark mode support
- 📱 Native macOS experience with SwiftUI
- 🔒 Privacy-first: offline operation, no telemetry
- ⚙️ Customizable settings: auto-cleanup threshold, scan directories
- ℹ️ About section with company info and open source links

### Features
- **11 Package Types**: node_modules, vendor, target, build, dist, .venv, Pods, Carthage, DerivedData, .next, .nuxt
- **10 Languages**: JavaScript/TypeScript, PHP, Java/Kotlin, Rust, Swift, Python, Dart, Ruby, Go, .NET
- **VCS Integration**: Git and SVN last activity detection
- **Manifest Parsing**: Reads package.json, composer.json, Cargo.toml, and more
- **Color-Coded UI**: Language-specific colors and age-based indicators
- **Accordion Filters**: Collapsible sidebar sections
- **Live Scan Progress**: Shows current directory and found count
- **Modern Components**: Cards, buttons, progress views with consistent design

### Technical
- Built with Swift 5.9+ and SwiftUI
- MVVM architecture
- Swift concurrency with async/await
- JSON-based persistence
- External dependencies: SwiftUIX, Defaults, KeyboardShortcuts
- macOS 12.0+ compatible

### UI/UX
- Two-row toolbar: Scan controls + Results filters
- Contextual UI: Controls appear only when relevant
- Inline scan progress with directory name
- Filter dropdowns with active state highlighting
- Icon-based quick actions with tooltips
- Responsive layout adapting to content

## [1.0.1] - 2026-03-23

### Added
- 🎨 App icon with proper macOS integration (displays in Finder, Dock, app switcher)
- 🔄 Reset to Defaults button in Settings with confirmation dialogs
- 🧹 Clear Results button to remove scan data
- 📝 Icon conversion script for iOS to macOS format
- 🖱️ Clickable empty state icon that opens Settings to Scan tab
- 📸 Screenshots in README for better project showcase
- 🏷️ Standard open source badges (Build Status, Release, License, macOS, Swift)

### Fixed
- 🔒 Permission management - no longer requests access on app launch
- 🔒 Permissions only requested for user-selected directories
- 🔐 Security-scoped bookmarks for persistent directory access
- 🔐 Single non-home directory now scans correctly with bookmark persistence
- ⚙️ Settings UI now updates immediately when adding/removing directories
- ⚙️ SettingsStore singleton ensures consistent state across all views
- 🎯 Scan button properly disabled when no directories configured
- 🎯 Scan button state correctly reflects directory configuration
- 📊 Empty state messages now context-aware (before/after configuration)
- 🎨 Empty state icon always visible (folder.fill or folder.fill.badge.plus)
- 🎨 Empty state icon clickable in all states to open Settings
- 🔧 Build script properly embeds app icon using iconutil
- 🔄 Reset to Defaults properly displays home directory in UI
- 🪟 ViewModels now shared between main window and Settings window
- 📑 Settings opens to Scan tab when clicked from empty state

### Changed
- 🏠 Default scan directory set to home directory on first launch
- 🏠 Home directory doesn't require security-scoped bookmarks
- 💬 Improved user guidance with helpful tooltips and messages
- 🎨 Better visual feedback for Reset to Defaults action
- 📖 README modernized with badges, screenshots, and concise format
- 📖 README shortened by ~40% while being more informative

### Technical
- Singleton pattern for SettingsStore to prevent state inconsistencies
- Manual objectWillChange triggers for reliable UI updates
- ForEach using indices for proper list tracking
- Alert placement in main view hierarchy for proper display
- Security-scoped bookmark creation and restoration for user-selected directories
- Bookmark fallback to paths for home directory and legacy data
- ViewModels created at app level and passed to views for state consistency
- Tab selection control in SettingsViewModel for programmatic navigation

## [Unreleased]

### Added
- Initial project setup
- Documentation structure

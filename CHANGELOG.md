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

### Fixed
- 🔒 Permission management - no longer requests access on app launch
- 🔒 Permissions only requested for user-selected directories
- ⚙️ Settings UI now updates immediately when adding/removing directories
- ⚙️ SettingsStore singleton ensures consistent state across all views
- 🎯 Scan button properly disabled when no directories configured
- 📊 Empty state messages now context-aware (before/after configuration)
- 🔧 Build script properly embeds app icon using iconutil

### Changed
- 🏠 Default scan directory set to home directory on first launch
- 💬 Improved user guidance with helpful tooltips and messages
- 🎨 Better visual feedback for Reset to Defaults action

### Technical
- Singleton pattern for SettingsStore to prevent state inconsistencies
- Manual objectWillChange triggers for reliable UI updates
- ForEach using indices for proper list tracking
- Alert placement in main view hierarchy for proper display

## [Unreleased]

### Added
- Initial project setup
- Documentation structure

# Package Cleaner - Technical Architecture

## Overview

This document describes the technical architecture for Package Cleaner, a native macOS application built using Swift and SwiftUI.

---

## Technology Stack

| Component | Technology | Rationale |
|-----------|------------|-----------|
| Language | Swift 5.9+ | Native macOS development, performance, safety |
| UI Framework | SwiftUI | Modern declarative UI, native macOS integration |
| Minimum Target | macOS 12.0 | Balance between modern APIs and user reach |
| Build System | Xcode / Swift Package Manager | Standard Apple toolchain |
| Architecture | MVVM | Clean separation of concerns, testability |

---

## System Architecture

```
+----------------------------------------------------------+
|                    Package Cleaner App                    |
+----------------------------------------------------------+
|                                                          |
|  +------------------+    +------------------+            |
|  |   Presentation   |    |    View Models   |            |
|  |     (SwiftUI)    |<-->|      (MVVM)      |            |
|  +------------------+    +------------------+            |
|                                |                         |
|                                v                         |
|  +--------------------------------------------------+   |
|  |                   Services Layer                  |   |
|  +--------------------------------------------------+   |
|  |                          |                        |   |
|  |  +------------------+    +------------------+     |   |
|  |  | Scanner Service  |    | Cleanup Service  |     |   |
|  |  +------------------+    +------------------+     |   |
|  |           |                       |               |   |
|  |  +------------------+    +------------------+     |   |
|  |  | Manifest Parser  |    |  VCS Detector    |     |   |
|  |  +------------------+    +------------------+     |   |
|  |                                                   |   |
|  +--------------------------------------------------+   |
|                                |                         |
|                                v                         |
|  +--------------------------------------------------+   |
|  |              Core / Data Layer                    |   |
|  +--------------------------------------------------+   |
|  |  +------------------+    +------------------+     |   |
|  |  | File System API  |    | Settings Store   |     |   |
|  |  +------------------+    +------------------+     |   |
|  +--------------------------------------------------+   |
|                                                          |
+----------------------------------------------------------+
```

---

## Module Structure

```
PackageCleaner/
├── App/
│   ├── PackageCleanerApp.swift       # App entry point
│   └── AppDelegate.swift             # App lifecycle (if needed)
│
├── Models/
│   ├── PackageDirectory.swift        # Package directory model
│   ├── Project.swift                 # Project information model
│   ├── ScanResult.swift              # Scan results container
│   ├── PackageType.swift             # Enum of package types
│   └── Language.swift                # Enum of languages/frameworks
│
├── ViewModels/
│   ├── MainViewModel.swift           # Main window state
│   ├── ScannerViewModel.swift        # Scanning operations
│   ├── CleanupViewModel.swift        # Cleanup operations
│   └── SettingsViewModel.swift       # Settings management
│
├── Views/
│   ├── MainView.swift                # Main window layout
│   ├── DirectoryListView.swift       # List of directories
│   ├── DirectoryRowView.swift        # Single directory row
│   ├── SidebarView.swift             # Filter sidebar
│   ├── ToolbarView.swift             # Toolbar items
│   ├── SettingsView.swift            # Settings panel
│   └── Components/
│       ├── SizeLabel.swift           # Formatted size display
│       ├── DateLabel.swift           # Relative date display
│       └── ProgressOverlay.swift     # Progress indicator
│
├── Services/
│   ├── ScannerService.swift          # Directory scanning logic
│   ├── CleanupService.swift          # Deletion operations
│   ├── ManifestParser.swift          # Parse manifest files
│   ├── VCSDetector.swift             # Git/SVN detection
│   └── SizeCalculator.swift          # Directory size calculation
│
├── Utilities/
│   ├── FileManagerExtensions.swift   # File system helpers
│   ├── DateExtensions.swift          # Date formatting
│   └── Constants.swift               # App constants
│
└── Resources/
    ├── Assets.xcassets               # Images and icons
    └── Localizable.strings           # Localization
```

---

## Core Data Models

### PackageDirectory

```swift
struct PackageDirectory: Identifiable, Hashable {
    let id: UUID
    let path: URL
    let type: PackageType
    let size: Int64
    let lastModified: Date
    let project: Project?
}
```

### Project

```swift
struct Project: Identifiable, Hashable {
    let id: UUID
    let path: URL
    let name: String
    let language: Language
    let lastActivity: Date
    let activitySource: ActivitySource  // .git, .svn, .filesystem
    let manifestFile: URL?
}
```

### PackageType

```swift
enum PackageType: String, CaseIterable {
    case nodeModules = "node_modules"
    case vendor = "vendor"
    case gradle = ".gradle"
    case gradleBuild = "build"
    case target = "target"
    case pods = "Pods"
    case venv = "venv"
    case pycache = "__pycache__"
    case packages = "packages"
    case pubCache = ".pub-cache"
    
    var displayName: String { ... }
    var associatedLanguages: [Language] { ... }
}
```

### Language

```swift
enum Language: String, CaseIterable {
    case javascript
    case typescript
    case php
    case java
    case kotlin
    case rust
    case swift
    case python
    case dart
    case ruby
    case go
    case dotnet
    case unknown
    
    var displayName: String { ... }
    var iconName: String { ... }
}
```

---

## Services

### ScannerService

Responsible for filesystem traversal and package directory detection.

```swift
protocol ScannerServiceProtocol {
    func scan(directories: [URL], 
              packageTypes: Set<PackageType>,
              progress: @escaping (ScanProgress) -> Void) async throws -> [PackageDirectory]
    func cancel()
}
```

**Implementation Details:**
- Uses `FileManager.enumerator` with skip flags for efficiency
- Runs on background thread using Swift Concurrency
- Supports cancellation via `Task.checkCancellation()`
- Excludes system directories and hidden volumes

### ManifestParser

Parses project manifest files to extract metadata.

```swift
protocol ManifestParserProtocol {
    func parseProject(at directory: URL) -> Project?
}
```

**Supported Formats:**
| Format | Parser |
|--------|--------|
| JSON | `JSONDecoder` (package.json, composer.json) |
| TOML | Custom parser (Cargo.toml, pyproject.toml) |
| YAML | Custom parser (pubspec.yaml) |
| XML | `XMLParser` (pom.xml) |
| Gradle | Regex-based extraction |

### VCSDetector

Detects version control systems and retrieves last activity.

```swift
protocol VCSDetectorProtocol {
    func detectVCS(at directory: URL) -> VCSType?
    func lastActivity(at directory: URL, vcs: VCSType) -> Date?
}
```

**Detection Methods:**
- **Git**: Check for `.git` directory, run `git log -1 --format=%ci`
- **SVN**: Check for `.svn` directory, parse `svn info`
- **Fallback**: Use filesystem modification time

### CleanupService

Handles deletion operations with safety checks.

```swift
protocol CleanupServiceProtocol {
    func delete(directories: [PackageDirectory], 
                moveToTrash: Bool,
                progress: @escaping (CleanupProgress) -> Void) async throws -> CleanupResult
    func cancel()
}
```

**Safety Features:**
- Validates paths before deletion
- Only deletes recognized package directory types
- Supports move-to-trash for recovery
- Provides detailed error reporting

---

## Data Flow

### Scanning Flow

```
User clicks "Scan"
       |
       v
MainViewModel.startScan()
       |
       v
ScannerService.scan(directories:)
       |
       +---> FileManager.enumerator (background thread)
       |            |
       |            v
       |     Detect package directories
       |            |
       |            v
       |     ManifestParser.parseProject()
       |            |
       |            v
       |     VCSDetector.lastActivity()
       |            |
       |            v
       +<--- Return [PackageDirectory]
       |
       v
Update @Published scanResults
       |
       v
SwiftUI updates DirectoryListView
```

### Cleanup Flow

```
User selects directories + clicks "Delete"
       |
       v
Confirmation dialog
       |
       v
CleanupViewModel.deleteSelected()
       |
       v
CleanupService.delete(directories:)
       |
       +---> For each directory:
       |         |
       |         v
       |     Validate path is package directory
       |         |
       |         v
       |     FileManager.trashItem() or removeItem()
       |         |
       |         v
       |     Report progress
       |
       +<--- Return CleanupResult
       |
       v
Remove from scanResults
       |
       v
Show completion summary
```

---

## Concurrency Model

The application uses Swift Concurrency (async/await) for all background operations:

```swift
@MainActor
class MainViewModel: ObservableObject {
    @Published var scanResults: [PackageDirectory] = []
    @Published var isScanning = false
    
    private var scanTask: Task<Void, Never>?
    
    func startScan() {
        scanTask = Task {
            isScanning = true
            defer { isScanning = false }
            
            do {
                let results = try await scannerService.scan(...)
                scanResults = results
            } catch {
                // Handle error
            }
        }
    }
    
    func cancelScan() {
        scanTask?.cancel()
    }
}
```

---

## Persistence

### User Settings (UserDefaults)

| Key | Type | Default |
|-----|------|---------|
| `scanDirectories` | `[String]` | `["~"]` |
| `autoCleanupThresholdDays` | `Int` | `180` |
| `excludedPaths` | `[String]` | `[]` |
| `moveToTrash` | `Bool` | `true` |
| `enabledPackageTypes` | `[String]` | All types |

### Scan Cache (Optional)

For performance, scan results can be cached to disk:
- Location: `~/Library/Caches/PackageCleaner/`
- Format: JSON or Property List
- Invalidation: On directory modification

---

## Security Considerations

### Filesystem Access

- Request Full Disk Access permission for comprehensive scanning
- Gracefully handle permission denied errors
- Never follow symbolic links outside scanned directories

### Deletion Safety

```swift
func validateDeletionTarget(_ url: URL) throws {
    // 1. Must be a directory
    guard url.hasDirectoryPath else {
        throw CleanupError.notADirectory
    }
    
    // 2. Must match a known package directory name
    guard PackageType.allCases.map(\.rawValue).contains(url.lastPathComponent) else {
        throw CleanupError.notAPackageDirectory
    }
    
    // 3. Must not be a system directory
    guard !isSystemDirectory(url) else {
        throw CleanupError.systemDirectory
    }
    
    // 4. Must be within user's home or specified scan paths
    guard isWithinAllowedPaths(url) else {
        throw CleanupError.outsideAllowedPaths
    }
}
```

---

## Testing Strategy

### Unit Tests

- Model serialization/deserialization
- Manifest parsing for each format
- Date calculations and formatting
- Size formatting

### Integration Tests

- Scanner service with mock filesystem
- VCS detection with test repositories
- Cleanup service with temporary directories

### UI Tests

- Main window interactions
- Settings persistence
- Keyboard shortcuts

---

## Performance Targets

| Operation | Target |
|-----------|--------|
| Initial scan (home directory) | < 30 seconds |
| Size calculation per directory | < 100ms |
| UI responsiveness during scan | 60 FPS |
| Memory usage during scan | < 200 MB |

---

## Future Considerations

1. **Menu Bar App**: Lightweight menu bar presence for quick access
2. **Scheduled Cleanup**: Background agent for automatic cleanup
3. **Statistics Dashboard**: Historical data on space saved
4. **Project Favorites**: Pin important projects to exclude from cleanup
5. **Custom Package Types**: User-defined package directory patterns

---

## Document History

| Version | Date | Author | Description |
|---------|------|--------|-------------|
| 1.0 | 2026-03-17 | - | Initial architecture document |

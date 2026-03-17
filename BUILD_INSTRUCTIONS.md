# Build Instructions

## Prerequisites

- macOS 12.0 (Monterey) or later
- Xcode 15.0 or later
- Command Line Tools for Xcode

## Building with Xcode

### Option 1: Create Xcode Project (Recommended)

1. Open Xcode
2. File > New > Project
3. Select: macOS > App
4. Configure:
   - Product Name: `PackageCleaner`
   - Team: Your development team
   - Organization Identifier: `com.yourname` (or your preference)
   - Interface: SwiftUI
   - Language: Swift
   - Use Core Data: No
   - Include Tests: Yes
5. Save to: `/Users/mim/Projects/Raspiska/package-cleaner`
6. After creation, add all source files from the `PackageCleaner/` directory to the project
7. Configure the project:
   - Set Deployment Target to macOS 12.0
   - Add `PackageCleaner.entitlements` to the target
   - Set `Info.plist` as the Info.plist file
8. Build and Run (Cmd+R)

### Option 2: Use Swift Package Manager

The project includes a `Package.swift` file for Swift Package Manager support.

```bash
# Build the project
swift build

# Run tests
swift test

# Run the application
swift run
```

Note: SPM builds may not include all macOS app features like entitlements and proper app bundling. Xcode is recommended for full functionality.

## Project Structure

After adding files to Xcode, ensure the following structure:

```
PackageCleaner/
├── App/
│   └── PackageCleanerApp.swift
├── Models/
│   ├── ActivitySource.swift
│   ├── CleanupProgress.swift
│   ├── CleanupResult.swift
│   ├── Language.swift
│   ├── PackageDirectory.swift
│   ├── PackageType.swift
│   ├── Project.swift
│   └── ScanProgress.swift
├── Services/
│   ├── CleanupService.swift
│   ├── ManifestParser.swift
│   ├── ScannerService.swift
│   ├── SettingsStore.swift
│   └── VCSDetector.swift
├── ViewModels/
│   ├── CleanupViewModel.swift
│   ├── MainViewModel.swift
│   └── SettingsViewModel.swift
├── Views/
│   ├── Components/
│   │   ├── DateLabel.swift
│   │   ├── ProgressOverlay.swift
│   │   └── SizeLabel.swift
│   ├── DirectoryListView.swift
│   ├── DirectoryRowView.swift
│   ├── MainView.swift
│   ├── SettingsView.swift
│   ├── SidebarView.swift
│   └── ToolbarView.swift
├── Utilities/
│   ├── ByteCountExtensions.swift
│   ├── Constants.swift
│   ├── DateExtensions.swift
│   └── FileManagerExtensions.swift
├── Resources/
│   └── Assets.xcassets/
├── Info.plist
└── PackageCleaner.entitlements
```

## Configuration

### Entitlements

The app requires the following entitlements (already configured in `PackageCleaner.entitlements`):
- App Sandbox
- User Selected File (Read/Write)
- File Bookmarks (App Scope)

### Permissions

For comprehensive scanning, users should grant:
- Full Disk Access (System Settings > Privacy & Security > Full Disk Access)

## Troubleshooting

### Build Errors

If you encounter build errors:

1. Clean build folder: Product > Clean Build Folder (Cmd+Shift+K)
2. Ensure all files are added to the target
3. Check that deployment target is set to macOS 12.0
4. Verify Swift version is 5.9 or later

### Runtime Issues

If the app doesn't scan properly:

1. Check that Full Disk Access is granted
2. Verify entitlements are properly configured
3. Check Console.app for error messages

## Distribution

### Code Signing

1. Select your development team in project settings
2. Xcode will automatically manage signing

### Creating a Release Build

1. Product > Archive
2. Distribute App > Copy App
3. The built app will be in the exported folder

### Notarization (for distribution)

For public distribution, the app must be notarized:

```bash
# Create a signed build
xcodebuild -scheme PackageCleaner -configuration Release archive

# Submit for notarization
xcrun notarytool submit PackageCleaner.zip --apple-id YOUR_APPLE_ID --team-id YOUR_TEAM_ID --wait

# Staple the notarization
xcrun stapler staple PackageCleaner.app
```

## Running Tests

```bash
# In Xcode
Product > Test (Cmd+U)

# Or with Swift Package Manager
swift test
```

## Development Tips

1. Use Xcode's SwiftUI preview for rapid UI development
2. Enable "Debug > Activate Breakpoints" for debugging
3. Use Instruments for performance profiling
4. Check memory usage when scanning large directories

## Next Steps

After building:

1. Test scanning your home directory
2. Verify package type detection
3. Test deletion (use Trash mode first)
4. Check settings persistence
5. Test with different project types

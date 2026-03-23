import Foundation
import Combine

class SettingsStore: ObservableObject {
    static let shared = SettingsStore()
    
    @Published var scanDirectories: [URL]
    @Published var autoCleanupThresholdDays: Int
    @Published var excludedPaths: [String]
    @Published var moveToTrash: Bool
    @Published var enabledPackageTypes: Set<PackageType>
    
    private let defaults = UserDefaults.standard
    
    private init() {
        print("🏗️ SettingsStore.init() - Creating singleton instance")
        
        // Try to load from bookmarks first (for security-scoped access)
        if let bookmarksData = defaults.array(forKey: Constants.UserDefaultsKeys.scanDirectoryBookmarks) as? [Data], !bookmarksData.isEmpty {
            let loadedDirs = bookmarksData.compactMap { data -> URL? in
                var isStale = false
                guard let url = try? URL(resolvingBookmarkData: data, options: .withSecurityScope, relativeTo: nil, bookmarkDataIsStale: &isStale) else {
                    return nil
                }
                _ = url.startAccessingSecurityScopedResource()
                return url
            }
            // If bookmarks failed to resolve, fall back to paths
            if loadedDirs.isEmpty, let paths = defaults.stringArray(forKey: Constants.UserDefaultsKeys.scanDirectories) {
                scanDirectories = paths.map { URL(fileURLWithPath: $0) }
            } else {
                scanDirectories = loadedDirs
            }
        } else if let paths = defaults.stringArray(forKey: Constants.UserDefaultsKeys.scanDirectories) {
            // Fallback to paths (for home directory or legacy data)
            scanDirectories = paths.map { URL(fileURLWithPath: $0) }
        } else {
            // Default to home directory on first launch
            scanDirectories = [FileManager.default.homeDirectoryForCurrentUser]
        }
        
        let threshold = defaults.integer(forKey: Constants.UserDefaultsKeys.autoCleanupThresholdDays)
        autoCleanupThresholdDays = threshold == 0 ? Constants.defaultAutoCleanupThresholdDays : threshold
        
        excludedPaths = defaults.stringArray(forKey: Constants.UserDefaultsKeys.excludedPaths) ?? []
        
        moveToTrash = defaults.object(forKey: Constants.UserDefaultsKeys.moveToTrash) as? Bool ?? true
        
        if let savedTypes = defaults.stringArray(forKey: Constants.UserDefaultsKeys.enabledPackageTypes) {
            enabledPackageTypes = Set(savedTypes.compactMap { PackageType(rawValue: $0) })
        } else {
            enabledPackageTypes = Set(PackageType.allCases)
        }
        
        print("📚 Loaded \(scanDirectories.count) scan directories")
    }
    
    func save() {
        // Save paths for display
        defaults.set(scanDirectories.map { $0.path }, forKey: Constants.UserDefaultsKeys.scanDirectories)
        
        // Save bookmarks for security-scoped access (skip home directory - it doesn't need bookmarks)
        let homeDir = FileManager.default.homeDirectoryForCurrentUser
        let bookmarks = scanDirectories.compactMap { url -> Data? in
            // Home directory doesn't need security-scoped bookmarks
            if url == homeDir {
                return nil
            }
            do {
                let bookmark = try url.bookmarkData(options: .withSecurityScope, includingResourceValuesForKeys: nil, relativeTo: nil)
                print("✅ Created bookmark for: \(url.path)")
                return bookmark
            } catch {
                print("❌ Failed to create bookmark for \(url.path): \(error)")
                return nil
            }
        }
        defaults.set(bookmarks, forKey: Constants.UserDefaultsKeys.scanDirectoryBookmarks)
        print("💾 Saved \(bookmarks.count) bookmarks")
        
        defaults.set(autoCleanupThresholdDays, forKey: Constants.UserDefaultsKeys.autoCleanupThresholdDays)
        defaults.set(excludedPaths, forKey: Constants.UserDefaultsKeys.excludedPaths)
        defaults.set(moveToTrash, forKey: Constants.UserDefaultsKeys.moveToTrash)
        defaults.set(enabledPackageTypes.map { $0.rawValue }, forKey: Constants.UserDefaultsKeys.enabledPackageTypes)
    }
    
    func resetToDefaults() {
        objectWillChange.send()
        scanDirectories = [FileManager.default.homeDirectoryForCurrentUser]
        autoCleanupThresholdDays = Constants.defaultAutoCleanupThresholdDays
        excludedPaths = []
        moveToTrash = true
        enabledPackageTypes = Set(PackageType.allCases)
        save()
        print("🔄 Reset to defaults - scanDirectories count: \(scanDirectories.count)")
    }
}

import Foundation
import Combine

class SettingsStore: ObservableObject {
    @Published var scanDirectories: [URL]
    @Published var autoCleanupThresholdDays: Int
    @Published var excludedPaths: [String]
    @Published var moveToTrash: Bool
    @Published var enabledPackageTypes: Set<PackageType>
    
    private let defaults = UserDefaults.standard
    
    init() {
        let homeDir = FileManager.default.homeDirectoryForCurrentUser
        
        if let paths = defaults.stringArray(forKey: Constants.UserDefaultsKeys.scanDirectories) {
            scanDirectories = paths.map { URL(fileURLWithPath: $0) }
        } else {
            scanDirectories = [homeDir]
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
    }
    
    func save() {
        defaults.set(scanDirectories.map { $0.path }, forKey: Constants.UserDefaultsKeys.scanDirectories)
        defaults.set(autoCleanupThresholdDays, forKey: Constants.UserDefaultsKeys.autoCleanupThresholdDays)
        defaults.set(excludedPaths, forKey: Constants.UserDefaultsKeys.excludedPaths)
        defaults.set(moveToTrash, forKey: Constants.UserDefaultsKeys.moveToTrash)
        defaults.set(enabledPackageTypes.map { $0.rawValue }, forKey: Constants.UserDefaultsKeys.enabledPackageTypes)
    }
}

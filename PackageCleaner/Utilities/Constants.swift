import Foundation

enum Constants {
    static let defaultAutoCleanupThresholdDays = 180
    
    enum UserDefaultsKeys {
        static let scanDirectories = "scanDirectories"
        static let autoCleanupThresholdDays = "autoCleanupThresholdDays"
        static let excludedPaths = "excludedPaths"
        static let moveToTrash = "moveToTrash"
        static let enabledPackageTypes = "enabledPackageTypes"
    }
    
    enum SystemDirectories {
        static let excluded = [
            "/System",
            "/Library",
            "/private",
            "/usr",
            "/bin",
            "/sbin",
            "/var",
            "/tmp",
            "/dev",
            "/Volumes"
        ]
    }
}

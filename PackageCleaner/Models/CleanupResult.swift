import Foundation

struct CleanupResult {
    let successCount: Int
    let failureCount: Int
    let totalFreedSpace: Int64
    let errors: [CleanupError]
    
    var wasSuccessful: Bool {
        return failureCount == 0
    }
    
    var formattedFreedSpace: String {
        ByteCountFormatter.string(fromByteCount: totalFreedSpace, countStyle: .file)
    }
}

enum CleanupError: Error, LocalizedError {
    case notADirectory(URL)
    case notAPackageDirectory(URL)
    case systemDirectory(URL)
    case outsideAllowedPaths(URL)
    case permissionDenied(URL)
    case deletionFailed(URL, Error)
    
    var errorDescription: String? {
        switch self {
        case .notADirectory(let url):
            return "Not a directory: \(url.path)"
        case .notAPackageDirectory(let url):
            return "Not a recognized package directory: \(url.lastPathComponent)"
        case .systemDirectory(let url):
            return "Cannot delete system directory: \(url.path)"
        case .outsideAllowedPaths(let url):
            return "Path is outside allowed scan directories: \(url.path)"
        case .permissionDenied(let url):
            return "Permission denied: \(url.path)"
        case .deletionFailed(let url, let error):
            return "Failed to delete \(url.path): \(error.localizedDescription)"
        }
    }
}

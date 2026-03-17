import Foundation

struct CleanupProgress {
    let currentPath: String
    let completed: Int
    let total: Int
    let freedSpace: Int64
    
    var percentage: Double {
        guard total > 0 else { return 0 }
        return Double(completed) / Double(total)
    }
    
    var formattedFreedSpace: String {
        ByteCountFormatter.string(fromByteCount: freedSpace, countStyle: .file)
    }
}

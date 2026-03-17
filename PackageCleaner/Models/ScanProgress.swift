import Foundation

struct ScanProgress {
    let currentPath: String
    let directoriesFound: Int
    let totalSize: Int64
    
    var formattedSize: String {
        ByteCountFormatter.string(fromByteCount: totalSize, countStyle: .file)
    }
}

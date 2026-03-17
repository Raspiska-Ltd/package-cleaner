import Foundation

extension Int64 {
    var formattedByteCount: String {
        ByteCountFormatter.string(fromByteCount: self, countStyle: .file)
    }
}

extension Array where Element == PackageDirectory {
    var totalSize: Int64 {
        reduce(0) { $0 + $1.size }
    }
    
    var formattedTotalSize: String {
        totalSize.formattedByteCount
    }
}

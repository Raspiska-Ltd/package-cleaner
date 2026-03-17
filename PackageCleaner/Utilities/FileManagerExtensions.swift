import Foundation

extension FileManager {
    func directorySize(at url: URL) throws -> Int64 {
        guard let enumerator = enumerator(
            at: url,
            includingPropertiesForKeys: [.fileSizeKey, .isDirectoryKey],
            options: [.skipsHiddenFiles]
        ) else {
            return 0
        }
        
        var totalSize: Int64 = 0
        
        for case let fileURL as URL in enumerator {
            let resourceValues = try fileURL.resourceValues(forKeys: [.fileSizeKey, .isDirectoryKey])
            
            if let isDirectory = resourceValues.isDirectory, !isDirectory {
                totalSize += Int64(resourceValues.fileSize ?? 0)
            }
        }
        
        return totalSize
    }
    
    func isSystemDirectory(_ url: URL) -> Bool {
        let path = url.path
        return Constants.SystemDirectories.excluded.contains { path.hasPrefix($0) }
    }
    
    func lastModificationDate(at url: URL) -> Date? {
        guard let attributes = try? attributesOfItem(atPath: url.path) else {
            return nil
        }
        return attributes[.modificationDate] as? Date
    }
    
    func moveToTrash(at url: URL) throws {
        var trashedURL: NSURL?
        try trashItem(at: url, resultingItemURL: &trashedURL)
    }
}

extension URL {
    var isDirectory: Bool {
        (try? resourceValues(forKeys: [.isDirectoryKey]))?.isDirectory == true
    }
    
    func findParentDirectory(containing fileName: String) -> URL? {
        var current = self
        
        while current.path != "/" {
            let candidateFile = current.appendingPathComponent(fileName)
            if FileManager.default.fileExists(atPath: candidateFile.path) {
                return current
            }
            current = current.deletingLastPathComponent()
        }
        
        return nil
    }
}

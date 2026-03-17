import Foundation

protocol CleanupServiceProtocol {
    func delete(
        directories: [PackageDirectory],
        moveToTrash: Bool,
        progress: @escaping (CleanupProgress) -> Void
    ) async throws -> CleanupResult
    func cancel()
}

class CleanupService: CleanupServiceProtocol {
    private let fileManager = FileManager.default
    private var isCancelled = false
    
    func delete(
        directories: [PackageDirectory],
        moveToTrash: Bool,
        progress: @escaping (CleanupProgress) -> Void
    ) async throws -> CleanupResult {
        isCancelled = false
        
        var successCount = 0
        var failureCount = 0
        var totalFreedSpace: Int64 = 0
        var errors: [CleanupError] = []
        
        for (index, directory) in directories.enumerated() {
            guard !isCancelled else { break }
            
            progress(CleanupProgress(
                currentPath: directory.path.path,
                completed: index,
                total: directories.count,
                freedSpace: totalFreedSpace
            ))
            
            do {
                try validateDeletionTarget(directory.path)
                
                if moveToTrash {
                    try fileManager.moveToTrash(at: directory.path)
                } else {
                    try fileManager.removeItem(at: directory.path)
                }
                
                successCount += 1
                totalFreedSpace += directory.size
                
            } catch let error as CleanupError {
                failureCount += 1
                errors.append(error)
            } catch {
                failureCount += 1
                errors.append(.deletionFailed(directory.path, error))
            }
        }
        
        progress(CleanupProgress(
            currentPath: "",
            completed: directories.count,
            total: directories.count,
            freedSpace: totalFreedSpace
        ))
        
        return CleanupResult(
            successCount: successCount,
            failureCount: failureCount,
            totalFreedSpace: totalFreedSpace,
            errors: errors
        )
    }
    
    func cancel() {
        isCancelled = true
    }
    
    private func validateDeletionTarget(_ url: URL) throws {
        guard url.isDirectory else {
            throw CleanupError.notADirectory(url)
        }
        
        let directoryName = url.lastPathComponent
        guard PackageType.detect(directoryName: directoryName) != nil else {
            throw CleanupError.notAPackageDirectory(url)
        }
        
        guard !fileManager.isSystemDirectory(url) else {
            throw CleanupError.systemDirectory(url)
        }
        
        let homeDirectory = fileManager.homeDirectoryForCurrentUser
        guard url.path.hasPrefix(homeDirectory.path) else {
            throw CleanupError.outsideAllowedPaths(url)
        }
    }
}

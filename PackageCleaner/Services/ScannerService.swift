import Foundation

protocol ScannerServiceProtocol {
    func scan(
        directories: [URL],
        packageTypes: Set<PackageType>,
        progress: @escaping (ScanProgress, String) -> Void
    ) async throws -> [PackageDirectory]
    func cancel()
}

class ScannerService: ScannerServiceProtocol {
    private let fileManager = FileManager.default
    private let manifestParser: ManifestParserProtocol
    private var isCancelled = false
    
    init(manifestParser: ManifestParserProtocol = ManifestParser()) {
        self.manifestParser = manifestParser
    }
    
    func scan(
        directories: [URL],
        packageTypes: Set<PackageType>,
        progress: @escaping (ScanProgress, String) -> Void
    ) async throws -> [PackageDirectory] {
        isCancelled = false
        var results: [PackageDirectory] = []
        var totalSize: Int64 = 0
        
        for directory in directories {
            guard !isCancelled else { break }
            
            let foundDirectories = try await scanDirectory(
                directory,
                packageTypes: packageTypes,
                progress: { currentPath, found, size in
                    totalSize = size
                    let displayPath = URL(fileURLWithPath: currentPath).lastPathComponent
                    progress(ScanProgress(
                        currentPath: currentPath,
                        directoriesFound: results.count + found,
                        totalSize: totalSize
                    ), displayPath)
                }
            )
            
            results.append(contentsOf: foundDirectories)
        }
        
        return results
    }
    
    func cancel() {
        isCancelled = true
    }
    
    private func scanDirectory(
        _ directory: URL,
        packageTypes: Set<PackageType>,
        progress: @escaping (String, Int, Int64) -> Void
    ) async throws -> [PackageDirectory] {
        var results: [PackageDirectory] = []
        var totalSize: Int64 = 0
        var processedProjects: Set<URL> = []
        
        guard let enumerator = fileManager.enumerator(
            at: directory,
            includingPropertiesForKeys: [.isDirectoryKey, .nameKey],
            options: [.skipsHiddenFiles, .skipsPackageDescendants]
        ) else {
            print("⚠️ Failed to create enumerator for directory: \(directory.path)")
            print("⚠️ Check if app has permission to access this directory")
            return []
        }
        
        for case let fileURL as URL in enumerator {
            guard !isCancelled else { break }
            
            if fileManager.isSystemDirectory(fileURL) {
                enumerator.skipDescendants()
                continue
            }
            
            let directoryName = fileURL.lastPathComponent
            
            if let packageType = PackageType.detect(directoryName: directoryName),
               packageTypes.contains(packageType) {
                
                enumerator.skipDescendants()
                
                let projectDir = fileURL.deletingLastPathComponent()
                
                let project: Project?
                if !processedProjects.contains(projectDir) {
                    project = await manifestParser.parseProject(at: projectDir)
                    processedProjects.insert(projectDir)
                } else {
                    project = nil
                }
                
                let size = (try? fileManager.directorySize(at: fileURL)) ?? 0
                let lastModified = fileManager.lastModificationDate(at: fileURL) ?? Date()
                
                let packageDir = PackageDirectory(
                    path: fileURL,
                    type: packageType,
                    size: size,
                    lastModified: lastModified,
                    project: project
                )
                
                results.append(packageDir)
                totalSize += size
                
                progress(fileURL.path, results.count, totalSize)
            }
        }
        
        return results
    }
}

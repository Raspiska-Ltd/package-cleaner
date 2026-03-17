import Foundation

struct CachedScanData: Codable {
    let timestamp: Date
    let directories: [CachedPackageDirectory]
    
    struct CachedPackageDirectory: Codable {
        let id: UUID
        let path: String
        let type: String
        let size: Int64
        let lastModified: Date
        let projectName: String
        let projectPath: String
        let languageRaw: String
        let lastActivity: Date
        let activitySourceRaw: String?
    }
}

class PersistenceController {
    static let shared = PersistenceController()
    
    private let cacheURL: URL
    
    init() {
        let appSupport = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let appDirectory = appSupport.appendingPathComponent("PackageCleaner", isDirectory: true)
        
        try? FileManager.default.createDirectory(at: appDirectory, withIntermediateDirectories: true)
        
        cacheURL = appDirectory.appendingPathComponent("scan_cache.json")
    }
    
    func saveScanResults(_ directories: [PackageDirectory]) {
        let cached = directories.map { directory in
            CachedScanData.CachedPackageDirectory(
                id: directory.id,
                path: directory.path.path,
                type: directory.type.rawValue,
                size: directory.size,
                lastModified: directory.lastModified,
                projectName: directory.projectName,
                projectPath: directory.projectPath.path,
                languageRaw: directory.language.rawValue,
                lastActivity: directory.lastActivity,
                activitySourceRaw: directory.project?.activitySource.rawValue
            )
        }
        
        let data = CachedScanData(timestamp: Date(), directories: cached)
        
        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            let jsonData = try encoder.encode(data)
            try jsonData.write(to: cacheURL)
        } catch {
            print("Failed to save scan results: \(error.localizedDescription)")
        }
    }
    
    func loadScanResults() -> [PackageDirectory] {
        guard FileManager.default.fileExists(atPath: cacheURL.path) else {
            return []
        }
        
        do {
            let jsonData = try Data(contentsOf: cacheURL)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let cached = try decoder.decode(CachedScanData.self, from: jsonData)
            
            return cached.directories.compactMap { item in
                guard let type = PackageType(rawValue: item.type),
                      let language = Language(rawValue: item.languageRaw) else {
                    return nil
                }
                
                let path = URL(fileURLWithPath: item.path)
                let projectPath = URL(fileURLWithPath: item.projectPath)
                
                var activitySource: ActivitySource = .filesystem
                if let sourceRaw = item.activitySourceRaw,
                   let source = ActivitySource(rawValue: sourceRaw) {
                    activitySource = source
                }
                
                let project = Project(
                    path: projectPath,
                    name: item.projectName,
                    language: language,
                    lastActivity: item.lastActivity,
                    activitySource: activitySource,
                    manifestFile: nil
                )
                
                return PackageDirectory(
                    id: item.id,
                    path: path,
                    type: type,
                    size: item.size,
                    lastModified: item.lastModified,
                    project: project
                )
            }
        } catch {
            print("Failed to load scan results: \(error.localizedDescription)")
            return []
        }
    }
    
    func clearCache() {
        try? FileManager.default.removeItem(at: cacheURL)
    }
}

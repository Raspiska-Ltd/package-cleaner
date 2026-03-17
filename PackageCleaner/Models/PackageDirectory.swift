import Foundation

struct PackageDirectory: Identifiable, Hashable, Codable {
    let id: UUID
    let path: URL
    let type: PackageType
    let size: Int64
    let lastModified: Date
    let project: Project?
    
    init(
        id: UUID = UUID(),
        path: URL,
        type: PackageType,
        size: Int64,
        lastModified: Date,
        project: Project? = nil
    ) {
        self.id = id
        self.path = path
        self.type = type
        self.size = size
        self.lastModified = lastModified
        self.project = project
    }
    
    var projectName: String {
        project?.name ?? path.deletingLastPathComponent().lastPathComponent
    }
    
    var projectPath: URL {
        project?.path ?? path.deletingLastPathComponent()
    }
    
    var language: Language {
        project?.language ?? .unknown
    }
    
    var lastActivity: Date {
        project?.lastActivity ?? lastModified
    }
    
    var ageInDays: Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: lastActivity, to: Date())
        return components.day ?? 0
    }
    
    func isOlderThan(days: Int) -> Bool {
        return ageInDays > days
    }
}

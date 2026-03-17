import Foundation

struct Project: Identifiable, Hashable, Codable {
    let id: UUID
    let path: URL
    let name: String
    let language: Language
    let lastActivity: Date
    let activitySource: ActivitySource
    let manifestFile: URL?
    
    init(
        id: UUID = UUID(),
        path: URL,
        name: String,
        language: Language,
        lastActivity: Date,
        activitySource: ActivitySource,
        manifestFile: URL? = nil
    ) {
        self.id = id
        self.path = path
        self.name = name
        self.language = language
        self.lastActivity = lastActivity
        self.activitySource = activitySource
        self.manifestFile = manifestFile
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

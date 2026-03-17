import Foundation

enum ActivitySource: String, Codable {
    case git
    case svn
    case filesystem
    
    var displayName: String {
        switch self {
        case .git:
            return "Git"
        case .svn:
            return "SVN"
        case .filesystem:
            return "File System"
        }
    }
}

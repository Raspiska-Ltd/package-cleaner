import Foundation

enum PackageType: String, CaseIterable, Codable, Identifiable {
    case nodeModules = "node_modules"
    case vendor = "vendor"
    case gradle = ".gradle"
    case gradleBuild = "build"
    case target = "target"
    case pods = "Pods"
    case venv = "venv"
    case dotVenv = ".venv"
    case pycache = "__pycache__"
    case packages = "packages"
    case pubCache = ".pub-cache"
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .nodeModules:
            return "node_modules"
        case .vendor:
            return "vendor"
        case .gradle:
            return ".gradle"
        case .gradleBuild:
            return "build (Gradle)"
        case .target:
            return "target"
        case .pods:
            return "Pods"
        case .venv:
            return "venv"
        case .dotVenv:
            return ".venv"
        case .pycache:
            return "__pycache__"
        case .packages:
            return "packages"
        case .pubCache:
            return ".pub-cache"
        }
    }
    
    var associatedLanguages: [Language] {
        switch self {
        case .nodeModules:
            return [.javascript, .typescript]
        case .vendor:
            return [.php, .go, .ruby]
        case .gradle, .gradleBuild:
            return [.java, .kotlin]
        case .target:
            return [.rust, .java]
        case .pods:
            return [.swift]
        case .venv, .dotVenv, .pycache:
            return [.python]
        case .packages:
            return [.dotnet]
        case .pubCache:
            return [.dart]
        }
    }
    
    static func detect(directoryName: String) -> PackageType? {
        return PackageType.allCases.first { $0.rawValue == directoryName }
    }
}

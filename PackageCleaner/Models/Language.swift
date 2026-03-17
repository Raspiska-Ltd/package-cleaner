import Foundation

enum Language: String, CaseIterable, Codable, Identifiable {
    case javascript
    case typescript
    case php
    case java
    case kotlin
    case rust
    case swift
    case python
    case dart
    case ruby
    case go
    case dotnet
    case unknown
    
    var id: String { rawValue }
    
    var displayName: String {
        switch self {
        case .javascript:
            return "JavaScript"
        case .typescript:
            return "TypeScript"
        case .php:
            return "PHP"
        case .java:
            return "Java"
        case .kotlin:
            return "Kotlin"
        case .rust:
            return "Rust"
        case .swift:
            return "Swift"
        case .python:
            return "Python"
        case .dart:
            return "Dart"
        case .ruby:
            return "Ruby"
        case .go:
            return "Go"
        case .dotnet:
            return ".NET"
        case .unknown:
            return "Unknown"
        }
    }
    
    var iconName: String {
        switch self {
        case .javascript, .typescript:
            return "curlybraces"
        case .php:
            return "chevron.left.forwardslash.chevron.right"
        case .java, .kotlin:
            return "cup.and.saucer.fill"
        case .rust:
            return "gearshape.fill"
        case .swift:
            return "swift"
        case .python:
            return "snake"
        case .dart:
            return "bird.fill"
        case .ruby:
            return "diamond.fill"
        case .go:
            return "hare.fill"
        case .dotnet:
            return "square.grid.2x2.fill"
        case .unknown:
            return "questionmark.circle"
        }
    }
}

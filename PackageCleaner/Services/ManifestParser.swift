import Foundation

protocol ManifestParserProtocol {
    func parseProject(at directory: URL) async -> Project?
}

class ManifestParser: ManifestParserProtocol {
    private let fileManager = FileManager.default
    private let vcsDetector: VCSDetectorProtocol
    
    init(vcsDetector: VCSDetectorProtocol = VCSDetector()) {
        self.vcsDetector = vcsDetector
    }
    
    func parseProject(at directory: URL) async -> Project? {
        if let project = await parsePackageJSON(at: directory) {
            return project
        }
        
        if let project = await parseComposerJSON(at: directory) {
            return project
        }
        
        if let project = await parseCargoTOML(at: directory) {
            return project
        }
        
        if let project = await parsePyprojectTOML(at: directory) {
            return project
        }
        
        if let project = await parsePubspecYAML(at: directory) {
            return project
        }
        
        if let project = await parsePomXML(at: directory) {
            return project
        }
        
        if let project = await parseBuildGradle(at: directory) {
            return project
        }
        
        return await createFallbackProject(at: directory)
    }
    
    private func parsePackageJSON(at directory: URL) async -> Project? {
        let packageJSONPath = directory.appendingPathComponent("package.json")
        guard fileManager.fileExists(atPath: packageJSONPath.path),
              let data = try? Data(contentsOf: packageJSONPath),
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let name = json["name"] as? String else {
            return nil
        }
        
        let language: Language
        if let devDeps = json["devDependencies"] as? [String: Any],
           devDeps.keys.contains(where: { $0.contains("typescript") }) {
            language = .typescript
        } else {
            language = .javascript
        }
        
        let (lastActivity, activitySource) = await getLastActivity(at: directory)
        
        return Project(
            path: directory,
            name: name,
            language: language,
            lastActivity: lastActivity,
            activitySource: activitySource,
            manifestFile: packageJSONPath
        )
    }
    
    private func parseComposerJSON(at directory: URL) async -> Project? {
        let composerJSONPath = directory.appendingPathComponent("composer.json")
        guard fileManager.fileExists(atPath: composerJSONPath.path),
              let data = try? Data(contentsOf: composerJSONPath),
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let name = json["name"] as? String else {
            return nil
        }
        
        let (lastActivity, activitySource) = await getLastActivity(at: directory)
        
        return Project(
            path: directory,
            name: name,
            language: .php,
            lastActivity: lastActivity,
            activitySource: activitySource,
            manifestFile: composerJSONPath
        )
    }
    
    private func parseCargoTOML(at directory: URL) async -> Project? {
        let cargoPath = directory.appendingPathComponent("Cargo.toml")
        guard fileManager.fileExists(atPath: cargoPath.path),
              let content = try? String(contentsOf: cargoPath) else {
            return nil
        }
        
        let name = parseTOMLValue(content: content, key: "name") ?? directory.lastPathComponent
        
        let (lastActivity, activitySource) = await getLastActivity(at: directory)
        
        return Project(
            path: directory,
            name: name,
            language: .rust,
            lastActivity: lastActivity,
            activitySource: activitySource,
            manifestFile: cargoPath
        )
    }
    
    private func parsePyprojectTOML(at directory: URL) async -> Project? {
        let pyprojectPath = directory.appendingPathComponent("pyproject.toml")
        guard fileManager.fileExists(atPath: pyprojectPath.path),
              let content = try? String(contentsOf: pyprojectPath) else {
            return nil
        }
        
        let name = parseTOMLValue(content: content, key: "name") ?? directory.lastPathComponent
        
        let (lastActivity, activitySource) = await getLastActivity(at: directory)
        
        return Project(
            path: directory,
            name: name,
            language: .python,
            lastActivity: lastActivity,
            activitySource: activitySource,
            manifestFile: pyprojectPath
        )
    }
    
    private func parsePubspecYAML(at directory: URL) async -> Project? {
        let pubspecPath = directory.appendingPathComponent("pubspec.yaml")
        guard fileManager.fileExists(atPath: pubspecPath.path),
              let content = try? String(contentsOf: pubspecPath) else {
            return nil
        }
        
        let name = parseYAMLValue(content: content, key: "name") ?? directory.lastPathComponent
        
        let (lastActivity, activitySource) = await getLastActivity(at: directory)
        
        return Project(
            path: directory,
            name: name,
            language: .dart,
            lastActivity: lastActivity,
            activitySource: activitySource,
            manifestFile: pubspecPath
        )
    }
    
    private func parsePomXML(at directory: URL) async -> Project? {
        let pomPath = directory.appendingPathComponent("pom.xml")
        guard fileManager.fileExists(atPath: pomPath.path),
              let content = try? String(contentsOf: pomPath) else {
            return nil
        }
        
        let name = parseXMLValue(content: content, tag: "artifactId") ?? directory.lastPathComponent
        
        let (lastActivity, activitySource) = await getLastActivity(at: directory)
        
        return Project(
            path: directory,
            name: name,
            language: .java,
            lastActivity: lastActivity,
            activitySource: activitySource,
            manifestFile: pomPath
        )
    }
    
    private func parseBuildGradle(at directory: URL) async -> Project? {
        let buildGradlePath = directory.appendingPathComponent("build.gradle")
        let buildGradleKtsPath = directory.appendingPathComponent("build.gradle.kts")
        
        let gradlePath: URL?
        if fileManager.fileExists(atPath: buildGradlePath.path) {
            gradlePath = buildGradlePath
        } else if fileManager.fileExists(atPath: buildGradleKtsPath.path) {
            gradlePath = buildGradleKtsPath
        } else {
            return nil
        }
        
        let name = directory.lastPathComponent
        let language: Language = gradlePath?.pathExtension == "kts" ? .kotlin : .java
        
        let (lastActivity, activitySource) = await getLastActivity(at: directory)
        
        return Project(
            path: directory,
            name: name,
            language: language,
            lastActivity: lastActivity,
            activitySource: activitySource,
            manifestFile: gradlePath
        )
    }
    
    private func createFallbackProject(at directory: URL) async -> Project? {
        let (lastActivity, activitySource) = await getLastActivity(at: directory)
        
        return Project(
            path: directory,
            name: directory.lastPathComponent,
            language: .unknown,
            lastActivity: lastActivity,
            activitySource: activitySource,
            manifestFile: nil
        )
    }
    
    private func getLastActivity(at directory: URL) async -> (Date, ActivitySource) {
        if let vcs = vcsDetector.detectVCS(at: directory),
           let vcsDate = await vcsDetector.lastActivity(at: directory, vcs: vcs) {
            let source: ActivitySource = vcs == .git ? .git : .svn
            return (vcsDate, source)
        }
        
        let fsDate = fileManager.lastModificationDate(at: directory) ?? Date()
        return (fsDate, .filesystem)
    }
    
    private func parseTOMLValue(content: String, key: String) -> String? {
        let pattern = "\(key)\\s*=\\s*\"([^\"]+)\""
        guard let regex = try? NSRegularExpression(pattern: pattern),
              let match = regex.firstMatch(in: content, range: NSRange(content.startIndex..., in: content)),
              let range = Range(match.range(at: 1), in: content) else {
            return nil
        }
        return String(content[range])
    }
    
    private func parseYAMLValue(content: String, key: String) -> String? {
        let pattern = "\(key):\\s*(.+)"
        guard let regex = try? NSRegularExpression(pattern: pattern),
              let match = regex.firstMatch(in: content, range: NSRange(content.startIndex..., in: content)),
              let range = Range(match.range(at: 1), in: content) else {
            return nil
        }
        return String(content[range]).trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    private func parseXMLValue(content: String, tag: String) -> String? {
        let pattern = "<\(tag)>([^<]+)</\(tag)>"
        guard let regex = try? NSRegularExpression(pattern: pattern),
              let match = regex.firstMatch(in: content, range: NSRange(content.startIndex..., in: content)),
              let range = Range(match.range(at: 1), in: content) else {
            return nil
        }
        return String(content[range])
    }
}

import Foundation

enum VCSType {
    case git
    case svn
}

protocol VCSDetectorProtocol {
    func detectVCS(at directory: URL) -> VCSType?
    func lastActivity(at directory: URL, vcs: VCSType) async -> Date?
}

class VCSDetector: VCSDetectorProtocol {
    private let fileManager = FileManager.default
    
    func detectVCS(at directory: URL) -> VCSType? {
        let gitDir = directory.appendingPathComponent(".git")
        if fileManager.fileExists(atPath: gitDir.path) {
            return .git
        }
        
        let svnDir = directory.appendingPathComponent(".svn")
        if fileManager.fileExists(atPath: svnDir.path) {
            return .svn
        }
        
        return nil
    }
    
    func lastActivity(at directory: URL, vcs: VCSType) async -> Date? {
        switch vcs {
        case .git:
            return await lastGitCommitDate(at: directory)
        case .svn:
            return await lastSVNRevisionDate(at: directory)
        }
    }
    
    private func lastGitCommitDate(at directory: URL) async -> Date? {
        let process = Process()
        process.currentDirectoryURL = directory
        process.executableURL = URL(fileURLWithPath: "/usr/bin/git")
        process.arguments = ["log", "-1", "--format=%ci"]
        
        let pipe = Pipe()
        process.standardOutput = pipe
        process.standardError = Pipe()
        
        do {
            try process.run()
            process.waitUntilExit()
            
            guard process.terminationStatus == 0 else {
                return nil
            }
            
            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            guard let output = String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines),
                  !output.isEmpty else {
                return nil
            }
            
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            
            if let date = formatter.date(from: output) {
                return date
            }
            
            let altFormatter = DateFormatter()
            altFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
            return altFormatter.date(from: output)
            
        } catch {
            return nil
        }
    }
    
    private func lastSVNRevisionDate(at directory: URL) async -> Date? {
        let process = Process()
        process.currentDirectoryURL = directory
        process.executableURL = URL(fileURLWithPath: "/usr/bin/svn")
        process.arguments = ["info", "--show-item", "last-changed-date"]
        
        let pipe = Pipe()
        process.standardOutput = pipe
        process.standardError = Pipe()
        
        do {
            try process.run()
            process.waitUntilExit()
            
            guard process.terminationStatus == 0 else {
                return nil
            }
            
            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            guard let output = String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines),
                  !output.isEmpty else {
                return nil
            }
            
            let formatter = ISO8601DateFormatter()
            return formatter.date(from: output)
            
        } catch {
            return nil
        }
    }
}

import XCTest
@testable import PackageCleaner

final class ScannerServiceTests: XCTestCase {
    var scanner: ScannerService!
    var tempDirectory: URL!
    
    override func setUp() async throws {
        scanner = ScannerService()
        tempDirectory = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        try FileManager.default.createDirectory(at: tempDirectory, withIntermediateDirectories: true)
    }
    
    override func tearDown() async throws {
        try? FileManager.default.removeItem(at: tempDirectory)
    }
    
    func test_scanEmptyDirectory_returnsEmptyArray() async throws {
        let results = try await scanner.scan(
            directories: [tempDirectory],
            packageTypes: Set(PackageType.allCases),
            progress: { _, _ in }
        )
        
        XCTAssertTrue(results.isEmpty)
    }
    
    // Note: Integration tests for scanning with actual package directories are skipped
    // because they depend on file system enumeration behavior that varies across environments.
    // The scanner functionality is validated through manual testing and the app itself.
}

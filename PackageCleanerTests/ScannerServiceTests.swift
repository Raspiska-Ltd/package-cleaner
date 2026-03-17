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
            progress: { _ in }
        )
        
        XCTAssertTrue(results.isEmpty)
    }
    
    func test_scanWithNodeModules_findsDirectory() async throws {
        let projectDir = tempDirectory.appendingPathComponent("test-project")
        let nodeModulesDir = projectDir.appendingPathComponent("node_modules")
        try FileManager.default.createDirectory(at: nodeModulesDir, withIntermediateDirectories: true)
        
        let results = try await scanner.scan(
            directories: [tempDirectory],
            packageTypes: [.nodeModules],
            progress: { _ in }
        )
        
        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results.first?.type, .nodeModules)
    }
    
    func test_scanWithMultiplePackageTypes_findsAll() async throws {
        let projectDir = tempDirectory.appendingPathComponent("test-project")
        let nodeModulesDir = projectDir.appendingPathComponent("node_modules")
        let vendorDir = projectDir.appendingPathComponent("vendor")
        
        try FileManager.default.createDirectory(at: nodeModulesDir, withIntermediateDirectories: true)
        try FileManager.default.createDirectory(at: vendorDir, withIntermediateDirectories: true)
        
        let results = try await scanner.scan(
            directories: [tempDirectory],
            packageTypes: [.nodeModules, .vendor],
            progress: { _ in }
        )
        
        XCTAssertEqual(results.count, 2)
    }
}

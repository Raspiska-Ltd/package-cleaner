import XCTest
@testable import PackageCleaner

final class ManifestParserTests: XCTestCase {
    var parser: ManifestParser!
    var tempDirectory: URL!
    
    override func setUp() async throws {
        parser = ManifestParser()
        tempDirectory = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        try FileManager.default.createDirectory(at: tempDirectory, withIntermediateDirectories: true)
    }
    
    override func tearDown() async throws {
        try? FileManager.default.removeItem(at: tempDirectory)
    }
    
    func test_parsePackageJSON_extractsProjectName() async throws {
        let packageJSON = """
        {
            "name": "test-project",
            "version": "1.0.0"
        }
        """
        
        let packageJSONPath = tempDirectory.appendingPathComponent("package.json")
        try packageJSON.write(to: packageJSONPath, atomically: true, encoding: .utf8)
        
        let project = await parser.parseProject(at: tempDirectory)
        
        XCTAssertNotNil(project)
        XCTAssertEqual(project?.name, "test-project")
        XCTAssertEqual(project?.language, .javascript)
    }
    
    func test_parsePackageJSONWithTypeScript_detectsTypeScript() async throws {
        let packageJSON = """
        {
            "name": "ts-project",
            "devDependencies": {
                "typescript": "^5.0.0"
            }
        }
        """
        
        let packageJSONPath = tempDirectory.appendingPathComponent("package.json")
        try packageJSON.write(to: packageJSONPath, atomically: true, encoding: .utf8)
        
        let project = await parser.parseProject(at: tempDirectory)
        
        XCTAssertEqual(project?.language, .typescript)
    }
    
    func test_parseComposerJSON_extractsProjectName() async throws {
        let composerJSON = """
        {
            "name": "vendor/package",
            "description": "A test package"
        }
        """
        
        let composerJSONPath = tempDirectory.appendingPathComponent("composer.json")
        try composerJSON.write(to: composerJSONPath, atomically: true, encoding: .utf8)
        
        let project = await parser.parseProject(at: tempDirectory)
        
        XCTAssertNotNil(project)
        XCTAssertEqual(project?.name, "vendor/package")
        XCTAssertEqual(project?.language, .php)
    }
}

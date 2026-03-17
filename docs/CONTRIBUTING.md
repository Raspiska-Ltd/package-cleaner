# Contributing to Package Cleaner

Thank you for your interest in contributing to Package Cleaner. This document provides guidelines and instructions for contributing.

---

## Getting Started

### Prerequisites

- macOS 12.0 (Monterey) or later
- Xcode 15.0 or later
- Git

### Setting Up the Development Environment

1. Fork the repository on GitHub
2. Clone your fork:
   ```bash
   git clone https://github.com/YOUR_USERNAME/package-cleaner.git
   cd package-cleaner
   ```
3. Open the project in Xcode:
   ```bash
   open PackageCleaner.xcodeproj
   ```
4. Build and run the project (Cmd+R)

---

## Development Workflow

### Branching Strategy

- `main` - Stable release branch
- `develop` - Integration branch for features
- `feature/*` - Feature branches
- `bugfix/*` - Bug fix branches
- `release/*` - Release preparation branches

### Creating a Feature Branch

```bash
git checkout develop
git pull origin develop
git checkout -b feature/your-feature-name
```

### Commit Messages

Follow conventional commit format:

```
<type>(<scope>): <description>

[optional body]

[optional footer]
```

**Types:**
- `feat` - New feature
- `fix` - Bug fix
- `docs` - Documentation changes
- `style` - Code style changes (formatting, etc.)
- `refactor` - Code refactoring
- `test` - Adding or updating tests
- `chore` - Maintenance tasks

**Examples:**
```
feat(scanner): add support for Rust Cargo target directories

fix(cleanup): handle permission denied errors gracefully

docs(readme): update installation instructions
```

---

## Code Style

### Swift Style Guide

- Follow Apple's Swift API Design Guidelines
- Use 4 spaces for indentation
- Maximum line length: 120 characters
- Use meaningful variable and function names

### SwiftUI Conventions

- Use `@StateObject` for owned observable objects
- Use `@ObservedObject` for passed observable objects
- Prefer smaller, composable views
- Extract complex view logic into ViewModels

### File Organization

```swift
// MARK: - Properties

// MARK: - Initialization

// MARK: - Public Methods

// MARK: - Private Methods

// MARK: - Protocol Conformance
```

---

## Testing

### Running Tests

```bash
# Run all tests
xcodebuild test -scheme PackageCleaner -destination 'platform=macOS'

# Or use Xcode: Cmd+U
```

### Writing Tests

- Place unit tests in `PackageCleanerTests/`
- Place UI tests in `PackageCleanerUITests/`
- Name test methods descriptively: `test_methodName_condition_expectedResult`

**Example:**
```swift
func test_scannerService_emptyDirectory_returnsEmptyArray() async throws {
    let scanner = ScannerService()
    let results = try await scanner.scan(directories: [emptyDir])
    XCTAssertTrue(results.isEmpty)
}
```

### Test Coverage

- Aim for 80% code coverage on core services
- All bug fixes should include a regression test

---

## Pull Request Process

### Before Submitting

1. Ensure all tests pass
2. Update documentation if needed
3. Add entries to CHANGELOG.md for notable changes
4. Rebase on latest `develop` branch

### Pull Request Template

```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Documentation update
- [ ] Refactoring

## Testing
Describe how you tested the changes

## Checklist
- [ ] Tests pass locally
- [ ] Code follows style guidelines
- [ ] Documentation updated
- [ ] CHANGELOG updated (if applicable)
```

### Review Process

1. Submit PR against `develop` branch
2. Wait for CI checks to pass
3. Address reviewer feedback
4. Maintainer will merge when approved

---

## Reporting Issues

### Bug Reports

Include the following information:
- macOS version
- Application version
- Steps to reproduce
- Expected behavior
- Actual behavior
- Screenshots (if applicable)
- Console logs (if applicable)

### Feature Requests

- Describe the problem you're trying to solve
- Describe your proposed solution
- Consider alternatives you've thought about

---

## Adding Support for New Package Types

To add support for a new package directory type:

1. Add the type to `PackageType` enum in `Models/PackageType.swift`
2. Add associated language(s) to `Language` enum if needed
3. Update `ScannerService` to detect the new type
4. Add manifest parser if applicable
5. Add tests for the new type
6. Update documentation

**Example:**
```swift
// In PackageType.swift
enum PackageType: String, CaseIterable {
    // ... existing types
    case newType = "new_type_directory"
    
    var associatedLanguages: [Language] {
        switch self {
        case .newType: return [.newLanguage]
        // ...
        }
    }
}
```

---

## Adding Support for New Manifest Files

To add support for a new manifest file format:

1. Create a parser in `Services/ManifestParsers/`
2. Register the parser in `ManifestParser.swift`
3. Add tests with sample manifest files
4. Update documentation

---

## Code of Conduct

### Our Standards

- Be respectful and inclusive
- Accept constructive criticism gracefully
- Focus on what is best for the community
- Show empathy towards other community members

### Unacceptable Behavior

- Harassment or discrimination
- Trolling or insulting comments
- Personal or political attacks
- Publishing others' private information

---

## License

By contributing to Package Cleaner, you agree that your contributions will be licensed under the same license as the project (see LICENSE file).

---

## Questions?

If you have questions about contributing, please open a GitHub issue with the "question" label.

---

## Document History

| Version | Date | Author | Description |
|---------|------|--------|-------------|
| 1.0 | 2026-03-17 | - | Initial contributing guide |

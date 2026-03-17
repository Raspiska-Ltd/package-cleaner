 # Package Cleaner

A native macOS application that helps developers reclaim disk space by finding and removing package dependency directories from development projects.

---

## Features

- **Offline Operation**: Works entirely without internet connectivity
- **Multi-Language Support**: Detects package directories for Node.js, PHP, Java, Rust, Python, Swift, Dart, and more
- **Smart Detection**: Reads project metadata from manifest files (package.json, composer.json, etc.)
- **Activity Tracking**: Shows when you last worked on each project using Git/SVN history
- **Auto-Cleanup**: Automatically identify and remove package directories older than 6 months
- **Safe Deletion**: Moves to Trash by default for easy recovery
- **Native Experience**: Built with Swift and SwiftUI for optimal macOS integration

---

## Supported Package Types

| Directory | Language/Framework |
|-----------|-------------------|
| `node_modules` | Node.js, JavaScript, TypeScript |
| `vendor` | PHP (Composer), Go, Ruby (Bundler) |
| `.gradle`, `build` | Java, Kotlin, Android (Gradle) |
| `target` | Rust (Cargo), Java (Maven) |
| `Pods` | iOS, macOS (CocoaPods) |
| `venv`, `.venv`, `__pycache__` | Python |
| `packages` | .NET (NuGet) |
| `.pub-cache` | Dart, Flutter |

---

## Requirements

- macOS 12.0 (Monterey) or later
- Full Disk Access permission (for scanning all directories)

---

## Installation

### Download

Download the latest release from the [Releases](https://github.com/YOUR_USERNAME/package-cleaner/releases) page.

### Build from Source

```bash
git clone https://github.com/YOUR_USERNAME/package-cleaner.git
cd package-cleaner
open PackageCleaner.xcodeproj
```

Build and run using Xcode (Cmd+R).

---

## Usage

### Scanning

1. Launch Package Cleaner
2. Click "Scan" to search for package directories
3. Wait for the scan to complete

### Manual Cleanup

1. Select directories you want to remove
2. Click "Delete Selected"
3. Confirm the deletion

### Auto-Cleanup

1. Click "Auto-Cleanup" to find directories older than 6 months
2. Review the list of candidates
3. Confirm to delete all qualifying directories

---

## Privacy

Package Cleaner is designed with privacy in mind:

- No internet connection required
- No telemetry or analytics
- No data leaves your machine
- Open source for full transparency

---

## Documentation

- [Requirements](docs/REQUIREMENTS.md) - Detailed functional and non-functional requirements
- [Architecture](docs/ARCHITECTURE.md) - Technical architecture and design decisions
- [Roadmap](docs/ROADMAP.md) - Development phases and milestones
- [Contributing](docs/CONTRIBUTING.md) - How to contribute to the project

---

## Contributing

Contributions are welcome. Please read the [Contributing Guide](docs/CONTRIBUTING.md) before submitting a pull request.

---

## License

This project is open source. See the [LICENSE](LICENSE) file for details.

---

## Acknowledgments

Inspired by tools like npkill, but built as a native macOS application with broader language support.

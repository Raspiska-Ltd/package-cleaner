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

### Download (Recommended)

1. Download the latest `Package.Cleaner.zip` from the [Releases](https://github.com/Raspiska-Ltd/package-cleaner/releases) page
2. Unzip the file
3. Move `Package Cleaner.app` to your `/Applications` folder
4. Right-click the app and select "Open" on first launch (macOS security requirement)

### Build from Source

```bash
git clone git@github.com:Raspiska-Ltd/package-cleaner.git
cd package-cleaner
swift build -c release
./scripts/build-app.sh
```

The built app will be in `.build/release/Package Cleaner.app`

---

## Usage

### First Time Setup

1. Launch Package Cleaner
2. Open Settings (⌘,) and add directories to scan (e.g., `~/Projects`, `~/Developer`)
3. Configure auto-cleanup threshold (default: 180 days)

### Scanning

1. Click **Scan** (⌘R) to search for package directories
2. Watch live progress showing current directory and found count
3. Results appear automatically with statistics

### Filtering & Sorting

- Use **Language** and **Type** dropdowns to filter results
- Click **Sort** to change order (Name, Size, Date, Language)
- Toggle ascending/descending with the arrow icon
- Use the search bar (⌘F) to find specific projects

### Cleanup

**Manual Selection:**
1. Select individual directories by clicking checkboxes
2. Or use quick actions: **All**, **None**, or **Old** (projects older than threshold)
3. Click **Delete** (⌘⌫) to remove selected directories
4. Confirm deletion - files move to Trash by default

**Keyboard Shortcuts:**
- `⌘R` - Start scan
- `⌘F` - Focus search
- `⌘A` - Select all
- `⌘⌫` - Delete selected
- `⌘,` - Open settings

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

MIT License - see the [LICENSE](LICENSE) file for details.

---

## About

**Package Cleaner** is developed by [Raspiska Ltd](https://raspiska.co?utm_source=github&utm_medium=readme&utm_campaign=package-cleaner), a software development company focused on creating developer tools and productivity applications.

### Links

- 🌐 Website: [raspiska.co](https://raspiska.co?utm_source=github&utm_medium=readme&utm_campaign=package-cleaner)
- 💻 GitHub: [Raspiska-Ltd/package-cleaner](https://github.com/Raspiska-Ltd/package-cleaner)
- 🐛 Issues: [Report a bug](https://github.com/Raspiska-Ltd/package-cleaner/issues)
- 📖 Releases: [Download latest version](https://github.com/Raspiska-Ltd/package-cleaner/releases)

---

## Acknowledgments

Inspired by tools like npkill, but built as a native macOS application with broader language support and modern UI.

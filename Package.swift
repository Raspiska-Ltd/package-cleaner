// swift-tools-version: 5.10
import PackageDescription

let package = Package(
    name: "PackageCleaner",
    platforms: [
        .macOS(.v12)
    ],
    products: [
        .executable(
            name: "PackageCleaner",
            targets: ["PackageCleaner"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/SwiftUIX/SwiftUIX.git", from: "0.2.0"),
        .package(url: "https://github.com/sindresorhus/Defaults.git", from: "7.3.1"),
        .package(url: "https://github.com/sindresorhus/KeyboardShortcuts.git", from: "1.15.0")
    ],
    targets: [
        .executableTarget(
            name: "PackageCleaner",
            dependencies: [
                "SwiftUIX",
                "Defaults",
                "KeyboardShortcuts"
            ],
            path: "PackageCleaner"
        ),
        .testTarget(
            name: "PackageCleanerTests",
            dependencies: ["PackageCleaner"],
            path: "PackageCleanerTests"
        )
    ]
)

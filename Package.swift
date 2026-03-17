// swift-tools-version: 5.9
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
    targets: [
        .executableTarget(
            name: "PackageCleaner",
            path: "PackageCleaner"
        ),
        .testTarget(
            name: "PackageCleanerTests",
            dependencies: ["PackageCleaner"],
            path: "PackageCleanerTests"
        )
    ]
)

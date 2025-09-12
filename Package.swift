// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Tabular",
    platforms: [
        .macOS(.v13),
        .iOS(.v16),
        .watchOS(.v9),
        .tvOS(.v16),
        .visionOS(.v1),
        .macCatalyst(.v13)
    ], products: [
        .library(name: "Tabular", targets: ["Tabular"]),
    ], dependencies: [
        .package(url: "https://github.com/Vaida12345/FinderItem.git", from: "1.0.11")
    ], targets: [
        .target(name: "Tabular", dependencies: ["FinderItem"]),
        .testTarget(name: "TabularTests", dependencies: ["Tabular", "FinderItem"], path: "Tests"),
    ]
)

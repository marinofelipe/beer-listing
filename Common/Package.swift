// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Common",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15)
    ],
    products: [
        .library(
            name: "Common",
            targets: ["Common"]
        )
    ],
    // Ideally should only depend on Foundation
    dependencies: [],
    targets: [
        .target(
            name: "Common",
            dependencies: []
        ),
        .testTarget(
            name: "CommonTests",
            dependencies: ["Common"]
        )
    ]
)

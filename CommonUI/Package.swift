// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CommonUI",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "CommonUI",
            targets: ["CommonUI"]
        )
    ],
    // Ideally should only depend only on SwiftUI/UIKit
    dependencies: [],
    targets: [
        .target(
            name: "CommonUI",
            dependencies: []
        ),
        .testTarget(
            name: "CommonUITests",
            dependencies: ["CommonUI"]
        )
    ]
)

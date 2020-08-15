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
    dependencies: [
        .package(
            name: "SnapshotTesting",
            url: "https://github.com/pointfreeco/swift-snapshot-testing",
            .exact(.init(1, 8, 1))
        )
    ],
    targets: [
        // Ideally should only depend only on SwiftUI/UIKit
        .target(
            name: "CommonUI",
            dependencies: []
        ),
        .testTarget(
            name: "CommonUITests",
            dependencies: [
                "CommonUI",
                .product(name: "SnapshotTesting", package: "SnapshotTesting")
            ],
            resources: [
                .copy("__Snapshots__/LoadingViewSnapshotTests/testWithDefaultContent.1.png"),
                .copy("__Snapshots__/EmptyStateViewSnapshotTests/testWithGenericError.1.png"),
                .copy("__Snapshots__/EmptyStateViewSnapshotTests/testWithOfflineState.1.png"),
                .copy("__Snapshots__/EmptyStateViewSnapshotTests/testWithCustomError.1.png"),
            ]
        )
    ]
)

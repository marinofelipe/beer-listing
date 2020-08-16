// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TestSupport",
    products: [
        .library(
            name: "TestSupport",
            targets: ["TestSupport"]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "TestSupport",
            dependencies: []
        ),
        .testTarget(
            name: "TestSupportTests",
            dependencies: ["TestSupport"],
            resources: [.process("Resources/fixture.json")]
        )
    ]
)

// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DiscoveryFeature",
    products: [
        // Provide the discovery feature module
        .library(
            name: "DiscoveryFeature",
            targets: ["DiscoveryFeature"]
        ),
        // Provide an API to business logic and data layer
        .library(
            name: "DiscoveryRepository",
            targets: ["DiscoveryRepository"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "DiscoveryRepository",
            dependencies: []
        ),
        .testTarget(
            name: "DiscoveryRepositoryTests",
            dependencies: ["DiscoveryRepository"]
        ),
        .target(
            name: "DiscoveryFeature",
            dependencies: ["DiscoveryRepository"]
        ),
        .testTarget(
            name: "DiscoveryFeatureTests",
            dependencies: ["DiscoveryFeature"]
        ),
    ]
)

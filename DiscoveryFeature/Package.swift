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
    dependencies: [
        .package(
            name: "HTTPClient",
            url: "https://github.com/marinofelipe/http_client",
            .exact(.init(0, 0, 4))
        )
    ],
    targets: [
        .target(
            name: "DiscoveryRepository",
            dependencies: [
                .product(name: "HTTPClient", package: "HTTPClient")
            ]
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

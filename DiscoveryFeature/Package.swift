// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DiscoveryFeature",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        // Provide the discovery feature module
        .library(
            name: "DiscoveryFeature",
            targets: ["DiscoveryFeature"]
        )
    ],
    dependencies: [
        .package(
            name: "HTTPClient",
            url: "https://github.com/marinofelipe/http_client",
            .exact(.init(0, 0, 4))
        ),
        .package(name: "Common", path: "../Common"),
        .package(name: "CommonUI", path: "../CommonUI"),
        .package(name: "DiscoveryRepository", path: "../DiscoveryRepository")
    ],
    targets: [
        .target(
            name: "DiscoveryFeature",
            dependencies: [
                "Common",
                "CommonUI",
                "DiscoveryRepository"
            ]
            // TODO: Mention this limitation
        ),
        .testTarget(
            name: "DiscoveryFeatureTests",
            dependencies: ["DiscoveryFeature"]
        ),
    ]
)

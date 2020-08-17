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
        .package(
            name: "Kingfisher",
            url: "https://github.com/onevcat/Kingfisher",
            .exact(.init(5, 14, 1))
        ),
        .package(name: "Common", path: "../Common"),
        .package(name: "CommonUI", path: "../CommonUI"),
        .package(name: "DiscoveryRepository", path: "../DiscoveryRepository"),
        .package(name: "TestSupport", path: "../TestSupport")
    ],
    targets: [
        .target(
            name: "DiscoveryFeature",
            dependencies: [
                "Common",
                "CommonUI",
                "DiscoveryRepository",
                .product(name: "KingfisherSwiftUI", package: "Kingfisher")
            ]
        ),
        .testTarget(
            name: "DiscoveryFeatureTests",
            dependencies: [
                "DiscoveryFeature",
                "TestSupport"
            ]
        ),
    ]
)

// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DiscoveryRepository",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15) // This way the repository can be easily reused for other platforms
    ],
    products: [
        .library(
            name: "DiscoveryRepository",
            targets: [
                "DiscoveryRepository"
            ]
        )
    ],
    dependencies: [
        .package(
            name: "HTTPClient",
            url: "https://github.com/marinofelipe/http_client",
            .exact(.init(0, 0, 4))
        ),
        .package(url: "https://github.com/apple/swift-log.git", from: "1.0.0"),
        .package(name: "TestSupport", path: "../TestSupport")
    ],
    targets: [
        .target(
            name: "DiscoveryRepository",
            dependencies: [
                .product(name: "CombineHTTPClient", package: "HTTPClient")
            ]
        ),
        .testTarget(
            name: "DiscoveryRepositoryTests",
            dependencies: [
                "DiscoveryRepository",
                "TestSupport",
                .product(name: "HTTPClientTestSupport", package: "HTTPClient"),
                .product(name: "Logging", package: "swift-log"),
            ],
            resources: [
                .process("Resources/beer.json"),
                .process("Resources/beersPage.json"),
            ]
        ),
    ]
)

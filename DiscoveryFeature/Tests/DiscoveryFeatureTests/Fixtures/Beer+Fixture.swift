import struct Foundation.URL

import TestSupport

@testable import DiscoveryRepository

extension Fixture {
    static func makeBeerPage() -> [Beer] {
        (0...9).map { _ in makeBeer() }
    }

    private static func makeBeer() -> Beer {
        Beer(
            id: 1,
            name: "name",
            tagline: "tagline",
            description: "description",
            alcoholicStrength: 5.1,
            scaleOfBitterness: nil,
            imageURL: URL(string: "www.someImageURL.com")
        )
    }
}

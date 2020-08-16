import struct Foundation.URL

import TestSupport

@testable import DiscoveryRepository

extension Fixture {
    static func makeArrayOfBeer() -> [Beer] {
        [
            Beer(
                id: 1,
                name: "The beer",
                tagline: "Best beer ever",
                description: "Great beer made by cows in the Swiss Alps",
                alcoholicStrength: 4.5,
                scaleOfBitterness: 50,
                imageURL: URL(string: "www.someImageURL.com")
            ),
            Beer(
                id: 2,
                name: "Yet another beer",
                tagline: "Almost as good as the first beer",
                description: "Made in heaven!",
                alcoholicStrength: 4.3,
                scaleOfBitterness: 34,
                imageURL: URL(string: "www.someImageURL2.com")
            ),
        ]
    }
}

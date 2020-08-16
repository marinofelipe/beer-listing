import struct Foundation.URL

import TestSupport

@testable import DiscoveryFeature

extension Fixture {
    static func makePageOfBeerItemViewModel() -> [BeerItemViewModel] {
        (0...9).map { _ in makeBeerItemViewModel() }
    }

    static func makeBeerItemViewModel() -> BeerItemViewModel {
        BeerItemViewModel(
            id: 1,
            name: "name",
            tagline: "tagline",
            description: "description",
            alcoholicStrengthText: "5.1",
            alcoholicStrengthComplementaryText: " % of alcohol",
            scaleOfBitternessText: nil,
            imageURL: URL(string: "www.someImageURL.com")
        )
    }
}

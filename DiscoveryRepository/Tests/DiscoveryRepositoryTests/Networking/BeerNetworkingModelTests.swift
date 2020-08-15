import XCTest
import TestSupport

@testable import DiscoveryRepository

final class BeerNetworkingModelTests: XCTestCase {

    func testDecode() throws {
        let jsonFixtureData = try FixtureLoader.loadFixture(named: "beer", from: .module)

        let jsonDecoder = JSONDecoder()
        let fixtureBeer = try jsonDecoder.decode(Networking.Beer.self, from: jsonFixtureData)

        let expectedBeer = Networking.Beer(
            id: 1
            name: "The beer",
            tagline: "Best beer ever",
            description: "Great beer made by cows in the Swiss Alps",
            alcoholicStrength: 4.5,
            scaleOfBitterness: 50,
            imageURL: URL(string: "www.someImageURL.com")
        )
        XCTAssertEqual(fixtureBeer, expectedBeer)
    }
}

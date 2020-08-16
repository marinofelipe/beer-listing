import XCTest

@testable import TestSupport

final class TestSupportTests: XCTestCase {

    func testLoadingExistentFixture() throws {
        let jsonFixtureData = try FixtureLoader.loadFixture(named: "fixture", from: .module)

        let jsonDecoder = JSONDecoder()
        let fixture = try jsonDecoder.decode(Fixture.self, from: jsonFixtureData)

        let expectedFixture = Fixture(key: "value")
        XCTAssertEqual(fixture, expectedFixture)
    }

    func testLoadingInexistentFixture() throws {
        XCTAssertThrowsError(try FixtureLoader.loadFixture(named: "someFixture", from: .module))
    }
}

private struct Fixture: Decodable, Equatable {
    let key: String
}

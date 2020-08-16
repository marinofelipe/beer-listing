import XCTest

@testable import Common

final class BuildEnvironmentTests: XCTestCase {
    func test_development_API_host() {
        XCTAssertEqual(BuildEnvironment.development.api, API(host: "api.punkapi.com", port: nil))
    }

    func test_production_API_host() {
        XCTAssertEqual(BuildEnvironment.production.api, API(host: "api.punkapi.com", port: nil))
    }
}

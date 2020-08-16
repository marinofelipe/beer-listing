import XCTest

@testable import DiscoveryRepository

final class BeersNextPageQueryTests: XCTestCase {
    private var sut: BeersNextPageQuery!

    override func setUpWithError() throws {
        try super.setUpWithError()

        sut = .initial
    }

    override func tearDownWithError() throws {
        sut = nil

        try super.tearDownWithError()
    }

    func test_initial() {
        XCTAssertEqual(sut.pageIndex, 1)
    }

    func test_build_next_page_when_last_page_had_items() {
        let nextPageQuery = sut.buildNextPage(withLastPageItemsCount: 1)
        XCTAssertEqual(nextPageQuery, BeersNextPageQuery(pageIndex: 2))
    }

    func test_build_next_page_when_last_page_had_no_items() {
        let nextPageQuery = sut.buildNextPage(withLastPageItemsCount: 0)
        XCTAssertNil(nextPageQuery)
    }
}

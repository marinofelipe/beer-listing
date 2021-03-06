import Combine
import XCTest

import CombineHTTPClient
import HTTPClientCore
import HTTPClientTestSupport
import TestSupport

@testable import DiscoveryRepository

final class DiscoveryRepositoryTests: XCTestCase {
    private var sut: DiscoveryRepository!
    private var httpClient: CombineHTTPClient!
    private var disposeBag: Set<AnyCancellable>! = .init()

    override func setUpWithError() throws {
        try super.setUpWithError()

        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [URLProtocolMock.self]
        let urlSession = URLSession(configuration: configuration)

        httpClient = CombineHTTPClient(session: urlSession)

        let requestBuilder = HTTPRequestBuilder(scheme: .https, host: "www.fakeDomain.com")
        sut = DiscoveryRepository(httpClient: httpClient, requestBuilder: requestBuilder)
    }

    override func tearDownWithError() throws {
        disposeBag.removeAll()
        disposeBag = nil
        httpClient = nil
        sut = nil
        URLProtocolMock.cleanup()

        try super.tearDownWithError()
    }

    // MARK: - Tests - success

    func test_when_http_client_returns_a_successful_valid_response() throws {
        let runExpectation = expectation(description: "Client to run over mocked URLSession")

        let beerListDataFixture = try FixtureLoader.loadFixture(named: "beersPage", from: .module)

        let url = try XCTUnwrap(URL(string: "https://www.fakeDomain.com/beers/?page=1&per_page=10"))

        URLProtocolMock.stubbedRequestHandler = { request in
            let response = try XCTUnwrap(HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil))
            return (response, beerListDataFixture)
        }

        var capturedValue: Page<[Beer], BeersNextPageQuery?>?
        try sut.fetchList(nextPageQuery: .initial, receiveOn: .main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case let .failure(error):
                    XCTFail("Received an error completion: \(error.localizedDescription)")
                case .finished: break
                }
            }) { value in
                capturedValue = value
                runExpectation.fulfill()
            }.store(in: &disposeBag)

        wait(for: [runExpectation], timeout: 0.5)

        let expectedValue = Fixture.makeArrayOfBeer()
        XCTAssertEqual(capturedValue?.data, expectedValue)

        XCTAssertEqual(capturedValue?.nextPageQuery, BeersNextPageQuery(pageIndex: 2))

        XCTAssertEqual(URLProtocolMock.startLoadingCallsCount, 1)
        XCTAssertEqual(URLProtocolMock.stopLoadingCallsCount, 1)
    }

    // MARK: - Tests - failure

    func test_when_http_client_returns_a_failure_404_response() throws {
        let runExpectation = expectation(description: "Client to run over mocked URLSession")

        let url = try XCTUnwrap(URL(string: "https://www.fakeDomain.com/beers/?page=1&per_page=10"))

        URLProtocolMock.stubbedRequestHandler = { request in
            let response = try XCTUnwrap(HTTPURLResponse(url: url, statusCode: 404, httpVersion: nil, headerFields: nil))
            return (response, nil)
        }

        var capturedError: DiscoveryRepositoryError?
        try sut.fetchList(nextPageQuery: .initial, receiveOn: .main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case let .failure(error):
                    capturedError = error
                case .finished: break
                }
                runExpectation.fulfill()
            }) { value in
                XCTFail("Received a value: \(value)")
            }.store(in: &disposeBag)

        wait(for: [runExpectation], timeout: 0.5)

        XCTAssertEqual(capturedError, .unableToLoad)
        XCTAssertEqual(URLProtocolMock.startLoadingCallsCount, 1)
        XCTAssertEqual(URLProtocolMock.stopLoadingCallsCount, 1)
    }

    func test_when_http_client_returns_a_not_connected_url_error() throws {
        let runExpectation = expectation(description: "Client to run over mocked URLSession")

        URLProtocolMock.stubbedError = URLError(.notConnectedToInternet)

        var capturedError: DiscoveryRepositoryError?
        try sut.fetchList(nextPageQuery: .initial, receiveOn: .main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case let .failure(error):
                    capturedError = error
                case .finished: break
                }
                runExpectation.fulfill()
            }) { value in
                XCTFail("Received a value: \(value)")
            }.store(in: &disposeBag)

        wait(for: [runExpectation], timeout: 0.5)

        XCTAssertEqual(capturedError, .offline)
        XCTAssertEqual(URLProtocolMock.startLoadingCallsCount, 1)
        XCTAssertEqual(URLProtocolMock.stopLoadingCallsCount, 1)
    }
}

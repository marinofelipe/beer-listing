import Combine
import XCTest

import TestSupport

@testable import DiscoveryFeature
@testable import DiscoveryRepository

final class DiscoveryViewModelTests: XCTestCase {
    private var sut: DiscoveryViewModel!
    private var subject: PassthroughSubject<Page<[Beer], BeersNextPageQuery?>, DiscoveryRepositoryError>!
    private var repositoryMock: DiscoveryRepositoryMock!
    private var observedValues: [DiscoveryViewState]!
    private var cancellable: Any?

    override func setUpWithError() throws {
        try super.setUpWithError()

        observedValues = []
        subject = PassthroughSubject()
        repositoryMock = DiscoveryRepositoryMock(subject: subject)
        sut = DiscoveryViewModel(
            initialState: .initial,
            repository: repositoryMock
        )
        observeValues()
    }

    override func tearDownWithError() throws {
        observedValues = nil
        subject = nil
        repositoryMock = nil
        sut = nil

        try super.tearDownWithError()
    }

    func test_when_on_appear_action_is_sent() {
        sut.send(.onAppear)
        validateForWhenContentIsInitiallyLoaded()
    }

    func test_when_on_retry_tap_action_is_sent() {
        sut.send(.onRetryTap)
        validateForWhenContentIsInitiallyLoaded()
    }

    func test_when_item_on_appear_action_is_sent_below_threshold() {
        // Create a new instance with loaded items
        sut = DiscoveryViewModel(
            initialState: DiscoveryViewState(
                state: .loaded(Fixture.makePageOfBeerItemViewModel())
            ),
            repository: repositoryMock
        )

        // Observe the values emitted by it
        observeValues()

        // Send on appear event for item with index below threshold
        sut.send(.beerItem(index: 2, action: .onAppear))

        // Then
        XCTAssertEqual(observedValues, [])
        XCTAssertEqual(repositoryMock.fetchListCallsCount, 0)
    }

    func test_when_item_on_appear_action_is_sent_equal_threshold() {
        // Create a new instance with loaded items
        sut = DiscoveryViewModel(
            initialState: DiscoveryViewState(
                state: .loaded(Fixture.makePageOfBeerItemViewModel()),
                isFirstPageLoaded: true
            ),
            repository: repositoryMock
        )

        // Observe the values emitted by it
        observeValues()

        // Send on appear event for item with index below threshold
        sut.send(.beerItem(index: 6, action: .onAppear))

        // Then
        XCTAssertEqual(
            observedValues,
            [
                DiscoveryViewState(
                    state: .loaded(Fixture.makePageOfBeerItemViewModel()),
                    isFirstPageLoaded: true,
                    isPageRequestInFlight: true
                )
            ]
        )

        // Simulate repository emitting page of data
        let page = Page<[Beer], BeersNextPageQuery?>(data: Fixture.makeBeerPage(), nextPageQuery: nil)
        subject.send(page)

        // Then
        XCTAssertEqual(repositoryMock.fetchListCallsCount, 1)
        XCTAssertEqual(
            observedValues,
            [
                DiscoveryViewState(
                    state: .loaded(Fixture.makePageOfBeerItemViewModel()),
                    isFirstPageLoaded: true,
                    isPageRequestInFlight: true
                ),
                DiscoveryViewState(
                    state: .loaded(Fixture.makePageOfBeerItemViewModel()),
                    isFirstPageLoaded: true,
                    isPageRequestInFlight: false
                ),
                DiscoveryViewState(
                    state: .loaded(
                        Fixture.makePageOfBeerItemViewModel() + Fixture.makePageOfBeerItemViewModel()
                    ),
                    isFirstPageLoaded: true,
                    isPageRequestInFlight: false
                ),
            ]
        )
    }
}

// MARK: - Helpers

extension DiscoveryViewModelTests {

    func observeValues() {
        cancellable = sut.viewState.sink { [unowned self] viewState in
            self.observedValues.append(viewState)
        }
    }

    func validateForWhenContentIsInitiallyLoaded() {
        // Verify if loading states are emitted before repository emitting the page data
        XCTAssertEqual(
            observedValues,
            [
                DiscoveryViewState(state: .loading),
                DiscoveryViewState(state: .loading, isFirstPageLoaded: false, isPageRequestInFlight: true),
            ]
        )

        // Simulate repository emitting page of data
        let page = Page<[Beer], BeersNextPageQuery?>(data: Fixture.makeBeerPage(), nextPageQuery: nil)
        subject.send(page)

        // Then
        XCTAssertEqual(repositoryMock.fetchListCallsCount, 1)
        XCTAssertEqual(
            observedValues,
            [
                DiscoveryViewState(state: .loading),
                DiscoveryViewState(state: .loading, isFirstPageLoaded: false, isPageRequestInFlight: true),
                DiscoveryViewState(state: .loading),
                DiscoveryViewState(
                    state: .loaded(Fixture.makePageOfBeerItemViewModel()),
                    isFirstPageLoaded: true,
                    isPageRequestInFlight: false
                )
            ]
        )
    }
}

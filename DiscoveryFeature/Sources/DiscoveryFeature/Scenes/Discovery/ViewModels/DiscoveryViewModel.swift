import Combine
import Foundation

import DiscoveryRepository

protocol DiscoveryViewModelInterface {
    var viewState: PassthroughSubject<DiscoveryViewState, Never> { get }
    func send(_ action: DiscoveryAction)
}

final class DiscoveryViewModel: DiscoveryViewModelInterface {
    var viewState: PassthroughSubject<DiscoveryViewState, Never>
    private var _viewState: DiscoveryViewState {
        didSet {
            viewState.send(_viewState)
        }
    }

    private var nextPageQuery: BeersNextPageQuery? = .initial
    private let repository: DiscoveryRepositoryInterface
    private var cancellable: Any?

    init(
        initialState: DiscoveryViewState = .initial,
        repository: DiscoveryRepositoryInterface
    ) {
        self._viewState = initialState
        self.viewState = PassthroughSubject()
        self.repository = repository
    }

    func send(_ action: DiscoveryAction) {
        switch action {
        case .onAppear, .onRetryTap:
            guard _viewState.isFirstPageLoaded == false else { return }
            _viewState.state = .loading
            fetchNextPage()
        case let .beerItem(index, action):
            switch action {
            case .onAppear:
                guard let items = _viewState.items else { return }
                let thresholdIndex = items.index(items.endIndex, offsetBy: -4)
                if index == thresholdIndex {
                    fetchNextPage()
                }
            case .onTap:
                // could e.g. call a tracker to collect data about the user event
                debugPrint("Did tap item at index: \(index)")
            case .onLongPress:
                // could e.g. save item at favorites by calling repository
                debugPrint("Did long press item at index: \(index)")
            }
        }
    }

    private func fetchNextPage() {
        guard let nextPageQuery = nextPageQuery, _viewState.isPageRequestInFlight == false else { return }
        _viewState.isPageRequestInFlight = true

        cancellable = try? repository.fetchList(nextPageQuery: nextPageQuery, receiveOn: .main)
            .sink { [weak self] completion in
                guard let self = self else { return }

                self._viewState.isPageRequestInFlight = false

                guard case let .failure(error) = completion else { return }

                self._viewState.state = .error(DiscoveryViewState.map(error: error))
            } receiveValue: { [weak self] page in
                self?._viewState.isPageRequestInFlight = false
                self?.nextPageQuery = page.nextPageQuery as? BeersNextPageQuery

                let allItemViewModel: [BeerItemViewModel]
                let lastPageOfItemsViewModel = page.data.map(BeerItemViewModel.init(from:))
                if var renderedItems = self?._viewState.items {
                    renderedItems.append(contentsOf: lastPageOfItemsViewModel)
                    allItemViewModel = renderedItems
                } else {
                    allItemViewModel = lastPageOfItemsViewModel
                }

                self?._viewState.state = .loaded(allItemViewModel)
            }
    }
}

extension DiscoveryViewState {
    static func map(error: DiscoveryRepositoryError) -> Error {
        switch error {
        case .offline: return .offline
        case .unableToLoad: return .unableToLoad
        }
    }
}

#if DEBUG
struct DiscoveryViewModelFake: DiscoveryViewModelInterface {
    var viewState = PassthroughSubject<DiscoveryViewState, Never>()

    func send(_ action: DiscoveryAction) {
        switch action {
        case .onAppear, .onRetryTap:
            viewState.send(.initial)
            viewState.send(
                .init(
                    state: .loaded([]),
                    isFirstPageLoaded: true,
                    isPageRequestInFlight: false
                )
            )
        case let .beerItem(_, action):
            switch action {
            case .onAppear:
                viewState.send(
                    .init(
                        state: .loaded([]),
                        isFirstPageLoaded: true,
                        isPageRequestInFlight: false
                    )
                )
            case .onLongPress, .onTap: break
            }
        }
    }
}
#endif

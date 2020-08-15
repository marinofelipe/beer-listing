import Combine
import Foundation

import DiscoveryRepository

public final class DiscoveryViewModel: ObservableObject {
    @Published private(set) var viewState: DiscoveryViewState
    private var nextPageQuery: BeersNextPageQuery? = .initial

    private let repository: DiscoveryRepositoryInterface
    private var cancellable: Any?

    public init(
        initialState: DiscoveryViewState,
        repository: DiscoveryRepositoryInterface
    ) {
        self.viewState = initialState
        self.repository = repository
    }

    func send(_ action: DiscoveryAction) {
        switch action {
        case .onAppear:
            guard viewState.isFirstPageLoaded == false else { return }
            viewState.state = .loading
            fetchNextPage()
        case .onRetryTap:
            fetchNextPage()
        case let .beerItem(index, action):
            switch action {
            case .onAppear:
                guard let items = viewState.items else { return }
                let thresholdIndex = items.index(items.endIndex, offsetBy: -4)
                if index == thresholdIndex {
                    fetchNextPage()
                }
            default: break
            }
        }
    }

    private func fetchNextPage() {
        guard let nextPageQuery = nextPageQuery, viewState.isPageRequestInFlight == false else { return }
        viewState.isPageRequestInFlight = true

        cancellable = try? repository.fetchList(nextPageQuery: nextPageQuery, receiveOn: .main)
            .delay(for: viewState.isFirstPageLoaded ? 0 : 1, scheduler: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self = self else { return }

                self.viewState.isPageRequestInFlight = false

                guard case let .failure(error) = completion else { return }

                self.viewState.state = .error(DiscoveryViewState.map(error: error))
            } receiveValue: { [weak self] page in
                self?.viewState.isPageRequestInFlight = false
                self?.nextPageQuery = page.nextPageQuery as? BeersNextPageQuery

                let allItemViewModel: [BeerItemViewModel]
                let lastPageOfItemsViewModel = page.data.map(BeerItemViewModel.init(from:))
                if var renderedItems = self?.viewState.items {
                    renderedItems.append(contentsOf: lastPageOfItemsViewModel)
                    allItemViewModel = renderedItems
                } else {
                    allItemViewModel = lastPageOfItemsViewModel
                }

                self?.viewState.state = .loaded(allItemViewModel)
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

import Combine
import Foundation

import DiscoveryRepository

public final class DiscoveryViewModel: ObservableObject {
    @Published private(set) var viewState: DiscoveryViewState
    private var nextPageQuery: BeersNextPageQuery = .initial

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
        case .onAppear, .onRetryTap:
            fetchData()
        case let .onItemTap(index):
            debugPrint("Tapped at item index \(index)")
        }
    }

    private func fetchData() {
        self.viewState.state = .loading

        cancellable = try? repository.fetchList(nextPageQuery: nextPageQuery, receiveOn: .main)
            .delay(for: viewState.isFirstPageLoaded ? 0 : 1, scheduler: DispatchQueue.main)
            .sink { [weak self] completion in
                guard
                    let self = self,
                    case let .failure(error) = completion
                else { return }

                self.viewState.state = .error(DiscoveryViewState.map(error: error))
            } receiveValue: { [weak self] page in
                self?.nextPageQuery = page.nextPageQuery
                self?.viewState.state = .loaded(page.data.map(BeerItemViewModel.init(from:)))
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

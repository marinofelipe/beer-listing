import CommonUI
import SwiftUI

protocol DiscoveryCoordinatorInterface {
    func presentDetailView(for itemViewModel: BeerItemViewModel) -> BeerDetailView
}

final class DiscoveryCoordinator: Coordinator, DiscoveryCoordinatorInterface {
    private let environment: DiscoveryEnvironment

    init(environment: DiscoveryEnvironment) {
        self.environment = environment
    }

    func start() -> AnyView {
        let viewModel = DiscoveryViewModel(initialState: DiscoveryViewState.initial, repository: environment.repository)
        let viewStore = DiscoveryViewStore(viewModel: viewModel, coordinator: self)

        return DiscoveryView(viewStore: viewStore)
            .erase()
    }

    func presentDetailView(for itemViewModel: BeerItemViewModel) -> BeerDetailView {
        BeerDetailView(viewModel: itemViewModel)
    }
}

#if DEBUG
struct DiscoveryCoordinatorFake: DiscoveryCoordinatorInterface {
    func presentDetailView(for itemViewModel: BeerItemViewModel) -> BeerDetailView {
        BeerDetailView(viewModel: itemViewModel)
    }
}
#endif

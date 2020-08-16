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
        BeerDetailView(viewModel:
            BeerDetailViewModel(
                imageURL: itemViewModel.imageURL,
                name: itemViewModel.name,
                tagline: itemViewModel.tagline,
                description: itemViewModel.description
            )
        )
    }
}

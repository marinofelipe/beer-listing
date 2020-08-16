import Combine
import SwiftUI

/// Acts as a `observable view store`.
/// It hides the view model underneath, and creates a `bridge between UI and View Model`.
/// By doing that it can also `retain and communicate with the Coordinator`, to let it
/// construct views for navigation, `without leaking dependencies and UI logic to the view model`,
/// and keeping the `data flow more predictable`.
final class DiscoveryViewStore: ObservableObject {
    @Published var viewState: DiscoveryViewState = .initial

    private let viewModel: DiscoveryViewModelInterface
    private let coordinator: DiscoveryCoordinatorInterface

    private var cancellable: Any?

    init(
        viewModel: DiscoveryViewModelInterface,
        coordinator: DiscoveryCoordinatorInterface
    ) {
        self.viewModel = viewModel
        self.coordinator = coordinator

        bindToViewModel()
    }

    func send(_ action: DiscoveryAction) {
        viewModel.send(action)
    }

    func detailView(for item: BeerItemViewModel) -> BeerDetailView {
        coordinator.presentDetailView(for: item)
    }
}

private extension DiscoveryViewStore {
    func bindToViewModel() {
        cancellable = viewModel.viewState.eraseToAnyPublisher().sink { viewState in
            self.viewState = viewState
        }
    }
}

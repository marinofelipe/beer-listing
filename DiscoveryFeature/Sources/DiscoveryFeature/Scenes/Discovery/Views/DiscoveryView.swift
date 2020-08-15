import SwiftUI
import CommonUI

public struct DiscoveryView: View {
    @ObservedObject private var viewModel: DiscoveryViewModel

    public init(viewModel: DiscoveryViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        NavigationView {
            withAnimation {
                containedView
                    .navigationBarTitle(
                        Text("discovery_feature_list_title", bundle: .module)
                    )
            }
        }
        .onAppear {
            viewModel.send(.onAppear)
        }
    }

    private var containedView: some View {
        switch viewModel.viewState.state {
        case let .error(error):
            return EmptyStateView(
                state: EmptyStateViewState.init(from: error),
                onRetry: {
                    viewModel.send(.onRetryTap)
                }
            )
            .erase()
        case .loading:
            return LoadingView()
                .erase()
        case let .loaded(items):
            return List(items) { item in
//                NavigationLink(
//                    destination: BeerDetailView(
//                        viewModel: BeerDetailViewModel(
//                            imageURL: item.imageURL,
//                            name: item.name,
//                            tagline: item.tagline,
//                            description: item.description
//                        )
//                    )
//                ) {
                    BeerCell(viewModel: item)
//                    // TODO: Add long press to show context menu - add to favorites
//                }
            }
            .erase()
        }
    }
}

#if DEBUG
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        DiscoveryView(
//            viewModel: DiscoveryViewModel(
//                initialState: DiscoveryViewState(state: .loading, page: 0),
//                repository: BeerRepositor
//            )
//        )
//    }
//}
#endif

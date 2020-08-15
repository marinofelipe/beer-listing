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
                Group {
                    containedView
                        .navigationBarTitle(
                            Text("discovery_feature_list_title", bundle: .module)
                        )
                }
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
            let enumeratedItems = Array(zip(items.indices, items))
            return List {
                ForEach(enumeratedItems, id: \.0) { index, item in
                    BeerCell(viewModel: item)
                        .onAppear {
                            viewModel.send(
                                .beerItem(index: index, action: .onAppear)
                            )
                        }
//                    // TODO: Add long press to show context menu - add to favorites
                }
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

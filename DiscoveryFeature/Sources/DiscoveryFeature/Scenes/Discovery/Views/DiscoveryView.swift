import SwiftUI
import CommonUI

struct DiscoveryView: View {
    @ObservedObject private var viewStore: DiscoveryViewStore

    init(viewStore: DiscoveryViewStore) {
        self.viewStore = viewStore
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
            viewStore.send(.onAppear)
        }
    }

    private var containedView: some View {
        switch viewStore.viewState.state {
        case let .error(error):
            return EmptyStateView(
                state: EmptyStateViewState.init(from: error),
                onRetry: {
                    viewStore.send(.onRetryTap)
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
                    NavigationLink(destination: viewStore.detailView(for: item)) {
                        BeerCell(viewModel: item)
                            .onAppear {
                                viewStore.send(
                                    .beerItem(index: index, action: .onAppear)
                                )
                            }
                            .contextMenu {
                                Text("Add to favorites")
                            }
                            // TODO: Add long press to show context menu - add to favorites
                    }
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

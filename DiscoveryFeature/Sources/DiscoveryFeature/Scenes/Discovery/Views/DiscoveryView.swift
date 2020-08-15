//
//  DiscoveryView.swift
//  BeerApp
//
//  Created by Marino Felipe on 11.08.20.
//

import SwiftUI
import CommonUI

public struct DiscoveryView: View {
    @ObservedObject private var viewModel: DiscoveryViewModel

    public init(viewModel: DiscoveryViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        NavigationView {
            containedView
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
                NavigationLink(
                    destination: BeerDetailView(
                        viewModel: BeerDetailViewModel(
                            imageURL: item.imageURL,
                            name: item.name,
                            tagline: item.tagline,
                            description: item.description
                        )
                    )
                ) {
                    Text(item.name)
                    // TODO: Add long press to show context menu - add to favorites
                }
            }
            .navigationBarTitle(
                Text("discovery_feature_list_title", bundle: .module)
            )
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

extension EmptyStateViewState {
    init(from discoveryError: DiscoveryViewState.Error) {
        switch discoveryError {
        case .offline: self = .offline
        case .unableToLoad: self = .genericError
        }
    }
}

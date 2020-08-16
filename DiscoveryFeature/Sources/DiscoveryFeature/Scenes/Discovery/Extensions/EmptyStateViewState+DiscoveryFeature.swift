import CommonUI

extension EmptyStateViewState {
    init(from discoveryError: DiscoveryViewState.Error) {
        switch discoveryError {
        case .offline: self = .offline
        case .unableToLoad: self = .genericError
        }
    }
}

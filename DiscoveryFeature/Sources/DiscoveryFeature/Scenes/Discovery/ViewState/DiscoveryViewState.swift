public struct DiscoveryViewState: Equatable {
    enum Error: Equatable {
        case offline
        case unableToLoad
    }

    enum ViewState: Equatable {
        case loaded([BeerItemViewModel])
        case loading
        case error(_ error: Error)
    }

    var state: ViewState {
        didSet {
            switch state {
            case .loaded:
                isFirstPageLoaded = true
            default: break
            }
        }
    }
    var isFirstPageLoaded: Bool = false
    var isPageRequestInFlight: Bool = false

    var items: [BeerItemViewModel]? {
        guard case let .loaded(items) = state else { return nil }
        return items
    }

    static var initial: DiscoveryViewState {
        DiscoveryViewState(state: .loading)
    }
}

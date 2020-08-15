public struct DiscoveryViewState {
    enum Error {
        case offline
        case unableToLoad
    }

    enum ViewState {
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

    static var initial: DiscoveryViewState {
        DiscoveryViewState(state: .loading)
    }
}

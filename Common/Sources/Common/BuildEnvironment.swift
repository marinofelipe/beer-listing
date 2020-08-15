public enum BuildEnvironment: Equatable {
    case development
    case production

    public var api: API {
        switch self {
        case .development, .production:
            return API(host: "api.punkapi.com", port: nil)
        }
    }
}

// MARK: - API

public struct API: Equatable {
    public let host: String
    public let port: Int?
}

// MARK: - Provider

public struct BuildEnvironmentProvider {

    public static let current: BuildEnvironment = {
        #if DEBUG
        return .development
        #else
        return .production
        #endif
    }()
}

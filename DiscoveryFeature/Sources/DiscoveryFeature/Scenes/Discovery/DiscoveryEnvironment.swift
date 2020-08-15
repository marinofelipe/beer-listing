import Foundation
import Common
import CombineHTTPClient
import DiscoveryRepository
import HTTPClientCore
import SwiftUI

public protocol DiscoveryEnvironmentFlowFactory {
    func makeStartingView() -> AnyView
}

public struct DiscoveryEnvironment: DiscoveryEnvironmentFlowFactory {
    let repository: DiscoveryRepositoryInterface

    public init(
        httpRequestBuilder: HTTPRequestBuilder = .default,
        httpClient: CombineHTTPClient = .init(session: .shared)
    ) {
        self.repository = DiscoveryRepository(
            httpClient: httpClient,
            requestBuilder: httpRequestBuilder
        )
    }

    public func makeStartingView() -> AnyView {
        DiscoveryView(
            viewModel: DiscoveryViewModel(
                initialState: DiscoveryViewState.initial,
                repository: repository
            )
        ).erase()
    }
}

public extension HTTPRequestBuilder {
    static let `default`: HTTPRequestBuilder = {
        HTTPRequestBuilder(
            scheme: .https,
            host: BuildEnvironmentProvider.current.api.host
        )
    }()
}

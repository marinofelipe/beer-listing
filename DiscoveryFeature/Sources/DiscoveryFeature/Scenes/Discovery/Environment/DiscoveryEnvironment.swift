import Foundation
import Common
import CommonUI
import CombineHTTPClient
import DiscoveryRepository
import HTTPClientCore
import SwiftUI

public protocol DiscoveryEnvironmentFlowFactory {
    func makeCoordinator() -> Coordinator
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

    public func makeCoordinator() -> Coordinator {
        DiscoveryCoordinator(environment: self)
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


//public struct DiscoveryEnvironmentProvider {
//    public static let current: BuildEnvironment = {
//        #if DEBUG
//        return .development
//        #else
//        return .production
//        #endif
//    }()
//}


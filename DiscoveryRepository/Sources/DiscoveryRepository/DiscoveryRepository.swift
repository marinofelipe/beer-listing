import Foundation
import Combine

import CombineHTTPClient
import HTTPClientCore
import Logging

// MARK: - Interface

public protocol DiscoveryRepositoryInterface {
    func fetchList(
        nextPageQuery: BeersNextPageQuery,
        receiveOn queue: DispatchQueue
    ) throws -> AnyPublisher<Page<[Beer], BeersNextPageQuery>, DiscoveryRepositoryError>
}

// MARK: - Error

public enum DiscoveryRepositoryError: Swift.Error, LocalizedError {
    case offline, unableToLoad

    static func map(error: Swift.Error) -> DiscoveryRepositoryError {
        guard let httpResponseError = error as? HTTPResponseError else {
            return .unableToLoad
        }

        switch httpResponseError {
        case let .underlying(urlError):
            if urlError.code == .notConnectedToInternet {
                return .offline
            }
            return .unableToLoad
        case .decoding, .invalidResponse, .unknown:
            return .unableToLoad
        }
    }
}

// MARK: - Concrete

public final class DiscoveryRepository: DiscoveryRepositoryInterface {
    private let httpClient: CombineHTTPClient
    private var requestBuilder: HTTPRequestBuilder
    private let successDecoder: JSONDecoder
    private let itemsPerPage: Int
    private let logger = Logger(label: "com.BeerApp.DiscoveryRepository")

    public init(
        httpClient: CombineHTTPClient,
        requestBuilder: HTTPRequestBuilder,
        successDecoder: JSONDecoder = .default,
        itemsPerPage: Int = 10
    ) {
        self.httpClient = httpClient
        self.requestBuilder = requestBuilder
        self.successDecoder = successDecoder
        self.itemsPerPage = itemsPerPage
    }

    public func fetchList(
        nextPageQuery: BeersNextPageQuery,
        receiveOn queue: DispatchQueue = .global(qos: .userInteractive)
    ) throws -> AnyPublisher<Page<[Beer], BeersNextPageQuery>, DiscoveryRepositoryError> {
        try fetchListFromRemote(page: nextPageQuery.pageIndex, receiveOn: queue)
            .tryMap { [logger] httpResponse -> Page<[Beer], BeersNextPageQuery> in
                switch httpResponse.value {
                case let .success(beers):
                    logger.log(level: .debug, Logger.Message(stringLiteral: httpResponse.debugDescription))

                    let repositoryBeers = beers
                        .filter { $0.alcoholicStrength <= 5 } /// **business rule**: *filter out beers that are too alcoholic*
                        .map(Beer.init(from:))

                    var nextPageQuery = nextPageQuery
                    nextPageQuery.incrementPage()
                    return Page(data: repositoryBeers, nextPageQuery: nextPageQuery)
                case .failure:
                    logger.log(level: .error, Logger.Message(stringLiteral: httpResponse.debugDescription))
                    throw DiscoveryRepositoryError.unableToLoad
                }
            }
            .mapError { [weak self] error -> DiscoveryRepositoryError in
                if let httpResponseError = error as? HTTPResponseError {
                    self?.log(httpResponseError)
                }

                return DiscoveryRepositoryError.map(error: error)
            }
            .eraseToAnyPublisher()
    }

    private func fetchListFromRemote(
        page: Int,
        receiveOn queue: DispatchQueue
    ) throws -> AnyPublisher<HTTPResponse<[Networking.Beer], EmptyBody>, HTTPResponseError> {
        let builder = requestBuilder
            .method(.get)
            .path("/v2/beers")
            .queryItems(
                [
                    URLQueryItem(name: "page", value: "\(page)"),
                    URLQueryItem(name: "per_page", value: "\(itemsPerPage)")
                ]
            )
        let request = try builder.build()

        return httpClient
            .run(request, successDecoder: successDecoder, receiveOn: queue)
            .eraseToAnyPublisher()
    }

    private func log(_ httpResponseError: HTTPResponseError) {
        switch httpResponseError {
        case let .decoding(error):
            self.logger.error(Logger.Message.init(stringLiteral: error.localizedDescription))
        case let .underlying(error):
            self.logger.debug(Logger.Message.init(stringLiteral: error.localizedDescription))
        case let .invalidResponse(response):
            self.logger.debug("Received invalid response \(response)")
        default: break
        }
    }
}

// MARK: - Default JSON decoder

public extension JSONDecoder {
    static let `default`: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .iso8601
        return jsonDecoder
    }()
}

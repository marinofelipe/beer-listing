import Combine
import Foundation

import DiscoveryRepository

final class DiscoveryRepositoryMock: DiscoveryRepositoryInterface {
    private let subject: PassthroughSubject<Page<[Beer], BeersNextPageQuery?>, DiscoveryRepositoryError>
    private(set) var fetchListCallsCount = 0

    init(subject: PassthroughSubject<Page<[Beer], BeersNextPageQuery?>, DiscoveryRepositoryError>) {
        self.subject = subject
    }

    func fetchList(
        nextPageQuery: BeersNextPageQuery,
        receiveOn queue: DispatchQueue
    ) throws -> AnyPublisher<Page<[Beer], BeersNextPageQuery?>, DiscoveryRepositoryError> {
        fetchListCallsCount += 1

        return subject.eraseToAnyPublisher()
    }
}

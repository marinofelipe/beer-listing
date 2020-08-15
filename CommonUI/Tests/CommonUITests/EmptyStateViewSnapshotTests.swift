import XCTest

import SnapshotTesting

@testable import CommonUI

final class EmptyStateViewSnapshotTests: XCTestCase {

    func testWithGenericError() {
        let sut = EmptyStateView(state: .genericError, onRetry: { })
        assertSnapshot(matching: sut, as: .image, record: false)
    }

    func testWithOfflineState() {
        let sut = EmptyStateView(state: .offline, onRetry: { })
        assertSnapshot(matching: sut, as: .image, record: false)
    }

    func testWithCustomError() {
        let sut = EmptyStateView(state: .customError(message: "Some message"), onRetry: { })
        assertSnapshot(matching: sut, as: .image, record: false)
    }
}

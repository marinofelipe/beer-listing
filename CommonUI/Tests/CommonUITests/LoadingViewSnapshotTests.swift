import XCTest

import SnapshotTesting

@testable import CommonUI

final class LoadingViewSnapshotTests: XCTestCase {

    func testWithDefaultContent() {
        let sut = LoadingView()

        assertSnapshot(matching: sut, as: .image, record: false)
    }
}

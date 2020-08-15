import Foundation
import XCTest

@testable import Common

final class DateFormatterTests: XCTestCase {

    func test_long_style_date_formatter() {
        let dateFormatter = DateFormatter.longStyle
        let date = Date.distantFuture
        let formattedDate = dateFormatter.string(from: date)

        XCTAssertEqual(formattedDate, "January 1, 4001")
    }
}

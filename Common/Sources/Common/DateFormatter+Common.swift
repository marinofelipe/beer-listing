import class Foundation.DateFormatter

public extension DateFormatter {
    static let longStyle: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        return dateFormatter
    }()
}

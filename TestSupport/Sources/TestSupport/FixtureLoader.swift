import XCTest

public struct FixtureLoader {
    public enum Error: Swift.Error {
        case failed(reason: String, file: StaticString, line: UInt)
    }

    public static func loadFixture(
        named name: String,
        extension: String = "json",
        from bundle: Bundle,
        _ file: StaticString = #filePath,
        _ line: UInt = #line
    ) throws -> Data {
        do {
            let optionalData = try fixtureURL(named: name, from: bundle).flatMap { try Data(contentsOf: $0) }
            guard let data = optionalData else {
                let failureReason = "Fixture \(name) could not be loaded"
                throw Error.failed(reason: failureReason, file: file, line: line)
            }

            return data
        } catch {
            throw Error.failed(reason: String(describing: error), file: file, line: line)
        }
    }

    private static func fixtureURL(
        named name: String,
        extension: String = "json",
        from bundle: Bundle
    ) -> URL? {
        bundle.url(forResource: name, withExtension: `extension`)
    }
}

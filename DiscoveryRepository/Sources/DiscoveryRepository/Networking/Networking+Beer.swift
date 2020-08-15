import struct Foundation.URL

extension Networking {
    struct Beer: Decodable, Equatable {
        let id: Int
        let name: String
        let tagline: String
        let description: String
        let alcoholicStrength: Double
        let scaleOfBitterness: Double
        let imageURL: URL?

        private enum CodingKeys: String, CodingKey {
            case id
            case name
            case tagline
            case description
            case alcoholicStrength = "abv"
            case scaleOfBitterness = "ibu"
            case imageURL = "image_url"
        }
    }
}

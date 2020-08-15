import struct Foundation.URL

// Repository type
public struct Beer: Equatable {
    public let id: Int
    public let name: String
    public let tagline: String
    public let description: String
    public let alcoholicStrength: Double
    public let scaleOfBitterness: Double
    public let imageURL: URL?
}

extension Beer {
    init(from networkingBeer: Networking.Beer) {
        self.init(
            id: networkingBeer.id,
            name: networkingBeer.name,
            tagline: networkingBeer.tagline,
            description: networkingBeer.description,
            alcoholicStrength: networkingBeer.alcoholicStrength,
            scaleOfBitterness: networkingBeer.scaleOfBitterness,
            imageURL: networkingBeer.imageURL
        )
    }
}

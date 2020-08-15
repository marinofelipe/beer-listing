import struct Foundation.URL
import struct DiscoveryRepository.Beer

struct BeerItemViewModel: Equatable, Identifiable {
    let id: Int
    let name: String
    let tagline: String
    let description: String
    let alcoholicStrength: Double
    let scaleOfBitterness: Double
    let imageURL: URL?
}

extension BeerItemViewModel {
    init(from repositoryBeer: DiscoveryRepository.Beer) {
        self.init(
            id: repositoryBeer.id,
            name: repositoryBeer.name,
            tagline: repositoryBeer.tagline,
            description: repositoryBeer.description,
            alcoholicStrength: repositoryBeer.alcoholicStrength,
            scaleOfBitterness: repositoryBeer.scaleOfBitterness,
            imageURL: repositoryBeer.imageURL
        )
    }
}

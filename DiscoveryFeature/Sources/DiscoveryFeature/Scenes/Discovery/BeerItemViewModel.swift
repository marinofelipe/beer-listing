import struct Foundation.URL
import struct DiscoveryRepository.Beer

struct BeerItemViewModel: Equatable, Identifiable {
    let id: Int
    let name: String
    let tagline: String
    let description: String
    let alcoholicStrengthText: String
    let alcoholicStrengthComplementaryText: String
    let scaleOfBitternessText: String?
    let imageURL: URL?
}

extension BeerItemViewModel {
    init(from repositoryBeer: DiscoveryRepository.Beer) {
        let alcoholicStrengthText = String(format: "%.1f", repositoryBeer.alcoholicStrength)
        let alcoholicStrengthComplementaryText = " % of alcohol"
        let scaleOfBitternessText = repositoryBeer.scaleOfBitterness.map { "IBU scale: \($0)" }

        self.init(
            id: repositoryBeer.id,
            name: repositoryBeer.name,
            tagline: repositoryBeer.tagline,
            description: repositoryBeer.description,
            alcoholicStrengthText: alcoholicStrengthText,
            alcoholicStrengthComplementaryText: alcoholicStrengthComplementaryText,
            scaleOfBitternessText: scaleOfBitternessText,
            imageURL: repositoryBeer.imageURL
        )
    }
}

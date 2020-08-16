import SwiftUI
import CommonUI

import KingfisherSwiftUI

struct BeerCell: View {
    let viewModel: BeerItemViewModel

    init(viewModel: BeerItemViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        HStack(alignment: .center, spacing: 16) {
            KFImage(viewModel.imageURL)
                .placeholder {
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                }
                .cancelOnDisappear(true)
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)

            VStack(alignment: .leading, spacing: 4) {
                Text(viewModel.name)
                    .font(.title)
                    .lineLimit(2)

                HStack(spacing: 0) {
                    Text(viewModel.alcoholicStrengthText)
                        .font(.callout)
                        .foregroundColor(.gray)
                        .bold()

                    Text(viewModel.alcoholicStrengthComplementaryText)
                        .font(.callout)
                        .foregroundColor(.gray)
                }
            }

            Spacer()
        }
        .padding()
    }
}

#if DEBUG
struct BeerCell_Previews: PreviewProvider {
    static var previews: some View {
        BeerCell(
            viewModel: BeerItemViewModel(
                id: 1,
                name: "The Beer",
                tagline: "What a beer",
                description: "larger description",
                alcoholicStrengthText: "% 5",
                alcoholicStrengthComplementaryText: "of alcohol",
                scaleOfBitternessText: "% 20",
                scaleOfBitternessTextComplementaryText: "50",
                imageURL: nil
            )
        )
    }
}
#endif

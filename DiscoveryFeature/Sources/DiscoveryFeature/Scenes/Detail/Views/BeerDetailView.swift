import SwiftUI
import KingfisherSwiftUI

struct BeerDetailView: View {
    private let viewModel: BeerItemViewModel

    init(viewModel: BeerItemViewModel) {
        self.viewModel = viewModel
    }

     var body: some View {
        GeometryReader { geometryProxy in
            ScrollView {
                VStack(spacing: 16) {
                    KFImage(viewModel.imageURL)
                        .placeholder {
                            Image(systemName: "photo")
                                .resizable()
                        }
                        .resizable()
                        .scaledToFit()
                        .frame(height: geometryProxy.size.height * 0.4)

                    HStack {
                        if let scaleOfBitternessText = viewModel.scaleOfBitternessText {
                            InformationView(titleText: "IBU", valueText: "\(scaleOfBitternessText)%")

                            Divider()
                                .frame(height: 16)
                        }

                        InformationView(titleText: "ABV", valueText: "\(viewModel.alcoholicStrengthText)%")
                    }
                    .padding(8)
                    .background(Color(UIColor.lightGray.withAlphaComponent(0.3)))
                    .squircleCornerRadius(8, borderColor: Color(.systemBackground))

                    Text(viewModel.tagline)
                        .font(.title)
                        .bold()
                    Text(viewModel.description)
                        .font(.subheadline)
                }
                .padding()
                .navigationBarTitle(Text(viewModel.name))
            }
        }
    }
}

private struct InformationView: View {
    let titleText: String
    let valueText: String

    var body: some View {
        HStack {
            Text(titleText)
                .bold()
            Text(valueText)
        }
    }
}

#if DEBUG
struct BeerDetailView_Previews: PreviewProvider {
    static var previews: some View {
        BeerDetailView(
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

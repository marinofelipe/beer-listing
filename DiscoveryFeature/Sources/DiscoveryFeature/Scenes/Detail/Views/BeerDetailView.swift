//
//  BeerDetailView.swift
//  BeerApp
//
//  Created by Marino Felipe on 11.08.20.
//

import SwiftUI

struct BeerDetailViewModel {
    let imageURL: URL?
    let name: String
    let tagline: String
    let description: String
}

struct BeerDetailView: View {
    private let viewModel: BeerDetailViewModel

    init(viewModel: BeerDetailViewModel) {
        self.viewModel = viewModel
    }

     var body: some View {
        VStack {
            Image(systemName: "photo")
                .resizable()
                .scaledToFit()
                .padding()
            Text(viewModel.tagline)
                .font(.headline)
                .padding()
            Text(viewModel.description)
                .font(.subheadline)
            Spacer()
        }
        .navigationBarTitle(
            Text(viewModel.name)
        )
    }
}

#if DEBUG
struct BeerDetailView_Previews: PreviewProvider {
    static var previews: some View {
        BeerDetailView(
        viewModel:
            BeerDetailViewModel(
                imageURL: nil,
                name: "Beer name",
                tagline: "This is the best beer ever",
                description: "Some description"
            )
        )
    }
}
#endif

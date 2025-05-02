//
//  ProductImagePageView.swift
//  ProductBrowse
//
//  Created by Janusz Polowczyk on 29/04/2025.
//

import SwiftUI

struct ProductImagePageView: View {
    var product: Product
    var body: some View {
        TabView {
            ForEach(0..<product.images.count, id: \.self) { index in
                AsyncImage(url: URL(string: product.images[index])) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity)
                        .frame(height: 280)
                } placeholder: {
                    ProgressView()
                }
            }
        }
        .tabViewStyle(.page)
        .indexViewStyle(.page(backgroundDisplayMode: .automatic))
        .frame(maxWidth: .infinity)
        .frame(height: 300)
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    ProductImagePageView(product: Product.placeholder())
}

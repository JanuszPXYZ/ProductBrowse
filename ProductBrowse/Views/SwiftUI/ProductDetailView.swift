//
//  ProductDetailView.swift
//  ProductBrowse
//
//  Created by Janusz Polowczyk on 29/04/2025.
//

import SwiftUI

struct ProductDetailView<T: FavoritesService>: View {
    var product: Product
    @ObservedObject var favoritesService: T
    var body: some View {
        ProductDetailHeaderView(product: product, favoritesService: favoritesService)
            .padding([.horizontal, .top], 16)
        ScrollView {
            ProductImagePageView(product: product)
            Text(product.description)
                .lineSpacing(2)
                .padding()
            Divider()
            HStack {
                Text("Price:")
                    .font(.system(size: 20, weight: .medium))
                Spacer()
                Text("\(product.price)€")
                    .font(.system(size: 20, weight: .bold))
            }
            .padding()
        }
        Spacer()
    }
}

private struct ProductDetailHeaderView<T: FavoritesService>: View {
    var product: Product
    @ObservedObject var favoritesService: T
    var body: some View {
        VStack {
            HStack {
                Text(product.title)
                    .font(.title)
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
                    .bold()
                Spacer()
                Button {
                    withAnimation(.interpolatingSpring(.bouncy)) {
                        favoritesService.toggleFavorite(product)
                    }
                } label: {
                    Image(systemName: favoritesService.isProductFavorite(product) ? "heart.fill" : "heart")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 22, height: 20)
                        .foregroundStyle(favoritesService.isProductFavorite(product) ? .red : .gray)
                        .scaleEffect(favoritesService.isProductFavorite(product) ? 1.2 : 1.0)
                }
            }
        }
        .frame(height: 50)
    }
}

#Preview {
    ProductDetailView(product: Product.placeholder(), favoritesService: ProductManagerViewModel(networker: Networker()))
}

#Preview("ProductDetailHeaderView", traits: .sizeThatFitsLayout) {
    ProductDetailHeaderView(product: Product.placeholder(), favoritesService: ProductManagerViewModel(networker: Networker()))
}

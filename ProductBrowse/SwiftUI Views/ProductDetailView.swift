//
//  ProductDetailView.swift
//  ProductBrowse
//
//  Created by Janusz Polowczyk on 29/04/2025.
//

import SwiftUI

struct ProductDetailView: View {
    var product: Product
    var addFavoriteProductAction: ((Product) -> Void)?
    var removeFavoriteProductAction: ((Product) -> Void)?
    @State private var isFavorite = false
    var body: some View {
        ProductDetailHeaderView(product: product, addFavoriteProductAction: addFavoriteProductAction, removeFavoriteProductAction: removeFavoriteProductAction, isFavorite: $isFavorite)
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

private struct ProductDetailHeaderView: View {
    var product: Product
    var addFavoriteProductAction: ((Product) -> Void)?
    var removeFavoriteProductAction: ((Product) -> Void)?
    @Binding var isFavorite: Bool

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
                        isFavorite.toggle()
                        if isFavorite {
                            addFavoriteProductAction?(product)
                        } else {
                            removeFavoriteProductAction?(product)
                        }
                    }
                } label: {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 22, height: 20)
                        .foregroundStyle(isFavorite ? .red : .gray)
                        .scaleEffect(isFavorite ? 1.2 : 1.0)
                }
            }
            Divider()
        }
        .frame(height: 50)
    }
}

#Preview {
    ProductDetailView(product: Product.placeholder())
}

#Preview("ProductDetailHeaderView", traits: .sizeThatFitsLayout) {
    ProductDetailHeaderView(product: Product.placeholder(), isFavorite: .constant(false))
}

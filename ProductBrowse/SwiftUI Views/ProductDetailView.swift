//
//  ProductDetailView.swift
//  ProductBrowse
//
//  Created by Janusz Polowczyk on 29/04/2025.
//

import SwiftUI

struct ProductDetailView: View {
    var product: Product
    @State private var isFavorite = false
    var body: some View {
        ProductDetailHeaderView(product: product, isFavorite: $isFavorite)
            .padding([.horizontal, .top], 16)
        ScrollView {
            ProductImagePageView(product: product)
            Text(product.description)
                .lineSpacing(2)
                .padding()
        }
        Spacer()
    }
}

private struct ProductDetailHeaderView: View {
    var product: Product
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

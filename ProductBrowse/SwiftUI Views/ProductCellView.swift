//
//  ProductImageView.swift
//  ProductBrowse
//
//  Created by Janusz Polowczyk on 29/04/2025.
//

import SwiftUI

struct ProductCellView: View {
    var product: Product
    var isRedacted: Bool = false
    var action: ((Product) -> Void)?
    let networker: Networker
    let favoritesService: any FavoritesService

    var body: some View {
        HStack(alignment: .top) {
            AsyncImageView(urlString: product.images.first, networker: networker) {
                favoritesService.toggleFavorite(product)
            }
            .overlay {
                if favoritesService.isProductFavorite(product) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10.0)
                            .frame(width: 100, height: 100)
                            .foregroundStyle(.white)
                            .opacity(0.5)
                        Image(systemName: "heart.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundStyle(.red)
                    }
                }
            }
            VStack(spacing: 13) {
                HStack {
                    Text(product.title)
                        .font(.system(size: 16))
                    Spacer()
                    Text("\(product.price)€")
                        .fontWeight(.heavy)
                }
                HStack {
                    Text(product.description)
                        .font(.caption)
                        .lineLimit(4)
                    Spacer()
                    Image(systemName: "chevron.right")
                }
            }
        }
        .onTapGesture {
            action?(product)
        }
        .frame(maxWidth: .infinity)
        .redacted(reason: isRedacted ? .placeholder : [])
        .if(isRedacted) { view in
            view.shimmering()
        }
        .disabled(isRedacted)
    }
}


#Preview(traits: .sizeThatFitsLayout) {
    ProductCellView(product: Product.placeholder(), networker: Networker(), favoritesService: ProductManagerViewModel(networker: Networker()))
}

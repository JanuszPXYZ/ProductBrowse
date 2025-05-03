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

    var body: some View {
        HStack(alignment: .top) {
            AsyncImageView(urlString: product.images.first, networker: networker)
            VStack(spacing: 13) {
                HStack {
                    Text(product.title)
                        .font(.system(size: 16))
                    Spacer()
                    Text("\(product.price)€")
                        .fontWeight(.heavy)
                    // TODO: The system image should update accordingly. Once the product has been added to the favorites, it should be reflected in the list. The current approach simply won't trigger a SwiftUI redraw, because it's not a state variable, nor an observed object.
                    Image(systemName: product.isFavorite ?? false ? "heart.fill" : "heart")
                        .frame(width: 10, height: 10)
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
    ProductCellView(product: Product.placeholder(), networker: Networker())
}

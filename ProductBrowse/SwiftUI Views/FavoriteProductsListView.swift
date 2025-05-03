//
//  FavoriteProductsGridView.swift
//  ProductBrowse
//
//  Created by Janusz Polowczyk on 02/05/2025.
//

import SwiftUI

struct FavoriteProductsListView: View {
    @StateObject var productManagerViewModel: ProductManagerViewModel
    var action: ((Product) -> Void)?

    var body: some View {
        List {
            ForEach(productManagerViewModel.favoriteProducts, id: \.id) { product in
                ProductCellView(product: product, action: action, networker: productManagerViewModel.networker)
            }
            .alignmentGuide(.listRowSeparatorLeading) { _ in
                return 0
            }
        }
        .listStyle(PlainListStyle())
        .overlay {
            if productManagerViewModel.favoriteProducts.isEmpty {
                Text("No favorite products added")
            }
        }
    }
}

#Preview {
    FavoriteProductsListView(productManagerViewModel: ProductManagerViewModel(networker: Networker()))
}

//
//  ProductListView.swift
//  ProductBrowse
//
//  Created by Janusz Polowczyk on 29/04/2025.
//

import SwiftUI

struct ProductListView: View {
    @StateObject var productManagerViewModel: ProductManagerViewModel
    var action: ((Product) -> Void)?

    var body: some View {
        List {
            if productManagerViewModel.fetchedProducts.isEmpty {
                ForEach(0..<10, id: \.self) { _ in
                    ProductCellView(product: Product.placeholder(), isRedacted: true, networker: productManagerViewModel.networker, favoritesService: productManagerViewModel)
                }
                .alignmentGuide(.listRowSeparatorLeading) { _ in
                    return 0
                }
            } else {
                ForEach(productManagerViewModel.fetchedProducts, id: \.id) { product in
                    ProductCellView(product: product, action: action, networker: productManagerViewModel.networker, favoritesService: productManagerViewModel)
                }
                .alignmentGuide(.listRowSeparatorLeading) { _ in
                    return 0
                }
            }
        }
        .listStyle(PlainListStyle())
        .onAppear {
            Task {
                try await productManagerViewModel.fetchProducts()
            }
        }
    }
}

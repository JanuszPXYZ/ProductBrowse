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
                if productManagerViewModel.isLoading {
                    ForEach(0..<10, id: \.self) { _ in
                        ProductCellView(product: Product.placeholder(), isRedacted: true, networker: productManagerViewModel.networker, favoritesService: productManagerViewModel)
                    }
                    .alignmentGuide(.listRowSeparatorLeading) { _ in
                        return 0
                    }
                } else {
                    Text("No products available")
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding()
                }
            } else {
                ForEach(productManagerViewModel.fetchedProducts, id: \.id) { product in
                    ProductCellView(product: product, action: action, networker: productManagerViewModel.networker, favoritesService: productManagerViewModel)
                }
                .alignmentGuide(.listRowSeparatorLeading) { _ in
                    return 0
                }
                if productManagerViewModel.hasMoreProducts {
                    Button("Load More") {
                        Task {
                            await productManagerViewModel.fetchMoreProducts()
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .disabled(productManagerViewModel.isLoading)
                }
                if productManagerViewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, alignment: .center)
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

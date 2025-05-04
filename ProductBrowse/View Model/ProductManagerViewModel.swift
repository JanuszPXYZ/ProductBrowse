//
//  ProductManagerViewModel.swift
//  ProductBrowse
//
//  Created by Janusz Polowczyk on 30/04/2025.
//

import Foundation

final class ProductManagerViewModel: ObservableObject, @preconcurrency FavoritesService {
    @Published private(set) var fetchedProducts: [Product] = []
    @Published private(set) var favoriteProducts: [Product] = []

    // MARK: - Pagination functionality
    @Published private(set) var isLoading = false
    @Published private(set) var hasMoreProducts = true
    private var paginationOffset = 0
    private var paginationElementLimit = 10

    let networker: Networking

    init(networker: Networking) {
        self.networker = networker
    }

    @MainActor
    func fetchProducts() async throws {
        guard !isLoading else { return }
        isLoading = true
        paginationOffset = 0 // Reset for initial fetch
        hasMoreProducts = true

        let productRequest = ProductRequest(offset: paginationOffset, limit: paginationElementLimit)
        do {
            let products = try await networker.fetch(request: productRequest)
            if let products = products {
                fetchedProducts = products.compactMap { product in
                    var updatedProduct = product
                    updatedProduct.isFavorite = favoriteProducts.contains(where: { $0.id == product.id })
                    return updatedProduct
                }
                paginationOffset += products.count
                hasMoreProducts = products.count == paginationElementLimit
            }
        } catch {
            print(String(describing: error))
        }
        isLoading = false
    }

    @MainActor
    func fetchMoreProducts() async {
        guard !isLoading, hasMoreProducts else { return }
        isLoading = true

        let productRequest = ProductRequest(offset: paginationOffset, limit: paginationElementLimit)
        do {
            let products = try await networker.fetch(request: productRequest)
            if let products = products {
                fetchedProducts.append(contentsOf: products.compactMap({ product in
                    var updatedProduct = product
                    updatedProduct.isFavorite = favoriteProducts.contains(where: { $0.id == product.id })
                    return updatedProduct
                }))
                paginationOffset += products.count
                hasMoreProducts = products.count == paginationElementLimit
            }
        } catch {
            print(String(describing: error))
        }
        isLoading = false
    }

    func isProductFavorite(_ product: Product) -> Bool {
        return favoriteProducts.contains { $0.id == product.id } || product.isFavorite == true
    }

    @MainActor
    func toggleFavorite(_ product: Product) {
        var updatedProduct = product
        let isCurrentlyFavorite = isProductFavorite(product)

        if isCurrentlyFavorite {
            favoriteProducts.removeAll { $0.id == product.id }
            updatedProduct.isFavorite = false
        } else {
            favoriteProducts.append(updatedProduct)
            updatedProduct.isFavorite = true
        }

        if let index = fetchedProducts.firstIndex(where: { $0.id == product.id }) {
            fetchedProducts[index] = updatedProduct
        }
    }
}

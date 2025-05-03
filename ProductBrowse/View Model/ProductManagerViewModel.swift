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

    let networker: Networker

    init(networker: Networker) {
        self.networker = networker
    }

    @MainActor
    func fetchProducts() async throws {
        let productRequest = ProductRequest()
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "offset", value: "0"),
            URLQueryItem(name: "limit", value: "10"),
        ]
        do {
            let prodReq = try await networker.fetch(request: productRequest, queryItems: queryItems)
            if let prodReq = prodReq {
                fetchedProducts = prodReq
            }
        } catch {
            print(String(describing: error))
        }
    }

//    func addToFavorites(product: Product) {
//        guard !self.favoriteProducts.contains(where: { $0.id == product.id }) else {
//            return
//        }
//        var product = product
//        product.isFavorite = true
//        self.favoriteProducts.append(product)
//    }
//
//    func removeFromFavorites(product: Product) {
//        var product = product
//        product.isFavorite = false
//        self.favoriteProducts.removeAll { $0.id == product.id }
//    }
//
//    func productIsFavorite(product: Product) -> Bool {
//        let favorite = self.favoriteProducts.first { $0.id == product.id }
//        return favorite != nil ? true : false
//    }

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

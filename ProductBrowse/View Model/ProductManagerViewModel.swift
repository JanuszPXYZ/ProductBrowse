//
//  ProductManagerViewModel.swift
//  ProductBrowse
//
//  Created by Janusz Polowczyk on 30/04/2025.
//

import Foundation

final class ProductManagerViewModel: ObservableObject {
    @Published private(set) var fetchedProducts: [Product] = []

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

}

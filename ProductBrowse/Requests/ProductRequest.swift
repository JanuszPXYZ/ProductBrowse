//
//  ProductRequest.swift
//  ProductBrowse
//
//  Created by Janusz Polowczyk on 30/04/2025.
//

import Foundation

struct ProductRequest: Request {

    // MARK: - Pagination functionality
    let offset: Int
    let limit: Int
    
    var method: HTTPMethod { .get }

    var url: URLComponents? {
        var components = URLComponents(string: "https://api.escuelajs.co")
        components?.path = "/api/v1/products"

        components?.queryItems = [
            URLQueryItem(name: "offset", value: String(offset)),
            URLQueryItem(name: "limit", value: String(limit))
        ]

        return components
    }

    func decode(_ data: Data) throws -> [Product] {
        let decoder = JSONDecoder()
        let products = try decoder.decode([Product].self, from: data)
        return products
    }
}

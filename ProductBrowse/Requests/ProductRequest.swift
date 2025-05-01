//
//  ProductRequest.swift
//  ProductBrowse
//
//  Created by Janusz Polowczyk on 30/04/2025.
//

import Foundation

struct ProductRequest: Request {

    var method: HTTPMethod { .get }

    var url: URLComponents? = {
        var components = URLComponents(string: "https://api.escuelajs.co")
        components?.path = "/api/v1/products"

        return components
    }()

    func decode(_ data: Data) throws -> [Product] {
        let decoder = JSONDecoder()
        let products = try decoder.decode([Product].self, from: data)
        return products
    }
}

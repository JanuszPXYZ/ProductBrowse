//
//  Product.swift
//  ProductBrowse
//
//  Created by Janusz Polowczyk on 29/04/2025.
//

import Foundation

struct Product: Identifiable, Codable {
    var id: Int
    var title: String
    var slug: String
    var price: Int
    var description: String
    var category: Category
    var images: [String]
    var creationAt: String
    var updatedAt: String
    var isFavorite: Bool?

    struct Category: Codable {
        var id: Int
        var name: String
        var slug: String
        var image: URL
        var creationAt: String
        var updatedAt: String
    }
}

extension Product {
    static func save(_ products: [Product], to fileURL: URL) throws {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        let data = try encoder.encode(products)
        try data.write(to: fileURL)
    }

    static func load(from fileURL: URL) throws -> [Product] {
        let data = try Data(contentsOf: fileURL)
        let decoder = JSONDecoder()
        return try decoder.decode([Product].self, from: data)
    }

    static func placeholder() -> Product {
        return Product(
            id: 0,
            title: "Product Name",
            slug: "Slug",
            price: 999,
            description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum molestie mi tortor, et elementum mi vulputate id. Sed et ipsum sit amet est finibus venenatis vitae lobortis risus. Nam dignissim imperdiet libero quis scelerisque. Duis posuere finibus gravida. Nam volutpat purus a enim pharetra, ac pulvinar lectus maximus.",
            category: Category(
                id: 0,
                name: "Category",
                slug: "Slug",
                image: URL(
                    string: "https://i.imgur.com/BG8J0Fj.jpg"
                )!,
                creationAt: "2025-04-29",
                updatedAt: "2025-04-29"
            ),
            images: ["https://i.imgur.com/BG8J0Fj.jpg", "https://i.imgur.com/BG8J0Fj.jpg", "https://i.imgur.com/BG8J0Fj.jpg"],
            creationAt: "2025-04-29",
            updatedAt: "2025-04-29"
        )
    }
}

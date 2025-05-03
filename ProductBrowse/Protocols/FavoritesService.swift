//
//  FavoritesService.swift
//  ProductBrowse
//
//  Created by Janusz Polowczyk on 03/05/2025.
//

import Foundation

protocol FavoritesService: ObservableObject {
    func isProductFavorite(_ product: Product) -> Bool
    func toggleFavorite(_ product: Product)
}

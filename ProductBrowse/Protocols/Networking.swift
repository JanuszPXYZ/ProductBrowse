//
//  Networking.swift
//  ProductBrowse
//
//  Created by Janusz Polowczyk on 03/05/2025.
//

import UIKit

protocol Networking {
    func fetch<R: Request>(request: R) async throws -> R.Output?
    func fetchWithCache(for urlString: String) async throws -> UIImage
}

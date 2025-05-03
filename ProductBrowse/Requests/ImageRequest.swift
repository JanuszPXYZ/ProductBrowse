//
//  ImageRequest.swift
//  ProductBrowse
//
//  Created by Janusz Polowczyk on 03/05/2025.
//

import UIKit

struct ImageRequest: Request {
    typealias Output = UIImage

    var url: URLComponents?

    init(url: URLComponents? = nil) {
        self.url = url
    }

    enum ImageError: Error {
        case invalidData
    }

    var method: HTTPMethod { .get }

    func decode(_ data: Data) throws -> Output {
        guard let image = UIImage(data: data) else {
            throw ImageError.invalidData
        }
        return image
    }
}

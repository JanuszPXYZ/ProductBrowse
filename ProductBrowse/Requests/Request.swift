//
//  Request.swift
//  ProductBrowse
//
//  Created by Janusz Polowczyk on 30/04/2025.
//

import Foundation

protocol Request {
    associatedtype Output
    var url: URLComponents? { get }
    var method: HTTPMethod { get }
    func decode(_ data: Data) throws -> Output
}


//
//  Networker.swift
//  ProductBrowse
//
//  Created by Janusz Polowczyk on 30/04/2025.
//

import Foundation
import UIKit

@MainActor
final class Networker: Networking {

    private let imageCache: NSCache<NSString, UIImage>

    init() {
        self.imageCache = NSCache<NSString, UIImage>()
        imageCache.countLimit = 100
        imageCache.totalCostLimit = 50 * 1024 * 1024 // 50MB cache limit for images in the memory
    }

    nonisolated func fetch<R: Request>(request: R) async throws -> R.Output? {
        var requestURLComponents = request.url
        
        guard let components = requestURLComponents,
              let url = components.url else {
            throw URLError(.badURL)
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let parsedData = try request.decode(data)
            return parsedData
        } catch {
            print(String(describing: error))
        }
        
        return nil
    }

    func fetchWithCache(for urlString: String) async throws -> UIImage {
        let cacheKey = urlString as NSString

        if let cachedImage = imageCache.object(forKey: cacheKey) {
            return cachedImage
        }

        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }

        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        guard httpResponse.statusCode == 200 else {
            print("HTTP error for \(urlString): Status code \(httpResponse.statusCode)")
            throw URLError(.httpTooManyRedirects, userInfo: [NSURLErrorKey: urlString])
        }

        // Validate content type
        let contentType = httpResponse.value(forHTTPHeaderField: "Content-Type")
        guard let contentType = contentType, contentType.lowercased().hasPrefix("image/") else {
            let errorMessage = contentType != nil ? "Invalid content type for \(urlString): \(String(describing: contentType))" : "Missing Content-Type header for \(urlString)"
            print(errorMessage)
            throw URLError(.cannotDecodeContentData, userInfo: [NSURLErrorKey: urlString])
        }

        // Convert to UIImage
        guard let image = UIImage(data: data) else {
            print("Failed to create UIImage from data for \(urlString)")
            throw URLError(.cannotDecodeContentData, userInfo: [NSURLErrorKey: urlString])
        }

        imageCache.setObject(image, forKey: cacheKey)
        return image
    }

    private func loadImageFromDisk(for code: String) -> UIImage? {
        let fileManager = FileManager.default
        guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        let fileURL = documentsDirectory.appendingPathComponent("\(code).png")

        guard fileManager.fileExists(atPath: fileURL.path) else { return nil }
        return UIImage(contentsOfFile: fileURL.path)
    }

    private func saveImageToDisk(_ image: UIImage, for code: String) {
        let fileManager = FileManager.default
        guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first,
              let data = image.pngData() else { return }

        let fileURL = documentsDirectory.appendingPathComponent("\(code).png")
        try? data.write(to: fileURL)
    }
}

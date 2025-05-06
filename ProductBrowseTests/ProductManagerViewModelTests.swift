//
//  ProductManagerViewModelTests.swift
//  ProductBrowseTests
//
//  Created by Janusz Polowczyk on 06/05/2025.
//

import XCTest
import Combine
@testable import ProductBrowse

actor MockNetworker: Networking {

    private var imageCache: [String: UIImage] = [:]

    func fetchWithCache(for urlString: String) async throws -> UIImage {

        if let cachedImage = imageCache[urlString] {
            return cachedImage
        }

        // Using SF Symbols here
        let mockImage = UIImage(systemName: "photo")!

        imageCache[urlString] = mockImage
        return mockImage
    }

    func fetch<R>(request: R) async throws -> R.Output? where R : ProductBrowse.Request {

        switch request {
        case is ProductBrowse.ProductRequest:
            let product = Product(
                id: 0,
                title: "Bike",
                slug: "None",
                price: 199,
                description: "Ultra light-weight bike that will excel in the city-jungle, as well as in a deep forest",
                category: Product.Category(
                    id: 0,
                    name: "Sports",
                    slug: "None",
                    image: URL(string: "https://www.pexels.com/photo/black-fixed-gear-bike-beside-wall-276517/")!,
                    creationAt: "2025-04-04",
                    updatedAt: "2025-04-04"
                ),
                images: [],
                creationAt: "2025-04-04",
                updatedAt: "2025-04-04",
                isFavorite: true
            )
            return product as? R.Output
        default:
            return nil
        }
    }
}

final class ProductManagerViewModelTests: XCTestCase {

    var viewModel: ProductManagerViewModel!
    var cancellables: Set<AnyCancellable> = []
    var fetchedImage: UIImage?

    override func setUpWithError() throws {
        try super.setUpWithError()
        viewModel = ProductManagerViewModel(networker: MockNetworker())
    }

    @MainActor
    func testProductsAreFetchedCorrectly() async throws {
        XCTAssert(viewModel.fetchedProducts.isEmpty)
        let expectation = XCTestExpectation(description: "Product received")

        viewModel.$fetchedProducts.sink { products in
            guard !products.isEmpty else { return }
            XCTAssertEqual(products[0].title, "Bike")
            expectation.fulfill()
        }
        .store(in: &cancellables)

        do {
            try await viewModel.fetchProducts()
            expectation.fulfill()
        } catch {
            XCTFail("Product fetch failed with error: \(error)")
        }
    }

    @MainActor
    func testFetchWithCache() async {
        let expectation = XCTestExpectation(description: "Image fetched from cache")

        XCTAssertNil(fetchedImage)

        do {
            fetchedImage = try await viewModel.networker.fetchWithCache(for: "")
            XCTAssertNotNil(fetchedImage)
        } catch {
            XCTFail("Image fetch failed with error: \(error)")
        }

        expectation.fulfill()
    }

    @MainActor
    func testIsProductFavoriteWhenProductHasIsFavoriteTrue() {
        let testProduct = Product(
            id: 0,
            title: "Bike",
            slug: "None",
            price: 199,
            description: "Ultra light-weight bike that will excel in the city-jungle, as well as in a deep forest",
            category: Product.Category(
                id: 0,
                name: "Sports",
                slug: "None",
                image: URL(string: "https://www.pexels.com/photo/black-fixed-gear-bike-beside-wall-276517/")!,
                creationAt: "2025-04-04",
                updatedAt: "2025-04-04"
            ),
            images: [],
            creationAt: "2025-04-04",
            updatedAt: "2025-04-04",
            isFavorite: true
        )
        XCTAssertTrue(viewModel.isProductFavorite(testProduct))
    }

    @MainActor
    func testIsProductFavoriteWhenProductHasIsFavoriteFalse() {
        let testProduct = Product(
            id: 0,
            title: "Bike",
            slug: "None",
            price: 199,
            description: "Ultra light-weight bike that will excel in the city-jungle, as well as in a deep forest",
            category: Product.Category(
                id: 0,
                name: "Sports",
                slug: "None",
                image: URL(string: "https://www.pexels.com/photo/black-fixed-gear-bike-beside-wall-276517/")!,
                creationAt: "2025-04-04",
                updatedAt: "2025-04-04"
            ),
            images: [],
            creationAt: "2025-04-04",
            updatedAt: "2025-04-04",
            isFavorite: false
        )
        XCTAssertFalse(viewModel.isProductFavorite(testProduct))
    }

    @MainActor
    func testAddToFavoritesProduct() {

        let testProduct = Product(
            id: 0,
            title: "Bike",
            slug: "None",
            price: 199,
            description: "Ultra light-weight bike that will excel in the city-jungle, as well as in a deep forest",
            category: Product.Category(
                id: 0,
                name: "Sports",
                slug: "None",
                image: URL(string: "https://www.pexels.com/photo/black-fixed-gear-bike-beside-wall-276517/")!,
                creationAt: "2025-04-04",
                updatedAt: "2025-04-04"
            ),
            images: [],
            creationAt: "2025-04-04",
            updatedAt: "2025-04-04",
            isFavorite: false
        )

        XCTAssertFalse(viewModel.isProductFavorite(testProduct))

        viewModel.toggleFavorite(testProduct)

        XCTAssertTrue(viewModel.isProductFavorite(testProduct),
                      "Product should be favorite after first toggle")
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        viewModel = nil
        cancellables = []
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

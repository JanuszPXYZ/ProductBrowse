//
//  FavoritesViewController.swift
//  ProductBrowse
//
//  Created by Janusz Polowczyk on 29/04/2025.
//

import UIKit
import SwiftUI

final class FavoritesViewController: UIViewController {

    private var favoritesListHostingController: UIHostingController<FavoriteProductsListView>?
    private var productDetailView: UIHostingController<ProductDetailView<ProductManagerViewModel>>?
    var productManagerViewModel: ProductManagerViewModel?

    init(productManagerViewModel: ProductManagerViewModel) {
        self.productManagerViewModel = productManagerViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        configure()
    }

    private func configure() {
        guard let productManagerViewModel = productManagerViewModel else { return }
        favoritesListHostingController = UIHostingController(rootView: FavoriteProductsListView(productManagerViewModel: productManagerViewModel))
        guard let favoritesListHostingControllerView = favoritesListHostingController?.view else { return }

        favoritesListHostingController?.rootView.action = { [weak self] product in
            guard let self = self else { return }
            let productDetailView = UIHostingController(rootView: ProductDetailView(product: product, favoritesService: productManagerViewModel))
            productDetailView.navigationItem.largeTitleDisplayMode = .never

            self.productDetailView = productDetailView
            self.navigationController?.pushViewController(productDetailView, animated: true)
        }

        self.view.addSubview(favoritesListHostingControllerView)
        favoritesListHostingControllerView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            favoritesListHostingControllerView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            favoritesListHostingControllerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            favoritesListHostingControllerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            favoritesListHostingControllerView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

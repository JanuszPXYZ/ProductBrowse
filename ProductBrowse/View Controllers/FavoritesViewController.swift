//
//  FavoritesViewController.swift
//  ProductBrowse
//
//  Created by Janusz Polowczyk on 29/04/2025.
//

import UIKit
import SwiftUI

class FavoritesViewController: UIViewController {

    private var favoritesListHostingController: UIHostingController<FavoriteProductsListView>?
    var productManagerViewModel: ProductManagerViewModel?
    let networker = Networker()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        configure()
    }

    private func configure() {
        guard let productManagerViewModel = productManagerViewModel else { return }
        favoritesListHostingController = UIHostingController(rootView: FavoriteProductsListView(productManagerViewModel: productManagerViewModel))
        guard let favoritesListHostingControllerView = favoritesListHostingController?.view else { return }

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

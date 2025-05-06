//
//  ViewController.swift
//  ProductBrowse
//
//  Created by Janusz Polowczyk on 29/04/2025.
//

import UIKit
import SwiftUI

final class ProductListViewController: UIViewController {

    private var productListView: UIHostingController<ProductListView>?
    private var productDetailView: UIHostingController<ProductDetailView<ProductManagerViewModel>>?

    var managerViewModel: ProductManagerViewModel?
    var networker = Networker()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground

        configureProductListView()
    }

    private func configureProductListView() {
        guard let managerViewModel = managerViewModel else {
            return
        }
        productListView = UIHostingController(rootView: ProductListView(productManagerViewModel: managerViewModel))

        productListView?.rootView.action = { [weak self] product in
            guard let self = self else { return }
            let productDetailView = UIHostingController(rootView: ProductDetailView(product: product, favoritesService: managerViewModel))
            productDetailView.navigationItem.largeTitleDisplayMode = .never

            self.productDetailView = productDetailView
            self.navigationController?.pushViewController(productDetailView, animated: true)
        }

        guard let productViewCell = productListView?.view else {
            return
        }

        self.view.addSubview(productViewCell)
        productViewCell.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            productViewCell.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            productViewCell.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            productViewCell.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            productViewCell.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}


//
//  ProductTableViewController.swift
//  ProductBrowse
//
//  Created by Janusz Polowczyk on 04/05/2025.
//

import UIKit
import SwiftUI
import Combine

final class ProductTableViewController: UITableViewController, ProductTableViewCellDelegate {

    private let viewModel: ProductManagerViewModel
    private let cellReuseIdentifier = "ProductTableViewCell"
    private var tappedCellIndexPath = 0

    private var cancellables = Set<AnyCancellable>()

    init(viewModel: ProductManagerViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Products"
        tableView.register(UINib(nibName: "ProductTableViewCell", bundle: nil), forCellReuseIdentifier: cellReuseIdentifier)
        tableView.rowHeight = 128

        Task {
            try await viewModel.fetchProducts()
            await MainActor.run {
                self.tableView.reloadData()
            }
        }

        viewModel.objectWillChange.sink { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }.store(in: &cancellables)
    }

    nonisolated func doubleTapAddToFavorites(in cell: ProductTableViewCell) {
        MainActor.assumeIsolated {
            let row = tableView.indexPath(for: cell)?.row
            if let row = row {
                let product = viewModel.fetchedProducts[row]
                viewModel.toggleFavorite(product)
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.fetchedProducts.isEmpty ? 10 : viewModel.fetchedProducts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! ProductTableViewCell

        cell.delegate = self

        if viewModel.fetchedProducts.isEmpty {
            cell.configure(with: Product.placeholder(), networker: viewModel.networker, completion: {
                return false
            })
            cell.isUserInteractionEnabled = false
            cell.contentView.alpha = 0.5
        } else {
            let product = viewModel.fetchedProducts[indexPath.row]
            cell.configure(with: product, networker: viewModel.networker, completion: {
                self.viewModel.isProductFavorite(product)
            })
            cell.isUserInteractionEnabled = true
            cell.contentView.alpha = 1.0

            // MARK: - Implementing the infinite scroll mechanism -
            if indexPath.row == viewModel.fetchedProducts.count - 1, viewModel.hasMoreProducts, !viewModel.isLoading {
                Task {
                    await viewModel.fetchMoreProducts()
                }
            }
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        guard !viewModel.fetchedProducts.isEmpty, let navigationController = navigationController else {
            print("Navigation controller not available or no products")
            return
        }

        let product = viewModel.fetchedProducts[indexPath.row]
        let detailView = ProductDetailView<ProductManagerViewModel>(product: product, favoritesService: viewModel)
        let hostingController = UIHostingController(rootView: detailView)
        hostingController.navigationItem.largeTitleDisplayMode = .never
        navigationController.pushViewController(hostingController, animated: true)
    }

    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard viewModel.isLoading, !viewModel.fetchedProducts.isEmpty else {
            return nil
        }
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.startAnimating()
        activityIndicator.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 44)
        return activityIndicator
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return viewModel.isLoading && !viewModel.fetchedProducts.isEmpty ? 44 : 0
    }
}

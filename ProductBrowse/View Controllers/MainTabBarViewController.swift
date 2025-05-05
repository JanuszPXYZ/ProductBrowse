//
//  MainTabBarViewController.swift
//  ProductBrowse
//
//  Created by Janusz Polowczyk on 29/04/2025.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    private var networker: Networking
    private var productManagerViewModel: ProductManagerViewModel?

    init(networker: Networking, productManagerViewModel: ProductManagerViewModel? = nil) {
        self.networker = networker
        self.productManagerViewModel = productManagerViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = tabBar.standardAppearance
        configureViewControllers()
    }

    private func configureViewControllers() {
        guard let productManagerViewModel = self.productManagerViewModel else {
            return
        }
        #if UIKIT
        var tableNavController: UINavigationController?
//        if let productManagerViewModel = productManagerViewModel {
            let tableViewController = ProductTableViewController(viewModel: productManagerViewModel)
            tableNavController = UINavigationController(rootViewController: tableViewController)
            tableNavController?.tabBarItem = UITabBarItem(title: "Products (UIKit)", image: UIImage(systemName: "tablecells"), tag: 1)
//        }

        let vcTwo = SettingsViewController()
        vcTwo.title = "Settings"
        vcTwo.tabBarItem.image = UIImage(systemName: "gear")

        let favoritesVC = FavoritesViewController(networker: networker)
        favoritesVC.productManagerViewModel = productManagerViewModel
        favoritesVC.title = "Favorites"
        favoritesVC.tabBarItem.image = UIImage(systemName: "heart.fill")

        guard let tableNavController = tableNavController else { return }
        let navigationControllers = [tableNavController,
                                     UINavigationController(rootViewController: favoritesVC),
                                     UINavigationController(rootViewController: vcTwo)]

        _ = navigationControllers.map { navigationController in
            navigationController.navigationBar.prefersLargeTitles = true
        }
        #else
        let vcOne = ProductListViewController()
        vcOne.managerViewModel = productManagerViewModel
        vcOne.title = "Products"
        vcOne.tabBarItem.image = UIImage(systemName: "shippingbox.fill")

        let vcTwo = SettingsViewController()
        vcTwo.title = "Settings"
        vcTwo.tabBarItem.image = UIImage(systemName: "gear")

        let favoritesVC = FavoritesViewController(networker: networker)
        favoritesVC.productManagerViewModel = productManagerViewModel
        favoritesVC.title = "Favorites"
        favoritesVC.tabBarItem.image = UIImage(systemName: "heart.fill")

        let navigationControllers = [UINavigationController(rootViewController: vcOne),
                                     UINavigationController(rootViewController: favoritesVC),
                                     UINavigationController(rootViewController: vcTwo)]

        _ = navigationControllers.map { navigationController in
            navigationController.navigationBar.prefersLargeTitles = true
        }
        #endif

        self.viewControllers = navigationControllers
    }
}

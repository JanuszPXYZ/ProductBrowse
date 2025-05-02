//
//  MainTabBarViewController.swift
//  ProductBrowse
//
//  Created by Janusz Polowczyk on 29/04/2025.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    private var networker = Networker()
    private var productManagerViewModel: ProductManagerViewModel?

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
        productManagerViewModel = ProductManagerViewModel(networker: networker)
        let vcOne = ProductListViewController()
        vcOne.managerViewModel = productManagerViewModel
        vcOne.title = "Products"
        vcOne.tabBarItem.image = UIImage(systemName: "shippingbox.fill")

        let vcTwo = SettingsViewController()
        vcTwo.title = "Settings"
        vcTwo.tabBarItem.image = UIImage(systemName: "gear")

        let favoritesVC = FavoritesViewController()
        favoritesVC.productManagerViewModel = productManagerViewModel
        favoritesVC.title = "Favorites"
        favoritesVC.tabBarItem.image = UIImage(systemName: "heart.fill")
        

        let navigationControllers = [UINavigationController(rootViewController: vcOne),
                                     UINavigationController(rootViewController: favoritesVC),
                                     UINavigationController(rootViewController: vcTwo)]

        _ = navigationControllers.map { navigationController in
            navigationController.navigationBar.prefersLargeTitles = true
        }

        self.viewControllers = navigationControllers
    }
}

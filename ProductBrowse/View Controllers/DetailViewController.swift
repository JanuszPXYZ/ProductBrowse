//
//  DetailViewController.swift
//  ProductBrowse
//
//  Created by Janusz Polowczyk on 29/04/2025.
//

import UIKit

final class DetailViewController: UIViewController {
    
    private var label = UILabel()
    var productName: String

    init(productName: String) {
        self.productName = productName
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

    private func configure() {
        self.view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "PRODUCT #\(productName)"
    }
}

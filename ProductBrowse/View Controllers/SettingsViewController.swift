//
//  ViewControllerTwo.swift
//  ProductBrowse
//
//  Created by Janusz Polowczyk on 29/04/2025.
//

import UIKit

final class SettingsViewController: UIViewController {
    
    private var darkModeToggle: UISwitch!
    private var darkModeLabel: UILabel!

    private var toggleIsOn: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        configure()
    }

    private func configure() {
        darkModeToggle = UISwitch()
        darkModeLabel = UILabel()
        self.view.addSubview(darkModeToggle)
        self.view.addSubview(darkModeLabel)
        darkModeToggle.translatesAutoresizingMaskIntoConstraints = false
        darkModeLabel.translatesAutoresizingMaskIntoConstraints = false

        darkModeLabel.text = "Toggle dark mode on/off"


        let categoryDivider = UIView()
        self.view.addSubview(categoryDivider)
        categoryDivider.translatesAutoresizingMaskIntoConstraints = false
        categoryDivider.backgroundColor = UIColor.gray

        darkModeToggle.onTintColor = .systemBlue
        darkModeToggle.addTarget(self, action: #selector(toggleAction), for: .touchUpInside)

        NSLayoutConstraint.activate([
            darkModeLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            darkModeLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
            darkModeLabel.widthAnchor.constraint(equalToConstant: 220),
            darkModeLabel.heightAnchor.constraint(equalToConstant: 50),

            darkModeToggle.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10),
            darkModeToggle.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            darkModeToggle.widthAnchor.constraint(equalToConstant: 50),
            darkModeToggle.heightAnchor.constraint(equalToConstant: 50),

            categoryDivider.topAnchor.constraint(equalTo: self.darkModeToggle.bottomAnchor),
            categoryDivider.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
            categoryDivider.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
            categoryDivider.heightAnchor.constraint(equalToConstant: 1)
        ])
    }

    @objc private func toggleAction() {
        if darkModeToggle.isOn {
            toggleIsOn = true
        } else {
            toggleIsOn = false
        }
    }
}

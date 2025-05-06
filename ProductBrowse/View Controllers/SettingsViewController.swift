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

    private let userDefaults = UserDefaults.standard
    private let darkModeKey = "DarkModeEnabled"

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        configure()
        setupInitialToggleState()
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
        categoryDivider.backgroundColor = .separator

        darkModeToggle.onTintColor = .systemBlue
        darkModeToggle.addTarget(self, action: #selector(toggleAction), for: .valueChanged)

        NSLayoutConstraint.activate([
            darkModeLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            darkModeLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            darkModeLabel.widthAnchor.constraint(equalToConstant: 220),
            darkModeLabel.heightAnchor.constraint(equalToConstant: 50),

            darkModeToggle.centerYAnchor.constraint(equalTo: darkModeLabel.centerYAnchor),
            darkModeToggle.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),

            categoryDivider.topAnchor.constraint(equalTo: self.darkModeLabel.bottomAnchor, constant: 8),
            categoryDivider.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            categoryDivider.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            categoryDivider.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }

    private func setupInitialToggleState() {
        if #available(iOS 13.0, *) {
            if userDefaults.object(forKey: darkModeKey) != nil {
                let isDarkMode = userDefaults.bool(forKey: darkModeKey)
                darkModeToggle.isOn = isDarkMode
                updateDarkMode(isDarkMode)
            } else {
                let systemIsDark = self.traitCollection.userInterfaceStyle == .dark
                darkModeToggle.isOn = systemIsDark
            }
        } else {
            darkModeToggle.isOn = false
        }
    }

    @objc private func toggleAction() {
        let isDarkMode = darkModeToggle.isOn
        userDefaults.set(isDarkMode, forKey: darkModeKey)
        updateDarkMode(isDarkMode)
    }

    private func updateDarkMode(_ enable: Bool) {
        if #available(iOS 13.0, *) {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let window = windowScene.windows.first else {
                return
            }

            window.overrideUserInterfaceStyle = enable ? .dark : .light
        }
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        if #available(iOS 13.0, *) {
            if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
                if userDefaults.object(forKey: darkModeKey) == nil {
                    let systemIsDark = traitCollection.userInterfaceStyle == .dark
                    darkModeToggle.isOn = systemIsDark
                }
            }
        }
    }
}

//
//  RMSettingsViewController.swift
//  RickAndMorty
//
//  Created by Yunus Emre Berdibek on 26.11.2023.
//

import UIKit

/// Controller to show various app options and settings.
final class RMSettingsViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Settings"
        addSearchButton()
    }

    private func addSearchButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(didTapSearch))
    }

    @objc private func didTapSearch() {}
}

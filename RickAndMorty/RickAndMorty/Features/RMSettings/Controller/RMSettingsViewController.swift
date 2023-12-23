//
//  RMSettingsViewController.swift
//  RickAndMorty
//
//  Created by Yunus Emre Berdibek on 26.11.2023.
//

import UIKit

/// Controller to show various app options and settings.
final class RMSettingsViewController: UIViewController {
    /// Properties
    private let viewModel: RMSettingsViewModel = .init(
        cellViewModels:
        RMSettingsOption.allCases.compactMap {
            RMSettingsCellViewModel(type: $0)
        }
    )

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Settings"
    }
}

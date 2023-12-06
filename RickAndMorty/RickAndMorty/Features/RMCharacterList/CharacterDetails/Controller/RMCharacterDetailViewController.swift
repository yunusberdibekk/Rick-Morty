//
//  RMCharacterDetailViewController.swift
//  RickAndMorty
//
//  Created by Yunus Emre Berdibek on 7.12.2023.
//

import UIKit

/// Controller to show info about single character
class RMCharacterDetailViewController: UIViewController {
    // MARK: - Properties

    private let viewModel: RMCharacterDetailViewModel

    // MARK: - Components

    // MARK: - Lifecycle

    init(viewModel: RMCharacterDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = viewModel.title
    }
}

//
//  RMSearchViewController.swift
//  RickAndMorty
//
//  Created by Yunus Emre Berdibek on 14.12.2023.
//

import UIKit

/// Configurable controller to search.
class RMSearchViewController: UIViewController {
    /// Properties
    struct Config {
        enum `Type` {
            case character
            case episode
            case location
        }

        let type: `Type`
    }

    private let config: Config

    /// Lifecycle
    init(config: Config) {
        self.config = config
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search"
        view.backgroundColor = .systemBackground
    }
}

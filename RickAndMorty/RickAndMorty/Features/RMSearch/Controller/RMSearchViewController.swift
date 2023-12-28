//
//  RMSearchViewController.swift
//  RickAndMorty
//
//  Created by Yunus Emre Berdibek on 14.12.2023.
//

import UIKit

// Dynamic search option view
// Render results
// Render no results zero state
// Searching / API CALL

/// Configurable controller to search.
final class RMSearchViewController: UIViewController {
    /// Properties

    /// Configuration for search session
    struct Config {
        enum `Type` {
            case character // name | status | gender
            case episode // name
            case location //  name | type

            var title: String {
                switch self {
                case .character:
                    "Search Characters"
                case .episode:
                    "Search Episodes"
                case .location:
                    "Search Locations"
                }
            }
        }

        let type: `Type`
    }

    private let config: Config

    /// Init
    init(config: Config) {
        self.config = config
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = config.type.title
        view.backgroundColor = .systemBackground
    }
}

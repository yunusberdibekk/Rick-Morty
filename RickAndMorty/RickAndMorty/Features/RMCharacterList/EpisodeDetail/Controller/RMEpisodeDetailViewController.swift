//
//  RMEpisodeDetailViewController.swift
//  RickAndMorty
//
//  Created by Yunus Emre Berdibek on 12.12.2023.
//

import UIKit

/// VC to show details about single episode.
final class RMEpisodeDetailViewController: UIViewController {
    /// Properties
    private let url: URL?
    
    /// Lifecycle
    /// - Parameter url: Url of the episode to be displayed.
    init(url: URL?) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Episode"
        view.backgroundColor = .green
    }
}

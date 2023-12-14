//
//  RMEpisodeDetailViewController.swift
//  RickAndMorty
//
//  Created by Yunus Emre Berdibek on 12.12.2023.
//

import UIKit

/// VC to show details about single episode.
final class RMEpisodeDetailViewController: UIViewController {
    /// Components
    private let detailView = RMEpisodeDetailView()
    
    /// Properties
    private let viewModel: RMEpisodeDetailViewModel

    /// Lifecycle
    /// - Parameter url: Url of the episode to be displayed.
    init(url: URL?) {
        self.viewModel = RMEpisodeDetailViewModel(url: url)
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(detailView)
        addConstraints()
        title = "Episode"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapShare))
    }
    
    @objc
    private func didTapShare() {}
}

/// Privatized UI functions.
extension RMEpisodeDetailViewController {
    func addConstraints() {
        NSLayoutConstraint.activate([
            detailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            detailView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            detailView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            detailView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}

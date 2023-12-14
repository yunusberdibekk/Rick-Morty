//
//  RMEpisodeViewController.swift
//  RickAndMorty
//
//  Created by Yunus Emre Berdibek on 26.11.2023.
//

import UIKit

/// Controller to show and search for Episodes
final class RMEpisodeListViewController: UIViewController {
    /// Properties

    /// Components
    private let episodeListView = RMEpisodeListView()

    /// Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Episodes"
        setUpView()
        addSearchButton()
    }

    private func addSearchButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapSearch))
    }

    @objc private func didTapSearch() {
//        let vc = RMSearchViewController(config: .init(type: .episode))
//        vc.navigationItem.largeTitleDisplayMode = .never
//        navigationController?.pushViewController(vc, animated: true)
    }

    // MARK: - RMEpisodeListViewDelegate
}

/// Privatized UI functions.
extension RMEpisodeListViewController {
    private func setUpView() {
        episodeListView.delegate = self
        view.addSubview(episodeListView)
        NSLayoutConstraint.activate([
            episodeListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            episodeListView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            episodeListView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            episodeListView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}

/// RMEpisodeListViewController + RMEpisodeListViewDelegate extension.
extension RMEpisodeListViewController: RMEpisodeListViewDelegate {
    func rmEpisodeListView(_ characterListView: RMEpisodeListView, didSelectEpisode episode: RMEpisode) {
        // Open detail controller for that episode
        let detailVC = RMEpisodeDetailViewController(url: URL(string: episode.url))
        detailVC.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

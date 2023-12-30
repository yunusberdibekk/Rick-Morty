//
//  RMCharacterViewController.swift
//  RickAndMorty
//
//  Created by Yunus Emre Berdibek on 26.11.2023.
//

import UIKit

/// Controller to show and search for characters.
final class RMCharacterListViewController: UIViewController {
    // MARK: - Properties

    private let characterListView: RMCharacterListView = .init()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Characters"
        setUpView()
        addSearchButton()
    }

    private func addSearchButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(didTapSearch))
    }

    @objc
    private func didTapSearch() {
        let vc = RMSearchViewController(config: RMSearchViewController.Config(type: .character))
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
}

/// Privatized UI functions.
extension RMCharacterListViewController {
    private func setUpView() {
        characterListView.delegate = self
        view.addSubview(characterListView)
        NSLayoutConstraint.activate([
            characterListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            characterListView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            characterListView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            characterListView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

/// RMCharacterListViewController + RMCharacterListViewDelegate extension.
extension RMCharacterListViewController: RMCharacterListViewDelegate {
    func rmCharacterListView(_ characterListView: RMCharacterListView, didSelectCharacter character: RMCharacter) {
        /// Open detail controller for that character
        let viewModel = RMCharacterDetailViewModel(character: character)
        let detailVC = RMCharacterDetailViewController(viewModel: viewModel)
        detailVC.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

#Preview {
    RMCharacterListViewController()
}

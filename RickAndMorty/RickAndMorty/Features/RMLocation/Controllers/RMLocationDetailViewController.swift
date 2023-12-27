//
//  RMLocationDetailViewController.swift
//  RickAndMorty
//
//  Created by Yunus Emre Berdibek on 27.12.2023.
//

import UIKit

final class RMLocationDetailViewController: UIViewController, RMLocationDetailViewModelDelegate, RMLocationDetailViewDelegate {
    private let viewModel: RMLocationDetailViewModel

    private let detailView = RMLocationDetailView()

    // MARK: - Init

    init(location: RMLocation) {
        let url = URL(string: location.url)
        self.viewModel = RMLocationDetailViewModel(endpointUrl: url)
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(detailView)
        addConstraints()
        detailView.delegate = self
        title = "Location"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapShare))

        viewModel.delegate = self
        viewModel.fetchLocationData()
    }

    private func addConstraints() {
        NSLayoutConstraint.activate([
            detailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            detailView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            detailView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            detailView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }

    @objc
    private func didTapShare() {}

    // MARK: - View Delegate

    func rmEpisodeDetailView(
        _ detailView: RMLocationDetailView,
        didSelect character: RMCharacter
    ) {
        let vc = RMCharacterDetailViewController(viewModel: .init(character: character))
        vc.title = character.name
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }

    // MARK: - ViewModel Delegate

    func didFetchLocationDetails() {
        detailView.configure(with: viewModel)
    }
}

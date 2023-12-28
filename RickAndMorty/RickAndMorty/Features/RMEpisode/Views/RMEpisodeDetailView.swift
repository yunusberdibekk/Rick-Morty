//
//  RMEpisodeDetailView.swift
//  RickAndMorty
//
//  Created by Yunus Emre Berdibek on 12.12.2023.
//

import UIKit

protocol RMEpisodeDetailViewDelegate: AnyObject {
    func rmEpisodeDetailView(
        _ detailView: RMEpisodeDetailView,
        didSelect character: RMCharacter)
}

final class RMEpisodeDetailView: UIView {
    /// Properties
    public weak var delegate: RMEpisodeDetailViewDelegate?

    private var viewModel: RMEpisodeDetailViewModel? {
        didSet {
            spinner.stopAnimating()
            collectionView?.reloadData()
            collectionView?.isHidden = false
            UIView.animate(withDuration: 0.3) {
                self.collectionView?.alpha = 1
            }
        }
    }

    /// Components
    private var collectionView: UICollectionView?

    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.hidesWhenStopped = true
        return spinner
    }()

    /// Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemBackground
        let collectionView = createCollectionView()
        addSubviews(collectionView, spinner)
        self.collectionView = collectionView
        addConstraints()

        spinner.startAnimating()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

/// Privatized UI functions.
extension RMEpisodeDetailView {
    public func configure(with viewModel: RMEpisodeDetailViewModel) {
        self.viewModel = viewModel
    }

    private func addConstraints() {
        guard let collectionView = collectionView else { return }
        NSLayoutConstraint.activate([
            spinner.heightAnchor.constraint(equalToConstant: 100),
            spinner.widthAnchor.constraint(equalToConstant: 100),
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor),

            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leftAnchor.constraint(equalTo: leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    private func createCollectionView() -> UICollectionView {
        let layout = UICollectionViewCompositionalLayout { section, _ in
            self.layout(for: section)
        }
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isHidden = true
        collectionView.alpha = 0
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(
            RMEpisodeInfoCollectionViewCell.self,
            forCellWithReuseIdentifier: RMEpisodeInfoCollectionViewCell.cellIdentifier)
        collectionView.register(
            RMCharacterCollectionViewCell.self,
            forCellWithReuseIdentifier: RMCharacterCollectionViewCell.cellIdentifier)
        return collectionView
    }

    private func layout(for section: Int) -> NSCollectionLayoutSection {
        guard let sections = viewModel?.cellViewModels else {
            return createInfoLayout()
        }

        switch sections[section] {
        case .information:
            return createInfoLayout()
        case .characters:
            return createCharacterLayout()
        }
    }

    private func createInfoLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)))

        item.contentInsets = NSDirectionalEdgeInsets(
            top: 10,
            leading: 10,
            bottom: 10,
            trailing: 10)

        let group = NSCollectionLayoutGroup.vertical(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(80)),
            subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        return section
    }

    private func createCharacterLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: .init(
                widthDimension: .fractionalWidth(0.5),
                heightDimension: .fractionalHeight(1.0)))

        item.contentInsets = NSDirectionalEdgeInsets(
            top: 5,
            leading: 10,
            bottom: 5,
            trailing: 10)

        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(260)),
            subitems: [item, item])

        let section = NSCollectionLayoutSection(group: group)
        return section
    }
}

extension RMEpisodeDetailView: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        viewModel?.cellViewModels.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let sections = viewModel?.cellViewModels else {
            return 0
        }
        let sectionType = sections[section]
        switch sectionType {
        case .information(let viewModels):
            return viewModels.count
        case .characters(let viewModels):
            return viewModels.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let sections = viewModel?.cellViewModels else {
            fatalError("No viewmodel")
        }
        let sectionType = sections[indexPath.section]
        switch sectionType {
        case .information(let viewModels):
            let cellViewModel = viewModels[indexPath.row]
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: RMEpisodeInfoCollectionViewCell.cellIdentifier,
                for: indexPath) as? RMEpisodeInfoCollectionViewCell
            else {
                fatalError()
            }
            cell.configure(with: cellViewModel)
            return cell
        case .characters(let viewModels):
            let cellViewModel = viewModels[indexPath.row]
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: RMCharacterCollectionViewCell.cellIdentifier,
                for: indexPath) as? RMCharacterCollectionViewCell
            else {
                fatalError()
            }
            cell.configure(with: cellViewModel)
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        guard let viewModel = viewModel else {
            return
        }
        let sections = viewModel.cellViewModels
        let sectionType = sections[indexPath.section]

        switch sectionType {
        case .information:
            break
        case .characters:
            guard let character = viewModel.character(at: indexPath.row) else { return }
            delegate?.rmEpisodeDetailView(self, didSelect: character)
        }
    }
}

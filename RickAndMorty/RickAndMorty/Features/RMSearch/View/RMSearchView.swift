//
//  RMSearchView.swift
//  RickAndMorty
//
//  Created by Yunus Emre Berdibek on 28.12.2023.
//

import UIKit

final class RMSearchView: UIView {
    // MARK: - Subviews

    // Search input view(bar , selection buttons)
    // No results view
    // Results collection view

    // MARK: - Properties

    private let viewModel: RMSearchViewModel

    // MARK: - Init

    init(frame: CGRect, viewModel: RMSearchViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        backgroundColor = .red
        translatesAutoresizingMaskIntoConstraints = false
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - CollectionView

extension RMSearchView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

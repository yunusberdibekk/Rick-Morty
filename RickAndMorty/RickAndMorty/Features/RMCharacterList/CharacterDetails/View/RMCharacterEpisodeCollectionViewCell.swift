//
//  RMCharacterEpisodeCollectionViewCell.swift
//  RickAndMorty
//
//  Created by Yunus Emre Berdibek on 10.12.2023.
//

import UIKit

class RMCharacterEpisodeCollectionViewCell: UICollectionViewCell {
    /// Properties
    static let cellIdentifier: String = "RMCharacterEpisodeCollectionViewCell"

    /// Components

    /// Init
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }

    public func configure(with viewModel: RMCharacterEpisodeCollectionViewCellViewModel) {}
}

/// RMCharacterPhotoCollectionViewCell private extension.
extension RMCharacterEpisodeCollectionViewCell {
    private func setUpConstraints() {}
}

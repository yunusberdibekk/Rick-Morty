//
//  RMCharacterInfoCollectionViewCell.swift
//  RickAndMorty
//
//  Created by Yunus Emre Berdibek on 10.12.2023.
//

import UIKit

class RMCharacterInformationCollectionViewCell: UICollectionViewCell {
    /// Properties
    static let cellIdentifier: String = "RMCharacterInformationCollectionViewCell"

    /// Components

    /// Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .tertiarySystemBackground
        contentView.layer.cornerRadius = 8
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }

    public func configure(with viewModel: RMCharacterInformationCollectionViewCellViewModel) {}
}

/// RMCharacterPhotoCollectionViewCell private extension.
extension RMCharacterInformationCollectionViewCell {
    private func setUpConstraints() {}
}

//
//  RMCharacterPhotoCollectionViewCell.swift
//  RickAndMorty
//
//  Created by Yunus Emre Berdibek on 10.12.2023.
//

import UIKit

class RMCharacterPhotoCollectionViewCell: UICollectionViewCell {
    /// Properties
    static let cellIdentifier: String = "RMCharacterPhotoCollectionViewCell"

    /// Components
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    /// Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        addConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }

    public func configure(with viewModel: RMCharacterPhotoCollectionViewCellViewModel) {
        viewModel.fetchImage { [weak self] result in
            switch result {
            case .success(let data):
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    self?.imageView.image = image
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

/// Privatized UI functions.
extension RMCharacterPhotoCollectionViewCell {
    private func addConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            imageView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
}

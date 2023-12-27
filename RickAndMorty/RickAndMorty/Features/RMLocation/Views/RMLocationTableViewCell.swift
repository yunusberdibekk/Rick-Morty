//
//  RMLocationTableViewCell.swift
//  RickAndMorty
//
//  Created by Yunus Emre Berdibek on 27.12.2023.
//

import UIKit

class RMLocationTableViewCell: UITableViewCell {
    static let cellIdentifier: String = "RMLocationTableViewCell"

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemBackground
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }

    public func configure(with viewModel: RMLocationTableViewCellViewModel) {}
}

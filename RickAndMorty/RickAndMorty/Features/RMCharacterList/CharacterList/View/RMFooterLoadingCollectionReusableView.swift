//
//  RMFooterLoadingCollectionReusableView.swift
//  RickAndMorty
//
//  Created by Yunus Emre Berdibek on 6.12.2023.
//

import UIKit

final class RMFooterLoadingCollectionReusableView: UICollectionReusableView {
    // MARK: - Properties

    static let identifier = "RMFooterLoadingCollectionReusableView"

    // MARK: - Components

    private let spinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addSubview(spinner)
        addConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }

    // MARK: - Functions

    public func startAnimating() {
        spinner.startAnimating()
    }

    public func stopAnimating() {
        spinner.stopAnimating()
    }
}

// MARK: - Constraints extension

extension RMFooterLoadingCollectionReusableView {
    private func addConstraints() {
        NSLayoutConstraint.activate([
            spinner.widthAnchor.constraint(equalToConstant: 100),
            spinner.heightAnchor.constraint(equalToConstant: 100),
            spinner.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
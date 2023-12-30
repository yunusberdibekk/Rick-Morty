//
//  RMSearchView.swift
//  RickAndMorty
//
//  Created by Yunus Emre Berdibek on 28.12.2023.
//

import UIKit

protocol RMSearchViewDelegate: AnyObject {
    func rmSearchView(_ searchView: RMSearchView,
                      didSelectOption option: RMSearchInputViewModel.DynamicOption)
}

final class RMSearchView: UIView {
    // MARK: - Components

    private let noResultsView: RMNoSearchResultsView = .init()
    private let searchInputView: RMSearchInputView = .init()

    // MARK: - Properties

    weak var delegate: RMSearchViewDelegate?
    private let viewModel: RMSearchViewModel

    // MARK: - Init

    init(frame: CGRect, viewModel: RMSearchViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        backgroundColor = .systemBackground
        translatesAutoresizingMaskIntoConstraints = false
        addSubviews(noResultsView, searchInputView)
        addConstraints()
        searchInputView.configure(with: RMSearchInputViewModel(type: viewModel.config.type))
        searchInputView.delegate = self
        viewModel.registerOptionChangeBlock { [weak self] tuple in
            self?.searchInputView.update(option: tuple.0, value: tuple.1)
        }
        viewModel.registerSearchResultHandler { results in
            print(results)
        }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func presentKeyboard() {
        searchInputView.presentKeyboard()
    }
}

extension RMSearchView {
    private func addConstraints() {
        NSLayoutConstraint.activate([
            noResultsView.widthAnchor.constraint(equalToConstant: 150),
            noResultsView.heightAnchor.constraint(equalToConstant: 150),
            noResultsView.centerXAnchor.constraint(equalTo: centerXAnchor),
            noResultsView.centerYAnchor.constraint(equalTo: centerYAnchor),

            searchInputView.topAnchor.constraint(equalTo: topAnchor),
            searchInputView.leftAnchor.constraint(equalTo: leftAnchor),
            searchInputView.rightAnchor.constraint(equalTo: rightAnchor),
            searchInputView.heightAnchor.constraint(equalToConstant: viewModel.config.type == .episode ? 55 : 110)
        ])
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

// MARK: -  RMSearchInputViewDeleagate

extension RMSearchView: RMSearchInputViewDelegate {
    func rmSearchInputView(_ inputView: RMSearchInputView, didSelectOption option: RMSearchInputViewModel.DynamicOption) {
        delegate?.rmSearchView(self, didSelectOption: option)
    }

    func rmSearchInputView(_ inputView: RMSearchInputView, didChangeSearchText text: String) {
        viewModel.set(query: text)
    }

    func rmSearchInputViewDidTapSearchKeyboardButton(_ inputView: RMSearchInputView) {
        viewModel.executeSearch()
    }
}

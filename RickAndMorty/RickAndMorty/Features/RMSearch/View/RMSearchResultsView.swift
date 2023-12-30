//
//  RMSearchResultsView.swift
//  RickAndMorty
//
//  Created by Yunus Emre Berdibek on 30.12.2023.
//

import UIKit

protocol RMSearchResultsViewDelegate: AnyObject {
    func rmSearchResultsView(_ resultsView: RMSearchResultsView, didTapLocationAt index: Int)
}

/// Shows search results UI(table or collection as needed)
final class RMSearchResultsView: UIView {
    // MARK: - Components

    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isHidden = true
        tableView.register(RMLocationTableViewCell.self,
                           forCellReuseIdentifier: RMLocationTableViewCell.cellIdentifier)
        return tableView
    }()

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isHidden = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(RMCharacterCollectionViewCell.self,
                                forCellWithReuseIdentifier: RMCharacterCollectionViewCell.cellIdentifier)
        collectionView.register(RMCharacterEpisodeCollectionViewCell.self,
                                forCellWithReuseIdentifier: RMCharacterEpisodeCollectionViewCell.cellIdentifier)
        collectionView.register(RMFooterLoadingCollectionReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                withReuseIdentifier: RMFooterLoadingCollectionReusableView.identifier)
        return collectionView
    }()

    // MARK: - Properties

    weak var delegate: RMSearchResultsViewDelegate?
    // TableView viewmodels.
    private var locationCellViewModels: [RMLocationTableViewCellViewModel] = []
    // CollectionView viewmodels.
    private var collectionViewCellViewModels: [any Hashable] = []

    private var viewModel: RMSearchResultViewModel? {
        didSet {
            self.processViewModel()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        isHidden = true
        addSubviews(tableView, collectionView)
        addConstraints()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func configure(with viewModel: RMSearchResultViewModel) {
        self.viewModel = viewModel
    }

    private func processViewModel() {
        guard let viewModel = viewModel else { return }
        switch viewModel.results {
        case .characters(let viewModels):
            collectionViewCellViewModels = viewModels
            setUpCollectionView()
        case .episodes(let viewModels):
            collectionViewCellViewModels = viewModels
            setUpCollectionView()
        case .locations(let viewModels):
            setUpTableView(viewModel: viewModels)
        }
    }

    private func setUpCollectionView() {
        tableView.isHidden = true
        collectionView.isHidden = false
        collectionView.delegate = self
        collectionView.dataSource = self
        tableView.reloadData()
    }

    private func setUpTableView(viewModel: [RMLocationTableViewCellViewModel]) {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = false
        collectionView.isHidden = true
        locationCellViewModels = viewModel
        tableView.reloadData()
    }
}

extension RMSearchResultsView {
    private func addConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.leftAnchor.constraint(equalTo: leftAnchor),
            tableView.rightAnchor.constraint(equalTo: rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),

            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leftAnchor.constraint(equalTo: leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}

// MARK: - TableViewDelegate, TableViewDataSource

extension RMSearchResultsView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        locationCellViewModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: RMLocationTableViewCell.cellIdentifier,
            for: indexPath) as? RMLocationTableViewCell
        else {
            fatalError()
        }
        cell.configure(with: locationCellViewModels[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.rmSearchResultsView(self, didTapLocationAt: indexPath.row)
    }
}

// MARK: - CollectionViewDelegate, CollectionViewDataSource, CollectionViewDelegateFlowLayout

extension RMSearchResultsView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionViewCellViewModels.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let currentViewModel = collectionViewCellViewModels[indexPath.row]
        if let characterVM = currentViewModel as? RMCharacterCollectionViewCellViewModel {
            guard let cell = self.collectionView.dequeueReusableCell(
                withReuseIdentifier: RMCharacterCollectionViewCell.cellIdentifier,
                for: indexPath) as? RMCharacterCollectionViewCell
            else {
                fatalError()
            }
            cell.configure(with: characterVM)
            return cell
        }
        guard let cell = self.collectionView.dequeueReusableCell(
            withReuseIdentifier: RMCharacterEpisodeCollectionViewCell.cellIdentifier,
            for: indexPath) as? RMCharacterEpisodeCollectionViewCell
        else {
            fatalError()
        }
        if let episodeVM = currentViewModel as? RMCharacterEpisodeCollectionViewCellViewModel {
            cell.configure(with: episodeVM)
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let currentViewModel = collectionViewCellViewModels[indexPath.row]
        if currentViewModel is RMCharacterCollectionViewCellViewModel {
            let bounds = UIScreen.main.bounds
            let width = (bounds.width - 30) / 2
            return CGSize(width: width, height: width * 1.5)
        }
        let bounds = collectionView.bounds
        let width = bounds.width - 20
        return CGSize(width: width, height: 100)
    }
}

// MARK: - ScrollViewDelegate

extension RMSearchResultsView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !locationCellViewModels.isEmpty {
            handleLocationPagination(scrollView: scrollView)
        } else {
            handleCharacterOrEpisodePagination(scrollView: scrollView)
        }
    }

    private func handleCharacterOrEpisodePagination(scrollView: UIScrollView) {}

    private func handleLocationPagination(scrollView: UIScrollView) {
        guard let viewModel = viewModel,
              !locationCellViewModels.isEmpty,
              viewModel.shouldShowLoadMoreIndicator,
              !viewModel.isLoadingMoreResults
        else {
            return
        }
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { [weak self] timer in
            let offset = scrollView.contentOffset.y
            let totalContentHeight = scrollView.contentSize.height
            let totalScrollViewFixedHeight = scrollView.frame.size.height
            if offset >= (totalContentHeight - totalScrollViewFixedHeight - 120) {
                DispatchQueue.main.async {
                    self?.showLoadingIndicator()
                }
                viewModel.fetchAdditionalLocations { [weak self] newResults in
                    self?.tableView.tableFooterView = nil
                    self?.locationCellViewModels = newResults
                    self?.tableView.reloadData()
                }
            }
            timer.invalidate()
        }
    }

    private func showLoadingIndicator() {
        let footer = RMTableLoadingFooterView(frame: CGRect(x: .zero, y: .zero, width: frame.size.width, height: 100))
        tableView.tableFooterView = footer
    }
}

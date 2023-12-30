//
//  CharacterListViewModel.swift
//  RickAndMorty
//
//  Created by Yunus Emre Berdibek on 4.12.2023.
//

import UIKit

// MARK: - Protocols

protocol RMCharacterListViewModelDelegate: AnyObject {
    func didLoadInitialCharacters()
    func didLoadMoreCharacters(with newIndexPaths: [IndexPath])
    func didSelectItemAt(_ character: RMCharacter)
}

/// View model to handle character list view logic
final class RMCharacterListViewModel: NSObject {
    /// Properties
    public weak var delegate: RMCharacterListViewModelDelegate?
    private var cellViewModels: [RMCharacterCollectionViewCellViewModel] = .init()
    private var apiInfo: RMGetAllCharactersResponse.Info? = nil
    private var isLoadingMoreCharacters: Bool = false

    private var characters: [RMCharacter] = [] {
        didSet {
            characters.forEach { character in
                let viewModel = RMCharacterCollectionViewCellViewModel(
                    characterName: character.name,
                    characterStatus: character.status,
                    characterImageURL: URL(string: character.image))
                if !cellViewModels.contains(viewModel) {
                    cellViewModels.append(viewModel)
                }
            }
        }
    }

    public var shouldShowLoadMoreIndicator: Bool {
        return apiInfo?.next != nil
    }

    /// Fetch initial set of characters(20)
    public func fetchCharacters() {
        RMService.shared.execute(.listCharactersRequests, expecting: RMGetAllCharactersResponse.self) { [weak self] result in
            switch result {
            case .success(let responseModel):
                let results = responseModel.results
                let info = responseModel.info
                self?.apiInfo = info
                self?.characters = results
                DispatchQueue.main.async {
                    self?.delegate?.didLoadInitialCharacters()
                }
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }

    /// Paginate if additional characters are needed.
    public func fetchAdditionalCharacters(url: URL) {
        guard !isLoadingMoreCharacters else { return }
        isLoadingMoreCharacters = true
        guard let request = RMRequest(url: url) else {
            isLoadingMoreCharacters = false
            return
        }

        RMService.shared.execute(request, expecting: RMGetAllCharactersResponse.self) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let responseModel):
                let moreResults = responseModel.results
                let info = responseModel.info
                let originalCount = strongSelf.characters.count
                let newCount = moreResults.count
                let total = originalCount + newCount
                let startingIndex = total - newCount - 1
                let indexPathsToAdd: [IndexPath] = Array(startingIndex ..< (startingIndex + newCount)).compactMap {
                    IndexPath(row: $0, section: 0)
                }
                strongSelf.apiInfo = info
                strongSelf.characters.append(contentsOf: moreResults)
                DispatchQueue.main.async {
                    strongSelf.delegate?.didLoadMoreCharacters(with: indexPathsToAdd)
                    strongSelf.isLoadingMoreCharacters = false
                }
            case .failure(let failure):
                print(failure.localizedDescription)
                self?.isLoadingMoreCharacters = false
            }
        }
    }
}

/// RMCharacterListViewModel + CollectionView extension.
extension RMCharacterListViewModel: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellViewModels.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: RMCharacterCollectionViewCell.cellIdentifier,
            for: indexPath) as? RMCharacterCollectionViewCell
        else {
            fatalError("Unsupported")
        }
        cell.configure(with: cellViewModels[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = UIScreen.main.bounds
        let width = (bounds.width - 30) / 2
        return CGSize(width: width, height: width * 1.5)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let character = characters[indexPath.row]
        delegate?.didSelectItemAt(character)
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionFooter else {
            fatalError("Unsupported")
        }
        guard let footer = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: RMFooterLoadingCollectionReusableView.identifier,
            for: indexPath) as? RMFooterLoadingCollectionReusableView
        else {
            fatalError("Unsupported")
        }
        footer.startAnimating()
        return footer
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        guard shouldShowLoadMoreIndicator else { return .zero }
        return CGSize(width: collectionView.frame.width, height: 100)
    }
}

/// RMCharacterListViewModel + ScroolView extension.
extension RMCharacterListViewModel: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard shouldShowLoadMoreIndicator,
              !isLoadingMoreCharacters,
              !cellViewModels.isEmpty,
              let nextURLString = apiInfo?.next,
              let url = URL(string: nextURLString)
        else {
            return
        }
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: false) { [weak self] timer in
            let offset = scrollView.contentOffset.y
            let totalContentHeight = scrollView.contentSize.height
            let totalScrollViewFixedHeight = scrollView.frame.size.height
            if offset >= (totalContentHeight - totalScrollViewFixedHeight - 120) {
                self?.fetchAdditionalCharacters(url: url)
            }

            timer.invalidate()
        }
    }
}

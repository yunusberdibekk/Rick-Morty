//
//  RMSearchResultType.swift
//  RickAndMorty
//
//  Created by Yunus Emre Berdibek on 30.12.2023.
//

import Foundation

final class RMSearchResultViewModel {
    // MARK: - Properties

    public private(set) var results: RMSearchResultType
    private var next: String?

    // MARK: - Init

    init(results: RMSearchResultType, next: String?) {
        self.results = results
        self.next = next
    }

    public private(set) var isLoadingMoreResults = false
    public var shouldShowLoadMoreIndicator: Bool {
        next != nil
    }

    public func fetchAdditionalLocations(completion: @escaping ([RMLocationTableViewCellViewModel]) -> Void) {
        guard !isLoadingMoreResults else { return }

        guard let nextURLString = next,
              let url = URL(string: nextURLString) else { return }
        isLoadingMoreResults = true

        guard let request = RMRequest(url: url) else {
            isLoadingMoreResults = false
            return
        }

        RMService.shared.execute(request, expecting: RMGetAllLocationsResponse.self) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let responseModel):
                let moreResults = responseModel.results
                let info = responseModel.info
                strongSelf.next = info.next
                let additionalLocations = moreResults.compactMap {
                    RMLocationTableViewCellViewModel(location: $0)
                }
                var newResults: [RMLocationTableViewCellViewModel] = []
                switch strongSelf.results {
                case .locations(let existingResults):
                    newResults = existingResults + additionalLocations
                    strongSelf.results = .locations(newResults)
                case .characters, .episodes:
                    break
                }
                DispatchQueue.main.async {
                    strongSelf.isLoadingMoreResults = false
                    completion(newResults)
                }
            case .failure(let failure):
                print(failure.localizedDescription)
                self?.isLoadingMoreResults = false
            }
        }
    }
}

enum RMSearchResultType {
    case characters([RMCharacterCollectionViewCellViewModel])
    case episodes([RMCharacterEpisodeCollectionViewCellViewModel])
    case locations([RMLocationTableViewCellViewModel])
}

//
//  RMSearchViewModel.swift
//  RickAndMorty
//
//  Created by Yunus Emre Berdibek on 28.12.2023.
//

import Foundation

final class RMSearchViewModel {
    // MARK: - Properties

    let config: RMSearchViewController.Config
    private var optionMapUpdateBlock: (((RMSearchInputViewModel.DynamicOption, String)) -> Void)?
    private var searchResultHandler: ((RMSearchResultViewModel) -> Void)?
    private var noResultsHandler: (() -> Void)?
    private var optionMap: [RMSearchInputViewModel.DynamicOption: String] = [:]
    private var searchResultModel: Codable?
    private var searchText: String = ""

    // MARK: - Init

    init(config: RMSearchViewController.Config) {
        self.config = config
    }

    // MARK: - Public

    public func registerSearchResultHandler(_ block: @escaping (RMSearchResultViewModel) -> Void) {
        searchResultHandler = block
    }

    public func registerNoResultsHandler(_ block: @escaping () -> Void) {
        noResultsHandler = block
    }

    /// It will execute search based on the searchText.
    /// ```
    /// https://rickandmortyapi.com/api/character/?name=rick
    /// https://rickandmortyapi.com/api/character/?name=rick&status=alive
    /// https://rickandmortyapi.com/api/character/?name=rick&gender=male
    /// https://rickandmortyapi.com/api/character/?name=rick&status=alive&gender=male
    /// ```
    public func executeSearch() {
        guard !searchText.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        // Build arguments
        var queryParams: [URLQueryItem] = [
            URLQueryItem(name: "name", value: searchText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))
        ]
        // Add options
        queryParams.append(contentsOf: optionMap.enumerated().compactMap { _, element in
            let key: RMSearchInputViewModel.DynamicOption = element.key
            let value: String = element.value
            return URLQueryItem(name: key.queryArgument, value: value)
        })
        // Create request
        let request = RMRequest(endpoint: config.type.endpoint, queryParameters: queryParams)
        switch config.type.endpoint {
        case .character:
            makeSearchAPICall(RMGetAllCharactersResponse.self, request: request)
        case .location:
            makeSearchAPICall(RMGetAllLocationsResponse.self, request: request)
        case .episode:
            makeSearchAPICall(RMGetAllEpisodesResponse.self, request: request)
        }
    }

    private func makeSearchAPICall<T: Codable>(_ type: T.Type, request: RMRequest) {
        RMService.shared.execute(request, expecting: type) { [weak self] result in
            switch result {
            case .success(let model):
                self?.processSearchResults(model: model)
            case .failure:
                self?.handleNoResults()
            }
        }
    }

    private func processSearchResults(model: Codable) {
        var resultsVM: RMSearchResultType?
        var nextURL: String?
        if let charactersResults = model as? RMGetAllCharactersResponse {
            resultsVM = .characters(charactersResults.results.compactMap {
                RMCharacterCollectionViewCellViewModel(
                    characterName: $0.name,
                    characterStatus: $0.status,
                    characterImageURL: URL(string: $0.image))
            })
            nextURL = charactersResults.info.next
        }
        else if let episodesResults = model as? RMGetAllEpisodesResponse {
            resultsVM = .episodes(episodesResults.results.compactMap {
                RMCharacterEpisodeCollectionViewCellViewModel(episodeDataUrl: URL(string: $0.url))
            })
            nextURL = episodesResults.info.next
        }
        else if let locationsResults = model as? RMGetAllLocationsResponse {
            resultsVM = .locations(locationsResults.results.compactMap {
                RMLocationTableViewCellViewModel(location: $0)
            })
            nextURL = locationsResults.info.next
        }
        if let results = resultsVM {
            searchResultModel = model
            let vm = RMSearchResultViewModel(results: results, next: nextURL)
            searchResultHandler?(vm)
        }
        else {
            handleNoResults()
        }
    }

    private func handleNoResults() {
        noResultsHandler?()
    }

    public func set(query text: String) {
        searchText = text
    }

    public func set(value: String, for option: RMSearchInputViewModel.DynamicOption) {
        optionMap[option] = value
        let tuple = (option, value)
        optionMapUpdateBlock?(tuple)
    }

    public func registerOptionChangeBlock(_ block: @escaping ((RMSearchInputViewModel.DynamicOption, String)) -> Void) {
        optionMapUpdateBlock = block
    }

    public func locationSearchResult(at index: Int) -> RMLocation? {
        guard let searchModel = searchResultModel as? RMGetAllLocationsResponse else {
            return nil
        }
        return searchModel.results[index]
    }
}

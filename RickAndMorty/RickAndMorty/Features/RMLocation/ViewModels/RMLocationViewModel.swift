//
//  RMLocationViewModel.swift
//  RickAndMorty
//
//  Created by Yunus Emre Berdibek on 27.12.2023.
//

import Foundation

protocol RMLocationViewModelDelegate: AnyObject {
    func didFetchInitialLocations()
}

final class RMLocationViewModel {
    weak var delegate: RMLocationViewModelDelegate?
    public var apiInfo: RMGetAllLocationsResponse.Info?
    public private(set) var cellViewModels: [RMLocationTableViewCellViewModel] = []
    public var isLoadingMoreLocations: Bool = false

    private var locations: [RMLocation] = [] {
        didSet {
            for location in locations {
                let cellViewModel = RMLocationTableViewCellViewModel(location: location)
                if !cellViewModels.contains(cellViewModel) {
                    cellViewModels.append(cellViewModel)
                }
            }
        }
    }

    private var didFinishPagination: (() -> Void)?

    public var shouldShowMoreIndicator: Bool {
        return apiInfo?.next != nil
    }

    init() {}

    public func registerDidFinishPaginationBlock(_ block: @escaping () -> Void) {
        didFinishPagination = block
    }

    public func location(at index: Int) -> RMLocation? {
        guard index < locations.count, index >= 0 else {
            return nil
        }
        return locations[index]
    }

    public func fetchLocations() {
        RMService.shared.execute(.listLocationsRequest, expecting: RMGetAllLocationsResponse.self) { [weak self] result in
            switch result {
            case .success(let model):
                self?.apiInfo = model.info
                self?.locations = model.results
                DispatchQueue.main.async {
                    self?.delegate?.didFetchInitialLocations()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    public func fetchAdditionalLocations() {
        guard !isLoadingMoreLocations else { return }

        guard let nextURLString = apiInfo?.next,
              let url = URL(string: nextURLString) else { return }
        isLoadingMoreLocations = true

        guard let request = RMRequest(url: url) else {
            isLoadingMoreLocations = false
            return
        }

        RMService.shared.execute(request, expecting: RMGetAllLocationsResponse.self) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let responseModel):
                let moreResults = responseModel.results
                let info = responseModel.info
                strongSelf.apiInfo = info
                strongSelf.cellViewModels.append(contentsOf: moreResults.compactMap {
                    RMLocationTableViewCellViewModel(location: $0)
                })
                DispatchQueue.main.async {
                    strongSelf.isLoadingMoreLocations = false
                    // Notify via callback
                    strongSelf.didFinishPagination?()
                }
            case .failure(let failure):
                print(failure.localizedDescription)
                self?.isLoadingMoreLocations = false
            }
        }
    }
}

//
//  RMLocationViewModel.swift
//  RickAndMorty
//
//  Created by Yunus Emre Berdibek on 27.12.2023.
//

import Foundation

final class RMLocationViewModel {
    private var locations: [RMLocation] = []
    // Location response info.
    // Will contain next url, if present
    private var cellViewModels: [String] = []

    private var hasMoreResults: Bool {
        false
    }

    init() {}

    public func fetchLocations() {
        RMService.shared.execute(.listLocationsRequest, expecting: String.self) { [weak self] result in
            switch result {
            case .success(let models):
                break
            case .failure(let error):
                break
            }
        }
    }
}

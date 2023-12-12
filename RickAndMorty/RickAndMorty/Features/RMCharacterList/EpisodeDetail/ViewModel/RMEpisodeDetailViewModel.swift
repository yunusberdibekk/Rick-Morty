//
//  RMEpisodeDetailViewModel.swift
//  RickAndMorty
//
//  Created by Yunus Emre Berdibek on 12.12.2023.
//

import Foundation

final class RMEpisodeDetailViewModel {
    /// Properties
    private let endpointUrl: URL?

    /// Init
    init(url: URL?) {
        self.endpointUrl = url
        fetchEpisodeData()
    }

    private func fetchEpisodeData() {
        guard let url = endpointUrl, let request = RMRequest(url: url) else {
            return
        }
        RMService.shared.execute(request, expecting: RMEpisode.self) { result in
            switch result {
            case .success(let model):
                print(String(describing: model))
            case .failure(let error):
                print(String(describing: error))
            }
        }
    }
}

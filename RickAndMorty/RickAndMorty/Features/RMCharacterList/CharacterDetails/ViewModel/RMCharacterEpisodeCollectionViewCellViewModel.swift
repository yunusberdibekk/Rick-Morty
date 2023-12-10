//
//  RMCharacterEpisodeCollectionViewCellViewModel.swift
//  RickAndMorty
//
//  Created by Yunus Emre Berdibek on 10.12.2023.
//

import Foundation

final class RMCharacterEpisodeCollectionViewCellViewModel {
    /// Properties
    let episodeDataURL: URL?

    /// Init
    init(episodeDataURL: URL?) {
        self.episodeDataURL = episodeDataURL
    }
}

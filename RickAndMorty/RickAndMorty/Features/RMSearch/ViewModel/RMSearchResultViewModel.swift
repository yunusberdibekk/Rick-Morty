//
//  RMSearchResultViewModel.swift
//  RickAndMorty
//
//  Created by Yunus Emre Berdibek on 30.12.2023.
//

import Foundation

enum RMSearchResultViewModel {
    case characters([RMCharacterCollectionViewCellViewModel])
    case episodes([RMCharacterEpisodeCollectionViewCellViewModel])
    case locations([RMLocationTableViewCellViewModel])
}

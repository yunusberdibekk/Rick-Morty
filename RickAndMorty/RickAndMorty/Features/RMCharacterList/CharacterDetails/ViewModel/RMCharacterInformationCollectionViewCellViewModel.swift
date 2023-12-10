//
//  RMCharacterInformationCollectionViewCellViewModel.swift
//  RickAndMorty
//
//  Created by Yunus Emre Berdibek on 10.12.2023.
//

import Foundation

final class RMCharacterInformationCollectionViewCellViewModel {
    /// Properties
    public let value: String
    public let title: String

    /// Init
    init(value: String, title: String) {
        self.value = value
        self.title = title
    }
}

//
//  RMCharacterDetailViewModel.swift
//  RickAndMorty
//
//  Created by Yunus Emre Berdibek on 5.12.2023.
//

import Foundation

final class RMCharacterDetailViewModel {
    private let character: RMCharacter

    init(character: RMCharacter) {
        self.character = character
    }

    public var title: String {
        character.name.uppercased()
    }
}

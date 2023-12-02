//
//  RMCharacterStatus.swift
//  RickAndMorty
//
//  Created by Yunus Emre Berdibek on 2.12.2023.
//

import Foundation

enum RMCharacterStatus: String, Codable {
    case alive = "Alive"
    case dead = "Dead"
    case `unknown` = "unknown"
}

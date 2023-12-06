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
    case unknown

    var text: String {
        switch self {
        case .alive, .dead:
            return rawValue
        case .unknown:
            return "Unknown"
        }
    }
}

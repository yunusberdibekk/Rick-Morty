//
//  RMSearchInputViewModel.swift
//  RickAndMorty
//
//  Created by Yunus Emre Berdibek on 28.12.2023.
//

import Foundation

final class RMSearchInputViewModel {
    enum DynamicOption: String {
        case status = "Status"
        case gender = "Gender"
        case locationType = "Location Type"

        var choices: [String] {
            switch self {
            case .status:
                ["alive", "dead", "unknown"]
            case .gender:
                ["male", "female", "genderless", "unknown"]
            case .locationType:
                ["cluster", "planet", "microverse"]
            }
        }

        var queryArgument: String {
            switch self {
            case .status:
                "status"
            case .gender:
                "gender"
            case .locationType:
                "type"
            }
        }
    }

    private let type: RMSearchViewController.Config.`Type`

    init(type: RMSearchViewController.Config.`Type`) {
        self.type = type
    }

    // MARK: - Public

    public var hasDynamicOptions: Bool {
        switch type {
        case .character, .location:
            true
        case .episode:
            false
        }
    }

    public var options: [DynamicOption] {
        switch type {
        case .character:
            return [.status, .gender]
        case .episode:
            return []
        case .location:
            return [.locationType]
        }
    }

    public var searchPlaceholderText: String {
        switch type {
        case .character:
            return "Character Name"
        case .episode:
            return "Episode Title"
        case .location:
            return "Location Name"
        }
    }
}

//
//  RMSettingsCellViewModel.swift
//  RickAndMorty
//
//  Created by Yunus Emre Berdibek on 14.12.2023.
//

import UIKit

struct RMSettingsCellViewModel: Identifiable {
    // MARK: - Properties

    let id = UUID()

    public let type: RMSettingsOption
    public let onTapHandler: (RMSettingsOption) -> Void

    public var image: UIImage? {
        type.iconImage
    }

    public var title: String {
        type.displayTitle
    }

    public var iconContainerColor: UIColor {
        type.iconContainerColor
    }

    // MARK: - Init

    init(type: RMSettingsOption, onTapHandler: @escaping (RMSettingsOption) -> Void) {
        self.type = type
        self.onTapHandler = onTapHandler
    }
}

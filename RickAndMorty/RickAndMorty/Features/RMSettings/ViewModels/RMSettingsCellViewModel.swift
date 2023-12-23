//
//  RMSettingsCellViewModel.swift
//  RickAndMorty
//
//  Created by Yunus Emre Berdibek on 14.12.2023.
//

import UIKit

struct RMSettingsCellViewModel: Identifiable, Hashable {
    /// Properties
    let id = UUID()

    private let type: RMSettingsOption

    public var image: UIImage? {
        type.iconImage
    }

    public var title: String {
        type.displayTitle
    }

    public var iconContainerColor: UIColor {
        type.iconContainerColor
    }

    /// Init
    init(type: RMSettingsOption) {
        self.type = type
    }
}

//
//  RMSettingsOption.swift
//  RickAndMorty
//
//  Created by Yunus Emre Berdibek on 14.12.2023.
//

import UIKit

enum RMSettingsOption: CaseIterable {
    case rateApp
    case contactUs
    case terms
    case privacy
    case apiReference
    case viewSeries
    case viewCode

    var targetURL: URL? {
        switch self {
        case .rateApp:
            nil
        case .contactUs:
            URL(string: "https://github.com/yunusberdibekk")
        case .terms:
            URL(string: "https://github.com/yunusberdibekk")
        case .privacy:
            URL(string: "https://github.com/yunusberdibekk")
        case .apiReference:
            URL(string: "https://rickandmortyapi.com")
        case .viewSeries:
            URL(string: "        https://www.youtube.com/watch?v=EZpZDuOAFKE&list=PL5PR3UyfTWvdl4Ya_2veOB6TM16FXuv4y&index=2")
        case .viewCode:
            URL(string: "https://github.com/yunusberdibekk/RickAndMorty")
        }
    }

    var displayTitle: String {
        switch self {
        case .rateApp:
            "Rate App"
        case .contactUs:
            "Contack Us"
        case .terms:
            "Terms of Service"
        case .privacy:
            "Privacy Policy"
        case .apiReference:
            "Api Reference"
        case .viewSeries:
            "View Video Series"
        case .viewCode:
            "View App Code"
        }
    }

    var iconImage: UIImage? {
        switch self {
        case .rateApp:
            UIImage(systemName: "star.fill")
        case .contactUs:
            UIImage(systemName: "paperplane")
        case .terms:
            UIImage(systemName: "doc")
        case .privacy:
            UIImage(systemName: "lock")
        case .apiReference:
            UIImage(systemName: "list.clipboard")
        case .viewSeries:
            UIImage(systemName: "tv.fill")
        case .viewCode:
            UIImage(systemName: "hammer.fill")
        }
    }

    var iconContainerColor: UIColor {
        switch self {
        case .rateApp:
            return .systemBlue
        case .contactUs:
            return .systemGreen
        case .terms:
            return .systemRed
        case .privacy:
            return .systemYellow
        case .apiReference:
            return .systemOrange
        case .viewSeries:
            return .purple
        case .viewCode:
            return .systemPink
        }
    }
}

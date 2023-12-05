//
//  ViewController.swift
//  RickAndMorty
//
//  Created by Yunus Emre Berdibek on 26.11.2023.
//

import SwiftUI
import UIKit

/// Controller to house tabs and route tab controllers.
final class RootTabViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTabs()
    }

    private func setUpTabs() {
        let charactersNavController = UINavigationController(
            rootViewController: CharacterListViewController())
        let locationsNavController = UINavigationController(
            rootViewController: LocationListViewController())
        let episodesNavController = UINavigationController(
            rootViewController: EpisodeListViewController())
        let settingsNavController = UINavigationController(
            rootViewController: SettingsViewController())

        charactersNavController.tabBarItem = UITabBarItem(
            title: "Characters",
            image: UIImage(systemName: "person"),
            tag: 1)
        locationsNavController.tabBarItem = UITabBarItem(
            title: "Locations",
            image: UIImage(systemName: "globe"),
            tag: 2)
        episodesNavController.tabBarItem = UITabBarItem(
            title: "Episodes",
            image: UIImage(systemName: "tv"),
            tag: 3)
        settingsNavController.tabBarItem = UITabBarItem(
            title: "Settings",
            image: UIImage(systemName: "gear"),
            tag: 4)

        for navController in [charactersNavController, locationsNavController, episodesNavController, settingsNavController] {
            navController.navigationItem.largeTitleDisplayMode = .automatic
            navController.navigationBar.prefersLargeTitles = true
        }

        setViewControllers([charactersNavController, locationsNavController, episodesNavController, settingsNavController], animated: true)
    }
}

#Preview {
    RootTabViewController()
}

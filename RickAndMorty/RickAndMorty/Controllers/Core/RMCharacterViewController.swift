//
//  RMCharacterViewController.swift
//  RickAndMorty
//
//  Created by Yunus Emre Berdibek on 26.11.2023.
//

import UIKit

/// Controller to show and search for characters.
final class RMCharacterViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Characters"

        let request = RMRequest(
            endpoint: .character,
            pathComponents: ["1"],
            queryParameters: [
                URLQueryItem(name: "name", value: "rick"),
                URLQueryItem(name: "status", value: "alive"),
            ]
        )

        RMService.shared.execute(request, expecting: String.self) { result in
            switch result {
            case .success(let success):
                print(success)
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
        print(request.url)
    }
}

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

        RMService.shared.execute(.listCharactersRequest, expecting: RMGetAllCharactersResponse.self) { result in
            switch result {
            case .success(let model):
                print("Total: \(model.info.count)")
                print("Page result count: \(model.results.count)")
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
}

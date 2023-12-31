//
//  RMCharacterPhotoCollectionViewCellViewModel.swift
//  RickAndMorty
//
//  Created by Yunus Emre Berdibek on 10.12.2023.
//

import Foundation

final class RMCharacterPhotoCollectionViewCellViewModel {
    // MARK: - Properties

    private let imageURL: URL?

    // MARK: - Init

    init(imageURL: URL?) {
        self.imageURL = imageURL
    }

    public func fetchImage(completion: @escaping (Result<Data, Error>) -> Void) {
        guard let imageURL = imageURL else {
            completion(.failure(URLError(.badURL)))
            return
        }
        RMImageLoader.shared.downloadImage(imageURL, completion: completion)
    }
}

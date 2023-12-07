//
//  ImageLoader.swift
//  RickAndMorty
//
//  Created by Yunus Emre Berdibek on 7.12.2023.
//

import Foundation

final class RMImageLoader {
    /// Singleton instance.
    static let shared: RMImageLoader = .init()
    private var imageDataCache: NSCache = NSCache<NSString, NSData>()

    /// Privatized init.
    private init() {}

    /// Get image content with URI. If the image has already been downloaded, data is returned from the cache.
    /// - Parameters:
    ///   - url: Source url.
    ///   - completion: Callback.
    public func downloadImage(_ url: URL, completion: @escaping (Result<Data, Error>) -> Void) {
        let key = url.absoluteString as NSString
        if let data = imageDataCache.object(forKey: key) {
            completion(.success(data as Data))
            return
        }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(error ?? URLError(.badServerResponse)))
                return
            }
            let value = data as NSData
            self?.imageDataCache.setObject(value, forKey: key)
            completion(.success(data))
        }
        task.resume()
    }
}

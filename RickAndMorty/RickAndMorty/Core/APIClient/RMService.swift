//
//  RMService.swift
//  RickAndMorty
//
//  Created by Yunus Emre Berdibek on 26.11.2023.
//

import Foundation

/// Primary API service object to get RickAndMort data.
final class RMService {
    /// Singleton instance.
    static let shared: RMService = .init()
    private let cacheManager = RMAPICacheManager()

    /// Privatized init.
    private init() {}

    enum RMServiceError: Error {
        case failedToCreateRequest
        case failedToGetData
    }

    /// Send RickAndMorty API Call.
    /// - Parameters:
    ///   - request: Request instance.
    ///   - type: Type of object we expect get back.
    ///   - completion: Call back with data or error.
    public func execute<T: Codable>(
        _ request: RMRequest,
        expecting type: T.Type,
        completion: @escaping (Result<T, Error>) -> Void)
    {
        if let cachedData = cacheManager.cachedResponse(for: request.endpoint, url: request.url) {
            do {
                let result = try JSONDecoder().decode(type.self, from: cachedData)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
            return
        }

        guard let urlRequest = self.request(from: request) else {
            completion(.failure(RMServiceError.failedToCreateRequest))
            return
        }

        let task = URLSession.shared.dataTask(with: urlRequest) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                completion(.failure(RMServiceError.failedToGetData))
                return
            }

            do {
                let result = try JSONDecoder().decode(type.self, from: data)
                self?.cacheManager.setCache(for: request.endpoint, url: request.url, data: data)
                completion(.success(result))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}

extension RMService {
    private func request(from rmRequest: RMRequest) -> URLRequest? {
        guard let url = rmRequest.url else {
            return nil
        }

        var request = URLRequest(url: url)
        request.httpMethod = rmRequest.httpMethod
        return request
    }
}

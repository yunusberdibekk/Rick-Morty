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

    /// Privatized constructor.
    private init() {}

    /// Send RickAndMorty API Call.
    /// - Parameters:
    ///   - request: Request instance.
    ///   - type: Type of object we expect get back.
    ///   - completion: Call back with data or error.
    public func execute<T: Codable>(
        _ request: RMRequest,
        expecting type: T.Type,
        completion: @escaping (Result<String, Error>) -> Void) {}
}

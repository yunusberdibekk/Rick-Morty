//
//  RMEndpoint.swift
//  RickAndMorty
//
//  Created by Yunus Emre Berdibek on 26.11.2023.
//

import Foundation

/// Represents unique API endpoints.
@frozen enum RMEndpoint: String {
    /// Endpoint to get character info.
    case character
    /// Endpoint to get location info.
    case location
    /// Endpoint to get episode info.
    case episode
}

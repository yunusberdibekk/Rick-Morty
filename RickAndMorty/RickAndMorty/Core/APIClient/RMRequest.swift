//
//  RMRequest.swift
//  RickAndMorty
//
//  Created by Yunus Emre Berdibek on 26.11.2023.
//

import Foundation

/// Object that represents single API call.
final class RMRequest {
    /// API Contants
    private enum Constants {
        static let baseURL = "https://rickandmortyapi.com/api"
    }

    /// Desired endpoint.
    let endpoint: RMEndpoint
    /// Path components for API, if any.
    private let pathComponents: [String]
    /// Query arguments for API, if any.
    private let queryParameters: [URLQueryItem]

    /// Constructed url for the api request in string format
    private var urlString: String {
        var string = Constants.baseURL
        string += "/"
        string += endpoint.rawValue

        if !pathComponents.isEmpty {
            pathComponents.forEach {
                string += "/\($0)"
            }
        }

        if !queryParameters.isEmpty {
            string += "?"
            // name=value&name=value&
            let argumentString = queryParameters.compactMap {
                guard let value = $0.value else { return nil }
                return "\($0.name)=\(value)"
            }.joined(separator: "&")
            string += argumentString
        }

        return string
    }

    // MARK: - Public

    /// Desired http method.
    public let httpMethod = "GET"

    /// Computed & constructed API url.
    public var url: URL? {
        return URL(string: urlString)
    }

    /// Construct request.
    /// - Parameters:
    ///   - endpoint: Target endpoint
    ///   - pathComponents: Collection of path components.
    ///   - queryParameters: Collection of query parameters.
    public init(endpoint: RMEndpoint, pathComponents: [String] = [], queryParameters: [URLQueryItem] = []) {
        self.endpoint = endpoint
        self.pathComponents = pathComponents
        self.queryParameters = queryParameters
    }

    /// Attempt to create request.
    /// - Parameter url: URL to parse.
    convenience init?(url: URL) {
        let string = url.absoluteString
        if !string.contains(Constants.baseURL) {
            return nil
        }
        let trimmed = string.replacingOccurrences(of: Constants.baseURL + "/", with: "")
        if trimmed.contains("/") {
            let components = trimmed.components(separatedBy: "/")
            if !components.isEmpty {
                let endpointString = components[0]
                var pathComponents: [String] = []
                if components.count > 1 {
                    pathComponents = components
                    pathComponents.removeFirst()
                }
                if let rmEndpoint = RMEndpoint(rawValue: endpointString) {
                    self.init(endpoint: rmEndpoint, pathComponents: pathComponents)
                    return
                }
            }
        }
        else if trimmed.contains("?") {
            let components = trimmed.components(separatedBy: "?")
            if !components.isEmpty, components.count >= 2 {
                let endpointString = components[0]
                let queryItemsString = components[1]
                let queryItems: [URLQueryItem] = queryItemsString.components(separatedBy: "&").compactMap {
                    guard $0.contains("=") else {
                        return nil
                    }
                    let parts = $0.components(separatedBy: "=")
                    return URLQueryItem(name: parts[0], value: parts[1])
                }
                if let rmEndpoint = RMEndpoint(rawValue: endpointString) {
                    self.init(endpoint: rmEndpoint, queryParameters: queryItems)
                    return
                }
            }
        }
        return nil
    }
}

extension RMRequest {
    static let listCharactersRequest = RMRequest(endpoint: .character)
}

//
//  RMLocationTableViewCellViewModel.swift
//  RickAndMorty
//
//  Created by Yunus Emre Berdibek on 27.12.2023.
//

import Foundation

final class RMLocationTableViewCellViewModel: Hashable, Equatable {
    // MARK: - Properties

    private let location: RMLocation
    
    // MARK: - Init

    init(location: RMLocation) {
        self.location = location
    }
    
    public var name: String {
        location.name
    }
    
    public var type: String {
        "Type: " + location.type
    }
    
    public var dimension: String {
        location.dimension
    }
    
    static func == (lhs: RMLocationTableViewCellViewModel, rhs: RMLocationTableViewCellViewModel) -> Bool {
        return lhs.location.id == rhs.location.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(location.id)
        hasher.combine(name)
        hasher.combine(type)
        hasher.combine(dimension)
    }
}

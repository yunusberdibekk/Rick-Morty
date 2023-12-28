//
//  RMSearchViewModel.swift
//  RickAndMorty
//
//  Created by Yunus Emre Berdibek on 28.12.2023.
//

import Foundation

final class RMSearchViewModel {
    // MARK: - Properties

    let config: RMSearchViewController.Config
    private var optionMapUpdateBlock: (((RMSearchInputViewModel.DynamicOption, String)) -> Void)?
    private var optionMap: [RMSearchInputViewModel.DynamicOption: String] = [:]
    private var searchText: String = ""

    // MARK: - Init

    init(config: RMSearchViewController.Config) {
        self.config = config
    }

    // MARK: - Public

    public func executeSearch() {}

    public func set(query text: String) {
        searchText = text
    }

    public func set(value: String, for option: RMSearchInputViewModel.DynamicOption) {
        optionMap[option] = value
        let tuple = (option, value)
        optionMapUpdateBlock?(tuple)
    }

    public func registerOptionChangeBlock(_ block: @escaping ((RMSearchInputViewModel.DynamicOption, String)) -> Void) {
        optionMapUpdateBlock = block
    }
}

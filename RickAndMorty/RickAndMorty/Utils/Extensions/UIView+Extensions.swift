//
//  UIView+Extensions.swift
//  RickAndMorty
//
//  Created by Yunus Emre Berdibek on 4.12.2023.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach {
            addSubview($0)
        }
    }
}

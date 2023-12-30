//
//  UIDevice+Extensions.swift
//  RickAndMorty
//
//  Created by Yunus Emre Berdibek on 27.12.2023.
//

import UIKit

extension UIDevice {
    /// Check if current device is phone idiom
    static let isIphone = UIDevice.current.userInterfaceIdiom == .phone
}

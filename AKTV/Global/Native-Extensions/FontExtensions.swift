//
//  FontExtensions.swift
//  AKTV
//
//  Created by Alexander Kvamme on 05/02/2021.
//  Copyright © 2021 Alexander Kvamme. All rights reserved.
//

import Foundation
import SwiftUI

extension UIFont {
    static var defaultBodyAlpha: CGFloat = 0.8
}

enum DINWeights: String {
    case light  = "DINRoundPro-Light"
    case medium = "DINRoundPro-Medium"
    case bold   = "DINRoundPro-Bold"
    case black  = "DINRoundPro-Black"
}

enum GilroyWeights: String {
    case light      = "Gilroy-Thin"
    case regular    = "Gilroy-Regular"
    case medium     = "Gilroy-Medium"
    case semibold   = "Gilroy-Semibold"
    case bold       = "Gilroy-Bold"
    case extraBold  = "Gilroy-Extrabold"
    case heavy      = "Gilroy-Heavy"
}

extension UIFont {
    static func round(_ weight: DINWeights, _ size: CGFloat) -> UIFont {
        UIFont(name: weight.rawValue, size: size)!
    }

    static func gilroy(_ weight: GilroyWeights, _ size: CGFloat) -> UIFont {
        UIFont(name: weight.rawValue, size: size)!
    }
}

extension Font {
    static func round(_ weight: DINWeights, _ size: CGFloat) -> Font {
        Font.custom(weight.rawValue, size: size)
    }

    static func gilroy(_ weight: GilroyWeights, _ size: CGFloat) -> Font {
        Font.custom(weight.rawValue, size: size)
    }
}

//
//  NativeExtensions.swift
//  TabBarDevelopment
//
//  Created by Alexander Kvamme on 08/02/2021.
//

import UIKit

extension CGFloat {
    // TODO: iOSCornerRadius is device dependent. Must use framework like this: https://kylebashour.com/posts/finding-the-real-iphone-x-corner-radius to find exact
//    static let iOSCornerRadius: CGFloat = UIDevice.hasNotch ? 38.5 : 0
    static let iOSCornerRadius: CGFloat = 38.5
}

extension UIDevice {

    static var notchHeight = hasNotch ? 24 : 0 // TODO: Get real value

    static var hasNotch: Bool {
        return (UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0) > 0
    }
}

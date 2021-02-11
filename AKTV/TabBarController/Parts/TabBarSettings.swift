//
//  TabBarSettings.swift
//  TabBarDevelopment
//
//  Created by Alexander Kvamme on 08/02/2021.
//

import UIKit
import ScreenCorners

public struct TabBarSettings {
    static let circleRadius: CGFloat            = 36
    static let spacingUnderMainButton: CGFloat  = 8
    static let sectionButtonColor: UIColor      = UIColor(.black)
    static let plusButtonColor: UIColor         = .white
    static let barColor: UIColor                = .white
    static let extraHeight: CGFloat             = 24 // FIXME: Corners are masked wrong when modifying this. 40 looks ok but less does not (24)

    // Settings for the four main buttons
    static let sectionButtonTopOffset: CGFloat  = 16

    static var yPosition: CGFloat {
        screenHeight - TabBarSettings.height
    }

    static var height: CGFloat {
        circleRadius + spacingUnderMainButton + barHeight
    }

    static var barHeight: CGFloat = {
        UIDevice.hasNotch ? cornerRadius*2 + extraHeight : 80
    }()

    static var barOffsetFromButton: CGFloat {
        circleRadius + spacingUnderMainButton
    }

    static var cornerRadius: CGFloat {
        UIScreen.main.displayCornerRadius
    }
}

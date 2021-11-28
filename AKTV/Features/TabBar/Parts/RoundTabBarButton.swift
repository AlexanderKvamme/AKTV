//
//  RoundTabBarButton.swift
//  TabBarDevelopment
//
//  Created by Alexander Kvamme on 08/02/2021.
//

import UIKit


class RoundTabBarButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)

        let addButton = UIButton(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
        addButton.setImage(UIImage(named: "icon-search")?.withRenderingMode(.alwaysTemplate), for: .normal)
        let insets: CGFloat = 18
        addButton.imageEdgeInsets = UIEdgeInsets(top: insets, left: insets, bottom: insets, right: insets)
        addButton.tintColor = TabBarSettings.plusButtonColor
        addButton.tintColor = UIColor(light)
        addSubview(addButton)
        addButton.isUserInteractionEnabled = false

        backgroundColor = .clear
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        let context: CGContext = UIGraphicsGetCurrentContext()!
        context.addEllipse(in: CGRect(x: 0, y: 0, width: TabBarSettings.circleRadius*2, height: TabBarSettings.circleRadius*2))
        let color = TabBarSettings.sectionButtonColor
        context.setFillColor(color.cgColor)
        context.fillPath()
    }
}


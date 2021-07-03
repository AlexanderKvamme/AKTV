//
//  Card.swift
//  AKTV
//
//  Created by Alexander Kvamme on 27/06/2021.
//  Copyright © 2021 Alexander Kvamme. All rights reserved.
//

import UIKit


class Card: UIView {

    static let defaultCornerRadius: CGFloat = 32

    init(radius: CGFloat = defaultCornerRadius) {
        super.init(frame: .zero)

        layer.shadowColor = UIColor(dark).cgColor
        layer.shadowOpacity = 0.1
        layer.cornerCurve = .continuous
        layer.cornerRadius = radius
        layer.shadowRadius = 20
        layer.shadowOffset = CGSize(width: 0, height: 16)

        backgroundColor = .white
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

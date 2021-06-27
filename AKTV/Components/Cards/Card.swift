//
//  Card.swift
//  AKTV
//
//  Created by Alexander Kvamme on 27/06/2021.
//  Copyright © 2021 Alexander Kvamme. All rights reserved.
//

import UIKit


class Card: UIView {

    init() {
        super.init(frame: .zero)

        layer.shadowColor = UIColor(dark).cgColor
        layer.shadowRadius = 24
        layer.shadowOpacity = 0.2
        layer.cornerRadius = 24
        layer.shadowOffset = CGSize(width: 0, height: 16)

        backgroundColor = .white
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

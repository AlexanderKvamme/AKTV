//
//  AnimatableNumberLabel.swift
//  AKTV
//
//  Created by Alexander Kvamme on 12/02/2021.
//  Copyright © 2021 Alexander Kvamme. All rights reserved.
//

import UIKit


final class UpCountingLabel: UILabel {

    // MARK: - Initializers

    init() {
        super.init(frame: .zero)

        adjustsFontSizeToFitWidth = true
        font = UIFont.gilroy(.bold, 28)
        textColor = UIColor(dark)
        textAlignment = .center
        text = "0"
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


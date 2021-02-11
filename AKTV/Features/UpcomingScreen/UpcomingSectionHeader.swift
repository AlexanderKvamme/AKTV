//
//  UpcomingSectionHeader.swift
//  AKTV
//
//  Created by Alexander Kvamme on 03/02/2021.
//  Copyright © 2021 Alexander Kvamme. All rights reserved.
//

import UIKit

class UpcomingSectionHeader: UIView {

    static let frame = CGRect(x: 0, y: 0, width: 200, height: 200)

    init() {
        super.init(frame: UpcomingSectionHeader.frame)

        backgroundColor = .green
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

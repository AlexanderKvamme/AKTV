//
//  WellRoundedTabBarController.swift
//  AKTV
//
//  Created by Alexander Kvamme on 10/02/2021.
//  Copyright © 2021 Alexander Kvamme. All rights reserved.
//

import UIKit


class WellRoundedTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.isHidden = true

        let subVC = TabBarView(frame: CGRect(x: 0, y: screenHeight - TabBarSettings.barHeight, width: screenWidth, height: screenHeight))
        view.addSubview(subVC)
    }
}

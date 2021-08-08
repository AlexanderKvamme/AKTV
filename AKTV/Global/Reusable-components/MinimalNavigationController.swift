//
//  MinimalNavigationController.swift
//  AKTV
//
//  Created by Alexander Kvamme on 08/08/2021.
//  Copyright © 2021 Alexander Kvamme. All rights reserved.
//

import UIKit

class MinimalNavigationController: UINavigationController, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }

    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        let item = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        viewController.navigationItem.backBarButtonItem = item
        navigationController.navigationBar.backIndicatorImage = UIImage(named: "close-48")!.withInset(UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0))
        navigationController.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "close-48")!.withInset(UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0))
        navigationController.navigationBar.tintColor = .black
        navigationController.navigationBar.isTranslucent = true
        navigationController.navigationBar.shadowImage = UIImage()
        navigationController.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController.navigationBar.isTranslucent = true
    }

    @objc private func popToPrevious() {
        navigationController?.popViewController(animated: true)
    }
}

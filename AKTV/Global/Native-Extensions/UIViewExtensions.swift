//
//  UIViewExtensions.swift
//  AKTV
//
//  Created by Alexander Kvamme on 13/02/2021.
//  Copyright © 2021 Alexander Kvamme. All rights reserved.
//

import UIKit


extension UIView {
    func findViewController() -> UIViewController? {
        if let nextResponder = self.next as? UIViewController {
            return nextResponder
        } else if let nextResponder = self.next as? UIView {
            return nextResponder.findViewController()
        } else {
            return nil
        }
    }
}

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
        let backImage = UIImage(named: "chevron-left-slim-17")!.withRenderingMode(.alwaysTemplate)
        let appearence = UINavigationBarAppearance()
        appearence.configureWithOpaqueBackground()
        appearence.backgroundColor = .clear
        appearence.shadowColor = nil
        appearence.shadowImage = nil
        
        navigationBar.standardAppearance = appearence
        navigationBar.scrollEdgeAppearance = navigationController.navigationBar.standardAppearance
        
        // Show/hide tabBar (bottom) according to VC setting
        if let tb = tabBarController as? WellRoundedTabBarController {
            viewController.hidesBottomBarWhenPushed ? tb.hideIt(animated: true) : tb.showIt(animated: true)
        }
        
        let shouldShowBack = !viewController.navigationItem.hidesBackButton
        guard shouldShowBack else { return }
        
        let item = UIBarButtonItem(
            image: backImage,
            style: UIBarButtonItem.Style.done,
            target: self,
            action: #selector(popToPrevious))
        item.tintColor = UIColor(dark).withAlphaComponent(0.2)
        item.imageInsets = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 0)
        viewController.navigationItem.leftBarButtonItem = item
    }
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage? {
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }

    @objc private func popToPrevious() {
        if let navCon = navigationController {
            navCon.popViewController(animated: true)
            navCon.dismiss(animated: false)
        } else {
            print(" no navigationController to pop")
        }
        dismiss(animated: true)
        popViewController(animated: true)
    }
}

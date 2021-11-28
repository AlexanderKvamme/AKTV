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
        let backImage = UIImage(named: "close-24")!.withRenderingMode(.alwaysTemplate)
        let appearence = UINavigationBarAppearance()
        appearence.configureWithOpaqueBackground()
        appearence.backgroundColor = .clear
        appearence.shadowColor = nil
        appearence.shadowImage = nil
        
        navigationBar.standardAppearance = appearence
        navigationBar.scrollEdgeAppearance = navigationController.navigationBar.standardAppearance
        
        let item = UIBarButtonItem(
            image: backImage,
            style: UIBarButtonItem.Style.done,
            target: self,
            action: #selector(popToPrevious))
        item.tintColor = UIColor(dark)
        item.imageInsets = UIEdgeInsets(top: 0, left: 22, bottom: 0, right: 0)
        item.customView?.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
        item.width = 10
        item.customView?.backgroundColor = .green
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
        popViewController(animated: true)
        navigationController?.popViewController(animated: true)
        navigationController?.dismiss(animated: false)
    }
}

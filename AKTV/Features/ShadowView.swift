//
//  ShadowView.swift
//  AKTV
//
//  Created by Alexander Kvamme on 22/02/2021.
//  Copyright © 2021 Alexander Kvamme. All rights reserved.
//

import UIKit


public class ShadowView2: UIView {

    // MARK: - Properties

    var offset: CGSize = CGSize(width: 0, height: 0)
    var radius: CGFloat = 30
    var opacity: Float = 0.3
    var color: UIColor = UIColor.black
    var cornerRadius: Float = 0.0
    var isCircle: Bool = false
    var showOnlyOutsideBounds: Bool = false

    // MARK: - Layout

    override public func layoutSubviews() {
        super.layoutSubviews()

        var cornerRadius = self.cornerRadius
        if isCircle {
            cornerRadius = Float(min(frame.height, frame.width) / 2.0)
        }

        if showOnlyOutsideBounds {
            let maskLayer = CAShapeLayer()
            let path = CGMutablePath()
            path.addPath(UIBezierPath(roundedRect: bounds.inset(by: UIEdgeInsets.zero), cornerRadius: CGFloat(cornerRadius)).cgPath)
            path.addPath(UIBezierPath(roundedRect: bounds.inset(by: UIEdgeInsets(top: -offset.height - radius*2, left: -offset.width - radius*2, bottom: -offset.height - radius*2, right: -offset.width - radius*2)), cornerRadius: CGFloat(cornerRadius)).cgPath)
            maskLayer.backgroundColor = UIColor.black.cgColor
            maskLayer.path = path;
            maskLayer.fillRule = .evenOdd
            self.layer.mask = maskLayer
        } else {
            self.layer.masksToBounds = false
        }

        self.layer.shadowOffset = self.offset
        self.layer.shadowRadius = self.radius
        self.layer.shadowOpacity = self.opacity
        self.layer.shadowColor = self.color.cgColor
        self.layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: CGFloat(cornerRadius)).cgPath
    }
}


//
//  DiagonalComplimentaryView.swift
//  AKTV
//
//  Created by Alexander Kvamme on 11/02/2021.
//  Copyright © 2021 Alexander Kvamme. All rights reserved.
//

import UIKit
import ComplimentaryGradientView


final class DiagonalComplimentaryView: ComplimentaryGradientView {

    // MARK: - Methods

    override func draw(_ rect: CGRect) {
        let layerHeight = layer.frame.height
        let layerWidth = layer.frame.width
        let bezierPath = UIBezierPath()
        let pointA = CGPoint(x: 0, y: 0)
        let pointB = CGPoint(x: layerWidth, y: 0)
        let pointC = CGPoint(x: layerWidth, y: layerHeight)
        let pointD = CGPoint(x: 0, y: layerHeight*2/3)

        // Draw the path
        bezierPath.move(to: pointA)
        bezierPath.addLine(to: pointB)
        bezierPath.addLine(to: pointC)
        bezierPath.addLine(to: pointD)
        bezierPath.close()

        // Mask to Path
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = bezierPath.cgPath
        layer.mask = shapeLayer
    }
}

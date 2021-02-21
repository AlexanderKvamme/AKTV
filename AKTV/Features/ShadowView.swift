//
//  ShadowView.swift
//  AKTV
//
//  Created by Alexander Kvamme on 22/02/2021.
//  Copyright © 2021 Alexander Kvamme. All rights reserved.
//

import UIKit


final class ShadowView: UIView {

    // MARK: - Properties

    private let opacity: Float

    // MARK: - Initializers

    init(opacity: Float = 0.03) {
        self.opacity = opacity
        super.init(frame: .zero)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle

    override func layoutSubviews() {
        super.layoutSubviews()

        addShadowSameSizeAsView()
    }

    // MARK: - Methods

    private func addShadowSameSizeAsView() {
        let contactRect = CGRect(x: 0, y: 50, width: frame.width, height: frame.height)
        layer.shadowPath = UIBezierPath(rect: contactRect).cgPath
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 30
        layer.shadowOpacity = opacity
    }
}

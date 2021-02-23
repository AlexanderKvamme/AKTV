//
//  UpcomingShowCellView2.swift
//  AKTV
//
//  Created by Alexander Kvamme on 16/02/2021.
//  Copyright © 2021 Alexander Kvamme. All rights reserved.
//

import SwiftUI
import UIKit
import Kingfisher
import ComplimentaryGradientView


class BadgeView: UIView {

    // MARK: Properties

    private let label = UILabel()
    private let backgroundView = UIView()

    // MARK: Initializers

    init(text: String) {
        super.init(frame: .zero)
        label.text = text

        setup()
        addSubviewsAndConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Private methods

    private func setup() {
        label.font = UIFont.gilroy(.semibold, 12)

        layer.cornerRadius = 8
        clipsToBounds = true
    }

    private func addSubviewsAndConstraints() {
        addSubview(backgroundView)
        addSubview(label)

        backgroundView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        label.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview().inset(4)
            make.left.right.equalToSuperview().inset(8)
        }
    }

    func setColor(text: UIColor, background: UIColor) {
        label.textColor = text
        backgroundView.backgroundColor = background
        backgroundView.alpha = Alpha.faded

        if text == .black {
            label.alpha = 0.5
        } else {
            label.alpha = 0.9
        }
    }
}


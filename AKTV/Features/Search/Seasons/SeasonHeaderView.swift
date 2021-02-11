//
//  SeasonHeaderView.swift
//  AKTV
//
//  Created by Alexander Kvamme on 11/02/2021.
//  Copyright © 2021 Alexander Kvamme. All rights reserved.
//

import UIKit

final class SeasonHeaderView: UIView {

    // MARK: Properties

    var titleLabel = UILabel()

    // MARK: Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = UIColor(dark)

        setup()
        addSubviewsAndConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Private methods

    private func setup() {
        titleLabel.textColor = UIColor(light)
        titleLabel.font = UIFont.gilroy(.heavy, 40)
    }

    private func addSubviewsAndConstraints() {
        [titleLabel].forEach({ addSubview($0) })
        titleLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }
}

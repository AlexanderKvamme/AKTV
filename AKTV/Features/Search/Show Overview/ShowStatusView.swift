//
//  ShowStatusView.swift
//  AKTV
//
//  Created by Alexander Kvamme on 13/02/2021.
//  Copyright © 2021 Alexander Kvamme. All rights reserved.
//

import UIKit


final class ShowStatusView: UIView {

    // MARK: - Properties

    private let stack = UIStackView()
    private let header = UILabel()
    private let body = UILabel()

    // MARK: - Initializers

    init() {
        super.init(frame: .zero)

        setup()
        addSubviewsAndConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    private func setup() {
        header.textColor = UIColor(dark)
        header.font = UIFont.gilroy(.bold, 14)
        header.alpha = Alpha.faded
        header.text = "STATUS"
        header.textAlignment = .center

        body.textColor = UIColor(dark)
        body.font = UIFont.gilroy(.bold, 16)
        body.alpha = 0.7
        body.textAlignment = .center

        stack.axis = .vertical
        stack.spacing = 4
        stack.addArrangedSubview(UIView())
        stack.addArrangedSubview(header)
        stack.addArrangedSubview(body)
        stack.addArrangedSubview(UIView())
        stack.distribution = .equalCentering
    }

    private func addSubviewsAndConstraints() {
        addSubview(stack)
        stack.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.center.equalToSuperview()
        }
    }

    func update(with show: ShowOverview) {
        body.text = show.status?.uppercased() ?? "No status"
    }
}

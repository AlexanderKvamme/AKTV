//
//  IconRowView.swift
//  AKTV
//
//  Created by Alexander Kvamme on 11/02/2021.
//  Copyright © 2021 Alexander Kvamme. All rights reserved.
//

import UIKit

final class IconRowView: UIView {

    // MARK: - Properties

    let stackView = UIStackView()
    var starButton = StarLabeledIcon()

    // MARK: - Initializers

    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 100))

        setup()
        addSubviewsAndConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    private func setup() {
        stackView.frame = frame
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = 8

        let trailersButton = LabeledIcon(text: "Trailers", icon: "film")
        stackView.addArrangedSubview(UIView())
        stackView.addArrangedSubview(trailersButton)
        stackView.addArrangedSubview(starButton)
        stackView.addArrangedSubview(UIView())

        // 3. Make counting up label
    }

    private func addSubviewsAndConstraints() {
        addSubview(stackView)
    }

    // MARK: - Public methods

    func update(with overview: ShowOverview) {
        starButton.update(with: overview)
    }
}

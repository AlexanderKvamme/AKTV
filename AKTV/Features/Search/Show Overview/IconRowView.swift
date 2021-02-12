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
    let starButton = StarLabeledIcon()
    var ratingIcon = RatingIcon(text: "RATING", targetNumber: 0)

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

        let trailersButton = LabeledIconButton(text: "Trailers", icon: "film")
        stackView.addArrangedSubview(UIView())
        stackView.addArrangedSubview(trailersButton)
        stackView.addArrangedSubview(starButton)
        stackView.addArrangedSubview(ratingIcon)
        stackView.addArrangedSubview(UIView())
    }

    private func addSubviewsAndConstraints() {
        addSubview(stackView)
    }

    // MARK: - Public methods

    func update(with overview: ShowOverview) {
        ratingIcon.update(with: overview)
        starButton.update(with: overview)
    }
}

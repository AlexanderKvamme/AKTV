//
//  IconRowView.swift
//  AKTV
//
//  Created by Alexander Kvamme on 11/02/2021.
//  Copyright © 2021 Alexander Kvamme. All rights reserved.
//

import UIKit

final class LineSeparator: UIView {
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: screenWidth-24, height: 3))
        
        backgroundColor = UIColor(dark)
        layer.cornerRadius = frame.height/2
        alpha = 0.05
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class EntityIconRow: UIView {
    
    // MARK: - Properties

    let stackView = UIStackView()
    let trailersButton = UnlabeledIconButton(icon: "play.square")
    let shareButton = ShareButton()
    var ratingIcon = UnlabeledRatingIcon(targetNumber: 0)
    var topSeperator = LineSeparator()
    var botSeperator = LineSeparator()

    // MARK: - Initializers

    init(_ entity: Entity) {
        super.init(frame: .zero)

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

        stackView.addArrangedSubview(UIView())
        stackView.addArrangedSubview(trailersButton)
        stackView.addArrangedSubview(shareButton)
        stackView.addArrangedSubview(ratingIcon)
        stackView.addArrangedSubview(UIView())
    }

    private func addSubviewsAndConstraints() {
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.right.equalToSuperview().inset(16)
        }
    }

    // MARK: - Public methods

    func update(with entity: Entity) {
        ratingIcon.update(with: entity)
        // FIXME: Implement this
//        starButton.update(with: overview)
    }

    func update(with movie: Movie) {
        ratingIcon.update(with: movie)
        shareButton.update(with: movie)
    }
}

final class IconRowView: UIView {

    // MARK: - Properties

    let stackView = UIStackView()
    let descriptionButton = LabeledIconButton(text: "INFO", icon: "text.justifyleft")
    let trailersButton = LabeledIconButton(text: "Trailers", icon: "film")
    let starButton = ShareButton()
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

        stackView.addArrangedSubview(UIView())
        stackView.addArrangedSubview(descriptionButton)
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

    func update(with movie: Movie) {
        ratingIcon.update(with: movie)
        starButton.update(with: movie)
    }
}

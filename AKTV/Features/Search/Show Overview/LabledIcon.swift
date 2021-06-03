//
//  LabledIcon.swift
//  AKTV
//
//  Created by Alexander Kvamme on 12/02/2021.
//  Copyright © 2021 Alexander Kvamme. All rights reserved.
//

import UIKit


class LabeledIconButton: UIButton {

    // MARK: - Properties

    fileprivate var icon = UIImageView(frame: CGRect.defaultButtonRect)
    fileprivate var label = UILabel()

    // MARK: - Initializers

    init(text: String, icon: String) {
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))

        setup(iconName: icon, text: text)
        addSubviewsAndConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    private func setup(iconName: String, text: String) {
        let iconConfiguration = UIImage.SymbolConfiguration(scale: .medium)
        icon.image = UIImage(systemName: iconName, withConfiguration: iconConfiguration)
        icon.contentMode = .scaleAspectFit
        icon.tintColor = UIColor(dark)
        label.text = text.uppercased()
        label.textColor = UIColor(dark)
        label.textAlignment = .center
        label.font = UIFont.gilroy(.semibold, 12)
        label.alpha = Alpha.faded
        label.sizeToFit()
    }

    fileprivate func addSubviewsAndConstraints() {
        [icon, label].forEach({ addSubview($0) })

        icon.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.size.equalTo(32)
        }

        label.snp.makeConstraints { (make) in
            make.top.equalTo(icon.snp.bottom).offset(4)
            make.left.bottom.right.equalToSuperview()
        }
    }

    override func setImage(_ image: UIImage?, for state: UIControl.State) {
        fatalError("Use custom initializer instead.")
    }

    func setIconAlpha(_ val: CGFloat) {
        icon.alpha = val
    }
}


final class RatingIcon: LabeledIconButton {

    // MARK: - Properties

    private var endValue: Double
    private var ratingLabel = UpCountingLabel()
    private lazy var displayLink = CADisplayLink(target: self, selector: #selector(handleUpdate))
    
    // MARK: - Initializers
    
    init(text: String, targetNumber: Double) {
        self.endValue = targetNumber
        super.init(text: text, icon: "USE NUMBER LABEL INSTEAD")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    override func addSubviewsAndConstraints() {
        super.addSubviewsAndConstraints()

        addSubview(ratingLabel)
        ratingLabel.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.bottom.equalTo(label.snp.top)
        }
    }

    func update(with overview: ShowOverview) {
        endValue = overview.voteAverage
        displayLink.add(to: .main, forMode: .default)
    }

    @objc private func handleUpdate() {
        guard let labelText = ratingLabel.text, let currentValue = Double(labelText) else {
            return
        }

        let animationDurationInSeconds = 1.0
        let step = endValue/animationDurationInSeconds/60
        let newValue = currentValue+step
        ratingLabel.text = String(format:"%.1f", newValue)

        if currentValue >= endValue {
            ratingLabel.text = String(endValue)
            displayLink.remove(from: .main, forMode: .default)
        }
    }
}


final class StarLabeledIcon: LabeledIconButton {

    // MARK: - Properties

    private var showOverview: ShowOverview?

    // MARK: - Initializers

    init() {
        super.init(text: "FAVORITE", icon: "restart")

        addTarget(self, action: #selector(didTapHeart), for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    func setFilled(_ fill: Bool) {
        let iconConfiguration = UIImage.SymbolConfiguration(scale: .medium)
        let newIcon = fill ? "star.fill" : "star"
        icon.image = UIImage(systemName: newIcon, withConfiguration: iconConfiguration)
    }

    private func isFavorite() -> Bool {
        guard let id = showOverview?.id else { return false }

        let favShows = UserProfileManager().favouriteShows()
        return favShows.contains(id)
    }

    @objc func didTapHeart() {
        guard let showId = showOverview?.id else {
            fatalError("Error: Could not find id to favorite")
        }

        let profileManager = UserProfileManager()

        if isFavorite() {
            setFilled(false)
            profileManager.setFavouriteShow(id: showId, favourite: false)
        } else {
            setFilled(true)
            profileManager.setFavouriteShow(id: showId, favourite: true)
        }
    }

    func update(with overview: ShowOverview) {
        self.showOverview = overview

        setFilled(isFavorite())
    }
}

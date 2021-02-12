//
//  LabledIcon.swift
//  AKTV
//
//  Created by Alexander Kvamme on 12/02/2021.
//  Copyright © 2021 Alexander Kvamme. All rights reserved.
//

import UIKit


class LabeledIcon: UIButton {

    // MARK: - Properties

    fileprivate var icon = UIImageView(frame: CGRect.defaultButtonRect)
    fileprivate var label = UILabel()

    // MARK: - Initializers

    init(text: String, icon: String) {
        super.init(frame: .zero)

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
        icon.tintColor = UIColor(light)
        label.text = text.uppercased()
        label.textColor = UIColor(light)
        label.font = UIFont.gilroy(.bold, 14)
        label.alpha = 0.3
        label.sizeToFit()
    }

    private func addSubviewsAndConstraints() {
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
}

final class StarLabeledIcon: LabeledIcon {

    // MARK: - Properties

    private var showOverview: ShowOverview?

    // MARK: - Initializers

    init() {
        super.init(text: "RATINGS", icon: "restart")

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

        let um = UserProfileManager()

        if isFavorite() {
            print("bam removing fav: \(showOverview!.name)")
            setFilled(false)
            um.setFavouriteShow(id: showId, favourite: false)
        } else {
            setFilled(true)
            print("bam adding favourite: \(showOverview!.name)")
            um.setFavouriteShow(id: showId, favourite: true)
        }
    }

    func update(with overview: ShowOverview) {
        self.showOverview = overview

        setFilled(isFavorite())
    }
}

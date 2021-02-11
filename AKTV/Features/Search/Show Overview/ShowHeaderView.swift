//
//  ShowHeaderView.swift
//  AKTV
//
//  Created by Alexander Kvamme on 11/02/2021.
//  Copyright © 2021 Alexander Kvamme. All rights reserved.
//

import UIKit


final class ShowHeaderView: UIView {

    // MARK: Properties

    var titleLabel = UILabel()
    var heartButton = UIButton()
    var showOverview: ShowOverview?
    let backgroundImage = UIImageView()

    // MARK: Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
        addSubviewsAndConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Private methods

    private func setup() {
        backgroundColor = UIColor(dark)

        backgroundImage.image = UIImage(named: "default-placeholder-image")

        titleLabel.text = "ShowHeaderView"
        titleLabel.textColor = UIColor(light)
        titleLabel.font = UIFont.gilroy(.heavy, 40)
        titleLabel.sizeToFit()

        heartButton.tintColor = UIColor(light)
        heartButton.addTarget(self, action: #selector(didTapHeart), for: .touchUpInside)
    }

    private func isFavorite() -> Bool {
        guard let id = showOverview?.id else { return false}

        let favShows = UserProfileManager().favouriteShows()
        return favShows.contains(id)
    }

    private func addSubviewsAndConstraints() {
        addSubview(backgroundImage)
        backgroundImage.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }

        addSubview(heartButton)
        heartButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
            make.size.equalTo(40)
        }
    }

    @objc func didTapHeart() {
        guard let showId = showOverview?.id else {
            fatalError("Error: Could not find id to favorite")
        }

        let um = UserProfileManager()

        if isFavorite() {
            let heartImage = UIImage(named: "icons8-heart-50-outlined")!.withRenderingMode(.alwaysTemplate)
            heartButton.setImage(heartImage, for: .normal)
            um.setFavouriteShow(id: showId, favourite: false)
        } else {
            let heartImage = UIImage(named: "icons8-heart-50-filled")!.withRenderingMode(.alwaysTemplate)
            heartButton.setImage(heartImage, for: .normal)
            um.setFavouriteShow(id: showId, favourite: true)
        }
    }

    func update(withShow showOverview: ShowOverview) {
        self.showOverview = showOverview
        titleLabel.text = showOverview.name.uppercased()

        if let imagePath = showOverview.backdropPath,
           let url = URL(string: APIDAO.imageRoot+imagePath) {
            backgroundImage.kf.setImage(with: url)
        }

        heartButton.setImage(isFavorite() ? UIImage(named: "icons8-heart-50-filled")!.withRenderingMode(.alwaysTemplate) : UIImage(named: "icons8-heart-50-outlined")!.withRenderingMode(.alwaysTemplate), for: .normal)
    }
}

//
//  ShowHeaderView.swift
//  AKTV
//
//  Created by Alexander Kvamme on 11/02/2021.
//  Copyright © 2021 Alexander Kvamme. All rights reserved.
//

import UIKit
import ComplimentaryGradientView

extension CGRect {
    static let defaultButtonRect = CGRect(x: 0, y: 0, width: 48, height: 48)
}


final class ShowHeaderView: UIView {

    // MARK: Properties

    var titleLabel = UILabel()
    var showOverview: ShowOverview?
    let imageView = UIImageView()
    let gradientBackground = DiagonalComplimentaryView()
    let iconRow = IconRowView()

    // MARK: Initializers

    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 400))

        setup()
        addSubviewsAndConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Private methods

    private func setup() {
        backgroundColor = UIColor(dark)

        imageView.contentMode = .scaleAspectFill

        titleLabel.textColor = UIColor(light)
        titleLabel.font = UIFont.gilroy(.heavy, 40)
        titleLabel.sizeToFit()

        imageView.layer.cornerRadius = 24
        imageView.clipsToBounds = true

        gradientBackground.gradientType = .colors(start: .primary, end: .secondary)
    }

    private func isFavorite() -> Bool {
        guard let id = showOverview?.id else { return false}

        let favShows = UserProfileManager().favouriteShows()
        return favShows.contains(id)
    }

    private func addSubviewsAndConstraints() {
        addSubview(gradientBackground)
        addSubview(iconRow)
        addSubview(imageView)
        addSubview(titleLabel)

        gradientBackground.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(imageView.snp.bottom)
        }

        imageView.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
            make.height.equalTo(300)
        }

        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(imageView).offset(-24)
        }

        iconRow.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom)
            make.height.equalTo(100)
        }
    }

    func update(withShow showOverview: ShowOverview) {
        self.showOverview = showOverview
        titleLabel.text = showOverview.name.uppercased()

        if let imagePath = showOverview.backdropPath,
           let url = URL(string: APIDAO.imageRoot+imagePath) {

            imageView.kf.setImage(with: url) { result in
                switch result {
                case .success(let value):
                    print("bam Image: \(value.image). Got from: \(value.cacheType)")
                    self.gradientBackground.image = value.image
                case .failure(let error):
                    print("bam Error: \(error)")
                }
            }
        }
        iconRow.update(with: showOverview)
    }
}

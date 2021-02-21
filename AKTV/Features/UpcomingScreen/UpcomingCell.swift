//
//  UpcomingKitCell.swift
//  AKTV
//
//  Created by Alexander Kvamme on 20/02/2021.
//  Copyright © 2021 Alexander Kvamme. All rights reserved.
//

import UIKit


final class UpcomingCell: UICollectionViewCell {

    // MARK: Properties

    static var identifier = "UpcomingCell"
    private let imageView = UIImageView()
    private let card = UpcomingCard()
    private let cardShadow = ShadowView()
    private let imageShadow = ShadowView(opacity: 0.3)
    
    // MARK: Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
        addSubviewsAndConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Internal methods

    private func setup() {
        imageView.layer.cornerRadius = 40
        imageView.clipsToBounds = true
    }

    private func addSubviewsAndConstraints() {
        addSubview(imageShadow)
        addSubview(imageView)
        addSubview(cardShadow)
        addSubview(card)

        imageShadow.snp.makeConstraints { (make) in
            make.edges.equalTo(imageView)
        }

        imageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(16)
            make.left.right.equalToSuperview().inset(24)
            make.bottom.equalTo(card.snp.centerY)
        }

        card.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-180)
            make.centerX.equalToSuperview()
            make.width.equalTo(imageView.snp.width).offset(-32)
        }

        cardShadow.snp.makeConstraints { (make) in
            make.edges.equalTo(card)
        }
    }

    func update(with showOverview: ShowOverview) {
        var testURL = URL.createLocalUrl(forImageNamed: "default-placeholder-image")!
        if let imageURL = showOverview.posterPath, let url = URL(string: APIDAO.imageRoot+imageURL) {
            testURL = url
        }

        imageView.kf.setImage(with: testURL) { (result) in
            do {
                let test = try result.get()
                self.imageView.contentMode = .scaleAspectFill
            } catch {
                print(error)
            }

        }

        card.update(with: showOverview)
    }
}


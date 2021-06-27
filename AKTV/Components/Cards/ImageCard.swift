//
//  ImageCard.swift
//  AKTV
//
//  Created by Alexander Kvamme on 27/06/2021.
//  Copyright © 2021 Alexander Kvamme. All rights reserved.
//

import UIKit

class ImageCard: Card {

    // MARK: - Properties

    let imageView = UIImageView()
    let placeholderText = UILabel()

    // MARK: - Initializers

    override init() {
        super.init()

        setup()
        addSubviewsAndConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    private func setup() {
        placeholderText.text = "No episode selected"
        placeholderText.textColor = UIColor(dark).withAlphaComponent(0.2)
        placeholderText.font = UIFont.round(.light, 24)
        placeholderText.textAlignment = .center

        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = defaultCornerRadius
    }

    private func addSubviewsAndConstraints() {
        addSubview(placeholderText)
        addSubview(imageView)

        placeholderText.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

}

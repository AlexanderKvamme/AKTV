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

    private var imageViews = [UIImageView]()
    private let placeholderText = UILabel()
    private let stackView = UIStackView()
    private var urls = [URL]() {
        didSet {
            setupImageViews()
        }
    }

    // MARK: - Initializers

    init() {
        super.init()

        setup()
        addSubviewsAndConstraints()
        reset()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    private func setup() {
        stackView.axis = .horizontal
        placeholderText.text = "No episode selected"
        placeholderText.textColor = UIColor(dark).withAlphaComponent(0.2)
        placeholderText.font = UIFont.round(.light, 24)
        placeholderText.textAlignment = .center
        layer.cornerRadius = Self.defaultCornerRadius
        clipsToBounds = true
    }

    private func addSubviewsAndConstraints() {
        addSubview(stackView)
        addSubview(placeholderText)

        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        placeholderText.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func reset() {
        imageViews.forEach{ imageView in
            imageView.removeFromSuperview()
            imageView.snp.removeConstraints()
        }

        urls.removeAll()
        imageViews.removeAll()
    }

    private func setupImageViews() {
        imageViews.forEach{ imageView in
            imageView.removeFromSuperview()
            imageView.snp.removeConstraints()
        }

        imageViews.removeAll()

        // Setup all images
        for n in 0..<urls.underestimatedCount {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.kf.setImage(with: urls[n])
            imageViews.append(imageView)
            addSubview(imageView)
        }

        imageViews.forEach { imageView in
            stackView.addArrangedSubview(imageView)
            stackView.distribution = .fillEqually
        }
    }

    func addImage(url: URL) {
        if !urls.contains(where: {$0 == url}) {
            urls.append(url)
        }
    }
}

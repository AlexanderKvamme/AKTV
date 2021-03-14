//
//  UpcomingDetailedScreen.swift
//  AKTV
//
//  Created by Alexander Kvamme on 14/03/2021.
//  Copyright © 2021 Alexander Kvamme. All rights reserved.
//

import UIKit

extension CGRect {
    static let topLeftButtonFrame = CGRect(x: 16, y: 24 + UIDevice.notchHeight, width: 48, height: 48)
}


/// Adds on the basic superview controller by adding icons related to the episode it displays
final class UpcomingDetailedScreen: UIViewController {

    // MARK: - Properties

    static let imageHeight = 400
    static let cardVerticalOfffset: CGFloat = -16
    static let cardSize: CGSize = CGSize(width: screenWidth-32, height: 100)
    static let cardVSpacing: CGFloat = 16

    let imageView = UIImageView()
    let backButton = UIButton(frame: .topLeftButtonFrame)
    let headerCard = UpcomingCard()
    let textCard = TextCard(header: "Episode plot", text: Episode.mock.overview)

    // Shadows
    lazy var buttonShadow = ShadowView2(frame: self.backButton.frame)
    lazy var headerCardShadow = ShadowView2(frame: CGRect(origin: .zero, size: Self.cardSize))
    lazy var contentShadow =  ShadowView2()

    // MARK: - Initializers

    init() {
        super.init(nibName: nil, bundle: nil)

        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        addSubviewsAndConstraints()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        UIView.animate(withDuration: 0.4) {
            self.backButton.alpha = 0.8
            self.buttonShadow.alpha = 1
        }
    }

    private func setup() {
        view.backgroundColor = UIColor(light)

        backButton.alpha = 0
        buttonShadow.alpha = 0
        buttonShadow.isCircle = true
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 40, weight: .medium, scale: .medium)
        let largeBoldDoc = UIImage(systemName: "chevron.backward", withConfiguration: largeConfig)
        backButton.setImage(largeBoldDoc, for: .normal)
        backButton.tintColor = .white
        backButton.addTarget(self, action: #selector(dismissMe), for: .touchUpInside)
    }

    func addSubviewsAndConstraints() {
        [imageView, buttonShadow, backButton, contentShadow, headerCardShadow, headerCard, textCard]
            .forEach({ view.addSubview($0) })
    }

    @objc func dismissMe() {
        dismiss(animated: true, completion: nil)
    }

    func getCardEndFrame() -> CGRect {
        let cardWidth = Self.cardSize.width
        let cardX = CGFloat(screenWidth - cardWidth)/2
        return CGRect(x: cardX, y: CGFloat(Self.imageHeight-48), width: Self.cardSize.width, height: UpcomingCard.preferredSize.height)
    }

    func getImageViewEndFrame() -> CGRect {
        // TODO: Make the height dynamic
        return CGRect(x: 0, y: 0, width: Int(screenWidth), height: Self.imageHeight)
    }

    func getTextCardInitialFrame() -> CGRect {
        var f = getCardEndFrame()
        f.size.height = 0
        f.origin.y = screenHeight
        return f
    }

    func getTextCardEndFrame() -> CGRect {
        var f = getCardEndFrame()
        f.origin.y += UpcomingCard.preferredSize.height + Self.cardVSpacing
        f.size.height = 300
        return f
    }

    func update(show: ShowOverview, episode: Episode) {
        if let posterPath = show.posterPath {
            let posterURL = URL(string: APIDAO.imageRoot+posterPath)
            imageView.kf.setImage(with: posterURL)
        }

        headerCard.update(with: show)
    }
}

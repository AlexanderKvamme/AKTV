//
//  EpisodeScreen.swift
//  AKTV
//
//  Created by Alexander Kvamme on 24/02/2021.
//  Copyright © 2021 Alexander Kvamme. All rights reserved.
//

import UIKit
import SnapKit

extension CGRect {
    static let topLeftButtonFrame = CGRect(x: 16, y: 24 + UIDevice.notchHeight, width: 48, height: 48)
}

/// Adds on the basic superview controller by adding icons related to the episode it displays
final class EpisodeScreen2: UIViewController {

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
        print("tryna dismiss")
        dismiss(animated: true, completion: nil)
    }

    func getCardEndFrame() -> CGRect {
        let cardWidth = Self.cardSize.width
        let cardX = CGFloat(screenWidth - cardWidth)/2
        return CGRect(x: cardX, y: CGFloat(Self.imageHeight-48), width: Self.cardSize.width, height: Self.cardSize.height)
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
        f.origin.y += Self.cardSize.height + Self.cardVSpacing
        f.size.height = 300
        return f
    }

    func update(show: ShowOverview, episode: Episode) {
        print("updating")
        if let posterPath = show.posterPath {
            print("bam setting value: ", APIDAO.imageRoot+posterPath)
            let posterURL = URL(string: APIDAO.imageRoot+posterPath)
            imageView.kf.setImage(with: posterURL)
        }

        headerCard.update(with: show)

//        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(2)) {
//            self.dismiss(animated: true, completion: nil)
//        }
    }
}



/// Adds on the basic superview controller by adding icons related to the episode it displays
final class EpisodeScreen: BasicTextDisplayerViewController {

    // MARK: - Properties

    private let episodeDetailsView: EpisodeDetailsView
    private let subtitle = UILabel.make(.subtitle)

    // MARK: - Initializers

    init(_ episode: Episode) {
        let calendarItem = LabeledIconButton(text: episode.airDate, icon: "calendar")
        let numberItem = LabeledIconButton(text: "\(episode.episodeNumber)", icon: "number")
        let listItem = LabeledIconButton(text: "List", icon: "rectangle.grid.1x2")
        let buttons = [calendarItem, numberItem, listItem]

        buttons.forEach({ $0.setIconAlpha(0.7) })

        self.episodeDetailsView = EpisodeDetailsView(for: episode, buttons: buttons)
        super.init()

        super.update(with: episode)


        setup()
        addSubviewsAndConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    private func setup() {
        subtitle.text = "Overview"
    }

    private func addSubviewsAndConstraints() {
        episodeTextView.snp.removeConstraints()

        view.addSubview(episodeDetailsView)
        episodeDetailsView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(24)
            make.top.equalTo(episodeHeader.snp.bottom).offset(24)
            make.height.equalTo(EpisodeDetailsView.height)
        }

        view.addSubview(subtitle)
        subtitle.snp.makeConstraints { (make) in
            make.top.equalTo(episodeDetailsView.snp.bottom).offset(64)
            make.right.equalTo(episodeTextView)
            make.left.equalTo(episodeTextView).offset(4)
        }

        episodeTextView.snp.makeConstraints { (make) in
            make.top.equalTo(subtitle.snp.bottom).offset(8)
            make.left.right.equalTo(episodeHeader)
            make.bottom.equalToSuperview()
        }
    }
}

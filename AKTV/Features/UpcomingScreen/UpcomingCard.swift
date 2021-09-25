//
//  UpcomingCard.swift
//  AKTV
//
//  Created by Alexander Kvamme on 22/02/2021.
//  Copyright © 2021 Alexander Kvamme. All rights reserved.
//

import UIKit
import ComplimentaryGradientView

final class UpcomingCard: UIView {

    // MARK: Properties

    static let preferredSize = CGSize(width: screenWidth, height: 110)

    private let hStack = UIStackView()
    private let leftVStack = UIStackView()
    private let headerLabel = UILabel.make(.subtitle)
    private let badgeStack = UIStackView()
    private let episodeNumberLabel = UILabel()
    private let timeLabel = UILabel()
    private let dayNameLabel = UILabel()

    private var badgeColors: UIImageColors?

    // MARK: Initializers

    init() {
        super.init(frame: .zero)

        backgroundColor = .white
        layer.cornerRadius = 24

        setup()
        addSubviewsAndConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Private methods

    private func setup() {
        headerLabel.text = "Adventure Time: Distant Lands"
        headerLabel.textColor = UIColor(dark)
        headerLabel.font = UIFont.gilroy(.heavy, 26)
        headerLabel.numberOfLines = 0
        headerLabel.adjustsFontSizeToFitWidth = true

        episodeNumberLabel.text = "40"
        episodeNumberLabel.textAlignment = .center
        episodeNumberLabel.font = UIFont.gilroy(.extraBold, 40)
        episodeNumberLabel.textColor = UIColor(dark)
        episodeNumberLabel.alpha = Alpha.faded

        timeLabel.text = "24:00"
        timeLabel.textAlignment = .center
        timeLabel.font = UIFont.gilroy(.extraBold, 20)
        timeLabel.textColor = UIColor(dark)

        dayNameLabel.text = "WEDNESDAY"
        dayNameLabel.textAlignment = .center
        dayNameLabel.font = UIFont.gilroy(.extraBold, 10)
        dayNameLabel.textColor = UIColor(dark)
        dayNameLabel.sizeToFit()

        // Badge stack
        badgeStack.axis = .horizontal
        badgeStack.alignment = .leading
//        badgeStack.spacing = 8

        // Left stack
        leftVStack.axis = .vertical
        leftVStack.alignment = .leading
        leftVStack.spacing = 8
        leftVStack.addArrangedSubview(headerLabel)
        leftVStack.addArrangedSubview(badgeStack)

        hStack.addArrangedSubview(leftVStack)
    }

    private func addSubviewsAndConstraints() {
        let hspacing: CGFloat = 16
        let vspacing: CGFloat = 24

        [hStack].forEach({ addSubview($0) })

//        hStack.snp.makeConstraints { (make) in
//            make.left.equalToSuperview().inset(hspacing)
//            make.right.equalToSuperview().inset(hspacing)
//            make.bottom.equalToSuperview().inset(vspacing)
//            make.top.equalToSuperview()
//        }

        episodeNumberLabel.setContentHuggingPriority(.defaultLow, for: .vertical)
    }

    // MARK: Helper methods

    func update(with show: ShowOverview) {
        badgeStack.removeAllArrangedSubviews()

        headerLabel.text = show.name
        episodeNumberLabel.text = String(show.nextEpisodeToAir?.episodeNumber ?? 0)

        if let genres = show.genres {
            let badgeViews: [BadgeView] = [] // Array(genres.map({ genre in BadgeView(text: genre.name) }).prefix(2))
            badgeViews.forEach({ badgeStack.addArrangedSubview($0) })
        }
    }

    func setColors(_ cols: UIImageColors) {
        self.badgeColors = cols
        let badgeColors = [cols.background, cols.detail, cols.primary, cols.secondary]

        badgeStack.arrangedSubviews.enumerated().forEach({ (i, badge) in
            if let badgeBg = badgeColors[i], let badge = badge as? BadgeView {
                let textColor = getTextColor(bgColor: badgeBg)
                badge.setColor(text: textColor, background: badgeBg)
            }
        })
    }

    func getColors() -> UIImageColors? {
        return badgeColors
    }
}


// Returns black if the given background color is light or white if the given color is dark
func getTextColor(bgColor: UIColor) -> UIColor {
    var r: CGFloat = 0.0
    var g: CGFloat = 0.0
    var b: CGFloat = 0.0
    var a: CGFloat = 0.0
    var brightness: CGFloat = 0.0

    bgColor.getRed(&r, green: &g, blue: &b, alpha: &a)

    // algorithm from: http://www.w3.org/WAI/ER/WD-AERT/#color-contrast
    brightness = ((r * 299) + (g * 587) + (b * 114)) / 1000;
    if (brightness < 0.5) {
        return .white
    }
    else {
        return .black
    }
}


//
//  EpisodeDisplayer.swift
//  AKTV
//
//  Created by Alexander Kvamme on 15/02/2021.
//  Copyright © 2021 Alexander Kvamme. All rights reserved.
//

import UIKit


extension UILabel {
    enum LabelStyle {
        case subtitle
        case header
    }

    static func make(_ style: LabelStyle, _ content: String? = "") -> UILabel {
        var label: UILabel
        switch style {
        case .subtitle:
            label = makeSubtitle()
        case .header:
            label = makeSubtitle()
        }
        label.text = content
        return label
    }

    private static func makeLabel() -> UILabel {
        let label = UILabel()
        label.textColor = UIColor(light)
        return label
    }

    private static func makeHeader() -> UILabel {
        let label = makeLabel()
        label.font = UIFont.gilroy(.heavy, 64)
        return label
    }

    private static func makeSubtitle() -> UILabel {
        let label = makeLabel()
        label.font = UIFont.gilroy(.heavy, 32)
        return label
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


final class EpisodeDetailsView: UIView {

    // MARK: - Properties

    static let height: CGFloat = 80

    private let background = UIView()
    private let stack = UIStackView()

    // MARK: - Initializers

    init(for episode: Episode, buttons: [LabeledIconButton]) {
        super.init(frame: .zero)
        stack.addArrangedSubview(UIView())
        buttons.forEach({ stack.addArrangedSubview($0) })
        stack.addArrangedSubview(UIView())

        setup()
        addSubviewsAndConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        background.mask = makeContinouslyRoundedBackgroundMask(radius: 16, to: rect)
    }

    private func setup() {
        background.backgroundColor = UIColor(light)
        background.alpha = 0.0375

        stack.distribution = .equalCentering
        stack.spacing = 16
        stack.alignment = .center
    }

    private func addSubviewsAndConstraints() {
        [background, stack].forEach({ addSubview($0) })

        background.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        stack.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }

    func makeContinouslyRoundedBackgroundMask(radius: CGFloat, to: CGRect) -> UIView {
        let maskView = UIView(frame: to)
        maskView.backgroundColor = .black // must have color to mask
        maskView.layer.cornerCurve = .continuous
        maskView.layer.maskedCorners = UIDevice.hasNotch ? [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner] : []
        maskView.layer.cornerRadius = radius
        return maskView
    }
}

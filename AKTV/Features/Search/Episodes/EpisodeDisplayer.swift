//
//  EpisodeDisplayer.swift
//  AKTV
//
//  Created by Alexander Kvamme on 15/02/2021.
//  Copyright © 2021 Alexander Kvamme. All rights reserved.
//

import UIKit

extension UITextView {
    static func makeBodyTextView() -> UITextView {
        let textView = UITextView()
        textView.font = UIFont.gilroy(.regular, 16)
        textView.backgroundColor = .clear
        textView.textColor = .black
        textView.alpha = Alpha.faded
        return textView
    }
}

extension UILabel {
    enum LabelStyle {
        case subtitle
        case header
    }

    static func make(_ style: LabelStyle, _ content: String? = "", color: UIColor = .purple) -> UILabel {
        var label: UILabel
        switch style {
        case .subtitle:
            label = makeSubtitle()
        case .header:
            label = makeHeader()
        }
        label.text = content
        label.textColor = color
        return label
    }

    private static func makeLabel() -> UILabel {
        let label = UILabel()
        label.textColor = UIColor(light)
        return label
    }

    private static func makeHeader() -> UILabel {
        let label = makeLabel()
        label.font = UIFont.gilroy(.heavy, 40)
        return label
    }

    private static func makeSubtitle() -> UILabel {
        let label = makeLabel()
        label.font = UIFont.gilroy(.regular, 20)
        label.textAlignment = .left
        label.alpha = 0.4
        label.numberOfLines = 0
        return label
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

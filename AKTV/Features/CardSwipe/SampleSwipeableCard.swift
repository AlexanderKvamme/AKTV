//
//  SampleSwipeableCard.swift
//  Swipeable-View-Stack
//
//  Created by Phill Farrugia on 10/21/17.
//  Copyright © 2017 Phill Farrugia. All rights reserved.
//

import UIKit
import CoreMotion


class GameCard: UIView {

    // MARK: - Properties

    var titleLabel =  UILabel.make(.header)
    var subtitleLabel =  UILabel.make(.subtitle)
    var imageView = UIImageView()

    // MARK: - Initializers

    init() {
        super.init(frame: .zero)

        setup()
        addSubviewsAndConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    private func setup() {
        clipsToBounds = true
        layer.cornerRadius = 32
        layer.cornerCurve = .continuous
    }

    private func addSubviewsAndConstraints() {
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(subtitleLabel)

        titleLabel.textAlignment = .left
        titleLabel.textColor = UIColor(dark)
        subtitleLabel.textColor = UIColor(dark)
        subtitleLabel.font = UIFont.gilroy(.bold, 16)
        subtitleLabel.alpha = 0.4

        imageView.backgroundColor = .white

        imageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        let textInset: CGFloat = 24
        titleLabel.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(imageView).inset(textInset)
        }

        subtitleLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(titleLabel)
            make.bottom.equalTo(titleLabel.snp.top).offset(-8)
        }
    }
}


class SampleSwipeableCard: SwipeableCardViewCard {

    private let card = GameCard()
    private let motionManager = CMMotionManager()

    /// Shadow View
    private weak var shadowView: UIView?

    /// Inner Margin
    private static let kInnerMargin: CGFloat = 20.0

    var viewModel: SampleSwipeableCellViewModel? {
        didSet {
            configure(forViewModel: viewModel)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
        addSubviewsAndConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {

    }

    private func addSubviewsAndConstraints() {
        layoutSubviews()

        addSubview(card)
    }

    private func configure(forViewModel viewModel: SampleSwipeableCellViewModel?) {
        if let viewModel = viewModel {

            card.titleLabel.text = viewModel.title
            card.subtitleLabel.text = viewModel.subtitle
            card.imageView.image = viewModel.image
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let inset: CGFloat = 24
        card.frame = CGRect(x: inset, y: 0, width: screenWidth-2*inset, height: 400)

//        print(imageView.frame)

        configureShadow()
    }

    // MARK: - Shadow

    private func configureShadow() {
        // Shadow View
        self.shadowView?.removeFromSuperview()
        let shadowView = UIView(frame: CGRect(x: SampleSwipeableCard.kInnerMargin,
                                              y: SampleSwipeableCard.kInnerMargin,
                                              width: card.frame.width,
                                              height: card.frame.height))
        insertSubview(shadowView, at: 0)
        self.shadowView = shadowView

        // Roll/Pitch Dynamic Shadow
//        if motionManager.isDeviceMotionAvailable {
//            motionManager.deviceMotionUpdateInterval = 0.02
//            motionManager.startDeviceMotionUpdates(to: .main, withHandler: { (motion, error) in
//                if let motion = motion {
//                    let pitch = motion.attitude.pitch * 10 // x-axis
//                    let roll = motion.attitude.roll * 10 // y-axis
//                    self.applyShadow(width: CGFloat(roll), height: CGFloat(pitch))
//                }
//            })
//        }
        self.applyShadow(width: CGFloat(0.0), height: CGFloat(0.0))
    }

    private func applyShadow(width: CGFloat, height: CGFloat) {
        if let shadowView = shadowView {
            let shadowPath = UIBezierPath(roundedRect: shadowView.bounds, cornerRadius: 32.0)
            shadowView.layer.masksToBounds = false
            shadowView.layer.shadowRadius = 8.0
            shadowView.layer.shadowColor = UIColor.black.cgColor
            shadowView.layer.shadowOffset = CGSize(width: width, height: height)
            shadowView.layer.shadowOpacity = 0.1
            shadowView.layer.shadowPath = shadowPath.cgPath
        }
    }

}
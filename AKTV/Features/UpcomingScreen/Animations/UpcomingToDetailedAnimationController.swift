    //
//  UpcomingToDetailedAnimationController.swift
//  AKTV
 //
//  Created by Alexander Kvamme on 23/02/2021.
//  Copyright © 2021 Alexander Kvamme. All rights reserved.
//

import UIKit


final class TextCard: UIView {

    // MARK: - Properties

    private let headerLabel = UILabel.make(.header)
    private let content = UITextView.makeBodyTextView()

    // MARK: - Initializers

    init(header: String, text: String) {
        super.init(frame: .zero)

        headerLabel.text = header
        content.text = text

        setup()
        addSubviewsAndConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    private func setup() {
        backgroundColor = .white
        layer.cornerRadius = 24

        clipsToBounds = true

        headerLabel.textColor = UIColor(dark)
        headerLabel.font = UIFont.gilroy(.heavy, 26)
        headerLabel.numberOfLines = 0
    }

    private func addSubviewsAndConstraints() {
        addSubview(headerLabel)
        headerLabel.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview().inset(24)
            make.height.equalTo(26)
        }

        addSubview(content)
        content.snp.makeConstraints { (make) in
            make.top.equalTo(headerLabel.snp.bottom).offset(8)
            make.left.right.equalTo(headerLabel)
            make.bottom.equalToSuperview().inset(24)
        }
    }
}


final class UpcomingToDetailedAnimationController: NSObject, UIViewControllerAnimatedTransitioning {

    // MARK: - Properties

    private let originImageView: UIImageView
    private let originCard: UpcomingCard

    // MARK: - Initializers

    init(_ cell: UpcomingCell) {
        self.originImageView = cell.imageView
        self.originCard = cell.card
    }

    // MARK: - Methods

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        0.35
    }

    func animationEnded(_ transitionCompleted: Bool) {
        print("bam animationEnded completed: ", transitionCompleted)
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        guard let fromVC = transitionContext.viewController(forKey: .from),
              let toVC = transitionContext.viewController(forKey: .to) as? UpcomingDetailedScreen,
              let snapshotStart = fromVC.view.snapshotView(afterScreenUpdates: true)
        else {
            return
        }

        if let badgeColors = originCard.getColors() {
            toVC.headerCard.setColors(badgeColors)
        } else {
            fatalError()
        }

        containerView.addSubview(toVC.view)

        let newImageView = toVC.imageView
        newImageView.frame = originImageView.globalFrame ?? .zero
        newImageView.layer.cornerRadius = UpcomingCell.cornerRadius
        newImageView.clipsToBounds = true
        newImageView.contentMode = .scaleAspectFill

        let whiteBg = UIView()
        whiteBg.frame = originCard.globalFrame ?? .zero
        whiteBg.backgroundColor = UIColor(light)
        whiteBg.layer.cornerRadius = UpcomingCell.cornerRadius

        let cardView = toVC.headerCard
        cardView.frame = originCard.globalFrame ?? .zero

        let textCard = toVC.textCard
        textCard.frame = toVC.getTextCardInitialFrame()
        textCard.layoutIfNeeded()

        let cardShadow = toVC.headerCardShadow
        cardShadow.frame = originCard.globalFrame ?? .zero
        cardShadow.radius = UpcomingCell.cornerRadius
        cardShadow.showOnlyOutsideBounds = false

        let contentShadow = toVC.contentShadow
        contentShadow.frame = CGRect(x: 0, y: screenHeight, width: 0, height: 0)
        contentShadow.isHidden = true

        containerView.addSubview(whiteBg)
        containerView.addSubview(newImageView)
        containerView.addSubview(contentShadow)
        containerView.addSubview(cardShadow)
        containerView.addSubview(textCard)
        containerView.addSubview(cardView)

        let duration = transitionDuration(using: transitionContext)

        // 1
        UIView.animateKeyframes(
            withDuration: duration,
            delay: 0,
            options: .calculationModeCubic,
            animations: {
                UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1) {
                    // Fill screen with bg
                    whiteBg.frame = screenFrame
                    whiteBg.frame.origin.y = CGFloat(UpcomingDetailedScreen.imageHeight) // Offset to deal with animation overshoot

                    // Scale up image
                    newImageView.layer.cornerRadius = 0
                    newImageView.frame = toVC.getImageViewEndFrame()

                    // Move up card
                    cardView.frame = toVC.getCardEndFrame()
                    cardShadow.frame = toVC.getCardEndFrame()

                    contentShadow.frame = toVC.getTextCardEndFrame()
                    contentShadow.opacity = 0.3
                    contentShadow.isHidden = false

                    // Slide up episode plot text
                    textCard.frame = toVC.getTextCardEndFrame()
                    textCard.alpha = 1
                }
            },
            completion: { _ in
                toVC.view.isHidden = false

                whiteBg.removeFromSuperview()

                toVC.addSubviewsAndConstraints()
                transitionContext.completeTransition(true)
            }
        )
    }
}

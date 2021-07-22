//
//  SwipeableStackView.swift
//  Swipeable-View-Stack
//
//  Created by Phill Farrugia on 10/21/17.
//  Copyright © 2017 Phill Farrugia. All rights reserved.
//

import UIKit


class GameCardController: UIView, SwipeableViewDelegate {

    static let horizontalInset: CGFloat = 12.0

    static let verticalInset: CGFloat = 12.0

    var dataSource: CardViewDataSource? {
        didSet {
            reloadData()
        }
    }

    var delegate: CardViewDelegate?

    private var cardViews: [SwipeableView] = []

    private var visibleCardViews: [SwipeableView] {
        return subviews as? [SwipeableView] ?? []
    }

    fileprivate var remainingCards: Int = 0

    static let numberOfVisibleCards: Int = 2

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Reloads the data used to layout card views in the
    /// card stack. Removes all existing card views and
    /// calls the dataSource to layout new card views.
    func reloadData() {
        removeAllCardViews()
        guard let dataSource = dataSource else {
            return
        }

        let numberOfCards = dataSource.numberOfCards()
        remainingCards = numberOfCards

        if numberOfCards > Self.numberOfVisibleCards {
            gamesService?.precache(dataSource.getItems())
        }

        for index in 0..<min(numberOfCards, GameCardController.numberOfVisibleCards) {
            let card = dataSource.card(forItemAtIndex: index)
            if index == 0 { (card as? SwipeableGameCard)?.card.setForeground(true) }
            addCardView(cardView: card, atIndex: index)
        }

        if let emptyView = dataSource.viewForEmptyCards() {
            addEdgeConstrainedSubView(view: emptyView)
        }

        setNeedsLayout()
    }

    private func addCardView(cardView: SwipeableView, atIndex index: Int) {
        cardView.delegate = self
        setFrame(forCardView: cardView, atIndex: index)
        cardViews.append(cardView)
        insertSubview(cardView, at: 0)
        remainingCards -= 1
    }

    private func removeAllCardViews() {
        for cardView in visibleCardViews {
            cardView.removeFromSuperview()
        }
        cardViews = []
    }

    /// Sets the frame of a card view provided for a given index. Applies a specific
    /// horizontal and vertical offset relative to the index in order to create an
    /// overlay stack effect on a series of cards.
    ///
    /// - Parameters:
    ///   - cardView: card view to update frame on
    ///   - index: index used to apply horizontal and vertical insets
    private func setFrame(forCardView cardView: SwipeableView, atIndex index: Int) {
        var cardViewFrame = bounds
        let horizontalInset = (CGFloat(index) * GameCardController.horizontalInset)
        let verticalInset = CGFloat(index) * GameCardController.verticalInset

        cardViewFrame.size.width -= 2 * horizontalInset
        cardViewFrame.origin.y += verticalInset

        cardView.frame = cardViewFrame
    }

}

// MARK: - SwipeableViewDelegate

extension GameCardController {

    func didTap(view: SwipeableView) {
        if let index = cardViews.firstIndex(of: view) {
            delegate?.didSelect(card: view, atIndex: index)

            if let game = dataSource?.getItems() {
                print("tapped game: ", game[index].name)
            }
        }
    }

    func didBeginSwipe(onView view: SwipeableView) {
        // React to Swipe Began?
    }

    func didEndSwipe(onView view: SwipeableView) {
        guard let dataSource = dataSource else {
            return
        }

        // Handle finished swipe
        if let index = cardViews.firstIndex(of: view) {
            delegate?.didSelect(card: view, atIndex: index)

            let game = dataSource.getItems()[index]
            print("bam didEndSwipe game: ", game.name)
            print("bam initial range is then: ", dataSource.initialRange)

            let swipedRange = GameRange(upper: dataSource.initialRange.upper, lower: Int(game.id))
            print("bam swiped range is then: ", swipedRange)

            GameStore.addCompleted(swipedRange, for: dataSource.initialPlatform)
            GameStore.printStatus()

            // TODO: Prefetch

        }

        removeSwipedCard(view)
    }

    private func removeSwipedCard(_ view: SwipeableView) {
        guard let dataSource = dataSource else {
            return
        }

        // Remove swiped card
        view.removeFromSuperview()

        // Only add a new card if there are cards remaining
        if remainingCards > 0 {

            // Calculate new card's index
            let newIndex = dataSource.numberOfCards() - remainingCards

            // Add new card as Subview
            addCardView(cardView: dataSource.card(forItemAtIndex: newIndex), atIndex: 2)

            // Update all existing card's frames based on new indexes, animate frame change
            // to reveal new card from underneath the stack of existing cards.
            for (cardIndex, cardView) in visibleCardViews.reversed().enumerated() {
                UIView.animate(withDuration: 0.2, animations: {
                    if cardIndex == 0, let cv = cardView as? SwipeableGameCard {
                        cv.card.setForeground(true)
                    }
                    cardView.center = self.center
                    self.setFrame(forCardView: cardView, atIndex: cardIndex)
                    self.layoutIfNeeded()
                })
            }
        }
    }

}

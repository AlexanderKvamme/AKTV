//
//  SwipeableStackView.swift
//  Swipeable-View-Stack
//
//  Created by Phill Farrugia on 10/21/17.
//  Copyright © 2017 Phill Farrugia. All rights reserved.
//

import UIKit
import SwiftUI


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
    fileprivate var cardIndex: Int = 0

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
        guard let dataSource = dataSource else { return }

        removeAllCardViews()

        let numberOfCards = dataSource.numberOfCards()
        remainingCards = numberOfCards

        // Precache
        if numberOfCards > Self.numberOfVisibleCards {
            GameService.precache(dataSource.getItems())
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
        guard let dataSource = dataSource else { return }
        let tappedGame = dataSource.getItems()[cardIndex]
        let gameScreen = GameScreen(tappedGame, platform: dataSource.initialPlatform)
        
        view.findViewController()?.present(gameScreen, animated: true, completion: nil )
        tabBarController.navigationController?.pushViewController(gameScreen, animated: true)
    }

    func didBeginSwipe(onView view: SwipeableView) {
        // React to Swipe Began?
    }

    func didEndSwipe(onView view: SwipeableView, _ swipeDirection: SwipeDirection) {
        guard let dataSource = dataSource else {
            return
        }

        // Handle finished swipe
        if let _ = cardViews.reversed().firstIndex(of: view) {
            guard dataSource.getItems().count > cardIndex else {
                print("Index too big")
                reloadData()
                return
            }

            let swipedGame = dataSource.getItems()[cardIndex]
            let swipedRange = GameRange(upper: dataSource.initialRange.upper, lower: Int(swipedGame.id))
            GameStore.addCompleted(swipedRange, for: dataSource.initialPlatform)
            
            let rightSwipes: [SwipeDirection] = [.right, .bottomRight, .topRight]
            if rightSwipes.contains(swipeDirection) {
                GameStore.setFavourite(swipedGame, true, platform: dataSource.initialPlatform)
            }

            // Get next range to fetch
            let sortedItems = dataSource.getItems().map({$0.id})
            let min = sortedItems.min()

            // Fetch 1 item
            GameService.fetchGame(currentLowestID: Int(min!), dataSource.initialPlatform) { game in
                guard let game = game.first else {
                    return
                }

                // Add this item to its correct spot in the datasource
                dataSource.addGames([game])
                self.remainingCards += 1

                // Prefetch
                GameService.precache([game])
                
                // TODO: Possibly remove the games swiped away?
            }
        }

        cardIndex += 1
        
        goToNextCard(view)
    }

    private func goToNextCard(_ view: SwipeableView) {
        guard let dataSource = dataSource else {
            return
        }

        // Remove swiped card
        view.removeFromSuperview()

        // Add cards if any
        guard remainingCards > 0 else {
            print("No remainingCards.. ")
            return
        }

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

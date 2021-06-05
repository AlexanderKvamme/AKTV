//
//  UpcomingGamesScreen.swift
//  AKTV
//
//  Created by Alexander Kvamme on 05/06/2021.
//  Copyright © 2021 Alexander Kvamme. All rights reserved.
//

import Foundation
import UIKit


final class UpcomingGamesScreen: UIViewController, SwipeableCardViewDataSource {

    // MARK: - Properties

    private var cardContainer = SwipeableCardViewContainer(frame: screenFrame)

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        view.backgroundColor = .red

        setup()
        addSubviewsAndConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        cardContainer.dataSource = self
    }

    // MARK: - Initializers

    // MARK: - Methods

    private func setup() {

    }

    private func addSubviewsAndConstraints() {
        view.addSubview(cardContainer)
        cardContainer.frame = screenFrame

//        swipeableCardView.snp.makeConstraints { (make) in
//            make.top.left.right.bottom.equalToSuperview()
//        }
    }
}

// MARK: - SwipeableCardViewDataSource

extension UpcomingGamesScreen {

    func numberOfCards() -> Int {
        return viewModels.count
    }

    func card(forItemAtIndex index: Int) -> SwipeableCardViewCard {
        let viewModel = viewModels[index]
        let cardView = SampleSwipeableCard(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        cardView.viewModel = viewModel
        cardView.layoutSubviews()
        return cardView
    }

    func viewForEmptyCards() -> UIView? {
        return nil
    }

    var viewModels: [SampleSwipeableCellViewModel] {

        let hamburger = SampleSwipeableCellViewModel(title: "Call of duty",
                                                     subtitle: "Hamburger",
                                                     color: UIColor(red:0.96, green:0.81, blue:0.46, alpha:1.0),
                                                     image: UIImage())

        let panda = SampleSwipeableCellViewModel(title: "Warzone",
                                                  subtitle: "Animal",
                                                  color: UIColor(red:0.29, green:0.64, blue:0.96, alpha:1.0),
                                                  image: UIImage())

        let puppy = SampleSwipeableCellViewModel(title: "DOTA",
                                                  subtitle: "Pet",
                                                  color: UIColor(red:0.29, green:0.63, blue:0.49, alpha:1.0),
                                                  image: UIImage())

        let poop = SampleSwipeableCellViewModel(title: "Fortnite",
                                                  subtitle: "Smelly",
                                                  color: UIColor(red:0.69, green:0.52, blue:0.38, alpha:1.0),
                                                  image: UIImage())

        let robot = SampleSwipeableCellViewModel(title: "Teletubbies the game",
                                                  subtitle: "Future",
                                                  color: UIColor(red:0.90, green:0.99, blue:0.97, alpha:1.0),
                                                  image: UIImage())

        let clown = SampleSwipeableCellViewModel(title: "Back Flip Trainers",
                                                  subtitle: "Scary",
                                                  color: UIColor(red:0.83, green:0.82, blue:0.69, alpha:1.0),
                                                  image: UIImage())

        return [hamburger, panda, puppy, poop, robot, clown]
    }

}

//
//  UpcomingGamesScreen.swift
//  AKTV
//
//  Created by Alexander Kvamme on 05/06/2021.
//  Copyright © 2021 Alexander Kvamme. All rights reserved.
//

import Foundation
import UIKit


class IconButton: UIButton {

    enum IconButtonStyle: String {
        case x = "close"
        case playstation = "logo-playstation-icon"
        case nintendoSwitch = "logo-nintendo-switch-icon"
        case windows = "logo-windows-icon"
    }

    static func make(_ style: IconButtonStyle) -> IconButton {
        let button = IconButton(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        button.setImage(UIImage.init(named: style.rawValue)!, for: .normal)
        return button
    }
}


enum Console: String {
    case playstation = "logo-playstation-icon"
    case nintendoSwitch = "logo-nintendo-switch-icon"
    case windows = "logo-windows-icon"
    case xbox = "logo-xbox-icon"
}


class ConsoleIconStack: UIStackView {

    var imageViews = [UIImageView]()

    init(_ consoles: [Console]) {
        super.init(frame: .zero)

        consoles.forEach { (console) in
            let img = UIImage.init(named: console.rawValue)!
            let iv = UIImageView(image: img)
            iv.contentMode = .scaleAspectFit
            imageViews.append(iv)
        }

        setup()
        addSubviewsAndConstraints()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        axis = .horizontal
        distribution = .fillEqually
        alignment = .leading

        imageViews.forEach { (img) in
            img.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
            addArrangedSubview(img)
        }

    }

    private func addSubviewsAndConstraints() {

    }

}


final class UpcomingGamesScreen: UIViewController, SwipeableCardViewDataSource {

    // MARK: - Properties

    private var xButton = IconButton.make(.x)
    private var headerLabel = UILabel.make(.header)
    private var genreLabel = UILabel.make(.subtitle)
    private var iconStack = ConsoleIconStack([.xbox, .playstation, .windows])

    private var cardContainer = SwipeableCardViewContainer(frame: screenFrame)
    weak var customTabBarDelegate: CustomTabBarDelegate?

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        view.backgroundColor = UIColor(light)

        setup()
        addSubviewsAndConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        cardContainer.dataSource = self

        customTabBarDelegate?.hideIt()
    }

    override func viewWillAppear(_ animated: Bool) {
        customTabBarDelegate?.hideIt()
    }

    // MARK: - Initializers

    // MARK: - Methods

    private func setup() {
        headerLabel.text = "Aight,\nhow about this?"
        headerLabel.textColor = UIColor(dark)
        headerLabel.numberOfLines = 0
        headerLabel.font = UIFont.gilroy(.heavy, 40)
        genreLabel.text = "This is an Arcade game."
        genreLabel.textColor = UIColor(dark)
        genreLabel.font = UIFont.gilroy(.bold, 12)
        genreLabel.alpha = 0.4
        xButton.addTarget(self, action: #selector(exitScreen), for: .touchDown)
    }

    @objc func exitScreen() {
        print("Would exit screen")
    }

    private func addSubviewsAndConstraints() {
        view.addSubview(xButton)
        view.addSubview(headerLabel)
        view.addSubview(genreLabel)
        view.addSubview(iconStack)
        view.addSubview(cardContainer)

        xButton.snp.makeConstraints { (make) in
            make.top.left.equalTo(view.safeAreaLayoutGuide).offset(24)
            make.size.equalTo(48)
        }

        headerLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(24)
            make.top.equalTo(xButton.snp.bottom).offset(24)
        }

        genreLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(headerLabel)
            make.top.equalTo(headerLabel.snp.bottom).offset(16)
        }

        iconStack.snp.makeConstraints { (make) in
            make.left.equalTo(headerLabel)
            make.width.lessThanOrEqualTo(48*3)
            make.top.equalTo(genreLabel.snp.bottom).offset(16)
            make.height.equalTo(24)
        }

        cardContainer.snp.makeConstraints { (make) in
            make.top.equalTo(iconStack.snp.bottom).offset(24)
            make.left.right.bottom.equalToSuperview()
        }
    }
}

// MARK: - SwipeableCardViewDataSource

extension UpcomingGamesScreen {

    func numberOfCards() -> Int {
        return viewModels.count
    }

    func card(forItemAtIndex index: Int) -> SwipeableCardViewCard {
        let viewModel = viewModels[index]
        let cardView = SampleSwipeableCard()
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
                                                     image: UIImage())

        let panda = SampleSwipeableCellViewModel(title: "Warzone",
                                                  subtitle: "Animal",
                                                  image: UIImage())

        let puppy = SampleSwipeableCellViewModel(title: "DOTA",
                                                  subtitle: "Pet",
                                                  image: UIImage())

        let poop = SampleSwipeableCellViewModel(title: "Fortnite",
                                                  subtitle: "Smelly",
                                                  image: UIImage())

        let robot = SampleSwipeableCellViewModel(title: "Teletubbies the game",
                                                  subtitle: "Future",
                                                  image: UIImage())

        let clown = SampleSwipeableCellViewModel(title: "Back Flip Trainers",
                                                  subtitle: "Scary",
                                                  image: UIImage())

        return [hamburger, panda, puppy, poop, robot, clown]
    }

}

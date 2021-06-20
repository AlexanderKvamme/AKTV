//
//  UpcomingGamesScreen.swift
//  AKTV
//
//  Created by Alexander Kvamme on 05/06/2021.
//  Copyright © 2021 Alexander Kvamme. All rights reserved.
//

import Foundation
import UIKit
import IGDB_SWIFT_API


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


final class DiscoveryScreen: UIViewController, CardViewDataSource {

    // MARK: - Properties

    private var xButton = IconButton.make(.x)
    private var headerLabel = UILabel.make(.header)
    private var genreLabel = UILabel.make(.subtitle)
    private var iconStack = ConsoleIconStack([.xbox, .playstation, .windows])

    private var cardContainer = GameCardController(frame: screenFrame)
    weak var customTabBarDelegate: CustomTabBarDelegate?

    var viewModels = [Proto_Game]()

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
        headerLabel.text = "This one?"
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
        tabBarController?.selectedIndex = 0
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

    func update(with games: [Proto_Game]) {
        viewModels = games
        cardContainer.reloadData()
    }

    func items() -> [Proto_Game] {
        return viewModels
    }

}

// MARK: - SwipeableCardViewDataSource

extension DiscoveryScreen {

    func numberOfCards() -> Int {
        return viewModels.count
    }

    func card(forItemAtIndex index: Int) -> SwipeableView {
        let viewModel = viewModels[index]
        let cardView = SwipeableGameCard()
        cardView.viewModel = viewModel
        cardView.layoutSubviews()

        return cardView
    }

    func viewForEmptyCards() -> UIView? {
        return nil
    }

}

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
    // TODO: Clean up and rethink
    var initialRange: GameRange = GameRange(upper: Int.max, lower: Int.min)
    
    var initialPlatform = GamePlatform.tbd
    var initialHighestRemoteID: Int = Int.max

    // MARK: - Properties

    private var xButton = UIImageView()
    private var headerLabel = UILabel.make(.header)
    private var genreLabel = UILabel.make(.subtitle)
    private var iconStack = ConsoleIconStack([.xbox, .playstation, .windows])

    private var cardContainer = GameCardController(frame: screenFrame)
    weak var customTabBarDelegate: CustomTabBarDelegate?

    var viewModels = [Proto_Game]()

    init() {
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = UIColor(light)

        setup()
        addSubviewsAndConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        cardContainer.dataSource = self

        customTabBarDelegate?.hideIt(animated: false)
    }

    override func viewWillAppear(_ animated: Bool) {
        customTabBarDelegate?.hideIt(animated: false)
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

        let tapRec = UITapGestureRecognizer(target: self, action: #selector(exitScreen))
        xButton.addGestureRecognizer(tapRec)

        let configuration = UIImage.SymbolConfiguration (pointSize: 24.0, weight: .light)
        xButton.image = UIImage(systemName: "chevron.down", withConfiguration: configuration)?.withRenderingMode(.alwaysTemplate)
        xButton.tintColor = UIColor(dark).withAlphaComponent(0.1)
        xButton.isUserInteractionEnabled = true
    }

    @objc func exitScreen() {
        customTabBarDelegate?.showIt(animated: false)
        navigationController?.popToRootViewController(animated: true)
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
        tabBarController?.dismiss(animated: true, completion: nil)
    }

    private func addSubviewsAndConstraints() {
        view.addSubview(xButton)
        view.addSubview(headerLabel)
        view.addSubview(genreLabel)
        view.addSubview(iconStack)
        view.addSubview(cardContainer)

        headerLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(24)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(24)
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
            make.left.right.equalToSuperview()
            make.bottom.equalTo(xButton.snp.top)
        }

        xButton.snp.makeConstraints { make in
            make.width.equalTo(56)
            make.height.equalTo(40)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-24)
        }

    }

    func addGame(_ game: Proto_Game) {
        // TODO: Make sure the games are added in order

        guard !viewModels.contains(game) else {
            print("Error: game \(game.id) was already contained in the datasource \(viewModels.map({$0.id})) so it will be skipped")
            return
        }

        let firstIndex = viewModels.firstIndex { existingGame in
            existingGame.id < game.id
        }

        // Add to end

        if firstIndex == nil {
            viewModels.append(game)
        }

        // FIXME: Make sure the game is added with a card
    }

    func addGames(_ games: [Proto_Game]) {
        games.forEach({addGame($0)})
    }

    func update(with games: [Proto_Game], range: GameRange, platform: GamePlatform, initialHighestRemoteID: Int? = nil) {
        if let initialHighestRemoteID = initialHighestRemoteID {
            self.initialHighestRemoteID = initialHighestRemoteID
        }

        initialRange = range
        initialPlatform = platform

        viewModels = games
        cardContainer.reloadData()
    }

    func getItems() -> [Proto_Game] {
        return viewModels
    }

    func removeFirstGame() {
        viewModels.remove(at: 0)
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
        return makeEmptyCardView()
    }

    private func makeEmptyCardView() -> UIView {
        let v = UIView()
        v.backgroundColor = .green
        return v
    }

}

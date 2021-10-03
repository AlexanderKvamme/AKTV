//
//  GameScreen.swift
//  AKTV
//
//  Created by Alexander Kvamme on 28/07/2021.
//  Copyright © 2021 Alexander Kvamme. All rights reserved.
//

let loremIpsum = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."

import UIKit
import IGDB_SWIFT_API
import Kingfisher

final class GameScreen: UIViewController {
    
    private var icon = UIImageView(frame: CGRect.defaultButtonRect)
    private let scrollView = UIScrollView()
    private let imageView = UIImageView()
    private let header = UILabel.make(.header)
    private let sub = UILabel.make(.subtitle)
    private let body = UITextView.makeBodyTextView()
    private let game: Proto_Game
    private let platform: GamePlatform

    init(_ game: Proto_Game, platform: GamePlatform) {
        self.game = game
        self.platform = platform
        
        super.init(nibName: nil, bundle: nil)
        
        setup()
        addSubviewsAndConstraint()
        
        fetchContent(game)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        view.backgroundColor = UIColor(dark)
        imageView.backgroundColor = .orange
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        header.text = "Header"
        sub.text = "Sub"
        sub.font = UIFont.round(.bold, 16)
        body.text = loremIpsum
        body.textColor = UIColor(light)
        
        let tr = UITapGestureRecognizer(target: self, action: #selector(didTapStar))
        icon.addGestureRecognizer(tr)
        icon.isUserInteractionEnabled = true
        
        // Update favourite icon
        let isFavourite = GameStore.getFavourites(platform).contains(Int(game.id))
        setFilled(isFavourite)
    }
    
    @objc private func didTapStar() {
        let isFavourite = GameStore.getFavourites(platform).contains(Int(game.id))
        setFilled(!isFavourite)
        
        GameStore.setFavourite(self.game, !isFavourite, platform: platform)
    }
    
    private func fetchContent(_ game: Proto_Game) {
        // Display cover image
        GameService.getCover(forGame: game) { cover in
            DispatchQueue.main.async {
                if let url = URL(string: imageBuilder(imageID: cover.imageID, size: .COVER_BIG)) {
                    self.imageView.kf.setImage(with: url)
                }
            }
        }

        header.text = game.name
        sub.text = "A game for gamers"
    }
    
    private func setFilled(_ fill: Bool) {
        let iconConfiguration = UIImage.SymbolConfiguration(scale: .medium)
        let newIcon = fill ? "star.fill" : "star"
        icon.tintColor = .white
        icon.image = UIImage(systemName: newIcon, withConfiguration: iconConfiguration)
    }
    
    private func addSubviewsAndConstraint() {
        view.addSubview(scrollView)
        
        let hInset: CGFloat = 24
        let vSpacing: CGFloat = 8
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        scrollView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.left.equalToSuperview()
            make.height.equalTo(400)
            make.width.equalTo(screenWidth)
        }
        
        scrollView.addSubview(icon)
        icon.snp.makeConstraints { make in
            make.right.bottom.equalTo(imageView).inset(24)
            make.size.equalTo(50)
        }
        
        scrollView.addSubview(header)
        header.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(24)
            make.left.right.equalToSuperview().inset(hInset)
        }
        
        scrollView.addSubview(sub)
        sub.snp.makeConstraints { make in
            make.top.equalTo(header.snp.bottom).offset(vSpacing)
            make.left.right.equalToSuperview().inset(hInset)
            make.bottom.equalToSuperview()
        }
        
        scrollView.addSubview(body)
        body.snp.makeConstraints { make in
            make.top.equalTo(sub.snp.bottom).offset(24)
            make.left.equalToSuperview().offset(hInset)
            make.height.equalTo(200)
            make.width.equalTo(screenWidth-hInset*2)
        }
    }
    
}
 

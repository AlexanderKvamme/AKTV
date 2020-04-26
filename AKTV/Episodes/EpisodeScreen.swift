//
//  EpisodeScreen.swift
//  AKTV
//
//  Created by Alexander Kvamme on 25/04/2020.
//  Copyright © 2020 Alexander Kvamme. All rights reserved.
//

import UIKit

final class EpisodeScreen: UIViewController {
    
    // MARK: Properties
    
    let episodeTextView = UITextView()
    
    // MARK: Initializers
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        setup()
        addSubviewsAndConstraints()
        view.backgroundColor = .purple
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Private methods
    
    private func setup() {
        episodeTextView.backgroundColor = .cyan
        episodeTextView.font = UIFont.systemFont(ofSize: 24)
    }
    
    private func addSubviewsAndConstraints() {
        view.addSubview(episodeTextView)
        episodeTextView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    // MARK: Helper methods
    
    // MARK: Internal methods
    
    func update(with episode: Episode) {
        episodeTextView.text = episode.overview
    }
}

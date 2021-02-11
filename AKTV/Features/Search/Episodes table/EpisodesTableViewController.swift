//
//  EpisodesTableViewController.swift
//  AKTV
//
//  Created by Alexander Kvamme on 13/04/2020.
//  Copyright © 2020 Alexander Kvamme. All rights reserved.
//

import UIKit
import SnapKit


final class SeasonScreen: UIViewController {
    
    // MARK: Properties
    
    var seasonHeaderView = SeasonHeaderView()
    var tableView = UITableView()
    var episodesDataDelegate = SeasonDataDelegate()
    var episodeDisplayer: EpisodeDisplayer?
    
    // MARK: Initializers
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        
        view.backgroundColor = UIColor(dark)
        
        setup()
        addSubviewsAndConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Private methods
    
    private func setup() {
        seasonHeaderView.frame.size = CGSize(width: screenWidth, height: 200)

        tableView.tableHeaderView = seasonHeaderView
        tableView.delegate = episodesDataDelegate
        tableView.dataSource = episodesDataDelegate
        tableView.register(EpisodeCell.self, forCellReuseIdentifier: EpisodeCell.identifier)
        tableView.estimatedRowHeight = 100
        tableView.backgroundColor = .clear
        
        episodesDataDelegate.episodeDisplayer = self
    }
    
    private func addSubviewsAndConstraints() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
    }
    
    // MARK: Internal methods
    
    func update(with season: Season) {
        episodesDataDelegate.season = season
        seasonHeaderView.titleLabel.text = season.name.uppercased()
    }
}

protocol EpisodeDisplayer {
    func display(episode: Episode) -> Void
}

extension SeasonScreen: EpisodeDisplayer {
    func display(episode: Episode) {
        let episodeScreen = EpisodeScreen()
        episodeScreen.update(with: episode)
        self.present(episodeScreen, animated: true, completion: nil)
    }
}

//
//  EpisodesSearchResultDataDelegate.swift
//  AKTV
//
//  Created by Alexander Kvamme on 25/03/2020.
//  Copyright © 2020 Alexander Kvamme. All rights reserved.
//

import Foundation
import UIKit

final class EpisodesSearchResultDataDelegate: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: Properties
    
    var episodes = [Episode]()
    
    // MARK: Delegate methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: EpisodeCell.identifier) ?? EpisodeCell(for: episodes[indexPath.row])
    }
}

final class EpisodeCell: UITableViewCell {
    static let identifier = "EpisodeCell"
    
    init(for episode: Episode) {
        super.init(style: .default, reuseIdentifier: EpisodeCell.identifier)
        
        // setup
        backgroundColor = .green
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

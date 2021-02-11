//
//  SeasonDataDelegate.swift
//  AKTV
//
//  Created by Alexander Kvamme on 11/02/2021.
//  Copyright © 2021 Alexander Kvamme. All rights reserved.
//

import UIKit


final class SeasonDataDelegate: NSObject, UITableViewDataSource, UITableViewDelegate {

    // MARK: Properties

    var season: Season!
    var episodeDisplayer: EpisodeDisplayer?

    // MARK: Initializers

    override init() {
        super.init()
    }

    // MARK: Internal methods

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return season.episodes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let episode = season.episodes[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: EpisodeCell.identifier) as? EpisodeCell ?? EpisodeCell()
        cell.update(with: episode)

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        episodeDisplayer!.display(episode: season.episodes[indexPath.row])
    }
}

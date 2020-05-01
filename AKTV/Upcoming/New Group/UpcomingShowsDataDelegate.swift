//
//  UpcomingShowsDataDelegate.swift
//  AKTV
//
//  Created by Alexander Kvamme on 27/04/2020.
//  Copyright © 2020 Alexander Kvamme. All rights reserved.
//

import UIKit

final class UpcomingShowsDataDelegate: NSObject,  UITableViewDelegate, UITableViewDataSource {
    
    // MARK: Properties
    
    private var shows = [ShowOverview]()
    
    // MARK: Initializers
    
    // MARK: Private methods
    
    // MARK: DataSource methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("bam count: ", shows.count)
        return shows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UpcomingShowCell.identifier) as? UpcomingShowCell ?? UpcomingShowCell()
        cell.update(withShowOverview: shows[indexPath.row])
        return cell
    }
    
    // MARK: Helper methods
    
    // MARK: Internal methods
    
    func update(withShows shows: [ShowOverview]) {
        print("bam would put shows into upcoming: ", shows.compactMap({$0.id}))
    }
    
    func update(withShow show: ShowOverview) {
        print("bam would put shows into upcoming: ", show.id)
        shows.sort { (a, b) -> Bool in
            // FIXME: Proper sorting needed
            a.nextEpisodeToAir?.timeIntervalSince1970 ?? 0 > b.nextEpisodeToAir?.timeIntervalSince1970 ?? 0
        }
        
        // FIXME: Put it proper place
        shows.append(show)

    }
}

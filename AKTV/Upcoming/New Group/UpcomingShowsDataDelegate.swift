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
    
    private var shows = [Show]()
    
    // MARK: Initializers
    
    // MARK: Private methods
    
    // MARK: DataSource methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UpcomingShowCell.identifier) as? UpcomingShowCell ?? UpcomingShowCell()
        cell.update(withShow: shows[indexPath.row])
        return cell
    }
    
    // MARK: Helper methods
    
    // MARK: Internal methods
    
    
}

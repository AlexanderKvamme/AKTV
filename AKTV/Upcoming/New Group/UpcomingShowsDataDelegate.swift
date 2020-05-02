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
    
    private var shows = [ShowOverview]() // remove?
    var sectionData = [Date: [ShowOverview]]()
    var dates = [Date]()
    
    // MARK: DataSource methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let sectionCount = dates.count
        print("bam sections: ", sectionCount)
        return sectionCount
    }
    
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
        
        // FIXME: Test organizing by dates
        
        var totalDates = [Date]()
        
        shows.forEach { (show) in
            if let nextDateString = show.nextEpisodeToAir?.airDate {
                print("bam added show under \(nextDateString)")
                if let date = AKDateFormatter.date(from: nextDateString) {
                    print("bam successfully made date.")
                    print("bam datestring was: ", nextDateString)
                    print("bam date becamse: ", date)
                    
                    if sectionData[date] == nil {
                        if let existing = sectionData[date] {
                            if existing.contains(where: { (existingShow) -> Bool in
                                show.id == existingShow.id
                            }) {
                                print("bam already existed in dict")
                            } else {
                                sectionData[date]?.append(show)
                            }
                        }
                        sectionData[date] = [show]
                    } else {
                        
                    }
                }
                
//                totalDates.append(nextDateString)
                
            }
            print("show had no next date and will not be included")
        }
        
        print("bam sections would be organized like this: ", sectionData)
        print("bam total dates: ", totalDates)
        print("bam would put shows into upcoming: ", show.id)
        shows.append(show)
    }
}

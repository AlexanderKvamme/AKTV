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

    private var data = [DayModel: [ShowOverview]]()
    
    // MARK: DataSource methods

    func numberOfSections(in tableView: UITableView) -> Int {
        let sectionCount = data.keys.count
        return sectionCount
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sortedDays = Array(data.keys.sorted())
        let relevantDate = sortedDays[section]
        let showsOnRelevantDate = data[relevantDate]
        return showsOnRelevantDate?.count ?? 0
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UpcomingSectionHeader()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UpcomingShowCell.identifier) as? UpcomingShowCell ?? UpcomingShowCell()
        let sortedDays: Array<DayModel> = Array(data.keys.sorted())
        let day = sortedDays[indexPath.section]
        if let shows = data[day] {
            cell.update(withShowOverview: shows[indexPath.row])
        } else {
            fatalError("Show data did not exist")
        }

        return cell
    }

    // MARK: Internal methods

    // TODO: Use this and gather all shows in one fetch
    func update(withShows shows: [ShowOverview]) {
        fatalError("Implement me")
    }
    
    func update(withShow show: ShowOverview) {
        guard let nextDateString = show.nextEpisodeToAir?.airDate else {
            print("Error: could not access next date of: ", show.name)
            return
        }

        guard let premierDate = AKDateFormatter.day(from: nextDateString) else {
            print("Error: could not format string into date")
            return
        }

        // Add section if it doesnt exist
        if data[premierDate] == nil {
            if let existing = data[premierDate] {
                if existing.contains(where: { (existingShow) -> Bool in
                    show.id == existingShow.id
                }) {
                    print("TODO: Fix better solution for entries already existing in dict")
                } else {
                    data[premierDate]?.append(show)
                }
            }
            data[premierDate] = [show]
        }
    }
}

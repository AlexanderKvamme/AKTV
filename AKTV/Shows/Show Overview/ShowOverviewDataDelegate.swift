//
//  ShowsOverviewDataDelegate.swift
//  AKTV
//
//  Created by Alexander Kvamme on 12/04/2020.
//  Copyright © 2020 Alexander Kvamme. All rights reserved.
//

import Foundation
import UIKit

final class ShowOverviewDataDelegate: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: Properties
    
    var showOverview: ShowOverview?
    var seasonPresenter: SeasonPresenter?
    
    // MARK: Delegate methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return showOverview?.seasons.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let seasonOverview = showOverview!.seasons[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: ShowCell.identifier) ?? SeasonOverviewCell(for: showOverview!.seasons[indexPath.row])
        if let cell = cell as? SeasonOverviewCell {
            cell.update(with: seasonOverview)
        } else {
            fatalError("bam could not cast")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        seasonPresenter!.displaySeason(showId: showOverview!.id,
                                       seasonNumber: showOverview!.seasons[indexPath.row].seasonNumber)
    }
}

final class SeasonOverviewCell: UITableViewCell {
    
    // MARK: Properties
    
    var header = UILabel()
    
    // MARK: Initializers
    
    static let identifier = "SeasonOverviewCell"
    
    init(for episode: SeasonOverview) {
        super.init(style: .default, reuseIdentifier: ShowCell.identifier)
        
        // setup
        backgroundColor = .orange
        setup()
        addSubviewsAndConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Private methods
    
    private func setup() {
        header.text = "Shazam"
        header.backgroundColor = .purple
    }
    
    private func addSubviewsAndConstraints() {
        contentView.addSubview(header)
        
//        contentView.snp.makeConstraints { (make) in
//            make.height.equalTo(200)
//            make.width.equalTo(UIScreen.main.bounds.width)
//        }
        
//        contentView.snp.makeConstraints { (make) in
//            make.height.equalTo(200)
////            make.width.equalTo(200)
//            make.width.equalTo(UIScreen.main.bounds.width)
//        }
        
        header.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.height.equalTo(100)
        }
    }
    
    // MARK: Internal methods
    
    func update(with seasonOverview: SeasonOverview) {
        header.text = seasonOverview.name
    }
}

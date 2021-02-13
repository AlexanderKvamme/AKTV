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

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

final class SeasonOverviewCell: UITableViewCell {
    
    // MARK: Properties
    
    var seasonLabel = UILabel()
    
    // MARK: Initializers
    
    static let identifier = "SeasonOverviewCell"
    
    init(for episode: SeasonOverview) {
        super.init(style: .default, reuseIdentifier: ShowCell.identifier)
        
        setup()
        addSubviewsAndConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Private methods
    
    private func setup() {
        backgroundColor = .clear
        selectionStyle = .none

        seasonLabel.text = "Season goes here"
        seasonLabel.textAlignment = .center
        seasonLabel.font = UIFont.gilroy(.semibold, 20)
        seasonLabel.textColor = UIColor(light)
    }
    
    private func addSubviewsAndConstraints() {
        contentView.addSubview(seasonLabel)
        
        seasonLabel.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(16)
        }
    }
    
    // MARK: Internal methods
    
    func update(with seasonOverview: SeasonOverview) {
        seasonLabel.text = seasonOverview.name
    }
}

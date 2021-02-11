//
//  EpisodesSearchResultDataDelegate.swift
//  AKTV
//
//  Created by Alexander Kvamme on 25/03/2020.
//  Copyright © 2020 Alexander Kvamme. All rights reserved.
//

import Foundation
import UIKit

final class ShowsDataDelegate: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: Properties
    
    var shows = [Show]()
    var detailedShowPresenter: ModelPresenter?
    
    // MARK: Delegate methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let show = shows[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: ShowCell.identifier) ?? ShowCell(for: shows[indexPath.row])
        cell.backgroundColor = .clear
        if let cell = cell as? ShowCell {
            cell.update(with: show)
        } else {
            fatalError("could not cast to ShowCell")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        detailedShowPresenter?.displayShow(shows[indexPath.row].id)
    }
}

final class ShowCell: UITableViewCell {
    
    // MARK: Properties

    static let estimatedHeight: CGFloat = 64
    var header = UILabel()
    
    // MARK: Initializers
    
    static let identifier = "EpisodeCell"
    
    init(for episode: Show) {
        super.init(style: .default, reuseIdentifier: ShowCell.identifier)

        setup()
        addSubviewsAndConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Private methods
    
    private func setup() {
        selectionStyle = .none

        header.text = "Shazam"
        header.textColor = UIColor(light)
        header.font = UIFont.gilroy(.bold, 20)
        header.layoutMargins = UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 0)
        header.backgroundColor = .clear
    }
    
    private func addSubviewsAndConstraints() {
        contentView.addSubview(header)
        
        header.snp.makeConstraints { (make) in
            make.top.right.equalToSuperview()
            make.left.equalToSuperview().offset(24)

            make.height.equalTo(Self.estimatedHeight)
        }
    }
    
    // MARK: Helper methods
    
    // MARK: Internal methods
    
    func update(with show: Show) {
        header.text = show.name
    }
}

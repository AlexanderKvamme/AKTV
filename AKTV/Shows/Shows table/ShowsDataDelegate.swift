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
    var detailedShowPresenter: DetailedShowPresenter?
    
    // MARK: Delegate methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("bam cell count: ", shows.count)
        return shows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let show = shows[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: ShowCell.identifier) ?? ShowCell(for: shows[indexPath.row])
        if let cell = cell as? ShowCell {
            cell.update(with: show)
        } else {
            print("bam could not cast")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("bam tapped \(shows[indexPath.row].name)")
        
        detailedShowPresenter?.displayShow(shows[indexPath.row].id)
    }
}

final class ShowCell: UITableViewCell {
    
    // MARK: Properties
    
    var header = UILabel()
    
    // MARK: Initializers
    
    static let identifier = "EpisodeCell"
    
    init(for episode: Show) {
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
            make.height.equalTo(200)
        }
    }
    
    // MARK: Helper methods
    
    // MARK: Internal methods
    
    func update(with show: Show) {
        header.text = show.name
    }
}

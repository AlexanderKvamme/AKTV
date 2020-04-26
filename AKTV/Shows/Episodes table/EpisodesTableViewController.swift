//
//  EpisodesTableViewController.swift
//  AKTV
//
//  Created by Alexander Kvamme on 13/04/2020.
//  Copyright © 2020 Alexander Kvamme. All rights reserved.
//

import UIKit
import SnapKit

final class EpisodeCell: UITableViewCell {
    
    // MARK: Properties
    
    static let identifier = "Episode Cell"
    
    let episodeNumberLabel = UILabel()
    let nameLabel = UILabel()
    let dateLabel = UILabel()
    
    // MARK: Initializers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: EpisodeCell.identifier)
        
        setup()
        addSubviewsAndConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Private methods
    
    private func setup() {
        episodeNumberLabel.backgroundColor = .cyan
        episodeNumberLabel.text = "TEMP"
        
        nameLabel.backgroundColor = .red
        nameLabel.text = "TEMP"
        
        dateLabel.backgroundColor = .blue
        dateLabel.text = "TEMP"
    }
    
    private func addSubviewsAndConstraints() {
        contentView.addSubview(episodeNumberLabel)
        contentView.addSubview(nameLabel)
        contentView.addSubview(dateLabel)
        
        contentView.snp.makeConstraints { (make) in
            make.height.equalTo(100)
        }
        
        episodeNumberLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(episodeNumberLabel.snp.bottom)
            make.left.equalTo(episodeNumberLabel)
        }
        
        dateLabel.snp.makeConstraints { (make) in
            make.top.equalTo(nameLabel.snp.bottom)
            make.left.equalToSuperview()
            make.height.equalTo(30)
            make.width.equalTo(200)
        }
    }
    
    // MARK: Internal methods
    
    func update(with episode: Episode) {
        episodeNumberLabel.text = "\(episode.episodeNumber)"
        nameLabel.text = episode.name
        dateLabel.text = episode.airDate
    }
}

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

final class SeasonHeaderView: UIView {
    
    // MARK: Properties
    
    var titleLabel = UILabel()
    
    // MARK: Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .black
        setup()
        addSubviewsAndConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Private methods
    
    private func setup() {
        titleLabel.text = "Something"
        titleLabel.textColor = .yellow
        titleLabel.sizeToFit()
    }
    
    private func addSubviewsAndConstraints() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
    }
}

final class SeasonTableViewController: UIViewController {
    
    // MARK: Properties
    
    var headerView = SeasonHeaderView()
    var tableView = UITableView()
    var episodesDataDelegate = SeasonDataDelegate()
    var episodeDisplayer: EpisodeDisplayer?
    
    // MARK: Initializers
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        
        view.backgroundColor = .black
        
        setup()
        addSubviewsAndConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Private methods
    
    private func setup() {
        tableView.delegate = episodesDataDelegate
        tableView.dataSource = episodesDataDelegate
        tableView.register(EpisodeCell.self, forCellReuseIdentifier: EpisodeCell.identifier)
        tableView.estimatedRowHeight = 100
        tableView.backgroundColor = .yellow
        
        episodesDataDelegate.episodeDisplayer = self
    }
    
    private func addSubviewsAndConstraints() {
        view.addSubview(headerView)
        view.addSubview(tableView)
        
        headerView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(300)
        }
        
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(headerView.snp.bottom)
            make.left.bottom.right.equalToSuperview()
        }
    }
    
    // MARK: Internal methods
    
    func update(with season: Season) {
        episodesDataDelegate.season = season
        headerView.titleLabel.text = "Show title"
    }
}


protocol EpisodeDisplayer {
    func display(episode: Episode) -> Void
}

extension SeasonTableViewController: EpisodeDisplayer {
    func display(episode: Episode) {
        let episodeScreen = EpisodeScreen()
        episodeScreen.update(with: episode)
        self.present(episodeScreen, animated: true, completion: nil)
    }
}

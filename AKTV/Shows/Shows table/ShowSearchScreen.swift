//
//  ShowSearchScreen.swift
//  AKTV
//
//  Created by Alexander Kvamme on 25/03/2020.
//  Copyright © 2020 Alexander Kvamme. All rights reserved.
//

import Foundation
import UIKit

//

protocol SeasonPresenter {
    func displaySeason(showId: Int?, seasonNumber: Int?)
}

// This is where the app starts

protocol ModelPresenter {
    func displayShow(_ id: Int?)
    func displayEpisode(_ episode: Episode)
}


final class ShowOverviewScreenHeader: UIView {
    
    // MARK: Properties
    
    private let heartIcon = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    
    // MARK: Initializers
    
    init() {
        super.init(frame: .zero)
        
        // FIXME: Add heart button
        backgroundColor = .darkGray

        setup()
        addSubviewsAndConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Private methods
    
    private func setup() {
        heartIcon.backgroundColor = .purple
        heartIcon.layer.borderColor = UIColor.green.cgColor
        heartIcon.layer.borderWidth = 10
        
        heartIcon.addTarget(self, action: #selector(toggleHeart), for: .touchUpInside)
    }
    
    private func addSubviewsAndConstraints() {
        addSubview(heartIcon)

        heartIcon.snp.makeConstraints { (make) in
            make.top.right.equalToSuperview()
        }
    }
    
    // MARK: Helper methods
    
    @objc func toggleHeart() {
        heartIcon.backgroundColor = heartIcon.backgroundColor == .red ? .green : .purple
    }
}


final class ShowsSearchScreen: UIViewController {
    
    // MARK: Properties
    
    private let searchField = UITextField()
    private let episodesSearchResultViewController = UITableViewController()
    private let episodesSearchResultDataDelegate = ShowsDataDelegate()
    private let apiDao: APIDAO
    
    // MARK: Initializers
    
    init(dao: APIDAO) {
        apiDao = dao
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .green
        setup()
        addSubviewsAndConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Private methods
    
    private func setup() {
        searchField.backgroundColor = .green
        searchField.placeholder = "Søk her"
        searchField.delegate = self
        searchField.isUserInteractionEnabled = true
        searchField.becomeFirstResponder()
        
        episodesSearchResultViewController.tableView.dataSource = episodesSearchResultDataDelegate
        episodesSearchResultViewController.tableView.delegate = episodesSearchResultDataDelegate
        episodesSearchResultViewController.tableView.estimatedRowHeight = 200
        
        episodesSearchResultDataDelegate.detailedShowPresenter = self
    }
    
    private func addSubviewsAndConstraints() {
        view.addSubview(searchField)
        
        searchField.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(100)
        }
        
        let tv = episodesSearchResultViewController
        view.addSubview(tv.view)
        addChild(episodesSearchResultViewController)
        
        episodesSearchResultViewController.view.snp.makeConstraints { (make) in
            make.top.equalTo(searchField.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
    }
}
// MARK: - DetailedShowPresenter conformance

extension ShowsSearchScreen: ModelPresenter {
    func displayEpisode(_ episode: Episode) {
        fatalError("SUCCESS! Now actually make VC and present to screen")
    }
    
    func displayShow(_ id: Int?) {
        guard let id = id else { fatalError("Show had no id to present from") }
        
        apiDao.testGettingAllSeasonsOverview(showId: id) { (showOverview) in
            
            DispatchQueue.main.async {
                let next = ShowOverviewScreen(dao: self.apiDao)
                next.update(with: showOverview)
                self.present(next, animated: false, completion: nil)
            }
        }
    }
}

// MARK: - Make self textview delegate

extension ShowsSearchScreen: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let searchterm = textField.text else {
            return false
        }
        
        _ = apiDao.searchShows(string: searchterm) { (shows) in
            DispatchQueue.main.async {
                self.episodesSearchResultDataDelegate.shows = shows
                self.episodesSearchResultViewController.tableView.reloadData()
            }
        }
        
        return true
    }
}

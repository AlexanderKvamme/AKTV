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

// TODO: Remove if not used
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

    private let headerField = UILabel()
    private let searchField = UITextField()
    private let episodesSearchResultViewController = UITableViewController()
    private let episodesSearchResultDataDelegate = ShowsDataDelegate()
    private let apiDao: APIDAO
    
    // MARK: Initializers
    
    init(dao: APIDAO) {
        apiDao = dao
        super.init(nibName: nil, bundle: nil)
        setup()
        addSubviewsAndConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Private methods
    
    private func setup() {
        view.backgroundColor = UIColor(dark)

        headerField.font = UIFont.gilroy(.semibold, 20)
        headerField.textAlignment = .center
        headerField.textColor = UIColor(light)
        headerField.text = "What are you looking for?"

        searchField.backgroundColor = UIColor(dark)
        searchField.textColor = UIColor(light)
        searchField.textAlignment = .center
        searchField.placeholder = "Game of thrones"
        searchField.font = UIFont.gilroy(.heavy, 60)
        searchField.delegate = self
        searchField.isUserInteractionEnabled = true
        searchField.becomeFirstResponder()
        searchField.adjustsFontSizeToFitWidth = true

        episodesSearchResultViewController.tableView.dataSource = episodesSearchResultDataDelegate
        episodesSearchResultViewController.tableView.delegate = episodesSearchResultDataDelegate
        episodesSearchResultViewController.tableView.estimatedRowHeight = ShowCell.estimatedHeight
        episodesSearchResultViewController.tableView.backgroundColor = .clear

        episodesSearchResultDataDelegate.detailedShowPresenter = self
    }
    
    private func addSubviewsAndConstraints() {
        view.addSubview(searchField)
        searchField.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(80)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(200)
        }

        view.addSubview(headerField)
        headerField.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(100)
            make.left.right.equalToSuperview()
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
        
        apiDao.show(withId: id) { (showOverview) in
            DispatchQueue.main.async {
                let next = ShowOverviewScreen(dao: self.apiDao)
                next.update(with: showOverview)
                self.present(next, animated: true, completion: nil)
            }
        }
    }
}

// MARK: - Make self textview delegate

extension ShowsSearchScreen: UITextFieldDelegate {

    func textFieldDidChangeSelection(_ textField: UITextField) {
        textField.text = textField.text?.uppercased()
    }
    
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

        textField.resignFirstResponder()
        return true
    }
}

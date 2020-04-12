//
//  ShowSearchScreen.swift
//  AKTV
//
//  Created by Alexander Kvamme on 25/03/2020.
//  Copyright © 2020 Alexander Kvamme. All rights reserved.
//

import Foundation
import UIKit

// This is where the app starts

protocol DetailedShowPresenter {
    func displayShow(_ id: Int?)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        apiDao.trytestMappingBBT()
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
            make.top.left.right.equalToSuperview()
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

extension ShowsSearchScreen: DetailedShowPresenter {
    
    func displayShow(_ id: Int?) {
        guard let id = id else { fatalError("Show had no id to present from") }
        
        print("bam success would show show ", id)
        
        let show = apiDao.testGettingAllSeasonsOverview(showId: 1418)
        let next = DetailedShowScreen()
        present(next, animated: false, completion: nil)
        
        // Update

        
    }
}

// MARK: - Make self textview delegate

extension ShowsSearchScreen: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let searchterm = textField.text else {
            return false
        }
        
        let shows = apiDao.searchShows(string: searchterm) { (shows) in
            print("bam finnaly returned som shows that i can use!")
            DispatchQueue.main.async {
                self.episodesSearchResultDataDelegate.shows = shows
                self.episodesSearchResultViewController.tableView.reloadData()
            }
        }
        
        return true
    }
}

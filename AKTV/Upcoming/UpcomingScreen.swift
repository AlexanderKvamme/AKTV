//
//  UpcomingScreen.swift
//  AKTV
//
//  Created by Alexander Kvamme on 27/04/2020.
//  Copyright © 2020 Alexander Kvamme. All rights reserved.
//

import UIKit

final class UpcomingScreen: UIViewController {
    
    // MARK: Properties
    
    let tableViewController = UITableView()
    let dataDelegate = UpcomingShowsDataDelegate()
    let header = UpcomingTableHeader()
    
    // MARK: Initializers
    
    init() {
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
        tableViewController.backgroundColor = .purple
        tableViewController.dataSource = dataDelegate
        tableViewController.delegate = dataDelegate
        header.frame = CGRect(x: 0, y: 0, width: 300, height: 100)
        tableViewController.tableHeaderView = header
    }
    
    private func addSubviewsAndConstraints() {
        view.addSubview(tableViewController)
        tableViewController.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: Helper methods
    
    // MARK: Internal methods
    
    func update(withShows shows: [ShowOverview]) {
        dataDelegate.update(withShows: shows)
    }
    
    func update(withShow show: ShowOverview) {
        dataDelegate.update(withShow: show)
        // FIXME: emove this later
        tableViewController.reloadData()
    }
}

//
//  ViewController.swift
//  AKTV
//
//  Created by Alexander Kvamme on 22/03/2020.
//  Copyright © 2020 Alexander Kvamme. All rights reserved.
//

import UIKit
//import SnapKit

// Temporarily the initial viewController

class ViewController: UIViewController {

    // MARK: Properties
    
    private let searchTextField = UITextField()
    private let tableView = UITableViewController()
    
    // MARK: Internal methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let dao = APIDAO()
//        let westworldId = "63247"
//        let season = "3"
//        dao.episodes(showId: westworldId, seasonNumber: season)

//        let res = dao.searchTVSeries(string: "Big bang theory")
    
        view.backgroundColor = .red
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("bam tryna present")
        let dao = APIDAO()
        let showSearchController = ShowSearchScreen(dao: dao)
        present(showSearchController, animated: true, completion: nil)
        
//        let slc = SeriesListScreen(dao: dao)
//        present(slc, animated: true, completion: nil)
    }
}


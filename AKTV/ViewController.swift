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
    
        view.backgroundColor = .red
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let dao = APIDAO()
        let showSearchController = ShowsSearchScreen(dao: dao)
        present(showSearchController, animated: true, completion: nil)
    }
}


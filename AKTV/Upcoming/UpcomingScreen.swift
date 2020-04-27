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
    
    let tableViewController = UITableViewController()
    let dataDelegate = UpcomingShowsDataDelegate()
    
    // MARK: Initializers
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        print("bam did init UpcomingScreen")
        
        view.backgroundColor = .green
        setup()
        addSubviewsAndConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Private methods
    
    private func setup() {
        
    }
    
    private func addSubviewsAndConstraints() {
        
    }
    // MARK: Helper methods
    
    // MARK: Internal methods
    
}

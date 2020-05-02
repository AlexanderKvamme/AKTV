//
//  TabBarController.swift
//  AKTV
//
//  Created by Alexander Kvamme on 01/05/2020.
//  Copyright © 2020 Alexander Kvamme. All rights reserved.
//

import UIKit

final class TabBarController: UITabBarController {
    
    // MARK: Properties
    
    // MARK: Initializers
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Private methods

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let upcomingScreen = UpcomingScreen()
        upcomingScreen.title = "One"
        upcomingScreen.tabBarItem.image = UIImage(systemName: "paperplane.fill", withConfiguration: .none)
        
        // Fetch favourite shows and show next episode dates
        let dao = APIDAO()
        let favouriteShows = UserProfileManager().favouriteShows()
        print("bam all favourite shows: ", favouriteShows)
        favouriteShows.forEach{ id in
            
            dao.show(withId: id) { (showOverview) in
                DispatchQueue.main.sync {
                upcomingScreen.update(withShow: showOverview)
                }
            }
        }
        
        let searchController = ViewController()
        searchController.title = "Two"
        searchController.tabBarItem.image = UIImage(systemName: "bell", withConfiguration: .none)
        //        let dao = APIDAO()
        //        let favouriteShows = UserProfileManager().favouriteShows()
        //        favouriteShows.forEach{ id in
        //            dao.show(withId: id) { (showOverview) in
        //                upcomingScreen.update(withShow: showOverview)
        //            }
        //        }
        
        setViewControllers([upcomingScreen, searchController], animated: true)
    
    }
    
    // MARK: Helper methods
    
    // MARK: Internal methods
    
}

extension TabBarController: UITabBarControllerDelegate {
    
}

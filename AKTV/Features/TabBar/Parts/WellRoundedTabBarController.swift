//
//  WellRoundedTabBarController.swift
//  AKTV
//
//  Created by Alexander Kvamme on 10/02/2021.
//  Copyright © 2021 Alexander Kvamme. All rights reserved.
//

import UIKit
import SwiftUI


class WellRoundedTabBarController: UITabBarController, UITabBarControllerDelegate, CustomTabBarDelegate {

    // MARK: - Properties

    let myTabBar = TabBarView(frame: CGRect(x: 0, y: screenHeight - TabBarSettings.barHeight, width: screenWidth, height: screenHeight))
    let discoveryScreen = DiscoveryScreen()
    let favouritesScreen = SUFavouritesScreen()
    let upcomingScreen = UpcomingScreen()
    var calendarScreen: CalendarScreen!
    var screens: [UIViewController]!
    var initialIndex: Int
    
    // MARK: - Initializers

    init(initalIndex: Int = 0) {
        self.initialIndex = initalIndex
        super.init(nibName: nil, bundle: nil)

        calendarScreen = CalendarScreen(tabBar: self)

        tabBar.isHidden = true
        discoveryScreen.customTabBarDelegate = self
        upcomingScreen.customTabBarDelegate = self

        let subVC = myTabBar
        view.addSubview(subVC)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life Cycle

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let dao = APIDAO()

        // Fetch favourite shows and show next episode dates
        let favouriteShows = UserProfileManager().favouriteShows()
        favouriteShows.forEach{ id in
            dao.showOverview(withId: id) { (showOverview) in
                DispatchQueue.main.sync {
                    self.upcomingScreen.update(withShow: showOverview)
                }
            }
        }

        // Fetch favourite shows and show next episode dates
        let favouriteGames = UserProfileManager().favouriteGames()
        // TODO: Maybe transition to using UInt64 for all ID's, as IGDB uses it
        favouriteGames.forEach{ id in
            dao.game(withId: UInt64(id)) { (gameOverview) in
                DispatchQueue.main.sync {
                    // FIXME: Continue here
                    // upcomingGamesScreen.update(withGame: gameOverview)
                }
            }
        }

        let searchTabScreen = MinimalNavigationController(rootViewController: MediaTypePickerScreen())
        let favouritesScreen = UIHostingController(rootView: SUFavouritesScreen())

        screens = [calendarScreen, discoveryScreen, searchTabScreen, TestViewController(), favouritesScreen]
        setViewControllers(screens, animated: true)

        // Initial View Controller
        selectedIndex = initialIndex
        configureTabBarButtons()
    }

    func configureTabBarButtons() {
        let controllers = [myTabBar.button1, myTabBar.button2, myTabBar.plusButton, myTabBar.button3, myTabBar.button4]
        for (index, button) in controllers.enumerated() {
            button.tag = index
            button.addTarget(self, action: #selector(setTab), for: .touchUpInside)
        }
    }

    /// Uses button's tag to decide which index the button had
    @objc func setTab(sender: UIButton) {
        selectedIndex = sender.tag
    }

    func hideIt() {
        myTabBar.alpha = 0
        myTabBar.plusButton.isUserInteractionEnabled = false
    }

    func showIt(){
        myTabBar.alpha = 1
        myTabBar.plusButton.isUserInteractionEnabled = true
    }
}


protocol CustomTabBarDelegate: class {
    func hideIt()
    func showIt()
}



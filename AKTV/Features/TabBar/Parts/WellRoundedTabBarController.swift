//
//  WellRoundedTabBarController.swift
//  AKTV
//
//  Created by Alexander Kvamme on 10/02/2021.
//  Copyright © 2021 Alexander Kvamme. All rights reserved.
//

import UIKit


class WellRoundedTabBarController: UITabBarController, UITabBarControllerDelegate, CustomTabBarDelegate {

    // MARK: - Properties

    let myTabBar = TabBarView(frame: CGRect(x: 0, y: screenHeight - TabBarSettings.barHeight, width: screenWidth, height: screenHeight))
    let upcomingGamesScreen = UpcomingGamesScreen()
    
    // MARK: - Initializers

    init() {
        super.init(nibName: nil, bundle: nil)

        tabBar.isHidden = true
        print("setting delegate")
        upcomingGamesScreen.customTabBarDelegate = self

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
        let showSearchController = ShowsSearchScreen(dao: dao)
        let upcomingScreen = UpcomingScreen()

        // Fetch favourite shows and show next episode dates
        let favouriteShows = UserProfileManager().favouriteShows()
        favouriteShows.forEach{ id in
            dao.show(withId: id) { (showOverview) in
                DispatchQueue.main.sync {
                upcomingScreen.update(withShow: showOverview)
                }
            }
        }

        // Fetch favourite shows and show next episode dates
        let favouriteGames = UserProfileManager().favouriteGames()
        favouriteGames.forEach{ id in
            dao.game(withId: id) { (gameOverview) in
                DispatchQueue.main.sync {
                    // FIXME: Continue here
                    // upcomingGamesScreen.update(withGame: gameOverview)
                }
            }
        }

        setViewControllers([upcomingGamesScreen, upcomingScreen, showSearchController, ColoredViewController(color: .cyan), ColoredViewController(color: .red)], animated: true)

        selectedIndex = 0
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
        print("would hide")
        myTabBar.alpha = 0
    }

    func showIt(){
        print("would show")
    }
}


protocol CustomTabBarDelegate: class {
    func hideIt()
    func showIt()
}



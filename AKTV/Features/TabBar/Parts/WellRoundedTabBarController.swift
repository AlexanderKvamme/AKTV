import UIKit
import SwiftUI
import IGDB_SWIFT_API

class WellRoundedTabBarController: UITabBarController, UITabBarControllerDelegate, CustomTabBarDelegate {

    // MARK: - Properties

    let disabledTabs = [1,3]
    let myTabBar = TabBarView(frame: CGRect(x: 0, y: screenHeight - TabBarSettings.barHeight, width: screenWidth, height: screenHeight))
    let discoveryScreen = DiscoveryScreen()
    let upcomingScreen = UpcomingScreen()
    var screens: [UIViewController]!
    var initialIndex: Int
    
    // MARK: - Initializers

    init(initalIndex: Int = 4) {
        self.initialIndex = initalIndex
        super.init(nibName: nil, bundle: nil)

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

        let searchTabScreen = MinimalNavigationController(rootViewController: MediaTypePickerScreen(header: "What are you looking for?", subheader: "Pick a media type"))
        let calendarScreen = MinimalNavigationController(rootViewController: CalendarScreen(tabBar: self))
        let favouritesScreen = MinimalNavigationController(rootViewController: MediaTypePickerScreen(header: "Favourite lists", subheader: "Pick a media type", onCompletion: {  mediaPickable in
            
            var next: UIViewController!
            switch mediaPickable {
            case MediaPickable.tvShow:
                next = UIKitFavouriteScreen<Show>()
            case MediaPickable.movie:
                next = UIKitFavouriteScreen<Movie>()
            case MediaPickable.game:
                next = UIKitFavouriteScreen<Proto_Game>()
            default:
                assertionFailure("Must pick a type")
            }
            next.sheetPresentationController?.preferredCornerRadius = 40
            self.present(next, animated: true, completion: nil)
        }))
        
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
        guard !disabledTabs.contains(sender.tag) else { return }
        selectedIndex = sender.tag
        tapAnimation(for: sender.tag)
    }
    
    private func tapAnimation(for buttonTag: Int) {
        let buttons = [myTabBar.button1, myTabBar.button2, myTabBar.plusButton, myTabBar.button3, myTabBar.button4]
        let scale: Double = 1.2
        let duration: Double = 0.2
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut) {
            buttons[buttonTag].transform = CGAffineTransform(scaleX: scale, y: scale)
        } completion: { bool in
            UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut) {
                buttons[buttonTag].transform = .identity
            }
        }
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


protocol CustomTabBarDelegate: AnyObject {
    func hideIt()
    func showIt()
}



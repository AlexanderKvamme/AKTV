//
//  SceneDelegate.swift
//  AKTV
//
//  Created by Alexander Kvamme on 22/03/2020.
//  Copyright © 2020 Alexander Kvamme. All rights reserved.
//

import UIKit
var gamesService: GameService!

let tabBarController = WellRoundedTabBarController(initalIndex: 0)

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        // TODO: REMOVE AFTER TESTING
//        GameStore.deleteAllEntries(platform: GamePlatform.NintendoSwitch)
//        GameStore.deleteAllFavourites()
        
        // Authenticate

        GameService.authenticate { (authToken) in
            gamesService = GameService(authToken)

            GameService.getCurrentHighestID(GamePlatform.NintendoSwitch) { highestRemoteGameID in
                // Get initial Swipeables
                let testPlatform = GamePlatform.NintendoSwitch
                let initialRange = GameStore.getNextRange(for: testPlatform, highestRemoteID: highestRemoteGameID)

                GameService.fetchGames(initialRange, testPlatform) { games in
                    DispatchQueue.main.sync {
                        tabBarController.discoveryScreen.update(with: games, range: initialRange, platform: testPlatform, initialHighestRemoteID: highestRemoteGameID)
                    }
                }
                
                // TODO: Clean up
                // TODO: Test getting favourite games
//                let ids = GameStore.getFavourites(.NintendoSwitch)
                let ids = [111, 222, 333]
                
                GameService.testFetchGames(IDs: ids, completion: { (games) in
                    print("successfully fetched games: ", games.map({$0.firstReleaseDate.date}))
                })
            }
        }

        self.window?.rootViewController = tabBarController
        self.window?.makeKeyAndVisible()
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
}



// Link: https://gist.github.com/proxpero/0cee32a53b94c37e1e92
func combinedIntervals(intervals: [CountableClosedRange<Int>]) -> [CountableClosedRange<Int>] {

    var combined = [CountableClosedRange<Int>]()
    var accumulator = (0...0) // empty range

    for interval in intervals.sorted(by: { $0.lowerBound  < $1.lowerBound  } ) {

        if accumulator == (0...0) {
            accumulator = interval
        }

        if accumulator.upperBound >= interval.upperBound {
            // interval is already inside accumulator
        }

        else if accumulator.upperBound >= interval.lowerBound  {
            // interval hangs off the back end of accumulator
            accumulator = (accumulator.lowerBound...interval.upperBound)
        }

        else if accumulator.upperBound <= interval.lowerBound  {
            // interval does not overlap
            combined.append(accumulator)
            accumulator = interval
        }
    }

    if accumulator != (0...0) {
        combined.append(accumulator)
    }

    return combined
}

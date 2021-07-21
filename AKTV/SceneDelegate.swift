//
//  SceneDelegate.swift
//  AKTV
//
//  Created by Alexander Kvamme on 22/03/2020.
//  Copyright © 2020 Alexander Kvamme. All rights reserved.
//

import UIKit
var gamesService: GameService!

let tabBarController = WellRoundedTabBarController()

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        //        RangeExperiments().testExample()
        //        return

        // Authenticate
        GameService.authenticate { (authToken) in
            gamesService = GameService(authToken)

            // Get initial Swipeables
            let testPlatform = GamePlatform.NintendoSwitch
            let initialRange = GameStore.getNextRange(for: testPlatform)

            GameService.fetchGames(initialRange, testPlatform) { games in
                print("bam succesfully got some games: ", games)
                DispatchQueue.main.sync {
                    tabBarController.discoveryScreen.update(with: games)
                }
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






class RangeExperiments: UIViewController {

    // MARK: Properties

    // MARK: Methods

    func testExample() {
        let platform = GamePlatform.PlayStation5

        // TODO: REMOVE THIS
        GameStore.deleteAllEntries(platform: platform)

        let noExistingRanges = GameStore.getCompleted(for: platform)
        print("bam should be nil: ", noExistingRanges)

        // Set ranges
        let mockRanges = testMerge()
        GameStore.setCompleted(ranges: mockRanges, for: platform)

        // Get ranges
        let rangesAfterSet = GameStore.getCompleted(for: platform)
        print("bam should have some ranges: ", rangesAfterSet)

        // Fetch and check highest ID
        let remoteHighestID = fetchHighestAvaiableID()
        print("bam remote highest ID: ", remoteHighestID)
        let next10IDs = GameStore.getRangeToFetch(remoteMax: remoteHighestID, platform: platform)
        print("bam next 10 IDs: ", next10IDs)

        // User receives for example 5 cards, swipes

        // Swipe a few cards
        let swipedCards = GameRange(upper: 999, lower: 990)
//        GameStore.setDiscoveredGameRange(gameRange, platform: platform)
    }

    @discardableResult func testMerge() -> [IDRange] {
        let r1: IDRange = 211...244
        let r2: IDRange = 255...279
        let r3: IDRange = 260...300

        let mergedRanges = mergeRanges([r1,r2,r3])
        print("mergedRange works: ", mergedRanges)
        return mergedRanges
    }

    //    @discardableResult func testGetNextRange(max: Int) -> IDRange {
    //        print("max: ", max)
    //
    //    }

    // Helpers

    func mergeRanges(_ ranges: [IDRange]) -> [IDRange] {
        return combinedIntervals(intervals: ranges)
    }

    func fetchHighestAvaiableID() -> Int {
        return 999
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

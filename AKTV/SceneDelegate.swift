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

        RangeExperiments().testExample()

        return
        // Make initial view controller
        tabBarController.selectedIndex = 1

        GameService.authenticate { (authToken) in
            gamesService = GameService(authToken)
            gamesService.testGettingSomeGames { (games) in
                print("token: ", authToken)
                print("token a: ", authToken.accessToken)
                DispatchQueue.main.async {
                    tabBarController.discoveryScreen.update(with: games)
                }
            }
        }

        self.window?.rootViewController = tabBarController
        self.window?.makeKeyAndVisible()
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
}




typealias IDRange = CountableClosedRange<Int>

class RangeStore {

    static let userDefault = UserDefaults.standard

    private static func makeKey(_ platform: GamePlatform) -> String {
        "completed-ranges-\(platform.rawValue)"
    }

    /// Used to convert ranges to custom array with 2 numbers
    /// [[Int]] can be saved to userDefaults while ranges cant
    static func arrayifyRanges( _ ranges: [IDRange]) -> [[Int]] {
        ranges.map { range in [range.lowerBound, range.upperBound]}
    }

    static func rangifyArrays( _ arrays: [[Int]]) -> [IDRange] {
        arrays.map { array in array[0]...array[1]}
    }

    static func setCompleted(ranges: [IDRange], for platform: GamePlatform) {
        let arrayified = arrayifyRanges(ranges)
        userDefault.set(arrayified, forKey: makeKey(platform))
    }

    static func getCompleted(for platform: GamePlatform) -> [IDRange] {
        guard let data = userDefault.object(forKey: makeKey(platform)) as? [[Int]] else {
            return []
        }

        let rangified = rangifyArrays(data)
        return rangified
    }

    static func deleteAllEntries(platform: GamePlatform) {
        userDefault.removeObject(forKey: makeKey(platform))
    }
}

class RangeExperiments: UIViewController {

    // MARK: Properties



    // MARK: Methods

    func testExample() {
        let platform = GamePlatform.PlayStation5

        // TODO: REMOVE THIS
        RangeStore.deleteAllEntries(platform: platform)

        let noExistingRanges = RangeStore.getCompleted(for: platform)
        print("bam should be nil: ", noExistingRanges)

        // Set ranges
        let mockRanges = testMerge()
        RangeStore.setCompleted(ranges: mockRanges, for: platform)

        // Get ranges
        let rangesAfterSet = RangeStore.getCompleted(for: platform)
        print("bam should have some ranges: ", rangesAfterSet)
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

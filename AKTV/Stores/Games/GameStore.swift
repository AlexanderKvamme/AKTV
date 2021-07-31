//
//  File.swift
//  AKTV
//
//  Created by Alexander Kvamme on 12/06/2021.
//  Copyright © 2021 Alexander Kvamme. All rights reserved.
//

import Foundation
import UIKit
import IGDB_SWIFT_API


typealias IDRange = CountableClosedRange<Int>


struct GameRange {
    let upper: Int
    let lower: Int
}


enum DiscoveryLimitType: String {
    case upper = "upper"
    case lower = "lower"
}


final class GameStore {

    // MARK: - Properties

    static let userDefaults = UserDefaults.standard

    // MARK: - Methods
    
    static func deleteAllFavourites() {
        print("deleteAllFavourites()")
        GamePlatform.allCases.forEach({ setFavourites([], platform: $0)})
    }
    
//    static func addFavourite(_ game: Proto_Game, _ isFavourite: Bool, platform: GamePlatform) {
//        let id = Int(game.id)
//        print("Adding to fav: ", game)
//        var existingFavs = getFavourites(platform)
//        if !existingFavs.contains(id) {
//            existingFavs.append(id)
//        }
//
//        setFavourites(existingFavs, platform: platform)
//    }
    
    static func setFavourite(_ game: Proto_Game, _ isFavourite: Bool, platform: GamePlatform) {
        let id = Int(game.id)
        var existingFavs = getFavourites(platform)
        print("Adding \(game.name) to fav: \(isFavourite)")
        
        switch isFavourite {
        case true:
            if !existingFavs.contains(id) {
                existingFavs.append(id)
            }
        case false:
            existingFavs = existingFavs.filter({ $0 != game.id})
        }
        
        setFavourites(existingFavs, platform: platform)
    }
    
    static func getFavourites(_ platform: GamePlatform) -> [Int] {
        let res = userDefaults.object(forKey: makeFavouriteKey(platform: platform)) as? [Int] ?? []
        return res
    }
    
    static func setFavourites(_ gameIds: [Int], platform: GamePlatform) {
        userDefaults.set(gameIds, forKey: makeFavouriteKey(platform: platform))
    }
    
    // MARK: - Private methods

    private static func makeLimitKey(_ type: DiscoveryLimitType, platform: GamePlatform) -> String {
        return "limit-\(type.rawValue)-\(platform.rawValue)"
    }
    
    private static func makeFavouriteKey(platform: GamePlatform) -> String {
        return "favourite-game-\(platform.rawValue)"
    }
    

    static func getNextRange(for platform: GamePlatform, highestRemoteID: Int) -> GameRange {
        let existingRanges = getCompletedRanges(for: platform)
        let remoteTop = highestRemoteID

        if existingRanges.isEmpty {
            return GameRange(upper: remoteTop, lower: 0)
        }

        // TODO: Sort when storing the ranges
        let highestLocalRange = existingRanges.max { r1, r2 in
            return r1.upperBound > r2.upperBound
        }

        guard let localTop = highestLocalRange else {
            print("Had no local top. returning remoteTop to 0")
            return GameRange(upper: remoteTop, lower: 0)
        }

        if (remoteTop > localTop.upperBound) {
            print("remoteTop was greater than localTop")
            return GameRange(upper: remoteTop, lower: localTop.upperBound)
        }

        if (localTop.upperBound > highestRemoteID) {
            return GameRange(upper: highestRemoteID, lower: localTop.upperBound)
        }

        // 1. [x]  get local-top range
        // 2. [x] if remote is greater than top-local, use top-remote...top-local
        // 3. [x] if remote is lesser, something is wrong
        // 4. [x] if remote is equal, get first gap

        if localTop.upperBound == highestRemoteID {
            print("No new unswiped releases. Find first gap and get busy")
        } else {
            fatalError("This should not happen")
        }

        // Remote and local top are equal

        if existingRanges.count == 1 {
            // These is only one count
            let lastRange = existingRanges.first!
            let isEverythingSwiped = lastRange.lowerBound == 0

            if isEverythingSwiped {
                print("Everything is swiped. Show some card indicating this")
            } else {
                let nextRange = GameRange(upper: lastRange.lowerBound, lower: 0)
                return nextRange
            }
        }

        let l = existingRanges[0]
        let r = existingRanges[1]

        let res = GameRange(upper: l.lowerBound, lower: r.upperBound)
        return res
    }

    static func getNextRangeAfterSwipe(for platform: GamePlatform, newRangeTop: Int) -> GameRange {
        let existingRanges = getCompletedRanges(for: platform)

        if existingRanges.isEmpty {
            return GameRange(upper: newRangeTop, lower: 0)
        }

        // TODO: Sort when storing the ranges
        let highestLocalRange = existingRanges.max { r1, r2 in
            return r1.upperBound > r2.upperBound
        }

        guard let localTop = highestLocalRange else {
            print("Had no local top. returning remoteTop to 0")
            return GameRange(upper: newRangeTop, lower: 0)
        }

        if (newRangeTop > localTop.upperBound) {
            print("remoteTop was greater than localTop")
            return GameRange(upper: newRangeTop, lower: localTop.upperBound)
        }

        print("Local top is greater than remote top. Something is wrong")
        return GameRange(upper: newRangeTop, lower: 0)
    }


    // MARK: - Helper Methods

    private static func makeKey(_ platform: GamePlatform) -> String {
        "completed-ranges-\(platform.rawValue)"
    }

    /// Used to convert ranges to custom array with 2 numbers
    /// [[Int]] can be saved to userDefaults while ranges cannot
    static func arrayifyRanges( _ ranges: [IDRange]) -> [[Int]] {
        ranges.map { range in [range.lowerBound, range.upperBound]}
    }

    static func rangifyArrays( _ arrays: [[Int]]) -> [IDRange] {
        arrays.map { array in array[0]...array[1]}
    }

    static private func setCompleted(ranges: [IDRange], for platform: GamePlatform) {
        let arrayified = arrayifyRanges(ranges)
        UserDefaults.standard.set(arrayified, forKey: makeKey(platform))
    }

    static func getCompletedRanges(for platform: GamePlatform) -> [IDRange] {
        guard
            let data = UserDefaults.standard.object(forKey: makeKey(platform)),
            let intified = data as? [[Int]] else {
                return []
            }
        let rangified = rangifyArrays(intified)
        return rangified
    }

    static func getRangeToFetch(remoteMax: Int, platform: GamePlatform) -> GameRange? {
        let allRanges = getCompletedRanges(for: platform)

        guard let existingUpperBound = allRanges.max(by: { a, b in
            a.upperBound < b.upperBound
        })?.upperBound else {
            return GameRange(upper: Int.max, lower: 0)
        }

        return GameRange(upper: remoteMax, lower: existingUpperBound)
    }

    static func deleteAllEntries(platform: GamePlatform) {
        UserDefaults.standard.removeObject(forKey: makeKey(platform))
    }

    static func addCompleted(_ range: GameRange, for platform: GamePlatform) {
        let newIDRange = range.lower...range.upper
        let existingRanges = getCompletedRanges(for: platform)

        if existingRanges.isEmpty {
            setCompleted(ranges: [newIDRange], for: platform)
        }

        var allRanges = existingRanges
        allRanges.append(newIDRange)

        let mergedRanges = mergeRanges(allRanges)

        setCompleted(ranges: mergedRanges, for: platform)
    }

    static func printStatus() {
//        print(getDiscoveredGameRange(platform: .NintendoSwitch, highestRemoteID: <#Int#>))
    }

    static func mergeRanges(_ ranges: [IDRange]) -> [IDRange] {
        return combinedIntervals(intervals: ranges)
    }

}



class RangeExperiments: UIViewController {

    // MARK: Properties

    // MARK: Methods

    func testExample() {
        let platform = GamePlatform.PlayStation5

        // TODO: REMOVE THIS
//        GameStore.deleteAllEntries(platform: platform)

        let noExistingRanges = GameStore.getCompletedRanges(for: platform)

        // Set ranges
        _ = testMerge()
//        GameStore.setCompleted(ranges: mockRanges, for: platform)

        // Get ranges
        let rangesAfterSet = GameStore.getCompletedRanges(for: platform)

        // Fetch and check highest ID
        let remoteHighestID = fetchHighestAvailableID()
        let next10IDs = GameStore.getRangeToFetch(remoteMax: remoteHighestID, platform: platform)

        // User receives for example 5 cards, swipes

        // Swipe a few cards
        _ = GameRange(upper: 999, lower: 990)
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

    func fetchHighestAvailableID() -> Int {
        // TODO: THIS SHOULD BE A FETCH TO REMOTE
        // - GET HIGHEST CURRENT ID
        return Int.max
    }

}

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

    private static func makeLimitKey(_ type: DiscoveryLimitType, platform: GamePlatform) -> String {
        return "limit-\(type.rawValue)-\(platform.rawValue)"
    }

    static func setDiscoveredGameRange(_ limit: GameRange, platform: GamePlatform) {
        userDefaults.set(limit.upper, forKey: makeLimitKey(.upper, platform: platform))
        userDefaults.set(limit.lower, forKey: makeLimitKey(.lower, platform: platform))
    }

    static func getNextRange(for platform: GamePlatform, highestRemoteID: Int) -> GameRange {
        let allRanges = getCompletedRanges(for: platform)
        print("bam getNextRange...")
        print("bam allRanges: ", allRanges)

        if allRanges.isEmpty {
            // Use full range to get started
            print("bam allRanges was empty. Returning ", GameRange(upper: highestRemoteID, lower: 0))
            return GameRange(upper: highestRemoteID, lower: 0)
        }

        // TODO: Sort when storing the ranges

        let localTop = allRanges.max { r1, r2 in
            return r1.upperBound > r2.upperBound
        }

        guard let localTop = localTop else {
            print("bam had no local top. returning remote top -> 0")
            return GameRange(upper: highestRemoteID, lower: 0)
        }

        print("bam localTop: ", localTop)

        // Ny

        // FIXME: Den kommer ned her,
        // FIXME: GJør at den returnerer en ekte range

        // return GameRange(upper: 111, lower: 11)

        if (highestRemoteID > localTop.upperBound) {
            return GameRange(upper: highestRemoteID, lower: localTop.upperBound)
        }

        if (localTop.upperBound > highestRemoteID) {
            print("bam Local top is greater than remote top. Something is wrong")
            GameRange(upper: highestRemoteID, lower: localTop.upperBound)
        }

        // 1. [x]  get local-top range
        // 2. [x] if remote is greater than top-local, use top-remote...top-local
        // 3. [x] if remote is lesser, something is wrong
        // 4. [ ] if remote is equal, get first gap

        print("--- bam getNextRange ---")

        if localTop.upperBound == highestRemoteID {
            print("No new unswiped releases. Find first gap and get busy")
        } else {
            fatalError("This should not happen")
        }

        // Remote and local top are equal

        if allRanges.count == 1 {
            // These is only one count
            let lastRange = allRanges.first!
            let isEverythingSwiped = lastRange.lowerBound == 0

            if isEverythingSwiped {
                print("Everything is swiped. Show some card indicating this")
            } else {
                let nextRange = GameRange(upper: lastRange.lowerBound, lower: 0)
                print("bam returning range: ", nextRange)
                return nextRange
            }
        }

        // FIXME: DONOW: Return the first gap
        print("bam would get first gap from: ", allRanges)

        let l = allRanges[0]
        let r = allRanges[1]

        let res = GameRange(upper: l.lowerBound, lower: r.upperBound)
        print("bam res was this range: ", res)
        return res
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
        print("BAM setCompleted: \(ranges) for \(platform)")
        let arrayified = arrayifyRanges(ranges)
        print("bam arrayified values to set: ", arrayified)
        UserDefaults.standard.set(arrayified, forKey: makeKey(platform))
    }

    static func getCompletedRanges(for platform: GamePlatform) -> [IDRange] {
        print("bam making this key: ", makeKey(platform))
        guard
            let data = UserDefaults.standard.object(forKey: makeKey(platform)),
            let intified = data as? [[Int]] else {
                print("bam had data but could not intify")
                print("bam data: ", UserDefaults.standard.object(forKey: makeKey(platform)))
                return []
            }

        print("bam getCompletedRanges data: ", intified)
        let rangified = rangifyArrays(intified)
        return rangified
    }

    static func getRangeToFetch(remoteMax: Int, platform: GamePlatform) -> GameRange? {
        let allRanges = getCompletedRanges(for: platform)
        print("bam all Ranges: ", allRanges)

        guard let existingUpperBound = allRanges.max(by: { a, b in
            a.upperBound < b.upperBound
        })?.upperBound else {
            print("bam had no stored max. returning greatest...0")
            return GameRange(upper: Int.max, lower: 0)
        }

        print("bam existing max was: ", existingUpperBound)
        return GameRange(upper: remoteMax, lower: existingUpperBound)
    }

    static func deleteAllEntries(platform: GamePlatform) {
        UserDefaults.standard.removeObject(forKey: makeKey(platform))
    }

    static func addCompleted(_ range: GameRange, for platform: GamePlatform) {
        print("bam addCompleted \(range) to \(Self.getCompletedRanges(for: platform))")

        let newIDRange = range.lower...range.upper
        let existingRanges = getCompletedRanges(for: platform)

        if existingRanges.isEmpty {
            setCompleted(ranges: [newIDRange], for: platform)
        }

        var allRanges = existingRanges
        allRanges.append(newIDRange)

        let mergedRanges = mergeRanges(allRanges)
        setCompleted(ranges: mergedRanges, for: platform)
        print("bam after range merge: ", mergedRanges)
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
        GameStore.deleteAllEntries(platform: platform)

        let noExistingRanges = GameStore.getCompletedRanges(for: platform)
        print("bam should be nil: ", noExistingRanges)

        // Set ranges
        _ = testMerge()
//        GameStore.setCompleted(ranges: mockRanges, for: platform)

        // Get ranges
        let rangesAfterSet = GameStore.getCompletedRanges(for: platform)
        print("bam should have some ranges: ", rangesAfterSet)

        // Fetch and check highest ID
        let remoteHighestID = fetchHighestAvailableID()
        print("bam remote highest ID: ", remoteHighestID)
        let next10IDs = GameStore.getRangeToFetch(remoteMax: remoteHighestID, platform: platform)
        print("bam next 10 IDs: ", next10IDs)

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

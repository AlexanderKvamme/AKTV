//
//  File.swift
//  AKTV
//
//  Created by Alexander Kvamme on 12/06/2021.
//  Copyright © 2021 Alexander Kvamme. All rights reserved.
//

import Foundation
import UIKit

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

    static func getDiscoveredGameRange(platform: GamePlatform) -> GameRange {
        var upper = userDefaults.integer(forKey: makeLimitKey(.upper, platform: platform))
        if upper == 0 {
            upper = 999999
        }

        let lower = userDefaults.integer(forKey: makeLimitKey(.lower, platform: platform))
        return GameRange(upper: upper, lower: lower)
    }

    // MARK: - Helper Methods

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
        UserDefaults.standard.set(arrayified, forKey: makeKey(platform))
    }

    static func getCompleted(for platform: GamePlatform) -> [IDRange] {
        guard let data = UserDefaults.standard.object(forKey: makeKey(platform)) as? [[Int]] else {
            return []
        }

        let rangified = rangifyArrays(data)
        return rangified
    }

    static func getRangeToFetch(remoteMax: Int, platform: GamePlatform) -> GameRange? {
        print("bam --- getRangeToFetch")
        let allRanges = getCompleted(for: platform)
        print("bam all Ranges: ", allRanges)
        guard let existingUpperBound = allRanges.max { a, b in
            a.upperBound < b.upperBound
        }?.upperBound else {
            print("bam had no stored max. returning greatest...0")
            return GameRange(upper: Int.max, lower: 0)
        }

        print("bam existing max was: ", existingUpperBound)
        return GameRange(upper: remoteMax, lower: existingUpperBound)
    }

    static func deleteAllEntries(platform: GamePlatform) {
        UserDefaults.standard.removeObject(forKey: makeKey(platform))
    }

}

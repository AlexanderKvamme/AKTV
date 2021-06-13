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

    func makeLimitKey(_ type: DiscoveryLimitType, platform: GamePlatform) -> String {
        return "limit-\(type.rawValue)-\(platform.rawValue)"
    }

    func setDiscoveredGameRange(_ limit: GameRange, platform: GamePlatform) {
        let defaults = UserDefaults.standard
        defaults.set(limit.upper, forKey: makeLimitKey(.upper, platform: platform))
        defaults.set(limit.lower, forKey: makeLimitKey(.lower, platform: platform))
    }

    func getDiscoveredGameRange(platform: GamePlatform) -> GameRange {
        let defaults = UserDefaults.standard
        var upper = defaults.integer(forKey: makeLimitKey(.upper, platform: platform))
        if upper == 0 {
            upper = 999999
        }

        let lower = defaults.integer(forKey: makeLimitKey(.lower, platform: platform))
        return GameRange(upper: upper, lower: lower)
    }

    // MARK: - Initializers

    // MARK: - Methods


}

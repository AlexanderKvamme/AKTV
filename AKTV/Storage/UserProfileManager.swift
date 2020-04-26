//
//  UserProfileManager.swift
//  AKTV
//
//  Created by Alexander Kvamme on 26/04/2020.
//  Copyright © 2020 Alexander Kvamme. All rights reserved.
//

import Foundation

enum UserProfileKeys: String {
    case favouriteShows
}

final class UserProfileManager: NSObject {
    
    // MARK: Properties
    
    let defaults = UserDefaults.standard
    
    // MARK: Initializers
    
    // MARK: Private methods
    
    // MARK: Helper methods
    
    // MARK: Internal methods
    
    func favouriteShows() -> [Int] {
        let existingFavourites = defaults.object(forKey: UserProfileKeys.favouriteShows.rawValue) as? [Int] ?? [Int]()
        return existingFavourites
    }
    
    func setFavouriteShow(id: Int, favourite: Bool) {
        switch favourite {
        case true:
            var existingFavourites = defaults.object(forKey: UserProfileKeys.favouriteShows.rawValue) as? [Int] ?? [Int]()
            existingFavourites.append(id)
            defaults.set(existingFavourites, forKey: UserProfileKeys.favouriteShows.rawValue)
        case false:
            var existingFavourites = defaults.object(forKey: UserProfileKeys.favouriteShows.rawValue) as? [Int] ?? [Int]()
            if let i = existingFavourites.firstIndex(of: id) {
                existingFavourites.remove(at: i)
                defaults.set(existingFavourites, forKey: UserProfileKeys.favouriteShows.rawValue)
            }
        }
    }
}

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
    case favouriteGames
    case favouriteMovies
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
    
    func setFavourite(_ entity: Entity, favourite: Bool) {
        print("bam setting favourite: ", entity)
        switch entity.type {
        case .game:
            setFavouriteGame(id: Int(entity.id), favourite: favourite)
        case .tvShow:
            setFavouriteShow(id: Int(entity.id), favourite: favourite)
        case .movie:
            setFavouriteMovie(id: Int(entity.id), favourite: favourite)
        }
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

    // Favourite movies

    func favouriteMovies() -> [Int] {
        let existingFavourites = defaults.object(forKey: UserProfileKeys.favouriteMovies.rawValue) as? [Int] ?? [Int]()
        return existingFavourites
    }

    func setFavouriteMovie(id: Int, favourite: Bool) {
        switch favourite {
        case true:
            var existingFavourites = defaults.object(forKey: UserProfileKeys.favouriteMovies.rawValue) as? [Int] ?? [Int]()
            existingFavourites.append(id)
            defaults.set(existingFavourites, forKey: UserProfileKeys.favouriteMovies.rawValue)
        case false:
            var existingFavourites = defaults.object(forKey: UserProfileKeys.favouriteMovies.rawValue) as? [Int] ?? [Int]()
            if let i = existingFavourites.firstIndex(of: id) {
                existingFavourites.remove(at: i)
                defaults.set(existingFavourites, forKey: UserProfileKeys.favouriteMovies.rawValue)
            }
        }
    }

    // FIXME: GET REAL GAMES
    // FIXME: Tror disse hører hjemme i GameStore om de i det hele tatt skal brukes

    func favouriteGames() -> [Int] {
        let existingFavourites = defaults.object(forKey: UserProfileKeys.favouriteGames.rawValue) as? [Int] ?? [Int]()
        return existingFavourites
    }

    func setFavouriteGame(id: Int, favourite: Bool) {
        let key = UserProfileKeys.favouriteGames.rawValue
        switch favourite {
        case true:
            var existingFavourites = defaults.object(forKey: key) as? [Int] ?? [Int]()
            existingFavourites.append(id)
            defaults.set(existingFavourites, forKey: key)
        case false:
            var existingFavourites = defaults.object(forKey: key) as? [Int] ?? [Int]()
            if let i = existingFavourites.firstIndex(of: id) {
                existingFavourites.remove(at: i)
                defaults.set(existingFavourites, forKey: key)
            }
        }
    }
}

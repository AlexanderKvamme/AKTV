//
//  IGDBService.swift
//  AKTV
//
//  Created by Alexander Kvamme on 05/06/2021.
//  Copyright © 2021 Alexander Kvamme. All rights reserved.
//

import Foundation
import IGDB_SWIFT_API
import Kingfisher


class TwitchAuthResponse: Codable {
    let expiresIn: Int
    let accessToken: String
    let tokenType: String
}

enum GamePlatform: String, CaseIterable {
    case PlayStation5 = "167"
    case NintendoSwitch = "130"
    case tbd = "tbd" // Temp
}

final class GameService {

    static var authToken: TwitchAuthResponse?
    static let clientID = "6w71e2zsvf5ak18snvrtweybwjl877"
    static private let rootURL = "https://api.igdb.com/v4"

    private static let minimumRequiredFields = "name,cover,id,platforms"
    private static let MAX_GAMES_PER_REQUEST: Int32 = 50

    private static var coverUrls: [UInt64:String] = [:]
    
    // MARK: - Initializers

    init(_ authToken: TwitchAuthResponse) {
        print("IGDB accessToken: ", authToken.accessToken)
        print("IGDB clientId: ", Self.clientID)
        Self.authToken = authToken
    }

    // MARK: - Methods

    static func fetchCoverImageUrl(cover: Proto_Cover, completion: @escaping ((URL) -> ())) {
        // Look through cache
        let key = KeyGenerator.coverUrl(coverId: cover.id)
        if let url = URLCache.getUrl(forKey: key) {
            completion(url)
            return
        }

        guard let authToken = authToken else {
            print("Missing authToken")
            return
        }

        let wrapper = IGDBWrapper(clientID: GameService.clientID, accessToken: authToken.accessToken)
        let str = String(cover.id)
        let apicalypse = APICalypse()
            .fields(fields: "*")
            .where(query: "id = " + str)

        wrapper.covers(apiCalypse: apicalypse) { cover in
            guard let cover = cover.first else {
                print("Could not retrierve retrieve and cover with id: ", str)
                return
            }
            getCoverImageURL(cover: cover, completion: completion)
        } errorResponse: { reqException in
            print("reqEx: ", reqException)
        }
    }

    typealias Completion = (([Proto_Game]) -> ())

//    static func getCachedCoverUrl(_ coverId: UInt64) -> String? {
//        if let existing = coverUrls[coverId] {
//            return existing
//        } else {
//            return nil
//        }
//    }

    static func precache(_ items: [Proto_Game]) {
        for item in items {
            getCoverImageURL(cover: item.cover) { (coverUrl) in

                Self.coverUrls[item.cover.id] = coverUrl.absoluteString
                let url = URL(string: coverUrl.absoluteString)!
                let resource = ImageResource(downloadURL: url)

                KingfisherManager.shared.retrieveImage(with: resource) { res in }
            }
        }
    }

    static func getCover(forGame game: Proto_Game, completion: @escaping ((Proto_Cover) -> ())) {
        guard let authToken = authToken else {
            print("Missing authToken")
            return
        }

        let wrapper = IGDBWrapper(clientID: GameService.clientID, accessToken: authToken.accessToken)
        let str = String(game.cover.id)
        let apicalypse = APICalypse()
            .fields(fields: "*")
            .where(query: "id = " + str)

        wrapper.covers(apiCalypse: apicalypse) { cover in
            guard let cover = cover.first else {
                print("Could not retrierve retrieve and cover with id: ", str)
                return
            }
            completion(cover)
        } errorResponse: { reqException in
            print("reqEx: ", reqException)
        }
    }

    static func getCoverImageURL(forGame game: Proto_Game, completion: @escaping ((URL?) -> ())) {
        let key = KeyGenerator.coverUrl(gameId: game.id)
        if let url = URLCache.getUrl(forKey: key) {
            completion(url)
            return
        }

        let apicalypse = APICalypse()
            .fields(fields: "*")
            .limit(value: 1)
            .where(query: "game = \(game.id)")

        guard let authToken = authToken else {
            print("Missing authToken")
            return
        }

        let wrapper = IGDBWrapper(clientID: GameService.clientID, accessToken: authToken.accessToken)
        wrapper.covers(apiCalypse: apicalypse) { (cover) -> (Void) in
            guard let cover = cover.first else { return }

            let urlString = imageBuilder(imageID: cover.imageID, size: .COVER_BIG)
            if let url = URL(string: urlString) {
                // cache
                let key = KeyGenerator.coverUrl(gameId: game.id)
                URLCache.setUrl(forKey: key, to: urlString)

                completion(url)
                return
            }

            completion(nil)
        } errorResponse: { (requestException) -> (Void) in
            print(requestException)
        }
    }

    static func getCoverImageURL(cover: Proto_Cover, completion: @escaping ((URL) -> ())) {
        guard cover.imageID != "" else {
            print("Error: cover must have imageID to get Url to it")
            return
        }

        let coverURL = imageBuilder(imageID: String(cover.imageID), size: ImageSize.COVER_BIG)
        let key = KeyGenerator.coverUrl(coverId: cover.id)
        URLCache.setUrl(forKey: key, to: coverURL)
        let url = URL(string: coverURL)!
        completion(url)
    }

/**
 - User can only search for one playform at a time (for now)
 - Discoverable games are tracked via an upper and a lower range, so that both new and old games can be discovered
 - I can track that user has swiped from 1000-800, and at the same time that they have swiped from 0-50 and combine these in searches
    - Sort
 */

    private static func makePlatformRequirement(for platform: GamePlatform) -> String {
        return "platforms = " + platform.rawValue
    }

    private static func makeIdLimitRequirement(_ platform: GamePlatform, limit: GameRange) -> String {
        var query = ""
        query += "id > \(limit.lower)"
        query += " & id < \(limit.upper)"
        return query
    }
    
    private static func makeCoverRequirement() -> String {
        return "cover != null"
    }

    static func makeWhereQuery(platform: GamePlatform, range: GameRange) -> String {
        var query = "where "
        query += makePlatformRequirement(for: platform)
        query += " & "
        query += makeIdLimitRequirement(platform, limit: range)
        query += " & "
        query += makeCoverRequirement()
        query += ";"
        return query
    }

    typealias GamesCompletionHandler = (([Proto_Game]) -> ())


    static func fetchGame(currentLowestID: Int, _ platform: GamePlatform, completion: @escaping GamesCompletionHandler) {
        let range: GameRange = GameStore.getNextRangeAfterSwipe(for: platform, newRangeTop: currentLowestID-1)
        print("Range for next single game fetch: ", range)
        fetchGames(range, platform, amount: 1, completion: completion)
    }

    static func fetchGames(_ range: GameRange, _ platform: GamePlatform, amount: Int32 = 10, completion: @escaping GamesCompletionHandler) {
        let whereQuery = makeWhereQuery(platform: platform, range: range)

        let apicalypse = APICalypse()
            .fields(fields: minimumRequiredFields)
            .limit(value: amount)
            .where(query: whereQuery)
            .sort(field: "id", order: .DESCENDING)

        guard let authToken = authToken else {
            print("Missing authToken")
            return
        }

        let wrapper = IGDBWrapper(clientID: GameService.clientID, accessToken: authToken.accessToken)
        wrapper.games(apiCalypse: apicalypse) { (games) -> (Void) in
            completion(games)
        } errorResponse: { (requestException) -> (Void) in
            print(requestException)
        }
    }

    // MARK: - Static Methods

    static func getCurrentHighestID(_ platform: GamePlatform, completion: @escaping ((Int) -> ())) {
        let whereQuery = makeWhereQuery(platform: platform, range: GameRange(upper: Int.max, lower: 0))

        let apicalypse = APICalypse()
            .fields(fields: minimumRequiredFields)
            .limit(value: 3)
            .where(query: whereQuery)
            .sort(field: "id", order: .DESCENDING)
        
        guard let authToken = authToken else {
            print("Missing authToken")
            return
        }

        let wrapper = IGDBWrapper(clientID: GameService.clientID, accessToken: authToken.accessToken)
        wrapper.games(apiCalypse: apicalypse) { (games) -> (Void) in
            if let id = games.first?.id {
                completion(Int(id))
            }
        } errorResponse: { (requestException) -> (Void) in
            print(requestException)
        }
    }

    static func authenticate(completion: @escaping ((TwitchAuthResponse) -> Void)) {
        let authUrl = URL(string: "https://id.twitch.tv/oauth2/token?client_id=\(GameService.clientID)&client_secret=pyjnp1qwivqhskefv1vkqizeg6oge9&grant_type=client_credentials")
        var request = URLRequest(url: authUrl!)
        request.httpMethod = "POST"

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in

            guard let data = data else { return }
            do {

                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase

                guard let decodedToken = try? decoder.decode(TwitchAuthResponse.self, from: data) else {
                    fatalError()
                }

                print(decodedToken)
                completion(decodedToken)
            }
        }
        task.resume()
    }
}


class KeyGenerator {

    static func coverUrl(coverId: UInt64) -> String {
        "cover-url-for-cover-id-\(coverId)"
    }

    static func coverUrl(gameId: UInt64) -> String {
        "cover-url-for-game-id-\(gameId)"
    }

}

class URLCache {

    static func getUrl(forKey key: String) -> URL? {
        if let str = UserDefaults.standard.string(forKey: key) {
            return URL(string: str)
        }
        
        return nil
    }

    static func setUrl(forKey key: String, to url: String) {
        UserDefaults.standard.set(url, forKey: key)
    }

}

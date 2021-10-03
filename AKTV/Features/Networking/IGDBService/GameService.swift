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

    private static var coverUrls: [String:String] = [:]
    
    // MARK: - Initializers

    init(_ authToken: TwitchAuthResponse) {
        print("IGDB accessToken: ", authToken.accessToken)
        print("IGDB clientId: ", Self.clientID)
        Self.authToken = authToken
    }

    // MARK: - Methods

    static func testFetchCover(coverId: UInt64? = 161120, completion: @escaping ((Proto_Cover) -> ())) {
        guard let authToken = authToken else {
            print("Missing authToken")
            return
        }

        let wrapper = IGDBWrapper(clientID: GameService.clientID, accessToken: authToken.accessToken)
        let str = String(Int(coverId!))
        let apicalypse = APICalypse()
            .fields(fields: "*")
            .where(query: "id = " + str)

        wrapper.covers(apiCalypse: apicalypse) { covers in
            guard let firstCover = covers.first else {
                print("no covers fetched")
                return
            }
            completion(firstCover)
        } errorResponse: { reqException in
            print("reqEx: ", reqException)
        }
    }

    static func fetchCoverImageUrl(coverId id: UInt64, completion: @escaping ((String) -> ())) {
        guard let authToken = authToken else {
            print("Missing authToken")
            return
        }

        let wrapper = IGDBWrapper(clientID: GameService.clientID, accessToken: authToken.accessToken)
        let str = String(id)
        let apicalypse = APICalypse()
            .fields(fields: "*")
            .where(query: "id = " + str)

        wrapper.covers(apiCalypse: apicalypse) { cover in
            guard let cover = cover.first else { return }
            let imageId = cover.imageID
            getCoverImageURL(coverId: imageId, completion: completion)
        } errorResponse: { reqException in
            print("reqEx: ", reqException)
        }
    }

    typealias Completion = (([Proto_Game]) -> ())

    static func getCachedCoverUrl(_ coverId: UInt64) -> String? {
        if let existing = coverUrls[String(coverId)] {
            return existing
        } else {
            return nil
        }
    }
    
    static func precache(_ items: [Proto_Game]) {
        for item in items {
            let coverId = String(item.cover.id)
            getCoverImageURL(coverId: coverId) { (coverUrl) in
                Self.coverUrls[coverId] = coverUrl
                let url = URL(string: coverUrl)!
                let resource = ImageResource(downloadURL: url)

                KingfisherManager.shared.retrieveImage(with: resource) { res in }
            }
        }
    }

    static func getCoverImageURL(coverId: String, completion: @escaping ((String) -> ())) {
        guard let authToken = authToken else {
            print("Missing authToken")
            return
        }

        let wrapper = IGDBWrapper(clientID: GameService.clientID, accessToken: authToken.accessToken)
        let apicalypse = APICalypse()
            .fields(fields: "*")
            .where(query: "id = co3gbk;")

        let imageURL = imageBuilder(imageID: coverId, size: ImageSize.COVER_BIG)
        completion(imageURL)

        //            completion("https://images.igdb.com/igdb/image/upload/t_thumb/co3gbk.jpg")
//        wrapper.covers(apiCalypse: apicalypse) { (covers) -> (Void) in
//            guard let imageId = covers.first?.imageID else {
//                print("ERROR could not access cover url. Use default")
//                return
//            }
//
////            let imageURL = imageBuilder(imageID: imageId, size: ImageSize.COVER_BIG)
////            print("bam imageUrl: ", imageURL)
//            completion("https://images.igdb.com/igdb/image/upload/t_thumb/co3gbk.jpg")
//        } errorResponse: { (requestException) -> (Void) in
//            print("Error getting cover image: ", requestException)
//        }
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

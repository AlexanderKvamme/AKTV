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

enum GamePlatform: String {
    case PlayStation5 = "167"
    case NintendoSwitch = "130"
}

final class GameService {

    let authToken: TwitchAuthResponse
    static private let clientID = "6w71e2zsvf5ak18snvrtweybwjl877"
    static private let rootURL = "https://api.igdb.com/v4"

    // MARK: - Initializers

    init(_ authToken: TwitchAuthResponse) {
        self.authToken = authToken
    }

    // MARK: - Methods

    typealias Completion = (([Proto_Game]) -> ())

    func precache(_ items: [Proto_Game]) {
        for item in items {
            getCoverImage(coverId: String(item.cover.id)) { (str) in
                guard let str = str else { return }
                KingfisherManager.shared.downloader.downloadImage(with: URL(string: str)!)
            }
        }
    }

    func getCoverImage(coverId: String, completion: @escaping ((String?) -> ())) {
        let wrapper = IGDBWrapper(clientID: GameService.clientID, accessToken: authToken.accessToken)
        let apicalypse = APICalypse()
            .fields(fields: "*")
            .where(query: "id = \(coverId);")

        wrapper.covers(apiCalypse: apicalypse) { (covers) -> (Void) in
            guard let imageId = covers.first?.imageID else {
                print("ERROR could not access cover url. Use default")
                return
            }

            let imageURL = imageBuilder(imageID: imageId, size: ImageSize.COVER_BIG)
            completion(imageURL)
        } errorResponse: { (requestException) -> (Void) in
            print("Error getting cover image: ", requestException)
        }
    }

    private let minimumRequiredFields = "name,cover,id,platforms"
    private let MAX_GAMES_PER_REQUEST: Int32 = 50

/**
 - User can only search for one playform at a time (for now)
 - Discoverable games are tracked via an upper and a lower range, so that both new and old games can be discovered
 - I can track that user has swiped from 1000-800, and at the same time that they have swiped from 0-50 and combine these in searches
    - Sort
 */

    private func makePlatformRequirement(for platform: GamePlatform) -> String {
        return "platforms = " + platform.rawValue
    }

    private func makeIdLimitRequirement(_ platform: GamePlatform, limit: GameRange) -> String {
        var query = ""
        query += "id > \(limit.lower)"
        query += " & id < \(limit.upper);"
        return query
    }

    func makeWhereQuery(platform: GamePlatform, range: GameRange) -> String {
        var query = "where "
        query += makePlatformRequirement(for: platform)
        query += " & "
        query += makeIdLimitRequirement(platform, limit: range)
        print("with platform and id reqs: ", query)
        return query
    }

    func testGettingSomeGames(completion: @escaping Completion) {
        let whereQuery = makeWhereQuery(platform: .PlayStation5, range: GameStore().getDiscoveredGameRange(platform: .PlayStation5))
        print(whereQuery)

        // Funker
        let testQuery = "where platforms = 167 & id > 0 & id < 216;"
        print("working: ", testQuery)

        print("not working: ", whereQuery)

        let apicalypse = APICalypse()
            .fields(fields: minimumRequiredFields)
            .limit(value: 10)
            .where(query: whereQuery)
            .sort(field: "id", order: .DESCENDING)

        let wrapper = IGDBWrapper(clientID: GameService.clientID, accessToken: authToken.accessToken)
        wrapper.games(apiCalypse: apicalypse) { (games) -> (Void) in
            completion(games)
        } errorResponse: { (requestException) -> (Void) in
            print(requestException)
        }
    }

    // MARK: - Static Methods

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

//
//  IGDBService.swift
//  AKTV
//
//  Created by Alexander Kvamme on 05/06/2021.
//  Copyright © 2021 Alexander Kvamme. All rights reserved.
//

import Foundation
import IGDB_SWIFT_API


class TwitchAuthResponse: Codable {
    let expiresIn: Int
    let accessToken: String
    let tokenType: String
}


final class IGDBService {

    private let authToken: TwitchAuthResponse
    static private let clientID = "6w71e2zsvf5ak18snvrtweybwjl877"
    static private let rootURL = "https://api.igdb.com/v4"

    // MARK: - Initializers

    init(_ authToken: TwitchAuthResponse) {
        self.authToken = authToken
    }

    // MARK: - Methods

    func testGettingSomeGames() {
        let apicalypse = APICalypse()
                  .fields(fields: "*")
//                  .exclude(fields: "*")
//                  .limit(value: 10)
//                  .offset(value: 0)
                  .search(searchQuery: "Halo")
//                  .sort(field: "release_dates.date", order: .ASCENDING)
//                  .where(query: "platforms = 48")
        let wrapper = IGDBWrapper(clientID: IGDBService.clientID, accessToken: authToken.accessToken)

        let test = wrapper.games(apiCalypse: apicalypse) { (games) -> (Void) in
            if let game = games.first { print(game) }

//            let gameData = wrapper


        } errorResponse: { (requestException) -> (Void) in
            print(requestException)
        }
    }

    // MARK: - Static Methods

    static func authenticate(completion: @escaping ((TwitchAuthResponse) -> Void)) {
        let authUrl = URL(string: "https://id.twitch.tv/oauth2/token?client_id=\(IGDBService.clientID)&client_secret=pyjnp1qwivqhskefv1vkqizeg6oge9&grant_type=client_credentials")
        var request = URLRequest(url: authUrl!)
        request.httpMethod = "POST"

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in

            guard let data = data else { return }
            do {

                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase

                guard  let decodedToken = try? decoder.decode(TwitchAuthResponse.self, from: data) else {
                    fatalError()
                }

                completion(decodedToken)
            }
        }
        task.resume()
    }
}

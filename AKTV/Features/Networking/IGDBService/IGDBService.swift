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

    let authToken: TwitchAuthResponse
    static private let clientID = "6w71e2zsvf5ak18snvrtweybwjl877"
    static private let rootURL = "https://api.igdb.com/v4"

    // MARK: - Initializers

    init(_ authToken: TwitchAuthResponse) {
        self.authToken = authToken
    }

    // MARK: - Methods

    typealias Completion = (([Proto_Game]) -> ())


    func getCoverImage(id: String, completion: @escaping ((String) -> ())) {
        let wrapper = IGDBWrapper(clientID: IGDBService.clientID, accessToken: authToken.accessToken)
        let apicalypse = APICalypse()
            .fields(fields: "*")
            .where(query: "id = \(id);")

        wrapper.covers(apiCalypse: apicalypse) { (covers) -> (Void) in
            guard let imageId = covers.first?.imageID else {
                print("ERROR could not access cover url")
                return
            }

            let imageURL = imageBuilder(imageID: imageId, size: ImageSize.COVER_BIG)
            completion(imageURL)
        } errorResponse: { (requestException) -> (Void) in
            print("Error getting cover image: ", requestException)
        }
    }

    func testGettingSomeGames(completion: @escaping Completion) {
        let apicalypse = APICalypse()
            .fields(fields: "*")
            .search(searchQuery: "Halo")
            .limit(value: 10)

        let wrapper = IGDBWrapper(clientID: IGDBService.clientID, accessToken: authToken.accessToken)
        wrapper.games(apiCalypse: apicalypse) { (games) -> (Void) in
            completion(games)
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

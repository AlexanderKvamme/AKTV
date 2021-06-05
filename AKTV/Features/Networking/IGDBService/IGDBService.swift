//
//  IGDBService.swift
//  AKTV
//
//  Created by Alexander Kvamme on 05/06/2021.
//  Copyright © 2021 Alexander Kvamme. All rights reserved.
//

import Foundation


class TwitchAuthResponse: Codable {
    let expiresIn: Int
    let accessToken: String
    let tokenType: String
}


final class IGDBService {
    
    static let rootURL = "https://api.igdb.com/v4"


    // MARK: - Methods

    static func setupAuthentication() {
        let authUrl = URL(string: "https://id.twitch.tv/oauth2/token?client_id=6w71e2zsvf5ak18snvrtweybwjl877&client_secret=pyjnp1qwivqhskefv1vkqizeg6oge9&grant_type=client_credentials")
        var request = URLRequest(url: authUrl!)
        request.httpMethod = "POST"

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in

            guard let data = data else { return }
            do {

                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase

                if let decoded = try? decoder.decode(TwitchAuthResponse.self, from: data) {
                    print("Successfully decoded: ", decoded)
                    print(decoded.accessToken)
                    print(decoded.expiresIn)
                    print(decoded.tokenType)
                }
            }
        }
        task.resume()
    }
}

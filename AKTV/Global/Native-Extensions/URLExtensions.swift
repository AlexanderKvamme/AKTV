//
//  URLExtensions.swift
//  AKTV
//
//  Created by Alexander Kvamme on 11/02/2021.
//  Copyright © 2021 Alexander Kvamme. All rights reserved.
//

import UIKit

extension URL {
    static func createLocalUrl(forImageNamed name: String) -> URL? {
        let fileManager = FileManager.default
        let cacheDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        let url = cacheDirectory.appendingPathComponent("\(name).png")
        let path = url.path

        guard fileManager.fileExists(atPath: path) else {
            guard
                let image = UIImage(named: name),
                let data = image.pngData()
            else { return nil }

            fileManager.createFile(atPath: path, contents: data, attributes: nil)
            return url
        }

        return url
    }
}

extension URLRequest {
    static let igdbAuthenticationRequest: URLRequest = {
        let authUrl = URL(string: "https://id.twitch.tv/oauth2/token?client_id=\(GameService.clientID)&client_secret=pyjnp1qwivqhskefv1vkqizeg6oge9&grant_type=client_credentials")!
        var authenticationRequest = URLRequest(url: authUrl)
        authenticationRequest.httpMethod = "POST"
        authenticationRequest.setValue(String(format: "Bearer %s", clientID), forHTTPHeaderField: "Authorization")
        return authenticationRequest
    }()
}

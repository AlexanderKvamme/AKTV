//
//  SceneDelegate.swift
//  AKTV
//
//  Created by Alexander Kvamme on 22/03/2020.
//  Copyright © 2020 Alexander Kvamme. All rights reserved.
//

import UIKit
import Combine


// Twitch API
let clientID = "6w71e2zsvf5ak18snvrtweybwjl877"
var subscriptions = Set<AnyCancellable>()
var gamesService: GameService!
let tabBarController = WellRoundedTabBarController(initalIndex: 4)

// MARK: - Temporary spot for global publishers

let gameAuthPublisher = URLSession.shared
    .dataTaskPublisher(for: .igdbAuthenticationRequest)
    .map(\.data)
    .decode(type: TwitchAuthResponse.self, decoder: JSONDecoder.snakeCaseConverting)

// MARK: - Class

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        gameAuthPublisher
            .sink { _ in
            } receiveValue: { authToken in
                gamesService = GameService(authToken)
                runDevelopmentExperiments()
            }
            .store(in: &subscriptions)

        setRootController()
    }

    private func setRootController() {
        self.window?.rootViewController = tabBarController
        self.window?.makeKeyAndVisible()
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
}


func runDevelopmentExperiments() {
    print("running development experiments...")

}



struct GameId {
    static let diablo: UInt64 = 142803
}

struct CoverId {
    static let diablo: UInt64 = 161120
}

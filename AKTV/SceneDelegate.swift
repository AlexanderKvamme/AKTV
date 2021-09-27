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
                testGettingCovers()
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

func testGettingCovers() {
    GameService.fetchCoverImageUrl(gameId: 161120) { coverImageUrl in
        print("bam successfully got cover url: ", coverImageUrl)
    }
}

func testGettingSwipeableGames() {
    GameService.getCurrentHighestID(GamePlatform.NintendoSwitch) { highestRemoteGameID in
        // Get initial Swipeables
        let testPlatform = GamePlatform.NintendoSwitch
        let initialRange = GameStore.getNextRange(for: testPlatform, highestRemoteID: highestRemoteGameID)

        GameService.fetchGames(initialRange, testPlatform) { games in
            DispatchQueue.main.sync {
                tabBarController.discoveryScreen.update(with: games, range: initialRange, platform: testPlatform, initialHighestRemoteID: highestRemoteGameID)
            }
        }

        // TODO: Clean up
        // TODO: Test getting favourite games
        // let ids = GameStore.getFavourites(.NintendoSwitch)
        let ids = [111, 222, 333]

        GameService.testFetchGames(IDs: ids, completion: { (games) in
            print("successfully fetched games: ", games.map({$0.firstReleaseDate.date}))
        })
    }
}


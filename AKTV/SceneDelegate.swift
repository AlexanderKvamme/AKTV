//
//  SceneDelegate.swift
//  AKTV
//
//  Created by Alexander Kvamme on 22/03/2020.
//  Copyright © 2020 Alexander Kvamme. All rights reserved.
//

import UIKit
var gamesService: IGDBService!


class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Make initial view controller
        let tabBarController = WellRoundedTabBarController()
        //tabBarController.setViewControllers([CalendarScreen()], animated: true)

        IGDBService.authenticate { (authToken) in
            gamesService = IGDBService(authToken)
            gamesService.testGettingSomeGames { (games) in
                print("token: ", authToken)
                print("token a: ", authToken.accessToken)
                DispatchQueue.main.async {
                    tabBarController.discoveryScreen.update(with: games)
                }
            }
        }

        self.window?.rootViewController = tabBarController
        self.window?.makeKeyAndVisible()
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
}


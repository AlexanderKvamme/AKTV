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
let tabBarController = WellRoundedTabBarController(initalIndex: 0)

// MARK: - Temporary spot for global publishers

let gameAuthPublisher = URLSession.shared
    .dataTaskPublisher(for: .igdbAuthenticationRequest)
    .map(\.data)
    .decode(type: TwitchAuthResponse.self, decoder: JSONDecoder.snakeCaseConverting)

// MARK: - Class

class SceneDelegate: UIResponder, UIWindowSceneDelegate, UIApplicationDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        UIApplication.shared.delegate = self
        
        PushNotificationManager.registerForPushNotifications()
        PushNotificationManager.getNotificationSettings()
        
        // Custom 1 week caching
        let cache = EntityURLCache()
        URLCache.shared = cache

        gameAuthPublisher
            .sink { _ in
            } receiveValue: { authToken in
                gamesService = GameService(authToken)
            }
            .store(in: &subscriptions)
        
        registerForRemoteNotification { bool in
            print("✉️ registered for notifications: ", bool)
        }
        
        // Remove after som field testing
        // testScheduleLocalNotification()
//        testPrintNotificationList()
        
        // Initialize app
        setRootController()
    }
    
    private func clearNotifications() {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.removeAllDeliveredNotifications()
        notificationCenter.removeAllPendingNotificationRequests()
    }
    
    private func testPrintNotificationList() {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.getPendingNotificationRequests(){[unowned self] requests in
            print("✉️ awaiting notification count: ", requests.count)
            for request in requests {
                guard let trigger = request.trigger as? UNCalendarNotificationTrigger else { return }
                print("✉️ Notification triggers: ", trigger)
            }
        }
    }
    
    func registerForRemoteNotification(completion: @escaping (Bool) -> Void){
        if #available(iOS 10.0, *) {
            let center  = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.sound, .alert, .badge]) { (granted, error) in
                if error == nil{
                    DispatchQueue.main.async {
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                    completion(true)
                }else{
                    completion(false)
                }
            }
        }
        else {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.sound, .alert, .badge], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
            completion(true)
        }
    }
    
    func testScheduleLocalNotification() {
        let content = UNMutableNotificationContent()
        content.title = "New show airing today!"
        content.body = "Severance"
        content.sound = .default
        
        let date = Date()
        var dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        
        if let secs = dateComponents.second {
            dateComponents.second = secs + 5
        }
        
        // Schedule the request with the system.
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier:  UUID().uuidString, content: content, trigger: trigger)
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.add(request) { (error) in
           if let error = error {
               print("✉️ Notification error: ", error)
           } else {
               print("✉️ Notification successfully added to list")
           }
        }
    }

    private func setRootController() {
        self.window?.rootViewController = tabBarController
        self.window?.makeKeyAndVisible()
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
    
    // MARK: Push notification methods
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
      let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
      let token = tokenParts.joined()
      print("✉️ Device Token: \(token)")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("✉️ Failed to register: \(error.localizedDescription)")
    }
    
    // Remote notifications will be handled here
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("✉️ didReceiveRemoteNotification: ", userInfo)
    }
}

struct GameId {
    static let diablo: UInt64 = 142803
}

struct CoverId {
    static let diablo: UInt64 = 161120
}

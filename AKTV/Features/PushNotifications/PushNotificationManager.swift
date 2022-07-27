//
//  PushNotificationManager.swift
//  AKTV
//
//  Created by Alexander Kvamme on 26/07/2022.
//  Copyright © 2022 Alexander Kvamme. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications

final class PushNotificationManager {
    
    static func registerForPushNotifications() {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
                print("✉️ Permission granted: \(granted)")
            }
    }
    
    static func getNotificationSettings() {
      UNUserNotificationCenter.current().getNotificationSettings { settings in
        print("✉️ Notification settings: \(settings)")
          guard settings.authorizationStatus == .authorized else { return }
          DispatchQueue.main.async {
              UIApplication.shared.registerForRemoteNotifications()
          }
      }
    }
}


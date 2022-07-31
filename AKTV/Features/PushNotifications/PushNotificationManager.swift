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
import CoreData

final class PushNotificationManager {
    
    // MARK: - Properties
    
    private static let arrayKey = "notifications-sent"
    
    // MARK: API methods
    
    static func scheduleNotification(for entity: Entity) {
        let validTypes: [EntitySubType] = [.episode, .movie, .game]
        guard validTypes.contains(entity.subType) else {
            return
        }
        
        // Remove from userdefaults if the premieredate has passed
        guard entity.premiereDate > Date().addingTimeInterval(.day) else {
            removeEntityFromUserdefaultNotificationRegistry(entity)
            return
        }
        
        // Create and Write Array of Strings
        let userDefaults = UserDefaults.standard
        var existingNotificationKeys = userDefaults.object(forKey: arrayKey) as? [String] ?? []
        
        // Append new key to UserDefaults if it doesnt already exists
        let notificationLogKey = keyFromEntity(entity)
        if !existingNotificationKeys.contains(notificationLogKey) {
            // Actually schedule the notification
            scheduleLocalNotification(for: entity)
            existingNotificationKeys.append(notificationLogKey)
        }
        
        userDefaults.set(existingNotificationKeys, forKey: arrayKey)
    }
    
    private static func removeEntityFromUserdefaultNotificationRegistry(_ entity: Entity) {
        let userDefaults = UserDefaults.standard
        var existingNotificationKeys = userDefaults.object(forKey: arrayKey) as? [String] ?? []
        let keyToRemove = keyFromEntity(entity)
        if let index = existingNotificationKeys.firstIndex(of: keyToRemove) {
            existingNotificationKeys.remove(at: index)
            userDefaults.set(existingNotificationKeys, forKey: arrayKey)
        }
    }
    
    private static func keyFromEntity(_ entity: Entity) -> String {
        return "\(entity.name)-\(entity.id)-\(entity.premiereDate.toString())".replacingOccurrences(of: " ", with: "-")
    }
    
    private static func scheduleLocalNotification(for entity: Entity) {
        print("Making an actual notification")
        let content = UNMutableNotificationContent()
        content.sound = .default
        content.title = "New \(entity.type.rawValue) today"
        content.body = entity.name
        
        // Get name if it is a tv show
        if let episode = entity as? Episode {
            content.body = episode.showName ?? entity.name
        }
        
        // Get date of premiere
        var dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: entity.premiereDate)
        dateComponents.hour = 9
        
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
    
    // MARK: Registration methods
    
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


extension TimeInterval {
    static let day: Double = 60*60*24
}

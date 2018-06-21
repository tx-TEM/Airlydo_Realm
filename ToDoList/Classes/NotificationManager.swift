//
//  NotificationManager.swift
//  ToDoList
//
//  Created by yoshiki-t on 2018/06/18.
//  Copyright © 2018年 yoshiki-t. All rights reserved.
//

import Foundation
import UserNotifications

class NotificationManager {
    
    
    static func setLocalNotification(identifier: String, date: Date, title: String, body: String) {
        
        // Date
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        
        // content
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default()
        
        // trigger
        let trigger = UNCalendarNotificationTrigger.init(dateMatching: components, repeats: false)
        
        // request includes content & trigger
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        // Schedule the request with the system.
        let notificationCenter = UNUserNotificationCenter.current()
        
        notificationCenter.add(request) { (error) in
            if let theError = error {
                print(theError.localizedDescription)
            }
            
        }
        
    }
    
    
    static func dateToString(date: Date)-> String {
        
        // Date Formatter
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.timeZone = TimeZone.ReferenceType.local
        dateFormatter.timeStyle = .medium
        dateFormatter.dateStyle = .medium
        
        
        return dateFormatter.string(from: date)
    }
}


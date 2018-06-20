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
    
    
    static func setLocalNotification(identifier: String, date: Date, title: String) {
        
        // Date
        let components = Calendar.current.dateComponents(in: TimeZone.current, from: date)
        
        // content
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = "Check your Task"
        content.sound = UNNotificationSound.default()
        
        // trigger
        let trigger = UNCalendarNotificationTrigger.init(dateMatching: components, repeats: false)
        //let trigger = UNCalendarNotificationTrigger.init(dateMatching: DateComponents(hour:7, minute:15 ), repeats: false)
        print(components)
        
        //let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 5, repeats: false)//５秒後
       
        
        // request includes content & trigger
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        // Schedule the request with the system.
        let notificationCenter = UNUserNotificationCenter.current()
        
        notificationCenter.add(request) { (error) in
            if let theError = error {
                print(theError.localizedDescription)
            }
            
            print("set")
            
        }
        
        let nextTriggerDate = trigger.nextTriggerDate()
        print(nextTriggerDate as Any)
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


//
//  ReminderManager.swift
//  ToDoList
//
//  Created by yoshiki-t on 2018/06/21.
//  Copyright © 2018年 yoshiki-t. All rights reserved.
//

import Foundation
import RealmSwift

class ReminderManager {
    
    // Get the default Realm
    lazy var realm = try! Realm()
    
    // Read Data
    func readData (minimumRemind: Date)-> Results<Reminder> {
        let predicate = NSPredicate(format: "remDate > %@", minimumRemind as NSDate)
        return self.realm.objects(Reminder.self).filter(predicate)
    }
    
}

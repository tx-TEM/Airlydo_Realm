//
//  ToDoItem.swift
//  ToDoList
//
//  Created by yoshiki-t on 2018/05/26.
//  Copyright © 2018年 yoshiki-t. All rights reserved.
//

import RealmSwift

// Realm model

// Task
class Task: Object{
    @objc dynamic var taskID = UUID().uuidString
    @objc dynamic var taskName = ""
    @objc dynamic var note = ""
    @objc dynamic var dueDate = Date()
    @objc dynamic var howRepeat = 3  //0:毎年, 1:毎週, 2:毎日, 3:なし
    @objc dynamic var priority = 1   //0:low, 1:middle, 2:high
    
    // default nil
    @objc dynamic var listT:ListOfTask?
    @objc dynamic var assign:Assign?
    
    let remindList = List<Reminder>()
    
    // primary key
    override static func primaryKey() -> String? {
        return "taskID"
    }
    
}

// List of Task
class ListOfTask: Object{
    @objc dynamic var listID = UUID().uuidString
    @objc dynamic var listName = ""
    
    let tasks = LinkingObjects(fromType: Task.self, property: "listT")
    // primary key
    override static func primaryKey() -> String? {
        return "listID"
    }
}

// Assignd user
class Assign: Object{
    @objc dynamic var assignID = UUID().uuidString
    @objc dynamic var assignName = ""
    let tasks = LinkingObjects(fromType: Task.self, property: "assign")
    
    // primary key
    override static func primaryKey() -> String? {
        return "assignID"
    }
}

// Reminder
class Reminder: Object{
    @objc dynamic var remID = UUID().uuidString
    @objc dynamic var remDate = Date()
    let tasks = LinkingObjects(fromType: Task.self, property: "remindList")
    
    // primary key
    override static func primaryKey() -> String? {
        return "remID"
    }
}

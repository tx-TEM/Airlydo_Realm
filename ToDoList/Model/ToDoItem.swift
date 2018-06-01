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
    @objc dynamic var priority = 0
    
    @objc dynamic var listT = ListOfTask()
    @objc dynamic var assign = Assign()
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
}

// Assignd user
class Assign: Object{
    @objc dynamic var assignID = UUID().uuidString
    @objc dynamic var assignName = ""
}

// reminder list
class Reminder: Object{
    @objc dynamic var remDate = Date()
}

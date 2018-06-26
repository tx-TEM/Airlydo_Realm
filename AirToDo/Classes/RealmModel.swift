//
//  RealmModel.swift
//  RealmModel
//
//  Created by yoshiki-t on 2018/05/26.
//  Copyright © 2018年 yoshiki-t. All rights reserved.
//

import RealmSwift


// Project
class Project: Object {
    @objc dynamic var projectID = UUID().uuidString
    @objc dynamic var projectName = ""
    let taskList = List<Task>()
    let assignList = List<Assign>()
    
    // primary key
    override static func primaryKey() -> String? {
        return "projectID"
    }
}

// Project Wrapper
class ProjectWrapper: Object{
    let projectList = List<Project>()
}

// Task
class Task: Object {
    @objc dynamic var taskID = UUID().uuidString
    @objc dynamic var taskName = ""
    @objc dynamic var note = ""
    @objc dynamic var isArchive = false
    @objc dynamic var dueDate = Date()
    @objc dynamic var howRepeat = 3  //0:毎月, 1:毎週, 2:毎日, 3:なし
    @objc dynamic var priority = 1   //0:low, 1:middle, 2:high
    
    @objc dynamic var assign:Assign?
    let remindList = List<Reminder>()
    
    // Parent Project
    @objc dynamic var projectID: String?
    
    private let projects:LinkingObjects<Project> = LinkingObjects(fromType: Project.self, property: "taskList")
    var project:Project? { return self.projects.first }
    

    // primary key
    override static func primaryKey() -> String? {
        return "taskID"
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
    private let tasks:LinkingObjects<Task> = LinkingObjects(fromType: Task.self, property: "remindList")
    var task: Task? { return self.tasks.first }
    
    // primary key
    override static func primaryKey() -> String? {
        return "remID"
    }
}

//
//  TaskDetailModel.swift
//  ToDoList
//
//  Created by yoshiki-t on 2018/06/13.
//  Copyright © 2018年 yoshiki-t. All rights reserved.
//

import Foundation
import RealmSwift

protocol TaskDetailModelDelegate: class {
    func listDidChange()
    func errorDidOccur(error: Error)
}

class TaskDetailModel {
    
    // Get the default Realm
    lazy var realm = try! Realm()
    var theTask: Task?
    var taskManager = TaskManager()
    
    // Page Status
    var pageTitle = "Add Task"
    var isNewTask: Bool
    
    // list for Form
    var theProjectList : List<Project>!
    var assignList : Results<Assign>!
    
    
    // Delegate
    weak var delegate: TaskDetailModelDelegate?
    
    init() {
        theTask = Task()
        isNewTask = true
        self.pageTitle = "Add Task"
        
        // get list for Form
        if let list = realm.objects(ProjectWrapper.self).first?.projectList {
            theProjectList = list
            
        }else{
            let projectWrapper = ProjectWrapper()
            
            try! realm.write {
                realm.add(projectWrapper)
            }
            
            theProjectList = projectWrapper.projectList
        }
        
        assignList = realm.objects(Assign.self)
        
    }
    
    init(task: Task) {
        theTask = task
        isNewTask = false
        self.pageTitle = "Edit Task"
        
        // get list for Form
        if let list = realm.objects(ProjectWrapper.self).first?.projectList {
            theProjectList = list
            
        }else{
            let projectWrapper = ProjectWrapper()
            
            try! realm.write {
                realm.add(projectWrapper)
            }
            
            theProjectList = projectWrapper.projectList
        }
        
        assignList = realm.objects(Assign.self)
        
    }
    
    // create NewTask
    func newTask(formTaskName: String, formNote: String, formDueDate: Date, formHowRepeat: String,
                 formPriority: String, formProject: Project?, formAssign: Assign?, formRemindList: [Date]) {
        
        self.taskManager.addTask(taskName: formTaskName, note: formNote, dueDate: formDueDate,
                                 howRepeat: self.howRepeatStringToInt(howRepeatText: formHowRepeat),
                                 priority: self.priorityStringToInt(priorityText: formPriority),
                                 project: formProject, assign: formAssign, remindList: formRemindList)
    }
    
    // edit Task
    func editTask(formTaskName: String, formNote: String, formDueDate: Date, formHowRepeat: String,
                  formPriority: String, formProject: Project?, formAssign: Assign?, formRemindList: [Date]) {
        
        self.taskManager.editTask(theTask: self.theTask!, taskName: formTaskName, note: formNote, dueDate: formDueDate,
                                  howRepeat: self.howRepeatStringToInt(howRepeatText: formHowRepeat),
                                  priority: self.priorityStringToInt(priorityText: formPriority),
                                  project: formProject, assign: formAssign, remindList: formRemindList)
        
    }
    
    
    // convert howRepeatText to Integer
    func howRepeatStringToInt(howRepeatText: String)-> Int {
        var howRepeat: Int!
        
        switch howRepeatText {
        case "毎月":
            howRepeat = 0
        case "毎週":
            howRepeat = 1
        case "毎日":
            howRepeat = 2
        case "なし":
            howRepeat = 3
        default:
            howRepeat = 3
        }
        
        return howRepeat
    }
    
    // convert priorityText to Integer
    func priorityStringToInt(priorityText: String)-> Int {
        var priority: Int!
        
        switch priorityText {
        case "High":
            priority = 0
        case "Middle":
            priority = 1
        case "Low":
            priority = 2
        default:
            priority = 1
        }
        
        return priority
    }
    
}

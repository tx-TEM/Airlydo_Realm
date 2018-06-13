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
    
    // task status : new or edit
    var isNewTask: Bool
    
    // list for Form
    var listTList : List<ListOfTask>!
    var assignList : Results<Assign>!
    
    
    // Delegate
    weak var delegate: TaskDetailModelDelegate?
    
    init() {
        theTask = Task()
        isNewTask = true
        
        // get list for Form
        if let list = realm.objects(ListOfTaskWrapper.self).first?.list {
            listTList = list
            
        }else{
            let listTWrapper = ListOfTaskWrapper()
            
            try! realm.write {
                realm.add(listTWrapper)
            }
            
            listTList = listTWrapper.list
        }
        
        assignList = realm.objects(Assign.self)
        
        if let taskID = theTask?.taskID{
            print("taskID\(taskID)")
        }
    }
    
    init(task: Task) {
        theTask = task
        isNewTask = false
        
        // get list for Form
        if let list = realm.objects(ListOfTaskWrapper.self).first?.list {
            listTList = list
            
        }else{
            let listTWrapper = ListOfTaskWrapper()
            
            try! realm.write {
                realm.add(listTWrapper)
            }
            
            listTList = listTWrapper.list
        }
        
        assignList = realm.objects(Assign.self)
        
        if let taskID = theTask?.taskID{
            print("taskID\(taskID)")
        }
    }
    
    // create NewTask
    func newTask(taskName: String,
                 note: String,
                 dueDate: Date,
                 howRepeat: String,
                 priority: String,
                 listT: ListOfTask?,
                 assign: Assign?,
                 formRemindList: [Date]
        ) {
        
        theTask?.taskName = taskName
        theTask?.note = note
        theTask?.dueDate = dueDate
        theTask?.howRepeat = self.howRepeatStringToInt(howRepeatText: howRepeat)
        theTask?.priority = self.priorityStringToInt(priorityText: priority)
        theTask?.listT = listT
        theTask?.assign = assign

        
        let remindList = self.genarateRemindList(theFormRemindList: formRemindList)
        
        for remind in remindList{
            theTask?.remindList.append(remind)
        }
        
        try! realm.write() {
            realm.add(theTask!)
        }
    }
    
    // edit Task
    func changeTask(taskName: String,
                    note: String,
                    dueDate: Date,
                    howRepeat: String,
                    priority: String,
                    listT: ListOfTask?,
                    assign: Assign?,
                    formRemindList: [Date]
        ) {
        
        let remindList = self.genarateRemindList(theFormRemindList: formRemindList)
        
        try! realm.write() {
            theTask?.taskName = taskName
            theTask?.note = note
            theTask?.dueDate = dueDate
            theTask?.howRepeat = self.howRepeatStringToInt(howRepeatText: howRepeat)
            theTask?.priority = self.priorityStringToInt(priorityText: priority)
            theTask?.listT = listT
            theTask?.assign = assign
            
            for remind in remindList{
                theTask?.remindList.append(remind)
            }
            
        }
    }
    
    // generate add RemindList using form Data
    func genarateRemindList(theFormRemindList: [Date])-> [Reminder] {
        var formRemindList = theFormRemindList
        var reRemindList: [Reminder] = []
        
        if(!isNewTask){
            if let remindList = theTask?.remindList {
                for reminder in remindList {
                    
                    // reminder is an element of formReminderList?
                    let index = formRemindList.index(of: reminder.remDate)
                    
                    if let theIndex = index {
                        formRemindList.remove(at: theIndex)
                    }
                }
            }
        }
        
        for formReminder in formRemindList {
            let tempReminder = Reminder()
            tempReminder.remDate = formReminder
            reRemindList.append(tempReminder)
        }
        
        return reRemindList
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

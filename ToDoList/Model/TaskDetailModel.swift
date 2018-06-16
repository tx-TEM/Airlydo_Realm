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
    var theProjectList : List<Project>!
    var assignList : Results<Assign>!
    
    
    // Delegate
    weak var delegate: TaskDetailModelDelegate?
    
    init() {
        theTask = Task()
        isNewTask = true
        
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
    func newTask(taskName: String,
                 note: String,
                 dueDate: Date,
                 howRepeat: String,
                 priority: String,
                 project: Project?,
                 assign: Assign?,
                 formRemindList: [Date]
        ) {
        
        // dueDate -> 11:59:59
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: dueDate)
        components.hour = 11
        components.minute = 59
        components.second = 59
        
        theTask?.taskName = taskName
        theTask?.note = note
        theTask?.dueDate = calendar.date(from: components)!
        theTask?.howRepeat = self.howRepeatStringToInt(howRepeatText: howRepeat)
        theTask?.priority = self.priorityStringToInt(priorityText: priority)
        theTask?.assign = assign
        theTask?.projectID = project?.projectID
        
        
        let remindList = self.genarateRemindList(formRemindList: formRemindList)
        
        for remind in remindList.addRemList {
            theTask?.remindList.append(remind)
        }
        
        try! realm.write() {
            if let theProject = project {
                theProject.taskList.append(theTask!)
            }else{
                // InBox
                realm.add(theTask!)
            }
        }
    }
    
    // edit Task
    func changeTask(taskName: String,
                    note: String,
                    dueDate: Date,
                    howRepeat: String,
                    priority: String,
                    project: Project?,
                    assign: Assign?,
                    formRemindList: [Date]
        ) {
        
        let remindList = self.genarateRemindList(formRemindList: formRemindList)
        
        try! realm.write() {
            theTask?.taskName = taskName
            theTask?.note = note
            theTask?.dueDate = dueDate
            theTask?.howRepeat = self.howRepeatStringToInt(howRepeatText: howRepeat)
            theTask?.priority = self.priorityStringToInt(priorityText: priority)
            theTask?.assign = assign
            
            // Remove theTask from old Project's Task List
            
            
            // insert Task to Project
            if let theProject = project {
                // the Task was element of Project?
                if let projPrimaryID = theTask?.projectID {
                    
                    // Does the Task move to other Project?
                    if projPrimaryID != theProject.projectID {
                        // Get Old Project
                        if let oldProj = realm.object(ofType: Project.self, forPrimaryKey: projPrimaryID) {
                            
                            // Search Task index
                            if let index = oldProj.taskList.index(of: theTask!) {
                                // Remove from old Project's Task List
                                oldProj.taskList.remove(at: index)
                                
                                // Insert to new Project's Task List
                                theProject.taskList.append(theTask!)
                                theTask?.projectID = theProject.projectID
                                
                            }else{
                                theTask?.projectID = theProject.projectID
                            }
                            
                        // Old Project has been deleted
                        }else{
                            theTask?.projectID = theProject.projectID
                        }
                        
                    // Stay Same Project
                    }else{
                        theTask?.projectID = theProject.projectID
                    }
                    
                // the Task was not element of Project?
                }else{
                    // Insert to new Project's Task List
                    theProject.taskList.append(theTask!)
                    theTask?.projectID = theProject.projectID
                }
                
            // insert Task to InBox(not Project)
            }else{
                // the Task was element of Project?
                if let projPrimaryID = theTask?.projectID {
                    
                    // Get Old Project
                    if let oldProj = realm.object(ofType: Project.self, forPrimaryKey: projPrimaryID) {
                        
                        // Search Task index
                        if let index = oldProj.taskList.index(of: theTask!) {
                            // Remove from old Project's Task List
                            oldProj.taskList.remove(at: index)
                            
                            // Insert to InBox (not Project)
                            theTask?.projectID = nil
                            
                        }else{
                            theTask?.projectID = nil
                        }
                        
                        // Old Project has been deleted
                    }else{
                        theTask?.projectID = nil
                    }
                    
                    
                    // the Task was not element of Project?
                }else{
                    theTask?.projectID = nil
                }
                
                theTask?.projectID = nil
            }
            
            for delRemind in remindList.delRemList {
                realm.delete(delRemind)
            }
            
            for remind in remindList.addRemList {
                theTask?.remindList.append(remind)
            }
            
        }
    }
    
    // generate add RemindList using form Data
    func genarateRemindList(formRemindList: [Date])-> (addRemList: [Reminder], delRemList: [Reminder]) {
        var uniqueRemindList: [Date] = []
        var tempRemindList: [Date] = []
        
        var reRemindList: [Reminder] = []
        var reDeleteRemindList: [Reminder] = []
        
        // Remind sec -> 0
        let calendar = Calendar.current
        
        for formRemind in formRemindList {
            let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: formRemind)
            tempRemindList.append(calendar.date(from: components)!)
        }
        
        // Eliminate duplication
        let orderedRemindList = NSOrderedSet(array: tempRemindList)
        uniqueRemindList = orderedRemindList.array as! [Date]
        
        
        if(!isNewTask){
            if let remindList = theTask?.remindList {
                for reminder in remindList {
                    
                    // reminder is an element of formReminderList?
                    let index = uniqueRemindList.index(of: reminder.remDate)
                    
                    if let theIndex = index {
                        uniqueRemindList.remove(at: theIndex)
                    }else{
                        reDeleteRemindList.append(reminder)
                    }
                }
            }
        }
        
        // create Reminder instance, and add list
        for reminder in uniqueRemindList {
            let tempReminder = Reminder()
            tempReminder.remDate = reminder
            reRemindList.append(tempReminder)
        }
        
        return (reRemindList, reDeleteRemindList)
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

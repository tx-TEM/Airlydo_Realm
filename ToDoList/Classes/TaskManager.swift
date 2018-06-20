//
//  TaskManager.swift
//  ToDoList
//
//  Created by yoshiki-t on 2018/06/20.
//  Copyright © 2018年 yoshiki-t. All rights reserved.
//

import Foundation
import RealmSwift

class TaskManager {
    
    // Get the default Realm
    lazy var realm = try! Realm()
    
    
    // Read Data from InBox
    func readData (isArchiveMode: Bool)-> Results<Task> {
        let predicate = NSPredicate(format: "isArchive = %@ && projectID = nil", NSNumber(booleanLiteral:isArchiveMode))
        return self.realm.objects(Task.self).filter(predicate)
    }
    
    // Read Data from Project
    func readData (isArchiveMode: Bool, project: Project)-> Results<Task> {
        let predicate = NSPredicate(format: "isArchive = %@ && projectID = %@", NSNumber(booleanLiteral:isArchiveMode), project.projectID)
        return self.realm.objects(Task.self).filter(predicate)
    }
    
    // Read All Data
    func readAllData (isArchiveMode: Bool)-> Results<Task> {
        let predicate = NSPredicate(format: "isArchive = %@" , NSNumber(booleanLiteral: isArchiveMode))
        return self.realm.objects(Task.self).filter(predicate)
    }
    
    // Create new Task
    func newTask(taskName: String,
                 note: String,
                 dueDate: Date,
                 howRepeat: Int,
                 priority: Int,
                 project: Project?,
                 assign: Assign?,
                 remindList: [Date]
        ) {
        
        // dueDate -> 11:59:59
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: dueDate)
        components.hour = 11
        components.minute = 59
        components.second = 59
        
        let theTask = Task()
        
        theTask.taskName = taskName
        theTask.note = note
        theTask.dueDate = calendar.date(from: components)!
        theTask.howRepeat = howRepeat
        theTask.priority = priority
        theTask.assign = assign
        theTask.projectID = project?.projectID
        
        
        let newRemindList = self.genarateRemindList(task: theTask, remindList: remindList, isNewTask: true)
        
        for remind in newRemindList.addRemList {
            theTask.remindList.append(remind)
            NotificationManager.setLocalNotification(identifier: remind.remID, date: remind.remDate, title: theTask.taskName)
        }
        
        try! realm.write() {
            if let theProject = project {
                theProject.taskList.append(theTask)
            }else{
                // InBox
                realm.add(theTask)
            }
        }
    }
    
    // edit Task
    func editTask(theTask: Task,
                  taskName: String,
                  note: String,
                  dueDate: Date,
                  howRepeat: Int,
                  priority: Int,
                  project: Project?,
                  assign: Assign?,
                  remindList: [Date]
        ) {
        
        let newRemindList = self.genarateRemindList(task: theTask, remindList: remindList, isNewTask: false)
        
        try! realm.write() {
            theTask.taskName = taskName
            theTask.note = note
            theTask.dueDate = dueDate
            theTask.howRepeat = howRepeat
            theTask.priority = priority
            theTask.assign = assign
            
            // Remove theTask from old Project's Task List
            
            // insert Task to Project
            if let theProject = project {
                // the Task was element of Project?
                if let projPrimaryID = theTask.projectID {
                    
                    // Does the Task move to other Project?
                    if projPrimaryID != theProject.projectID {
                        // Get Old Project
                        if let oldProj = realm.object(ofType: Project.self, forPrimaryKey: projPrimaryID) {
                            
                            // Search Task index
                            if let index = oldProj.taskList.index(of: theTask) {
                                // Remove from old Project's Task List
                                oldProj.taskList.remove(at: index)
                            }
                        }
                    }
                }
                
                // Insert to new Project's Task List
                theProject.taskList.append(theTask)
                theTask.projectID = theProject.projectID
                
                
            }else{
                // the Task was element of Project?
                if let projPrimaryID = theTask.projectID {
                    
                    // Get Old Project
                    if let oldProj = realm.object(ofType: Project.self, forPrimaryKey: projPrimaryID) {
                        
                        // Search Task index
                        if let index = oldProj.taskList.index(of: theTask) {
                            // Remove from old Project's Task List
                            oldProj.taskList.remove(at: index)
                        }
                    }
                }
                
                // insert Task to InBox(not Project)
                theTask.projectID = nil
            }
            
            for delRemind in newRemindList.delRemList {
                realm.delete(delRemind)
            }
            
            for remind in newRemindList.addRemList {
                theTask.remindList.append(remind)
                NotificationManager.setLocalNotification(identifier: remind.remID, date: remind.remDate, title: theTask.taskName)
            }
            
        }
    }
    
    // Check new RemindList
    // Eliminate duplication and Delete old Remind.
    private func genarateRemindList(task: Task, remindList: [Date], isNewTask: Bool)-> (addRemList: [Reminder], delRemList: [Reminder]) {
        var uniqueRemindList: [Date] = []
        var tempRemindList: [Date] = []
        
        var reRemindList: [Reminder] = []
        var reDeleteRemindList: [Reminder] = []
        
        // Remind sec -> 0
        let calendar = Calendar.current
        
        for reminder in remindList {
            let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: reminder)
            tempRemindList.append(calendar.date(from: components)!)
        }
        
        // Eliminate duplication
        let orderedRemindList = NSOrderedSet(array: tempRemindList)
        uniqueRemindList = orderedRemindList.array as! [Date]
        
        
        if(!isNewTask){
            for reminder in task.remindList {
                
                // reminder is an element of formReminderList?
                let index = uniqueRemindList.index(of: reminder.remDate)
                
                if let theIndex = index {
                    uniqueRemindList.remove(at: theIndex)
                }else{
                    reDeleteRemindList.append(reminder)
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
    
    
    // Delete Task
    func deleteTask(task: Task) {
        try! realm.write() {
            // delete Task's remindList
            for theReminder in task.remindList {
                realm.delete(theReminder)
            }
            realm.delete(task)
        }
    }
    
    // Send the task to archive
    func archiveTask(task: Task) {
        try! self.realm.write() {
            task.isArchive = true
        }
    }
    
    
}

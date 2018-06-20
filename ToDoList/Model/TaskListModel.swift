//
//  TaskPageModel.swift
//  ToDoList
//
//  Created by yoshiki-t on 2018/06/12.
//  Copyright © 2018年 yoshiki-t. All rights reserved.
//

import Foundation
import RealmSwift

protocol TaskListModelDelegate: class {
    func tasksDidChange()
    func errorDidOccur(error: Error)
}

class TaskListModel {
    
    // Get the default Realm
    lazy var realm = try! Realm()
    var tasks: Results<Task>!
    var taskManager = TaskManager()
    
    // Page Status
    var isArchiveMode = false
    var nowProject: Project?
    var pageTitle = "All"
    
    // 0: changeList(),  1: changeList(Proj)
    var oldChangeFunc = 0
    
    // Date Formatter
    let dateFormatter = DateFormatter()
    
    // Delegate
    weak var delegate: TaskListModelDelegate?
    
    init() {
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        // Get Data from Realm
        self.tasks = taskManager.readAllData(isArchiveMode: isArchiveMode)
        
        // Date Formatter
        dateFormatter.locale = Locale.current
        dateFormatter.timeZone = TimeZone.ReferenceType.local
        dateFormatter.dateFormat = "MMM. d"
    }
    
    
    // Change Display Tasks
    func changeList() {
        self.tasks = taskManager.readAllData(isArchiveMode: isArchiveMode)
        self.oldChangeFunc = 0
        self.pageTitle = isArchiveMode ? "All <Archive>" : "All"
        delegate?.tasksDidChange()
        self.nowProject = nil
    }
    
    func changeList(selectedProjcet: Project?) {
        
        if let theSelectedProjcet = selectedProjcet {
            self.tasks = taskManager.readData(isArchiveMode: isArchiveMode, project: theSelectedProjcet)
            self.pageTitle = isArchiveMode ? theSelectedProjcet.projectName + " <Archive>" : theSelectedProjcet.projectName
            
        }else{
            self.tasks = taskManager.readData(isArchiveMode: isArchiveMode)
            self.pageTitle = isArchiveMode ? "InBox <Archive>" : "InBox"
        }
        
        self.oldChangeFunc = 1
        self.nowProject = selectedProjcet
        delegate?.tasksDidChange()
    }
    
    func changeListOld() {
        
        switch self.oldChangeFunc {
        case 0:
            changeList()

        case 1:
            changeList(selectedProjcet: self.nowProject)
            
        default:
            changeList()
        }
    }
    
    // Date to String using Formatter
    func dueDateToString(dueDate: Date)-> String {
        return dateFormatter.string(from: dueDate)
    }
    
    // Delete Task
    func deleteTask(indexPath: IndexPath) {
        taskManager.deleteTask(task: tasks[indexPath.row])
        delegate?.tasksDidChange()
    }
    
    // Send the task to archive
    func archiveTask(indexPath: IndexPath) {
        taskManager.archiveTask(task: tasks[indexPath.row])
        self.delegate?.tasksDidChange()

    }
    
    // Get the Time of after Repeat Calc
    func calcRepeatTime(date: Date, howRepeat: Int)-> Date {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)

        switch howRepeat {
        // 毎月
        case 0:
            components.month = components.month! + 1
        // 毎週
        case 1:
            components.day = components.day! + 7
        // 毎日
        case 2:
            components.day = components.day! + 1
        default:
            components.day = components.day! + 1
        }
        
        return calendar.date(from: components)!
    }
    
    // Generate Repeat Task
    func genRepeatask(indexPath: IndexPath) {
        let task = tasks[indexPath.row]
        let repeatTask = Task()
        repeatTask.taskName = task.taskName
        repeatTask.dueDate = calcRepeatTime(date: task.dueDate, howRepeat: task.howRepeat)
        repeatTask.howRepeat = task.howRepeat
        repeatTask.priority = task.priority
        
        // Create Reminder instance, and Add List
        for reminder in task.remindList {
            let tempReminder = Reminder()
            tempReminder.remDate = calcRepeatTime(date: reminder.remDate, howRepeat: task.howRepeat)
            repeatTask.remindList.append(tempReminder)
        }
        
        // Add repeatTask
        taskManager.newTask(task: repeatTask, project: task.project)

        self.delegate?.tasksDidChange()
    }
}

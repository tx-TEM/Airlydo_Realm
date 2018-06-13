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
    
    var isArchiveMode = false
    var nowList: ListOfTask?
    
    // Date Formatter
    let dateFormatter = DateFormatter()
    
    // Delegate
    weak var delegate: TaskListModelDelegate?
    
    init() {
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        // Get Data from Realm
        let predicate = NSPredicate(format: "isArchive = %@", NSNumber(booleanLiteral: isArchiveMode))
        readData(predicate: predicate)
        
        // Date Formatter
        dateFormatter.locale = Locale.current
        dateFormatter.timeZone = TimeZone.ReferenceType.local
        dateFormatter.dateFormat = "MMM. d"
    }
    
    // Read Data from Realm
    func readData (predicate: NSPredicate) {
        self.tasks = self.realm.objects(Task.self).filter(predicate)
    }
    
    // Change Display Tasks
    func changeList () {
        let predicate = NSPredicate(format: "isArchive = %@" , NSNumber(booleanLiteral: isArchiveMode))
        readData(predicate: predicate)
        delegate?.tasksDidChange()
    }
    
    func changeList (selectedList: ListOfTask) {
        let predicate = NSPredicate(format: "isArchive = %@ && listT = %@", NSNumber(booleanLiteral:isArchiveMode), selectedList)
        readData(predicate: predicate)
        delegate?.tasksDidChange()
    }
    
    func changeListInBox(){
        let predicate = NSPredicate(format: "isArchive = %@ && listT = nil", NSNumber(booleanLiteral:isArchiveMode))
        readData(predicate: predicate)
        delegate?.tasksDidChange()
    }
    
    // Date to String using Formatter
    func dueDateToString(dueDate: Date)-> String {
        return dateFormatter.string(from: dueDate)
    }
    
    // Delete Task
    func deleteTask(indexPath: IndexPath) {
        try! realm.write() {
            // delete Task's remindList
            for theReminder in tasks[indexPath.row].remindList {
                realm.delete(theReminder)
            }
            realm.delete(tasks[indexPath.row])
        }
        delegate?.tasksDidChange()
    }
    
    // Send the task to archive
    func archiveTask(indexPath: IndexPath) {
        try! self.realm.write() {
            self.tasks[indexPath.row].isArchive = true
        }
        self.delegate?.tasksDidChange()

    }
}

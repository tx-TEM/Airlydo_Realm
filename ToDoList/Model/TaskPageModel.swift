//
//  TaskPageModel.swift
//  ToDoList
//
//  Created by yoshiki-t on 2018/06/12.
//  Copyright © 2018年 yoshiki-t. All rights reserved.
//

import Foundation
import RealmSwift

protocol TaskPageModelDelegate: class {
    func tasksDidChange()
    func errorDidOccur(error: Error)
}

class TaskPageModel {
    
    // Get the default Realm
    lazy var realm = try! Realm()
    var tasks: Results<Task>!
    
    var isArchiveMode = false
    var nowList: ListOfTask?
    
    // Date Formatter
    let dateFormatter = DateFormatter()
    
    // Delegate
    weak var delegate: TaskPageModelDelegate?
    
    init() {
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        // Get Data from Realm
        let predicate = NSPredicate(format: "isArchive = %@", NSNumber(booleanLiteral: self.isArchiveMode))
        readData(predicate: predicate)
        
        // Date Formatter
        self.dateFormatter.locale = Locale.current
        self.dateFormatter.timeZone = TimeZone.ReferenceType.local
        self.dateFormatter.dateFormat = "MMM. d"
    }
    
    // Read Data from Realm
    func readData (predicate: NSPredicate) {
        self.tasks = self.realm.objects(Task.self).filter(predicate)
    }
    
    // Change Display Tasks
    func changeList (selectedList: ListOfTask){
        let predicate = NSPredicate(format: "isArchive = %@ && listT = %@", NSNumber(booleanLiteral:self.isArchiveMode), selectedList)
        readData(predicate: predicate)
        self.delegate?.tasksDidChange()
    }
    
    // Date to String using Formatter
    func dueDateToString(dueDate: Date)-> String {
        return self.dateFormatter.string(from: dueDate)
    }
    
    // Delete Task
    func deleteTask(indexPath: IndexPath) {
        try! self.realm.write() {
            // delete Task's remindList
            for theReminder in self.tasks[indexPath.row].remindList {
                self.realm.delete(theReminder)
            }
            self.realm.delete(tasks[indexPath.row])
        }
        self.delegate?.tasksDidChange()
    }
    
    // Send the task to archive
    func archiveTask(indexPath: IndexPath) {
        try! self.realm.write() {
            self.tasks[indexPath.row].isArchive = true
        }
        self.delegate?.tasksDidChange()

    }
}

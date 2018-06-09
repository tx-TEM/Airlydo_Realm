//
//  AddTaskPageController.swift
//  ToDoList
//
//  Created by yoshiki-t on 2018/05/22.
//  Copyright © 2018年 yoshiki-t. All rights reserved.
//


import UIKit
import Eureka
import RealmSwift

class AddTaskPageController: FormViewController {
    
    @IBOutlet weak var SaveTaskButton: UIBarButtonItem!
    
    // Get the default Realm
    lazy var realm = try! Realm()

    // taskData
    var theTask: Task?
    var recvVal: String = ""
    
    // new or edit/ task property
    var taskName = ""
    var note = ""
    var dueDate = Date()
    var howRepeat = 3
    var priority = 1
    let remindList = List<Reminder>()
    var listT:ListOfTask?
    var assign:Assign?

    // list for Form
    var listTList : List<ListOfTask>!
    var assignList : Results<Assign>!
    
    // task: new or edit
    var newTask: Bool = true

  
    
    @IBAction func SaveTaskButtonTapped(_ sender: UIButton) {
        let valuesDictionary = form.values()
        
        // set property
        taskName = valuesDictionary["TitleTag"] as! String
        note = valuesDictionary["NoteTag"] as! String
        dueDate = valuesDictionary["DueDateTag"] as! Date
        
        // Reminder
        let formReminderTags = [String](valuesDictionary.keys).filter({$0.contains("ReminderTag_")}).sorted()
        var deleteReminderList: [Reminder] = []
        var formReminderList: [Date] = []
        
        for remTag in formReminderTags{
            formReminderList.append(valuesDictionary[remTag] as! Date)
        }
        
        if let reminderList = theTask?.remindList {
            for reminder in reminderList {
                
                // reminder is an element of formReminderList?
                let index = formReminderList.index(of: reminder.remDate)
                
                if let theIndex = index {
                    formReminderList.remove(at: theIndex)
                }else{
                    deleteReminderList.append(reminder)
                }
            }
        }
        
        for formReminder in formReminderList {
            let tempReminder = Reminder()
            tempReminder.remDate = formReminder
            remindList.append(tempReminder)
        }
        
        
        let repeatText = valuesDictionary["RepeatTag"] as! String
        switch repeatText {
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
        
        let priorityText = valuesDictionary["PriorityTag"] as! String
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

        
        // DB process
        if (newTask) {
            theTask?.taskName = taskName
            theTask?.note = note
            theTask?.dueDate = dueDate
            theTask?.howRepeat = howRepeat
            theTask?.priority = priority
            theTask?.listT = listT
            for remind in remindList{
                theTask?.remindList.append(remind)
            }
            
            try! realm.write() {
                realm.add(theTask!)
            }
        }else{
            try! realm.write() {
                theTask?.taskName = taskName
                theTask?.note = note
                theTask?.dueDate = dueDate
                theTask?.howRepeat = howRepeat
                theTask?.priority = priority
                theTask?.listT = listT
                for remind in remindList{
                    theTask?.remindList.append(remind)
                }
                
                for deleteReminder in deleteReminderList{
                    realm.delete(deleteReminder)
                }
                
            }
        }
        
        if let task = self.theTask{
            print(task)
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func updateNote(){
        let noteForm:LabelRow = form.rowBy(tag:"NoteTag") as! LabelRow
        noteForm.value = recvVal
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if(newTask){
            theTask = Task()
        }
        
        // Query Realm for all Tasks
        
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

        form +++ Section("Task")
            <<< TextRow("TitleTag"){
                $0.title = "Add a Task"
                $0.value = theTask?.taskName
            }
            <<< LabelRow("NoteTag"){
                $0.title = "Note"
                $0.value = theTask?.note
                }.onCellSelection{ cell, row in
                    let SetNotePageController = self.storyboard?.instantiateViewController(withIdentifier: "SetNotePageController") as! SetNotePageController
                    SetNotePageController.noteValue = row.value
                    self.navigationController?.pushViewController(SetNotePageController, animated: true)
            }
            
            <<< LabelRow("ListTag"){
                $0.title = "List"
                if let listName = theTask?.listT?.listName {
                    $0.value = listName
                }else{
                    $0.value = "InBox"
                }
                
                }.onCellSelection{ cell, row in
                    
                    let controller = UIAlertController(title: "List",
                                                       message: nil,
                                                       preferredStyle: .actionSheet)
                    
                    var actions = [UIAlertAction]()
                    let handler = { (action: UIAlertAction) in
                        // Returns the first index where the specified value appears in the collection.
                        if let index = actions.index(of: action) {
                            print("index:\(index) title:\(action.title!)")
                            
                            if index == 0 {
                                row.value = action.title!
                                row.updateCell()
                            }else if index == actions.count - 1 {
                                print("cancel")
                            }else{
                                row.value = action.title!
                                row.updateCell()
                                self.listT = self.listTList[index - 1] // InBox = index:0...
                            }
                            
                        }
                    }
                    
                    // Add Button
                    controller.addAction(UIAlertAction(title: "InBox", style: .default, handler: handler))
                    for data in self.listTList{
                        controller.addAction(UIAlertAction(title: data.listName, style: .default, handler: handler))
                    }
                    controller.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: handler)) //action.count - 1
                    
                    actions = controller.actions
                    self.present(controller, animated: true, completion: nil)
        }
        
        
        form +++ Section("")
            <<< DateRow("DueDateTag") {
                $0.title = "Due Date"
                $0.value = theTask?.dueDate
                
            }
            
            <<< ActionSheetRow<String>("RepeatTag") {
                $0.title = "Repeat"
                
                $0.selectorTitle = "繰り返し"
                var repeatArray = ["毎月","毎週","毎日", "なし"]
                $0.options = repeatArray
                
                if let howRepeat = theTask?.howRepeat{
                    $0.value = repeatArray[howRepeat]
                }else{
                    $0.value = repeatArray[3]
                }
                
                }.onChange{row in
                    print(row.value as Any)
        }
        
        
        
        form +++ MultivaluedSection(multivaluedOptions: [.Reorder, .Insert, .Delete],
                                    header: "Reminder") {
                                        $0.addButtonProvider = { section in
                                            return ButtonRow(){
                                                $0.title = "Add"
                                            }
                                        }
                                        $0.multivaluedRowToInsertAt = { index in
                                            return DateTimeRow("NReminderTag_\(index+1)") {
                                                $0.title = ""
                                            }
                                        }
                                        
                                        if let remindList = self.theTask?.remindList {
                                            for (index,data) in remindList.enumerated() {
                                                $0 <<< DateTimeRow("ReminderTag_\(index+1)") {
                                                    $0.title = ""
                                                    $0.value = data.remDate
                                                }
                                            }
                                        }
        }
        
        form +++ Section("Option")
            <<< ActionSheetRow<String>("PriorityTag") {
                $0.title = "Priority"
                $0.selectorTitle = "set priority"
                $0.options = ["High","Middle","Low"]
                $0.value = "Middle"
                }.onChange{row in
                    print(row.value as Any)
            }
        
            <<< LabelRow("AssignTag"){
                $0.title = "Assign"
                if let assignName = theTask?.assign?.assignName {
                    $0.value = assignName
                }else{
                    $0.value = "自分"
                }
                
                }.onCellSelection{ cell, row in
                    
                    let controller = UIAlertController(title: "Assign",
                                                       message: nil,
                                                       preferredStyle: .actionSheet)
                    
                    var actions = [UIAlertAction]()
                    let handler = { (action: UIAlertAction) in
                        // Returns the first index where the specified value appears in the collection.
                        if let index = actions.index(of: action) {
                            print("index:\(index) title:\(action.title!)")
                            
                            if index == 0 {
                                row.value = action.title!
                                row.updateCell()
                            }else if index == actions.count - 1 {
                                print("cancel")
                            }else{
                                row.value = action.title!
                                row.updateCell()
                                self.assign = self.assignList[index - 1] // 自分 = index:0...
                            }
                            
                        }
                    }
                    
                    // Add Button
                    controller.addAction(UIAlertAction(title: "自分", style: .default, handler: handler))
                    for data in self.assignList{
                        controller.addAction(UIAlertAction(title: data.assignName, style: .default, handler: handler))
                    }
                    controller.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: handler)) //action.count - 1
                    
                    actions = controller.actions
                    self.present(controller, animated: true, completion: nil)
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}


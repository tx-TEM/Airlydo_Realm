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

class TaskDetailViewController: FormViewController {
    
    @IBOutlet weak var SaveTaskButton: UIBarButtonItem!
    
    var taskDetailModel: TaskDetailModel?
    
    var recvVal: String = ""
    
    var formProject: Project?
    var formAssign: Assign?
    
    @IBAction func SaveTaskButtonTapped(_ sender: UIButton) {
        let valuesDictionary = form.values()
        
        
        // Reminder
        let formReminderTags = [String](valuesDictionary.keys).filter({$0.contains("ReminderTag_")}).sorted()
        var formRemindList: [Date] = []
        
        for remTag in formReminderTags{
            formRemindList.append(valuesDictionary[remTag] as! Date)
        }
        
        if(taskDetailModel?.isNewTask)! {
            taskDetailModel?.newTask(formTaskName: valuesDictionary["TitleTag"] as! String,
                                     formNote: valuesDictionary["NoteTag"] as! String,
                                     formDueDate: valuesDictionary["DueDateTag"] as! Date,
                                     formHowRepeat: valuesDictionary["RepeatTag"] as! String,
                                     formPriority: valuesDictionary["PriorityTag"] as! String,
                                     formProject: formProject,
                                     formAssign: formAssign,
                                     formRemindList: formRemindList)
            
        }else{
            taskDetailModel?.editTask(formTaskName: valuesDictionary["TitleTag"] as! String,
                                      formNote: valuesDictionary["NoteTag"] as! String,
                                      formDueDate: valuesDictionary["DueDateTag"] as! Date,
                                      formHowRepeat: valuesDictionary["RepeatTag"] as! String,
                                      formPriority: valuesDictionary["PriorityTag"] as! String,
                                      formProject: formProject,
                                      formAssign: formAssign,
                                      formRemindList: formRemindList)
        }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func updateNote(note: String){
        let noteForm:LabelRow = form.rowBy(tag:"NoteTag") as! LabelRow
        noteForm.value = note
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if taskDetailModel == nil {
            taskDetailModel = TaskDetailModel()
        }
        
        form +++ Section("Task")
            <<< TextRow("TitleTag"){
                $0.title = "Add a Task"
                $0.value = taskDetailModel?.theTask?.taskName
            }
            <<< LabelRow("NoteTag"){
                $0.title = "Note"
                $0.value = taskDetailModel?.theTask?.note
                }.onCellSelection{ cell, row in
                    let SetNotePageController = self.storyboard?.instantiateViewController(withIdentifier: "SetNotePageController") as! SetNotePageController
                    SetNotePageController.noteValue = row.value
                    self.navigationController?.pushViewController(SetNotePageController, animated: true)
            }
            
            <<< LabelRow("ListTag"){
                $0.title = "List"
                if let listName = taskDetailModel?.theTask?.project?.projectName {
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
                            
                            if index == 0 {
                                row.value = action.title!
                                row.updateCell()
                            }else if index == actions.count - 1 {
                                print("cancel")
                            }else{
                                row.value = action.title!
                                row.updateCell()
                                self.formProject = self.taskDetailModel?.theProjectList[index - 1] // InBox = index:0...
                            }
                            
                        }
                    }
                    
                    // Add Button
                    controller.addAction(UIAlertAction(title: "InBox", style: .default, handler: handler))
                    if let projectList = self.taskDetailModel?.theProjectList {
                        
                        for data in projectList {
                            controller.addAction(UIAlertAction(title: data.projectName, style: .default, handler: handler))
                        }
                    }
                    
                    controller.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: handler)) //action.count - 1
                    
                    actions = controller.actions
                    self.present(controller, animated: true, completion: nil)
        }
        
        
        form +++ Section("")
            <<< DateRow("DueDateTag") {
                $0.title = "Due Date"
                $0.value = taskDetailModel?.theTask?.dueDate
                
            }
            
            <<< ActionSheetRow<String>("RepeatTag") {
                $0.title = "Repeat"
                
                $0.selectorTitle = "繰り返し"
                var repeatArray = ["毎月","毎週","毎日", "なし"]
                $0.options = repeatArray
                
                if let howRepeat = taskDetailModel?.theTask?.howRepeat{
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
                                        
                                        if let remindList = self.taskDetailModel?.theTask?.remindList {
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
                if let assignName = taskDetailModel?.theTask?.assign?.assignName {
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
                                self.formAssign = self.taskDetailModel?.assignList[index - 1] // 自分 = index:0...
                            }
                            
                        }
                    }
                    
                    // Add Button
                    controller.addAction(UIAlertAction(title: "自分", style: .default, handler: handler))
                    
                    if let assignList = self.taskDetailModel?.assignList {
                        
                        for data in assignList{
                            controller.addAction(UIAlertAction(title: data.assignName, style: .default, handler: handler))
                        }
                    }
                    
                    controller.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: handler)) //action.count - 1
                    
                    actions = controller.actions
                    self.present(controller, animated: true, completion: nil)
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


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
    var realm: Realm!
    
    // list for Form
    var listT : Results<ListOfTask>!
    var assign : Results<Assign>!
    
    // task: new or edit
    var newTask: Bool = true
    
    // taskData
    var theTask: Task?
    var recvVal: String = ""
    
    @IBAction func SaveTaskButtonTapped(_ sender: UIButton) {
        let valuesDictionary = form.values()
        
        //DB Process
        let reminderTags = [String](valuesDictionary.keys).filter({$0.contains("ReminderTag_")}).sorted()
        print(reminderTags)
        
        
        /*
        print(valuesDictionary["TitleTag"] as! String)
        print(valuesDictionary["NoteTag"] as! String)
        print(valuesDictionary["ListTag"] as! String)
        print(valuesDictionary["DueDateTag"] as! Date)
        print(valuesDictionary["RepeatTag"] as! String)
        print(valuesDictionary["PriorityTag"] as! String)
        print(valuesDictionary["AssignTag"] as! String)
        */
        
        print(valuesDictionary["RepeatTag"] as! String)

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
        
        // Get the default Realm
        realm = try! Realm()
        
        // Query Realm for all Tasks
        listT = realm.objects(ListOfTask.self)
        assign = realm.objects(Assign.self)
        
        if let taskID = theTask?.taskID{
            print("taskID\(taskID)")
        }
        if let taskName = theTask?.taskName{
            print("taskID\(taskName)")
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
                    $0.value = "なし"
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
                                print("InBox")
                            }else if index == actions.count - 1 {
                                print("cancel")
                            }else{
                                print("custom")
                                self.theTask?.listT = self.listT[index - 1] // InBox = index:0...
                            }
                            
                        }
                    }
                    
                    // Add Button
                    controller.addAction(UIAlertAction(title: "InBox", style: .default, handler: handler))
                    for data in self.listT{
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
                                            return DateTimeRow("ReminderTag_\(index+1)") {
                                                $0.title = ""
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
                                print("自分")
                            }else if index == actions.count - 1 {
                                print("cancel")
                            }else{
                                print("custom")
                                self.theTask?.assign = self.assign[index - 1] // 自分 = index:0...
                            }
                            
                        }
                    }
                    
                    // Add Button
                    controller.addAction(UIAlertAction(title: "自分", style: .default, handler: handler))
                    for data in self.assign{
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


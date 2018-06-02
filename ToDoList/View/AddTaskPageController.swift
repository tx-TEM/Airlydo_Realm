//
//  AddTaskPageController.swift
//  ToDoList
//
//  Created by yoshiki-t on 2018/05/22.
//  Copyright © 2018年 yoshiki-t. All rights reserved.
//


import UIKit
import Eureka

class AddTaskPageController: FormViewController {
    
    @IBOutlet weak var SaveTaskButton: UIBarButtonItem!
    
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
        print(values["TitleTag"] as! String)
        print(values["NoteTag"] as! String)
        print(values["ListTag"] as! String)
        print(values["DueDateTag"] as! Date)
        print(values["RepeatTag"] as! String)
        print(values["PriorityTag"] as! String)
        print(values["AssignTag"] as! String)
        */

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
            
        
            <<< ActionSheetRow<String>("ListTag") {
                $0.title = "List"
                $0.selectorTitle = "List"
                $0.options = ["なし"]
                
                if let theList = theTask?.listT {
                    $0.value = theList.listName
                }else{
                    $0.value = "なし"
                }
                
                }.onChange{row in
                    print(row.value as Any)
        }
        
        
        form +++ Section("")
            <<< DateRow("DueDateTag") {
                $0.title = "Due Date"
                $0.value = theTask?.dueDate
                
            }
            
            <<< ActionSheetRow<String>("RepeatTag") {
                $0.title = "Repeat"
                $0.selectorTitle = "繰り返し"
                var repeatArray = ["毎週","毎月","毎年", "なし"]
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
            <<< ActionSheetRow<String>("AssignTag") {
                $0.title = "Assign"
                $0.selectorTitle = "Assign"
                $0.options = ["自分"]
                $0.value = "自分"
                }.onChange{row in
                    print(row.value as Any)
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


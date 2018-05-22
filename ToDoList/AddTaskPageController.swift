//
//  AddTaskPageController.swift
//  ToDoList
//
//  Created by yoshiki-t on 2018/05/22.
//  Copyright © 2018年 yoshiki-t. All rights reserved.
//

import UIKit

import UIKit
import Eureka

class AddTaskPageController: FormViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        form +++ Section("Task")
            <<< TextRow("TextFiled"){
                $0.title = "Add a Task"
            }
            <<< LabelRow("areaTag"){
                $0.title = "Note"
                $0.value = "Note"
                }.onCellSelection{ cell, row in
                    cell.backgroundColor = .lightGray
            }
            
            
            
            <<< TextRow("aaa").cellSetup({ (cell, row) in
                cell.height = ({return 10})
            })
            
            <<< ActionSheetRow<String>("listTag") {
                $0.title = "List"
                $0.selectorTitle = "List"
                $0.options = ["なし"]
                $0.value = "なし"
                }.onChange{row in
                    print(row.value as Any)
        }
        
        
        form +++ Section("")
            <<< DateRow() {
                $0.title = "Due Date"
                $0.value = Date()
                
            }
            
            <<< ActionSheetRow<String>("repeatTag") {
                $0.title = "Repeat"
                $0.selectorTitle = "繰り返し"
                $0.options = ["毎週","毎月","毎年", "なし"]
                $0.value = "なし"
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
                                            return DateTimeRow() {
                                                $0.title = ""
                                            }
                                        }
        }
        
        form +++ Section("Option")
            <<< ActionSheetRow<String>("") {
                $0.title = "Priority"
                $0.selectorTitle = "set priority"
                $0.options = ["High","Middle","Low"]
                $0.value = "Middle"
                }.onChange{row in
                    print(row.value as Any)
            }
            <<< ActionSheetRow<String>("assignTag") {
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


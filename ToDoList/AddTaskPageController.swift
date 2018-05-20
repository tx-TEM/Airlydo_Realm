//
//  AddTaskPageController.swift
//  ToDoList
//
//  Created by yoshiki-t on 2018/05/19.
//  Copyright © 2018年 yoshiki-t. All rights reserved.
//

import UIKit
import Eureka

class AddTaskPageController: FormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        form +++ Section("タスク")
            <<< TextRow("TextFiled"){
                $0.title = "タイトル"
                $0.placeholder = "ここに書いてね"
            }
            <<< TextRow(){
                $0.title = "詳細"
                $0.placeholder = "ここに書いてね"
            }
            <<< DateRow() { $0.title = "期限"; $0.value = Date()}

        
        form +++ MultivaluedSection(multivaluedOptions: [.Reorder, .Insert, .Delete],
                           header: "リマインダー") {
                            $0.addButtonProvider = { section in
                                return ButtonRow(){
                                    $0.title = "追加"
                                }
                            }
                            $0.multivaluedRowToInsertAt = { index in
                                return DateTimeRow() {
                                    $0.title = "通知時刻"
                                }
                            }
                            $0 <<< DateTimeRow() {
                                $0.title = "通知時刻"
                            }
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

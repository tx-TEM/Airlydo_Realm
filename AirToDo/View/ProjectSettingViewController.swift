//
//  ProjectSettingViewController.swift
//  ToDoList
//
//  Created by yoshiki-t on 2018/06/25.
//  Copyright © 2018年 yoshiki-t. All rights reserved.
//

import UIKit
import Eureka

class ProjectSettingViewController: FormViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        form +++ Section("General")
            <<< TextRow("ProjectNameTag"){
                $0.title = "Project Name"
                $0.value = "ProjName"
            }
            
            <<< SwitchRow("NotificationTag"){
                $0.title = "Notification"
                $0.value = true
            }
        
        form +++ Section("Member")
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

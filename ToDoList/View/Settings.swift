//
//  Settings.swift
//  ToDoList
//
//  Created by Yuto Nakamura on 2018/06/12.
//  Copyright © 2018年 yoshiki-t. All rights reserved.
//

import UIKit
import Eureka

enum LanguageSelect: String{
    case English = "English"
    case Japanese = "Japanese"
    
    static func all() -> [LanguageSelect]{
        return [
            LanguageSelect.English,
            LanguageSelect.Japanese,
        ]
    }
}

class ViewController: FormViewController {
    var nickname = ""
    var alertOn = true
    var languageSelect = LanguageSelect.English
    var priority = 0
    
 
    override func viewDidLoad() {
        super.viewDidLoad()

           form
            // UserName
            +++ Section("User Name")
                <<< TextRow(){
                    $0.title = "Username"
                    $0.placeholder = "optional"
                    $0.onChange{ [unowned self] row in
                        self.nickname = row.value ?? ""
                }
            }
            // GeneralSettings
            +++ Section("General")
                <<< SwitchRow(){
                    $0.title = "alert"
                    $0.value = true
                    $0.onChange{ [unowned self] row in
                        self.alertOn = row.value ?? true
                    }
                }
                <<< PushRow<String>(){
                    $0.title = "Language"
                    $0.options = LanguageSelect.all().map{$0.rawValue}
                    $0.onChange{[unowned self] row in
                        self.languageSelect = LanguageSelect(rawValue: row.value!) ?? LanguageSelect.English
                    }
                }
                <<< SegmentedRow<String>(){
                    $0.title = "Priority"
                    $0.value = "0"
                    $0.options = ["0", "1", "2"]
                    $0.onChange{ [unowned self] row in
                        self.priority = Int(row.value ?? "0")!
                    }
                }
                /// Button
                +++ Section()
                <<< ButtonRow(){
                    $0.title = "Save"
                    $0.onCellSelection{ [unowned self] cell, row in
                        self.printAll()
                    }
                }
        
    }
    
    private func printAll(){
        print("Username:", nickname)
        print("Alrt:", (alertOn ? "On": "Off"))
        print("Language Select:", languageSelect.rawValue)
        print("Priority:", priority)
    }
}

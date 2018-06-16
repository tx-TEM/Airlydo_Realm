//
//  LeftViewModel_CustomList.swift
//  ToDoList
//
//  Created by yoshiki-t on 2018/06/12.
//  Copyright © 2018年 yoshiki-t. All rights reserved.
//

import Foundation
import RealmSwift

protocol LeftModelDelegate: class {
    func listDidChange()
    func errorDidOccur(error: Error)
}

class LeftModel {
    
    // Get the default Realm
    lazy var realm = try! Realm()
    var customListData: List<Project>!
    
    // Delegate
    weak var delegate: LeftModelDelegate?
    
    init() {
        
        if let list = realm.objects(ProjectWrapper.self).first?.projectList {
            customListData = list
        }else{
            let listTWrapper = ProjectWrapper()
            
            try! realm.write {
                realm.add(listTWrapper)
            }
            
            customListData = listTWrapper.projectList
        }
    }
    
    func addList(listName: String) {
        if(!(listName.isEmpty)) {
            let tempListT = Project()
            tempListT.projectName = listName
            
            try! self.realm.write {
                self.customListData.append(tempListT)
            }
        }        
        
        delegate?.listDidChange()
    }
    
    func reorder(sourceIndexPath: IndexPath, destinationIndexPath: IndexPath) {
        try! realm.write {
            let item = customListData[sourceIndexPath.row]
            customListData.remove(at: sourceIndexPath.row)
            customListData.insert(item, at: destinationIndexPath.row)
        }
    }
    
    
}

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
    
    var projectManager = ProjectManager()
    var customListData: List<Project>!
    
    // Delegate
    weak var delegate: LeftModelDelegate?
    
    init() {
        
       customListData = projectManager.readAllData()
    }
    
    func addList(projectName: String) {
        projectManager.addProject(projectList: customListData, projectName: projectName)
        
        delegate?.listDidChange()
    }
    
    func reorder(sourceIndexPath: IndexPath, destinationIndexPath: IndexPath) {
        projectManager.reorder(projectList: customListData, sourceIndexPath: sourceIndexPath, destinationIndexPath: destinationIndexPath)
    }
    
    
}

//
//  ProjectManager.swift
//  ToDoList
//
//  Created by yoshiki-t on 2018/06/20.
//  Copyright © 2018年 yoshiki-t. All rights reserved.
//

import Foundation
import RealmSwift

class ProjectManager {
    
    // Get the default Realm
    lazy var realm = try! Realm()
    
    // Read Project and Return List type
    func readAllData()-> List<Project> {
        if let list = realm.objects(ProjectWrapper.self).first?.projectList {
            return list
        }else{
            let listTWrapper = ProjectWrapper()
            
            try! realm.write {
                realm.add(listTWrapper)
            }
            
            return listTWrapper.projectList
        }
    }
    
    // Add new Project
    func addProject(projectList: List<Project>, projectName: String) {
        
        if(!(projectName.isEmpty)) {
            let tempProject = Project()
            tempProject.projectName = projectName
            
            try! self.realm.write {
                projectList.append(tempProject)
            }
        }
    }
    
    // reorder Project List
    func reorder(projectList: List<Project>, sourceIndexPath: IndexPath, destinationIndexPath: IndexPath) {
        try! realm.write {
            let tempProject = projectList[sourceIndexPath.row]
            projectList.remove(at: sourceIndexPath.row)
            projectList.insert(tempProject, at: destinationIndexPath.row)
        }
    }
}

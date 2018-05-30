//
//  LeftViewController.swift
//  ToDoList
//
//  Created by yoshiki-t on 2018/05/27.
//  Copyright © 2018年 yoshiki-t. All rights reserved.
//

import UIKit
import MobileCoreServices
import SlideMenuControllerSwift

class LeftViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITableViewDragDelegate, UITableViewDropDelegate {
    
    
    @IBOutlet weak var SlideListTable: UITableView!
    
    var listData: [String] = ["InBox", "Today", "All"]
    var customListData: [String] = ["Work", "Private", "Study"]
    
    let sectionTitle: [String] = ["Default", "Custom"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SlideListTable.dataSource = self
        SlideListTable.delegate = self
        
        SlideListTable.dragDelegate = self
        SlideListTable.dropDelegate = self
    
        SlideListTable.separatorStyle = .none
        
        SlideListTable.register(UINib(nibName: "SlideListCell", bundle: nil), forCellReuseIdentifier: "LeftView_SlideListCell")
        
        // Enable Drag
        SlideListTable.dragInteractionEnabled = true
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return sectionTitle.count
    }
    
    // Section Title
    /*
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitle[section]
    }
    */
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 {
            return listData.count
        } else if section == 1 {
            return customListData.count
        } else {
            return 0
        }
        
    }
    
    // return cell height (px)
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    // create new cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeftView_SlideListCell", for: indexPath) as! SlideListCell
        
        // Configure the cell...
        if indexPath.section == 0 {
            cell.textLabel?.text = "\(listData[indexPath.row])"
            cell.backgroundColor = UIColor.orange

        } else if indexPath.section == 1 {
            cell.textLabel?.text = "\(customListData[indexPath.row])"
            cell.backgroundColor = UIColor.green

        }
        
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // cell tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // deselect
        SlideListTable.deselectRow(at: indexPath, animated: true)
        
        // push view
        print("section:\(indexPath.section) , row:\(indexPath.row)")
        print()
    }
    
    // Drag and Drop
    // Provide Data for a Drag Session
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        
        // Get the Data
        let item = indexPath.section == 0 ? listData[indexPath.row] : customListData[indexPath.row]
        guard let data = item.data(using: .utf8) else { return [] }
        
        let itemProvider = NSItemProvider()
        itemProvider.registerDataRepresentation(forTypeIdentifier: kUTTypePlainText as String, visibility: .all) { completion in
            completion(data, nil)
            return nil
        }
        
        return [
            UIDragItem(itemProvider: itemProvider)
        ]
    }
    
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
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

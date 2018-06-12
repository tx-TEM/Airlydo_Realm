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
import RealmSwift

class LeftViewController: UIViewController {
    
    let leftModel = LeftModel()
    var listData: [String] = ["Inbox", "Today", "All"]
    
    @IBOutlet weak var SlideListTable: UITableView!
    @IBOutlet weak var CustomSlideListTable: UITableView!
    @IBOutlet weak var AddListButton: UIButton!

    @IBAction func AddListButtonTapped(_ sender: UIButton) {
        
        let controller = UIAlertController(title: "ListName",
                                           message: nil,
                                           preferredStyle: .alert)
        
        // OK Button
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: .default, handler:{
            (action: UIAlertAction!) -> Void in
            let textFields:Array<UITextField>? =  controller.textFields as Array<UITextField>?
            
            if textFields != nil {
                for textField:UITextField in textFields! {
                    self.leftModel.addList(listName: textField.text!)
                }
            }
            
        })
        
        // Cancel Button
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: .cancel, handler:{
            (action: UIAlertAction!) -> Void in
        })
        
        // add Button Action
        controller.addAction(cancelAction)
        controller.addAction(defaultAction)
        
        // add textfiled
        controller.addTextField(configurationHandler: {(text:UITextField!) -> Void in
        })
        
        // Display Alert
        self.present(controller, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SlideListTable.dataSource = self
        SlideListTable.delegate = self
        CustomSlideListTable.dataSource = self
        CustomSlideListTable.delegate = self

        SlideListTable.separatorStyle = .none
        SlideListTable.isScrollEnabled = false
        CustomSlideListTable.separatorStyle = .none

        SlideListTable.register(UINib(nibName: "SlideListCell", bundle: nil), forCellReuseIdentifier: "LSlideListCell")
        CustomSlideListTable.register(UINib(nibName: "SlideListCell", bundle: nil), forCellReuseIdentifier: "LCustomSlideListCell")
        
        leftModel.delegate = self
        
        // Enable Drag
        CustomSlideListTable.dragDelegate = self
        CustomSlideListTable.dropDelegate = self
        CustomSlideListTable.dragInteractionEnabled = true
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
}

extension LeftViewController: LeftModelDelegate {
    func listDidChange() {
        CustomSlideListTable.reloadData()
    }
    
    func errorDidOccur(error: Error) {
        print(error.localizedDescription)
    }
}


extension LeftViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if(tableView.tag == 0) {
            return listData.count
        }else{
            return leftModel.customListData.count
        }
    }
    
    // return cell height (px)
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    // create new cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SlideListCell
        if(tableView.tag == 0) {
            cell = tableView.dequeueReusableCell(withIdentifier: "LSlideListCell", for: indexPath) as! SlideListCell
            
            // Configure the cell...
            cell.textLabel?.text = "\(listData[indexPath.row])"
            cell.backgroundColor = UIColor.white
            
        }else{
            cell = tableView.dequeueReusableCell(withIdentifier: "LCustomSlideListCell", for: indexPath) as! SlideListCell
            
            // Configure the cell...
            cell.textLabel?.text = "\(leftModel.customListData[indexPath.row].listName)"
            cell.backgroundColor = UIColor.white
        }
        
        return cell
    }
    
    // Cell tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // deselect
        tableView.deselectRow(at: indexPath, animated: true)
        
        // get mainViewController instance
        if let slideMenuController = self.slideMenuController() {
            let NavigationController = slideMenuController.mainViewController as! UINavigationController
            let TaskPageViewController = NavigationController.topViewController as! TaskPageViewController
            
            if(tableView.tag == 0) {
                
                switch indexPath.row {
                case 0:
                    TaskPageViewController.taskPageModel.changeListInBox()
                case 1:
                    TaskPageViewController.taskPageModel.changeList()
                case 2:
                    TaskPageViewController.taskPageModel.changeList()
                default:
                    TaskPageViewController.taskPageModel.changeList()
                }
                
            }else{
                TaskPageViewController.taskPageModel.changeList(selectedList: leftModel.customListData[indexPath.row])
            }
            
        }
    }
    
    // Reorder Cell
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        leftModel.reorder(sourceIndexPath: sourceIndexPath, destinationIndexPath: destinationIndexPath)
    }

}


extension LeftViewController: UITableViewDragDelegate {
    // Provide Data for a Drag Session
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        
        // Get the Data
        let item = listData[indexPath.row]
        let itemProvider = NSItemProvider()
        
        itemProvider.registerDataRepresentation(forTypeIdentifier: kUTTypePlainText as String, visibility: .all) { completion in
            let data = item.data(using: .utf8)
            completion(data, nil)
            return nil
        }
        
        
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = item
        return [dragItem]
    }
    
}

extension LeftViewController: UITableViewDropDelegate{
    
    func tableView(_ tableView: UITableView, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: NSString.self)
    }
    
    
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        // The .move operation is available only for dragging within a single app.
        if tableView.hasActiveDrag {
            if session.items.count > 1 {
                return UITableViewDropProposal(operation: .cancel)
            } else {
                return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
            }
        } else {
            return UITableViewDropProposal(operation: .copy, intent: .insertAtDestinationIndexPath)
        }
    }
    
    
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        // someday
    }

}

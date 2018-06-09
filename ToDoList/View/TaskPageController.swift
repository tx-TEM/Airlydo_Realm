//
//  TaskPageController.swift
//  ToDoList
//
//  Created by yoshiki-t on 2018/05/16.
//  Copyright © 2018年 yoshiki-t. All rights reserved.
//

import UIKit
import RealmSwift
import MCSwipeTableViewCell
import SlideMenuControllerSwift

class TaskPageController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var TaskCellTable: UITableView!
    @IBOutlet weak var AddTaskButton: UINavigationItem!
    
    @IBAction func addTaskButtonTapped(_ sender: UIButton) {
        //performSegue(withIdentifier: "presentSecondViewController", sender: self)
        let AddTaskPageController = self.storyboard?.instantiateViewController(withIdentifier: "AddTaskPageController") as! AddTaskPageController
        AddTaskPageController.newTask = true // Set new Task
        self.navigationController?.pushViewController(AddTaskPageController, animated: true)
    }
    
    // Get the default Realm
    lazy var realm = try! Realm()
    var tasks : Results<Task>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(Realm.Configuration.defaultConfiguration.fileURL!)

        TaskCellTable.dataSource = self
        TaskCellTable.delegate = self
        TaskCellTable.register(UINib(nibName: "TaskCell", bundle: nil), forCellReuseIdentifier: "TaskPage_TaskCell")
        
        addLeftBarButtonWithImage(UIImage(named: "menu")!)
        
        // Query Realm for all Tasks
        let predicate = NSPredicate(format: "isArchive = false")
        tasks = realm.objects(Task.self).filter(predicate)
        
    }
    
    // reload Page
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        TaskCellTable.reloadData()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return tasks.count
    }
    
    // return cell height (px)
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    // create new cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskPage_TaskCell", for: indexPath) as! TaskCell
        
        let theTask = tasks[indexPath.row]
        
        // Configure the cell...
        cell.TaskTitleLabel.text = theTask.taskName
        cell.TaskInfoLabel.text = theTask.note
        if let assignName = theTask.assign?.assignName{
            cell.AssignLabel.text = assignName
        } else {
            cell.AssignLabel.text = "自分"

        }
        cell.DateLabel.text = "Date"
        
        //cell.label.text = dataList[indexPath.row]
        cell.defaultColor = .lightGray
        cell.firstTrigger = 0.1;
        cell.secondTrigger = 0.4
        
        // setup
        // cell.selectionStyle = .none
        // cell.textLabel?.text = dataList[indexPath.row]
        // cell.detailTextLabel?.text = "details..."
        // cell.detailTextLabel?.textColor = .lightGray
        
        
        cell.setSwipeGestureWith(UIImageView(image: UIImage(named: "check")), color: UIColor.green, mode: .exit, state: .state1, completionBlock: { [weak self] (cell, state, mode) in
            
            
            if let cell = cell, let indexPath = tableView.indexPath(for: cell) {
                // Send the task to archive
                try! self?.realm.write() {
                    self?.tasks[indexPath.row].isArchive = true
                }
            }
            self?.TaskCellTable.reloadData()
        })
        
        cell.setSwipeGestureWith(UIImageView(image: UIImage(named: "fav")), color: UIColor.blue, mode: .exit, state: .state2, completionBlock: { [weak self] (cell, state, mode) in
            
            
            if let cell = cell, let indexPath = tableView.indexPath(for: cell) {

                // delete task
                try! self?.realm.write() {
                    for theReminder in (self?.tasks[indexPath.row].remindList)! {
                        self?.realm.delete(theReminder)
                    }
                    self?.realm.delete((self?.tasks[indexPath.row])!)
                }
            }
            self?.TaskCellTable.reloadData()
        })
        
        cell.setSwipeGestureWith(UIImageView(image: UIImage(named: "check")), color: UIColor.green, mode: .exit, state: .state3, completionBlock: { [weak self] (cell, state, mode) in
            
            
            if let cell = cell, let indexPath = tableView.indexPath(for: cell) {
                //self?.dataList.remove(at: indexPath.row)
                // 該当のセルを削除
                //self?.tableView.deleteRows(at: [indexPath], with: .fade)
            }
        })
        
        cell.setSwipeGestureWith(UIImageView(image: UIImage(named: "check")), color: UIColor.yellow, mode: .exit, state: .state4, completionBlock: { [weak self] (cell, state, mode) in
            
            
            if let cell = cell, let indexPath = tableView.indexPath(for: cell) {
                //self?.dataList.remove(at: indexPath.row)
                // 該当のセルを削除
                //self?.tableView.deleteRows(at: [indexPath], with: .fade)
            }
        })

        return cell
    }
    
    // cell tapped
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // deselect
        tableView.deselectRow(at: indexPath, animated: true)
        
        // push view
        print("row:\(indexPath.row)")
        let AddTaskPageController = self.storyboard?.instantiateViewController(withIdentifier: "AddTaskPageController") as! AddTaskPageController
        AddTaskPageController.newTask = false // edit Task
        AddTaskPageController.theTask = self.tasks[indexPath.row]
        self.navigationController?.pushViewController(AddTaskPageController, animated: true)
        
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

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

class TaskListViewController: UIViewController {

    @IBOutlet weak var TaskCellTable: UITableView!
    @IBOutlet weak var AddTaskButton: UINavigationItem!
    @IBOutlet weak var MainButton: UIButton!
    @IBOutlet weak var ArchiveButton: UIButton!
    @IBOutlet weak var SortButton: UIButton!
    
    
    let taskListModel = TaskListModel()
    
    @IBAction func addTaskButtonTapped(_ sender: UIButton) {
        let TaskDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "TaskDetailViewController") as! TaskDetailViewController
        TaskDetailViewController.taskDetailModel = TaskDetailModel() // Set new Task
        self.navigationController?.pushViewController(TaskDetailViewController, animated: true)
    }
    
    @IBAction func mainButtonTapped(_ sender: UIButton) {
        taskListModel.isArchiveMode = false
        taskListModel.changeListOld()
    }

    @IBAction func archiveButtonTapped(_ sender: UIButton) {
        taskListModel.isArchiveMode = true
        taskListModel.changeListOld()
    }
    
    @IBAction func sortButtonTapped(_ sender: UIButton) {
        let SortViewController = self.storyboard?.instantiateViewController(withIdentifier: "SortViewController") as! SortViewController
        
        SortViewController.modalPresentationStyle = .overCurrentContext
        self.present(SortViewController, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = self.taskListModel.pageTitle
        
        // TableView
        TaskCellTable.dataSource = self
        TaskCellTable.delegate = self
        TaskCellTable.register(UINib(nibName: "TaskCell", bundle: nil), forCellReuseIdentifier: "TaskPage_TaskCell")
        
        taskListModel.delegate = self
        addLeftBarButtonWithImage(UIImage(named: "menu")!)
            
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

}

extension TaskListViewController: TaskListModelDelegate {
    func tasksDidChange() {
        self.navigationItem.title = self.taskListModel.pageTitle
        TaskCellTable.reloadData()
    }
    
    func errorDidOccur(error: Error) {
        print(error.localizedDescription)
    }
}

extension TaskListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return taskListModel.tasks.count
    }
    
    // return cell height (px)
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    // create new cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskPage_TaskCell", for: indexPath) as! TaskCell
        
        let theTask = taskListModel.tasks[indexPath.row]
        
        // Configure the cell...
        cell.TaskTitleLabel.text = theTask.taskName
        cell.TaskInfoLabel.text = theTask.note
        if let assignName = theTask.assign?.assignName{
            cell.AssignLabel.text = assignName
        } else {
            cell.AssignLabel.text = "自分"
            
        }
        
        cell.DateLabel.text = taskListModel.dueDateToString(dueDate: theTask.dueDate)
        
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
                // Genarate Repeat Task
                if(self?.taskListModel.tasks[indexPath.row].howRepeat != 3){
                    self?.taskListModel.genRepeatask(indexPath: indexPath)
                }
                
                // Send the Task to Archive
                self?.taskListModel.archiveTask(indexPath: indexPath)
            }
            self?.TaskCellTable.reloadData()
        })
        
        cell.setSwipeGestureWith(UIImageView(image: UIImage(named: "fav")), color: UIColor.blue, mode: .exit, state: .state2, completionBlock: { [weak self] (cell, state, mode) in
            
            
            if let cell = cell, let indexPath = tableView.indexPath(for: cell) {
                // Genarate Repeat Task
                if(self?.taskListModel.tasks[indexPath.row].howRepeat != 3){
                    self?.taskListModel.genRepeatask(indexPath: indexPath)
                }
                
                // Remove Task
                self?.taskListModel.deleteTask(indexPath: indexPath)
            }
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
        let TaskDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "TaskDetailViewController") as! TaskDetailViewController
        TaskDetailViewController.taskDetailModel = TaskDetailModel(task: self.taskListModel.tasks[indexPath.row])
        self.navigationController?.pushViewController(TaskDetailViewController, animated: true)
        
    }
}

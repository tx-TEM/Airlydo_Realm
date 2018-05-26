//
//  TaskPageController.swift
//  ToDoList
//
//  Created by yoshiki-t on 2018/05/16.
//  Copyright © 2018年 yoshiki-t. All rights reserved.
//

import UIKit
import MGSwipeTableCell

class TaskPageController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var TaskCellTable: UITableView!
    @IBOutlet weak var AddTaskButton: UINavigationItem!
    
    @IBAction func addTaskButtonTapped(_ sender: UIButton) {
        //performSegue(withIdentifier: "presentSecondViewController", sender: self)
        let AddTaskPageController = self.storyboard?.instantiateViewController(withIdentifier: "AddTaskPageController") as! AddTaskPageController
        self.navigationController?.pushViewController(AddTaskPageController, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        TaskCellTable.dataSource = self
        TaskCellTable.delegate = self
        
        TaskCellTable.register(UINib(nibName: "TaskCell", bundle: nil), forCellReuseIdentifier: "TaskPage_TaskCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 10
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    // return cell height (px)
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    // create new cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskPage_TaskCell", for: indexPath) as! TaskCell
        
        // Configure the cell...
        cell.TaskTitleLabel.text = "Aiueo"
        cell.TaskInfoLabel.text = "kakikukeko!!"
        cell.AssignLabel.text = "Taro"
        cell.DateLabel.text = "1/1"
        
        //configure left buttons
        cell.leftButtons = [MGSwipeButton(title: "", icon: UIImage(named:"check.png"), backgroundColor: .green),
                            MGSwipeButton(title: "", icon: UIImage(named:"fav.png"), backgroundColor: .blue)]
        cell.leftSwipeSettings.transition = .rotate3D
        
        //configure right buttons
        cell.rightButtons = [MGSwipeButton(title: "Delete", backgroundColor: .red),
                             MGSwipeButton(title: "More",backgroundColor: .lightGray)]
        cell.rightSwipeSettings.transition = .rotate3D

        
        return cell
    }
    
    /// セルが選択された時に呼ばれるデリゲートメソッド
    //func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

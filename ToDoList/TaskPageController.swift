//
//  TaskPageController.swift
//  ToDoList
//
//  Created by yoshiki-t on 2018/05/16.
//  Copyright © 2018年 yoshiki-t. All rights reserved.
//

import UIKit

class TaskPageController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var TaskCellTable: UITableView!
    
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

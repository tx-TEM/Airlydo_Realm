//
//  SetNotePageController.swift
//  ToDoList
//
//  Created by yoshiki-t on 2018/05/22.
//  Copyright © 2018年 yoshiki-t. All rights reserved.
//

import UIKit

class SetNotePageController: UIViewController {

    @IBOutlet weak var NoteTextView: UITextView!
    @IBOutlet weak var SaveNoteButton: UIBarButtonItem!
    
    var noteValue: String? = ""
    
    @IBAction func SaveNoteButtonTapped(_ sender: UIButton) {
        let count = (self.navigationController?.viewControllers.count)! - 2
        let TaskDetailViewController = self.navigationController?.viewControllers[count] as! TaskDetailViewController
        TaskDetailViewController.recvVal = NoteTextView.text
        TaskDetailViewController.updateNote()
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NoteTextView.text = noteValue

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

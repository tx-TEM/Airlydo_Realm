//
//  ContainerViewController.swift
//  ToDoList
//
//  Created by yoshiki-t on 2018/05/27.
//  Copyright © 2018年 yoshiki-t. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

class ContainerViewController: SlideMenuController {
    
    override func awakeFromNib() {
        if let mainVC = self.storyboard?.instantiateViewController(withIdentifier: "Main"){
            self.mainViewController = mainVC
        }
        
        if let leftVC = self.storyboard?.instantiateViewController(withIdentifier: "Left"){
            self.leftViewController = leftVC
        }
        
        super.awakeFromNib()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

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

//
//  TaskCell.swift
//  ToDoList
//
//  Created by yoshiki-t on 2018/05/17.
//  Copyright © 2018年 yoshiki-t. All rights reserved.
//

import UIKit
import MCSwipeTableViewCell

class TaskCell: MCSwipeTableViewCell {

    @IBOutlet weak var TaskTitleLabel: UILabel!
    @IBOutlet weak var TaskInfoLabel: UILabel!
    @IBOutlet weak var AssignLabel: UILabel!
    @IBOutlet weak var DateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

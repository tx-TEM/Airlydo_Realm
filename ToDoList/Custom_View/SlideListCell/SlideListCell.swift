//
//  SlideListCell.swift
//  ToDoList
//
//  Created by yoshiki-t on 2018/05/28.
//  Copyright © 2018年 yoshiki-t. All rights reserved.
//

import UIKit

class SlideListCell: UITableViewCell {
    
    @IBOutlet weak var ListLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        ListLabel.text = ""
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

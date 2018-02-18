//
//  NameCell.swift
//  TaskManager
//
//  Created by Divya Basappa on 2/14/18.
//  Copyright © 2018 Divya Basappa. All rights reserved.
//

import UIKit

class NameCell: UITableViewCell {

    @IBOutlet weak var taskNameTextFeild: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func customInit(taskName: String) {
        self.taskNameTextFeild.text = taskName
    }
    
}

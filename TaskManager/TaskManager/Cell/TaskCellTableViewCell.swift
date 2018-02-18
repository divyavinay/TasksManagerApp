//
//  TaskCellTableViewCell.swift
//  TaskManager
//
//  Created by Divya Basappa on 2/14/18.
//  Copyright © 2018 Divya Basappa. All rights reserved.
//

import UIKit

class TaskCellTableViewCell: UITableViewCell {


    @IBOutlet weak var taskName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func customInit(name: String) {
        self.taskName.text = name
        
    }
    
}

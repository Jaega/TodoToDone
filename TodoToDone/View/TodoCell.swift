//
//  TodoCell.swift
//  TodoToDone
//
//  Created by Xinzhao Li on 7/14/19.
//  Copyright © 2019 Jaega. All rights reserved.
//

import UIKit

class TodoCell: UITableViewCell {

    @IBOutlet weak var TodoItemLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

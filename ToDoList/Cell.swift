//
//  Cell.swift
//  ToDoList
//
//  Created by Ashok on 3/17/17.
//  Copyright © 2017 Ashok. All rights reserved.
//

import UIKit

class Cell: UITableViewCell {

    @IBOutlet weak var itemTitle: UILabel!
        override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

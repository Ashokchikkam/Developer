//
//  DataTableViewCell.swift
//  sampleNotes
//
//  Created by Ashok on 2/28/17.
//  Copyright © 2017 Ashok. All rights reserved.
//

import UIKit

class DataTableViewCell: UITableViewCell {

    //MARK: Properties
    
    @IBOutlet weak var title: UITextView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

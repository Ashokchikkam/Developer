//
//  DataModel.swift
//  sampleNotes
//
//  Created by Ashok on 2/28/17.
//  Copyright © 2017 Ashok. All rights reserved.
//

import Foundation
import UIKit

class DataModel {
    
    //MARK: Properties
    
    var title: String
    var info: String?
    
    init?(title: String, info: String?) {
        
        // Initialization should fail if there is no name or if the rating is negative.
        if title.isEmpty{
            return nil
        }
        
        // Initialize stored properties.
        self.title = title
        self.info = info
        
    }
    
}

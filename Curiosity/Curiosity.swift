//
//  Curiosity.swift
//  Curiosity
//
//  Created by Ashok on 4/7/17.
//  Copyright © 2017 Ashok. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class Curiosity {
    
    
    //MARK: Properties
    private var _image: UIImage?
    
    var image: UIImage?{
        set{
            _image = image
        }
        get{
            return _image
        }
    }

    //MARK: Initialization
    init(image: UIImage) {
        _image = image
    }

}

//
//  CuriosityCell.swift
//  Curiosity
//
//  Created by Ashok on 4/7/17.
//  Copyright © 2017 Ashok. All rights reserved.
//

import UIKit
import Alamofire
import ImageIO

class CuriosityCell: UICollectionViewCell {
    
    //MARK: Properties
    @IBOutlet weak var imageOutlet: UIImageView!
    
    var curiosity: Curiosity!
    
    func configureCell(curiosity: Curiosity) {
        imageOutlet.image = curiosity.image
        imageOutlet.isHidden = false
        print("inside curiosity cell configuring cell")
    }
    
}

//
//  ArtClass.swift
//  My_First_MapApp
//
//  Created by Ashok on 7/24/17.
//  Copyright © 2017 Ashok. All rights reserved.
//

import Foundation

import MapKit

class ArtClass: NSObject, MKAnnotation  {
    
    let title: String?
    let  coordinate: CLLocationCoordinate2D
    
    init(title: String, coordinate: CLLocationCoordinate2D){
        self.title = title
        self.coordinate = coordinate
        
        super.init()
    }
    
    
    
}

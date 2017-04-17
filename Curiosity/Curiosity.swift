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
    
    
    private var _indexValue: Int?
    private var _image: UIImage?
    
    var image: UIImage?{
        set{
            _image = image
        }
        get{
            return _image
        }
    }

    
    var indexValue: Int?{
        
        return _indexValue
    }
    
    init(indexValue: Int?) {
        _indexValue = indexValue
        print("initializing indexValue")
    }
    
    
    
    private var _imageURL: URL?
    
    var imageURL: URL?{
        return _imageURL
    }
    init(imageURL: URL?) {
        _imageURL = imageURL
    }
//
    init(image: UIImage) {
        _image = image
    }
//    func loadData(indexValue: Int) -> UIImage? {
//        
//        Alamofire.request(BASE_URL).responseJSON{ response in
//            if let dict = response.result.value as? Dictionary<String, AnyObject>{
//                if let photos = dict["photos"] as? [Dictionary<String, AnyObject>], photos.count > 0{
//                    if let img_src = photos[indexValue]["img_src"] as? URL{
//                        print("inside Model indexValue:\(indexValue), img_src:\(img_src)")
//                        
//                        DispatchQueue.global().async {
//                            do {
//                                let data = try Data(contentsOf: img_src)
//                                DispatchQueue.global().sync {
//                                    
//                                    print("Sample test")
//                                    self._image = UIImage(data: data)
//                                }
//                            } catch  {
//                                print("unable to find the image at the given url")
//                                //handle the error
//                            }
//                        }
//                    }
//                }
//            }
//        }
//        
//        return _image
//    }
//
    
    
}

//
//  CuriosityCell.swift
//  Curiosity
//
//  Created by Ashok on 4/7/17.
//  Copyright © 2017 Ashok. All rights reserved.
//

import UIKit
import Alamofire

class CuriosityCell: UICollectionViewCell {
    
    
    @IBOutlet weak var imageOutlet: UIImageView!
    
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    var curiosity: Curiosity!
    
    func configureCell(curiosity: Curiosity) {
        loading.isHidden = false
        imageOutlet.isHidden = true
        self.curiosity = curiosity
        
        if let img_url = curiosity.imageURL{
//            var temp = String(describing: img_url)
//            temp = temp.replacingOccurrences(of: ".JPG", with: "s.JPG")
            DispatchQueue.global().async {
                do {
                    let data = try Data(contentsOf: img_url)
                    DispatchQueue.global().sync {
                        
                        print("Sample test")
                        self.loading.isHidden = true
                        self.imageOutlet.isHidden = false
                        self.imageOutlet.image = UIImage(data: data)
                    }
                } catch  {
                    print("unable to find the image at the given url")
                    //handle the error
                }
            }
            
            print("inside configuring cell")
        }
        
        print("inside configuring cell")
    }
    
    //    func configureCell(curiosity: Curiosity) {
    //        self.curiosity = curiosity
    //
    //        Alamofire.request(BASE_URL).responseJSON{ response in
    //            if let dict = response.result.value as? Dictionary<String, AnyObject>{
    //                if let photos = dict["photos"] as? [Dictionary<String, AnyObject>], photos.count > 0{
    //                    if let img_src = photos[curiosity.indexValue!]["img_src"] as? URL{
    //
    //                        DispatchQueue.global().async {
    //                            do {
    //                                let data = try Data(contentsOf: img_src)
    //                                DispatchQueue.global().sync {
    //
    //                                    print("Sample test")
    //                                    self.imageOutlet.image = UIImage(data: data)
    //                                }
    //                            } catch  {
    //                                print("unable to find the image at the given url")
    //                                //handle the error
    //                            }
    //                        }
    //
    //                    }
    //                }
    //            }
    //        }
    //
    // self.imageOutlet.image = curiosity.image
    //
    //        if let img_url = curiosity.imageURL{
    //
    //            DispatchQueue.global().async {
    //                do {
    //                    let data = try Data(contentsOf: img_url)
    //                    DispatchQueue.global().sync {
    //
    //                        print("Sample test")
    //                        self.imageOutlet.image = UIImage(data: data)
    //                    }
    //                } catch  {
    //                    print("unable to find the image at the given url")
    //                    //handle the error
    //                }
    //            }
    //
    //            print("inside configuring cell")
    //        }
    
    
}

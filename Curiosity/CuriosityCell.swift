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
                
                let img_src = CGImageSourceCreateWithURL((img_url as? CFURL)!, nil)
                let scale = UIScreen.main.scale
                print("scale value: \(scale)")
                
                
                let w = self.imageOutlet.bounds.size.width * CGFloat(scale)
                print("image outlet width: \(self.imageOutlet.bounds.size.width)")
                print("width: \(w)")
                
                // Create thumbnail options
                let options: [NSObject: AnyObject] = [
                    kCGImageSourceShouldAllowFloat : true as AnyObject,
                    kCGImageSourceCreateThumbnailWithTransform : true as AnyObject,
                    kCGImageSourceCreateThumbnailFromImageAlways : true as AnyObject,
                    kCGImageSourceThumbnailMaxPixelSize: w as AnyObject
                ]
                let imref = CGImageSourceCreateThumbnailAtIndex(img_src!, 0, options as CFDictionary?)
                let im = UIImage(cgImage: imref!)
                DispatchQueue.global().sync {
                    self.loading.isHidden = true
                    self.imageOutlet.isHidden = false
                    self.imageOutlet.image = im
                }
                
                
                var img_size: NSData = NSData(data: UIImageJPEGRepresentation(im, 1)!)
                
                print("size of the loaded image: \(Double(img_size.length))")
                
                print("inside configuring cell")
            }
            
            print("inside configuring cell")
        }
    }
    //BELOW CODE WORKS FINE...
    /*
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
     */
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

//
//  ViewController.swift
//  Curiosity
//
//  Created by Ashok on 4/6/17.
//  Copyright © 2017 Ashok. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    //Mark: Properties
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var collection: UICollectionView!
    
    var curiosity: Curiosity?
    var urlData: [Dictionary<String, AnyObject>]?
    
    private weak var timer: Timer?
    private var imageSet = [UIImage]()
    var x = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("inside viewdidload")
        loadApi()
//        Alamofire.request(BASE_URL).responseJSON{ response in
//            if let dict = response.result.value as? Dictionary<String, AnyObject>{
//                self.urlData = dict["photos"] as? [Dictionary<String, AnyObject>]
//                print("inside loadApi")
//            }
//        }
        collection.delegate = self
        collection.dataSource = self
        //loadApi()
        
        //curiosity = Curiosity(indexValue: 0, image: nil)
        //To load BackGround images from web.
        loadBgImages()
        
        //Calling changeBGImage every 4 seconds gives the changing background.
        timer = Timer.scheduledTimer(withTimeInterval: 4, repeats: true){_ in
            self.changeBGImage()
        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if urlData != nil{
            print("number of items:\(urlData?.count)")
            return (urlData?.count)!
        }
        else{
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CuriosityCell", for: indexPath) as? CuriosityCell
        
        //curiosity = Curiosity(indexValue: indexPath.row)
        let tempUrl = getImgUrlAtIndexPath(indexValue: indexPath.row)
        
        curiosity = Curiosity(imageURL: tempUrl)
        
        print("inside cell for row at imageURL:\(curiosity?.imageURL)")
        
        cell?.configureCell(curiosity: curiosity!)
        
        return cell!
    }
    
    //To load the Api which consists of all the image_url's we need to display the images.
    func loadApi(){
        print("before calling the request")
        Alamofire.request(BASE_URL).responseJSON{ response in
            if let dict = response.result.value as? Dictionary<String, AnyObject>{
                 self.urlData = dict["photos"] as? [Dictionary<String, AnyObject>]
                print("inside loadApi")
                print("Dictionary Count:\(self.urlData?.count)")
                print("\(self.urlData!)")
                self.collection.reloadData()
            }
        }

        
    }
    
    func getImgUrlAtIndexPath(indexValue: Int) -> URL? {
        
        if let temp = urlData?[indexValue]{
            if let img_src = temp["img_src"] as? String{
                return URL(string: img_src)
            }
        }
        print("returning nil at getImgUrlAtIndexPath method")
        return nil
    }
    
    func loadBgImages(){
        
        //Add any background images to the bgSet.
        var bgSet = [String]()
        let bg01 = "https://www.nasa.gov/centers/ames/images/content/671125main_msl20110519_PIA14156.jpg"
        let bg02 = "http://www.manilalivewire.com/wp-content/uploads/2015/08/Mars-Curiosity-Rover-with-Laser-0301-960x700.jpg"
        let bg03 = "http://news.nationalgeographic.com/content/dam/news/photos/000/578/57828.jpg"
        let bg04 = "http://www.hdwallpapers.org/walls/nasa-curiosity-mars-rover-wide.jpg"
        //let bg05 = "https://www.nasa.gov/centers/ames/images/content/671125main_msl20110519_PIA14156.jpg"
        
        
        bgSet += [bg01, bg02, bg03, bg04]
        
        for bg in bgSet{
            loadImage(url: bg)
        }
    }
    
    //To load the images from the web.
    func loadImage(url: String){
        let url = URL(string: url)!
        var bgImage: UIImage?
        
        DispatchQueue.global().async {
            do {
                let data = try Data(contentsOf: url)
                DispatchQueue.global().sync {
                    bgImage = UIImage(data: data)
                    self.imageSet.append(bgImage!)
                    
                    //self.videoPreviewImage.image = UIImage(data: data)
                }
            } catch  {
                print("unable to find the image at the given url")
                //handle the error
            }
        }
    }
    
    //To change BackGround Images continously.
    func changeBGImage(){
        let crossFading: CABasicAnimation = CABasicAnimation(keyPath: "contents")
        
        if(x == imageSet.count-1){
            
            x=0
        }
        crossFading.duration = 2
        crossFading.fromValue = imageSet[x].cgImage
        crossFading.toValue = imageSet[x + 1].cgImage
        bgImageView.image = imageSet[x+1]
        bgImageView.layer.add(crossFading, forKey: "animateContents")
        
        x += 1
    }
    
}

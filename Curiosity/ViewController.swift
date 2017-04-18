//
//  ViewController.swift
//  Curiosity
//
//  Created by Ashok on 4/6/17.
//  Copyright © 2017 Ashok. All rights reserved.
//

import UIKit
import CoreData
import ImageIO
import Alamofire

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, NSFetchedResultsControllerDelegate {
    
    //Mark: Properties
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var collection: UICollectionView!
    
    var curiosity: Curiosity?
    var urlData: [Dictionary<String, AnyObject>]?
    
    var controller: NSFetchedResultsController<Item>!
    
    //var controller: NSFetchedResultsController<CuriosityDataModel>!
    
    
    private weak var timer: Timer?
    private var imageSet = [UIImage]()
    var bgImageCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //loadApi()
        attemptFetch()
        
        //below method needs to be called only once in the lifetime of an app. Its been used to load the API
        loadInitialData()
        
        print("inside viewdidload")
        
        collection.delegate = self
        collection.dataSource = self
        
        //To load BackGround images from web.
        loadBgImages()
        
        
        //Calling changeBGImage every 4 seconds gives the changing background.
        timer = Timer.scheduledTimer(withTimeInterval: 4, repeats: true){_ in
            self.changeBGImage()
        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        DispatchQueue.main.async {
            print("saving the object to core data")
            ad.saveContext()
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let objs = controller.fetchedObjects , objs.count > 0 {
            print("number of objects in collection: \(objs.count)")
            return objs.count
        }
        print("returning zero number of items.")
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CuriosityCell", for: indexPath) as? CuriosityCell
        
        configureCell(cell: cell!, indexPath: indexPath as NSIndexPath)
        return cell!
    }
    
    //    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    //        if let objs = controller.fetchedObjects , objs.count > 0 {
    //            let item = objs[indexPath.row]
    //            print("inside did select item")
    //            performSegue(withIdentifier: "ItemDetailsVC", sender: item)
    //        }
    //    }
    //
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "ItemDetailsVC" {
            
            guard let destination = segue.destination as? DetailsVC else {
                fatalError("Unexpected Destination")
            }
            guard let itemCell = sender as? CuriosityCell else {
                fatalError("Unexpected cell")
            }
            guard let indexPath = collection.indexPath(for: itemCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let detailItem = controller.object(at: indexPath)
            
            destination.detailItem = detailItem
            print("inside prepare for segue")
            
        }
        
    }
    
    
    func configureCell(cell: CuriosityCell, indexPath: NSIndexPath) {
        
        print("cell number:\(indexPath.row) loaded")
        
        let obj = controller.object(at: indexPath as IndexPath)
        print(" camera value: \(obj.camera!)")
        
        if !obj.thumbnailisLoaded{
            obj.thumbnailisLoaded = true
            DispatchQueue.global().async {
                
                if let tempImageUrl = obj.imageURL{
                    if let img_src = CGImageSourceCreateWithURL(URL(string: tempImageUrl) as! CFURL, nil){
                        let scale = UIScreen.main.scale
                        print("scale value: \(scale)")
                        
                        let w = cell.imageOutlet.bounds.size.width * CGFloat(scale)
                        print("image outlet width: \(cell.imageOutlet.bounds.size.width)")
                        print("width: \(w)")
                        
                        // Create thumbnail options
                        let options: [NSObject: AnyObject] = [
                            kCGImageSourceShouldAllowFloat : true as AnyObject,
                            kCGImageSourceCreateThumbnailWithTransform : true as AnyObject,
                            kCGImageSourceCreateThumbnailFromImageAlways : true as AnyObject,
                            kCGImageSourceThumbnailMaxPixelSize: w as AnyObject
                        ]
                        if let imref = CGImageSourceCreateThumbnailAtIndex(img_src, 0, options as CFDictionary?){
                            let im = UIImage(cgImage: imref)
                            
                            let x: NSData = NSData(data: UIImageJPEGRepresentation(im, 1)!)
                            obj.thumbnail = x
                            
                            DispatchQueue.main.async {
                                
                                self.curiosity = Curiosity(image: im)
                                print("inside main .async ")
                                //cell.imageOutlet.image = UIImage(data: obj.thumbnail as! Data)
                            }
                            //ad.saveContext()
                            
                            let img_size: NSData = NSData(data: UIImageJPEGRepresentation(im, 1)!)
                            
                            print("size of the loaded image: \(Double(img_size.length))")
                        }
                        else{
                            print("unable to load thumbnail image")
                        }
                        
                    }
                    else{
                        print("image source not found at the given image url at index value: \(indexPath.row)")
                    }
                }
                else{
                    print("imageUrl not found at the index value: \(indexPath.row)")
                }
                
                
                //let im = UIImage(cgImage: imref!)
                
            }
            
            print("inside configuring cell")
        }
        else if obj.thumbnail != nil{
            let tempImage = UIImage(data: obj.thumbnail as! Data)
            
            self.curiosity = Curiosity(image: tempImage!)
            cell.imageOutlet.image = UIImage(data: obj.thumbnail as! Data)
        }
    }
    
    
    
    func attemptFetch() {
        
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        
        let imageIdSort = NSSortDescriptor(key: "imageId", ascending: true)
        
        fetchRequest.sortDescriptors = [imageIdSort]
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        controller.delegate = self
        
        self.controller = controller
        
        do {
            
            try controller.performFetch()
            
        } catch {
            
            let error = error as NSError
            print("\(error)")
            
        }
        
    }
    
    
    //Loading initial Data, Loading image_URL's into CoreData.
    func loadInitialData() {
        if(!UserDefaults.standard.bool(forKey: "firstlaunch1.0")){
            //Put any code here and it will be executed only once.
            print("inside loadInitialData")
            Alamofire.request(BASE_URL).responseJSON{ response in
                if let dict = response.result.value as? Dictionary<String, AnyObject>{
                    if let data = dict["photos"] as? [Dictionary<String, AnyObject>]{
                        print("urlData:")
                        for row in data{
                            
                            let newItem = Item(context: context)
                            
                            if let img_src = row["img_src"] as? String{
                                
                                
                                newItem.thumbnailisLoaded = false
                                newItem.imageURL = img_src
                                print("Adding a new item.")
                            }
                            if let camera = row["camera"] as? Dictionary<String, AnyObject>{
                                if let cameraName = camera["name"] as? String{
                                    newItem.camera = cameraName
                                }
                            }
                            if let id = row["id"] as? NSInteger{
                                newItem.imageId = Int32(id)
                            }
                            //ad.saveContext()
                        }
                        
                        //self.collection.reloadData()
                        print("Dictionary Count:\(data.count)")
                        
                    }
                    print("inside loadApi")
                    //print("\(self.urlData!)")
                    self.collection.reloadData()
                }
            }
            
            
            print("Is a first launch")
            UserDefaults.standard.set(true, forKey: "firstlaunch1.0")
            UserDefaults.standard.synchronize();
        }
    }
    
    
    
    //To load the Api which consists of all the image_url's we need to display images.
    func loadApi(){
        print("before calling the request")
        Alamofire.request(BASE_URL).responseJSON{ response in
            if let dict = response.result.value as? Dictionary<String, AnyObject>{
                self.urlData = dict["photos"] as? [Dictionary<String, AnyObject>]
                print("inside loadApi")
                print("Dictionary Count:\(self.urlData?.count)")
                //print("\(self.urlData!)")
                self.collection.reloadData()
            }
        }
    }
    
    //Helper method to retrieve the imageURL from the Api loaded
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
        let bg05 = "https://www.nasa.gov/centers/ames/images/content/671125main_msl20110519_PIA14156.jpg"
        
        
        bgSet += [ bg01, bg05, bg02, bg03, bg04]
        
        for bg in bgSet{
            
            loadImage(url: bg)
            print("loading the background image")
        }
    }
    
    //To load the images from the web.
    func loadImage(url: String){
        let url = URL(string: url)!
        
        DispatchQueue.global().async {
            do {
                let data = try Data(contentsOf: url)
                DispatchQueue.global().sync {
                    if let bgImage = UIImage(data: data){
                        self.imageSet.append(bgImage)
                    }
                    else{
                        print("bgimage is nil")
                    }
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
        if imageSet.count > 1{
            let crossFading: CABasicAnimation = CABasicAnimation(keyPath: "contents")
            
            if(bgImageCount == imageSet.count-1){
                bgImageCount = 0
            }
            crossFading.duration = 2
            crossFading.fromValue = imageSet[bgImageCount].cgImage
            crossFading.toValue = imageSet[bgImageCount + 1].cgImage
            bgImageView.image = imageSet[bgImageCount+1]
            bgImageView.layer.add(crossFading, forKey: "animateContents")
            
            bgImageCount += 1
        }
    }
    
    
}

//
//
//func configureCell(cell: CuriosityCell, indexPath: NSIndexPath) {
//
//    print("cell number:\(indexPath.row) loaded")
//
//    let obj = controller.object(at: indexPath as IndexPath)
//    print(" camera value: \(obj.camera!)")
//
//    if !obj.thumbnailisLoaded{
//        obj.thumbnailisLoaded = true
//        DispatchQueue.global().async {
//
//
//            let img_src = CGImageSourceCreateWithURL(URL(string: obj.imageURL!) as! CFURL, nil)
//            let scale = UIScreen.main.scale
//            print("scale value: \(scale)")
//
//            let w = cell.imageOutlet.bounds.size.width * CGFloat(scale)
//            print("image outlet width: \(cell.imageOutlet.bounds.size.width)")
//            print("width: \(w)")
//
//            // Create thumbnail options
//            let options: [NSObject: AnyObject] = [
//                kCGImageSourceShouldAllowFloat : true as AnyObject,
//                kCGImageSourceCreateThumbnailWithTransform : true as AnyObject,
//                kCGImageSourceCreateThumbnailFromImageAlways : true as AnyObject,
//                kCGImageSourceThumbnailMaxPixelSize: w as AnyObject
//            ]
//            if let imref = CGImageSourceCreateThumbnailAtIndex(img_src!, 0, options as CFDictionary?){
//                let im = UIImage(cgImage: imref)
//
//                let x: NSData = NSData(data: UIImageJPEGRepresentation(im, 1)!)
//                obj.thumbnail = x
//
//                DispatchQueue.main.async {
//
//                    self.curiosity = Curiosity(image: im)
//                    print("inside main .async ")
//                    //cell.imageOutlet.image = UIImage(data: obj.thumbnail as! Data)
//
//
//                }
//                //ad.saveContext()
//
//                let img_size: NSData = NSData(data: UIImageJPEGRepresentation(im, 1)!)
//
//                print("size of the loaded image: \(Double(img_size.length))")
//            }
//            else{
//                print("unable to load thumbnail image")
//            }
//            //let im = UIImage(cgImage: imref!)
//
//        }
//
//        print("inside configuring cell")
//    }
//    else if obj.thumbnail != nil{
//        let tempImage = UIImage(data: obj.thumbnail as! Data)
//
//        self.curiosity = Curiosity(image: tempImage!)
//        cell.imageOutlet.image = UIImage(data: obj.thumbnail as! Data)
//    }
//}
//    

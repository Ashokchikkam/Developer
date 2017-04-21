//
//  DetailsVC.swift
//  Curiosity
//
//  Created by Ashok on 4/18/17.
//  Copyright © 2017 Ashok. All rights reserved.
//

import UIKit
import ImageIO

class DetailsVC: UIViewController, UIScrollViewDelegate {
    
    var detailItem: Item?
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var imageOutlet: UIImageView!
    @IBOutlet weak var cameraLabel: UILabel!
    @IBOutlet weak var doneOutlet: UIButton!

    @IBOutlet weak var scrollView: UIScrollView!

    var currentImageData: Data? { didSet { updateUI() } }
    var scale: CGFloat = 0.9 { didSet { updateView() } }
    var viewHeight: CGFloat?
    var viewWidth: CGFloat?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateUI()
        
        //let handler = #selector(self.changeScale(byReactingTo:))
        let pinchRecognizer = UIPinchGestureRecognizer(target: self, action: nil)
        self.scrollView.addGestureRecognizer(pinchRecognizer)
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handlerForTapping))
        self.scrollView.addGestureRecognizer(tapRecognizer)
        
        self.scrollView.minimumZoomScale = 0.7
        self.scrollView.maximumZoomScale = 3.0
        self.scrollView.contentSize = self.imageOutlet.frame.size
        self.scrollView.delegate = self
        
        print("inside detailvc's view did load)")
        if detailItem != nil{
            loadItemData()
            
        }
        // Do any additional setup after loading the view.
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        
        print("inside view for zooming")
        return self.imageOutlet
        
    }
    
    
    
    private func updateUI(){
        
        //mainVerticalStackView.spacing = UIScreen.main.bounds.size.height - doneOutlet.bounds.size.height - cameraLabel.bounds.size.height - 16
        
        
        print("inside updateUI")
        
        if let cameraName = detailItem?.camera{
            cameraLabel.text = "Camera: \(cameraName)"
        }
        
        if currentImageData != nil{
            
            indicator.stopAnimating()
            
            print("before height:\(imageOutlet.bounds.size.height)")
            
            imageOutlet.image = UIImage(data: currentImageData!)
            
            //imageOutlet.image = UIImage(data: currentImageData!, scale: 1.5)
            print("called updateUI")
        }
        else{
            
            indicator.startAnimating()
            //Loading the thumbnail image to the DetailVC.
            print("Loading the thumbnail image to the DetailVC")
            if let tempData = detailItem?.thumbnail{
                let temp = UIImage(data: tempData as Data)
                imageOutlet.image = temp
            }
        }
        
    }
    
    //Handler method for toggling Done and Camera Label.
    func handlerForTapping(){
        
        //self.view.backgroundColor = (self.view.backgroundColor == UIColor.black ? UIColor.white : UIColor.black)
        
        UIView.transition(with: doneOutlet, duration: 0.4, options: .transitionCrossDissolve, animations: toggleDone, completion: nil)
        UIView.transition(with: cameraLabel, duration: 0.4, options: .transitionCrossDissolve, animations: toggleCameraLabel, completion: nil)
    }
    
    //helper methods for toggling Done and camera labels with animation.
    func toggleDone(){
        doneOutlet.isHidden = !doneOutlet.isHidden
    }
    func toggleCameraLabel(){
        cameraLabel.isHidden = !cameraLabel.isHidden
    }
    
    func changeScale(byReactingTo pinchRecognizer: UIPinchGestureRecognizer){
        switch pinchRecognizer.state {
        case .changed:
            scale *= pinchRecognizer.scale
            print("scale value: \(scale)")
            pinchRecognizer.scale = 1
        case .ended:
            break
            //            if self.view.bounds.size.height > (viewHeight! * 2){
            //                self.view.bounds.size.height = viewHeight! * 2
            //                self.view.bounds.size.width = viewWidth! * 2
            //            }
            //            else if self.view.bounds.size.height < (viewHeight! * 0.9){
            //                self.view.bounds.size.height = viewHeight! * 0.9
            //                self.view.bounds.size.width = viewWidth! * 0.9
            //
            //            }
        //
        default:
            break
        }
    }
    
    func updateView(){
        
        self.scrollView.bounds.size.height += (scale * 10)
        self.scrollView.bounds.size.width += (scale * 10)
        
        print("inside updateView")
        
        //        if self.view.bounds.size.height < (viewHeight! * 2.3) ||  self.view.bounds.size.height > (viewHeight! * 0.9){
        //
        //            if scale >= 1{
        //                self.view.bounds.size.height += (scale * 10)
        //                self.view.bounds.size.width += (scale * 10)
        //
        //            }
        //            else{
        //                self.view.bounds.size.height -= (scale * 10)
        //                self.view.bounds.size.width -= (scale * 10)
        //
        //            }
        //
        //        }
        
        
    }
    
    func loadItemData() {
        
        //Loading the image of the actual size.
        DispatchQueue.global().async {
            if let tempImageUrl = self.detailItem?.imageURL{
                if let img_src = CGImageSourceCreateWithURL(URL(string: tempImageUrl)! as CFURL, nil){
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
                    if let imref = CGImageSourceCreateThumbnailAtIndex(img_src, 0, options as CFDictionary?){
                        
                        DispatchQueue.main.async {
                            //self.indicator.stopAnimating()
                            let x: NSData = NSData(data: UIImageJPEGRepresentation(UIImage(cgImage: imref), 1.0)!)
                            
                            self.currentImageData = x as Data
                            //self.imageOutlet.image = self.currentImage
                        }
                        
                    }
                    else{
                        print("unable to load thumbnail image")
                    }
                }
                else{
                    print("image source not found at the given image url")
                }
            }
            else{
                print("imageUrl not found")
            }
        }
        
    }
    
    @IBAction func doneBtnPressed(_ sender: Any) {
        
        print("done button pressed")
        dismiss(animated: true, completion: nil)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

//Saving LoadItemData for reference.

//func loadItemData() {
//
//    indicator.startAnimating()
//    if let cameraName = detailItem?.camera{
//        cameraLabel.text = "Camera: \(cameraName)"
//    }
//
//    if let tempData = detailItem?.thumbnail{
//        let temp = UIImage(data: tempData as Data)
//        imageOutlet.image = temp
//    }
//    DispatchQueue.global().async {
//        do {
//            let data = try Data(contentsOf: URL(string: (self.detailItem?.imageURL)!)!)
//            DispatchQueue.global().sync {
//                self.indicator.stopAnimating()
//                self.imageOutlet.image = UIImage(data: data)
//            }
//        } catch  {
//            print("unable to fetch the actual size image in Detail VC")
//            //handle the error
//        }
//    }
//
//}

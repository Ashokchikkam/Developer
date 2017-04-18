//
//  DetailsVC.swift
//  Curiosity
//
//  Created by Ashok on 4/18/17.
//  Copyright © 2017 Ashok. All rights reserved.
//

import UIKit

class DetailsVC: UIViewController {


    var detailItem: Item?
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var imageOutlet: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("inside detailvc's view did load \(detailItem)")
        if detailItem != nil{
            loadItemData()
        }
        // Do any additional setup after loading the view.
    }

    func loadItemData() {

        indicator.startAnimating()
        
        
        if let tempData = detailItem?.thumbnail{
            let temp = UIImage(data: tempData as Data)
            imageOutlet.image = temp
        }
//
//        imageOutlet.sizeThatFits(CGSize(width: (temp?.size.width)!, height: (temp?.size.height)!))
//        
//        print("size of temp width: \(temp?.size.width) height:\(temp?.size.height)")
//        print("size of imageoutlet width: \(imageOutlet.bounds.width) height: \(imageOutlet.bounds.height)")
        
        DispatchQueue.global().async {
            do {
                let data = try Data(contentsOf: URL(string: (self.detailItem?.imageURL)!)!)
                DispatchQueue.global().sync {
                    self.indicator.stopAnimating()
                    self.imageOutlet.image = UIImage(data: data)
                }
            } catch  {
                print("unable to fetch the actual size image in Detail VC")
                //handle the error
            }
        }
        
    }
    
    @IBAction func doneBtnPressed(_ sender: Any) {
        
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

//
//  GameViewController.swift
//  SaveMe
//
//  Created by Ashok on 10/25/16.
//  Copyright © 2016 Ashok. All rights reserved.
//

import UIKit
import SpriteKit
import GoogleMobileAds

class GameViewController: UIViewController, GADBannerViewDelegate, GADInterstitialDelegate {
  
 //   @IBOutlet weak var myBanner: GADBannerView!
    @IBOutlet weak var myBanner: GADBannerView!
    var myAd: GADInterstitial!
    
    let request = GADRequest()
    let request1 = GADRequest()

    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        NotificationCenter.default.addObserver(self, selector: #selector(GameViewController.loadAndShow), name: NSNotification.Name(rawValue: "loadAndShow"), object: nil)
        
        
        request.testDevices = [kGADSimulatorID]
        
        myBanner.delegate = self
        myBanner.isHidden = false
        myBanner.adUnitID = "ca-app-pub-7241884207202342/7347584710"
        myBanner.rootViewController = self
        myBanner.load(request)
        myAd = GADInterstitial(adUnitID: "ca-app-pub-7241884207202342/3336187514")
        myAd.load(request1)
        
        
        
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(GameViewController.hideBannerAd),
            name: NSNotification.Name(rawValue: "hideAd"),
            object: nil)
        
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(GameViewController.noHideBannerAd),
            name: NSNotification.Name(rawValue: "nohideAd"),
            object: nil)
        
        let scene = StartScene(size: view.bounds.size)
        let skView = view as! SKView
        //skView.showsFPS = true
        //skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .resizeFill
        skView.presentScene(scene)
    }
    
    func loadAndShow() {
        
        request1.testDevices = [kGADSimulatorID]
        
        myAd.present(fromRootViewController: self)
        print("came")
        
        
        if (self.myAd.isReady) {
            
            myAd.present(fromRootViewController: self)
            myAd = CreateAd()
            print("shown")
        }
    }
    
    func CreateAd()->GADInterstitial{
        let myAd = GADInterstitial(adUnitID: "ca-app-pub-7241884207202342/3336187514")
        myAd.load(request1)
        return myAd
    }

    func hideBannerAd(){
        self.myBanner.isHidden = true
    }
    
    func noHideBannerAd(){
        self.myBanner.isHidden = false
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .landscape
        } else {
            return .all
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
}

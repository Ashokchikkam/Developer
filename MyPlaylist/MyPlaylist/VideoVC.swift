//
//  VideoVC.swift
//  MyPlaylist
//
//  Created by Ashok on 3/19/17.
//  Copyright © 2017 Ashok. All rights reserved.
//

import UIKit

class VideoVC: UIViewController {

    @IBOutlet weak var webVIew: UIWebView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var navTitle: UINavigationItem!
    
    private var _partyRock: PartyRock!
    
    var partyRock: PartyRock{
        get{
            return _partyRock
        }
        set{
            _partyRock = newValue
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLbl.text = partyRock.videoTitle
        navTitle.title = partyRock.videoTitle
        webVIew.loadHTMLString(partyRock.videoURL, baseURL: nil)
        
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backToList(_ sender: UIBarButtonItem) {
        
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

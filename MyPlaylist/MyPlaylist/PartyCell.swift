//
//  PartyCell.swift
//  MyPlaylist
//
//  Created by Ashok on 3/19/17.
//  Copyright © 2017 Ashok. All rights reserved.
//

import UIKit

class PartyCell: UITableViewCell {

    @IBOutlet weak var videoPreviewImage: UIImageView!
    @IBOutlet weak var videoTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    func updateUI(partyRock: PartyRock){
        
        videoTitle.text = partyRock.videoTitle

        let url = URL(string: partyRock.imageURL)!
        
        //Creates a new thread on the Backgound.
        DispatchQueue.global().async {
            do{
                let data = try Data(contentsOf: url)
              //Putting the image data back on the main thread.
                DispatchQueue.global().sync {
                    self.videoPreviewImage.image = UIImage(data: data)
                    
                }
                
                
            }catch
            {
                //Handling the error.
            }
        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

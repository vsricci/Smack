//
//  ChannelCell.swift
//  Smack
//
//  Created by Vinicius Ricci on 5/24/18.
//  Copyright © 2018 Vinicius Ricci. All rights reserved.
//

import UIKit

class ChannelCell: UITableViewCell {

    
    // Outlets
    @IBOutlet weak var channelName: NSLayoutConstraint!
    
    @IBOutlet weak var channelNameLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            self.layer.backgroundColor = UIColor(white: 1, alpha: 0.2).cgColor
        }else {
            self.layer.backgroundColor = UIColor.clear.cgColor
        }
    }
    
    func configureCell(channel: Channel){
        
        let title = channel.name ?? ""
        channelNameLbl.text = "#\(title)"
        channelNameLbl.font = UIFont(name: "HelveticaNeue-Regular", size: 17)
        
        for id in MessageService.sharedInstance.unreadChannels {
            if id == channel._id {
                channelNameLbl.font = UIFont(name: "HelveticaNeue-Bold", size: 22)
            }
        }
        
        
    }

}

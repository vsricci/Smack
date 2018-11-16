//
//  MessageCell.swift
//  Smack
//
//  Created by Vinicius Ricci on 25/09/2018.
//  Copyright © 2018 Vinicius Ricci. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(message: Message) {
        messageLabel.text = message.message
        userNameLabel.text = message.userName
        userImg.image = UIImage(named: message.userAvatar)
        userImg.backgroundColor = UserDataService.sharedInstance.returnUIColor(components: message.userAvatarColor)
        
        guard var iosDate = message.timestamp as? String else { return }
        let end = iosDate.index(iosDate.endIndex, offsetBy: -5)
        iosDate = iosDate.substring(to: end)
        
        let iosFormatter = ISO8601DateFormatter()
        let chatDate = iosFormatter.date(from: iosDate.appending("Z"))
        
        let newFormatter = DateFormatter()
        newFormatter.dateFormat = "MMM d, h:mm a"
        if let finalDate = chatDate {
            let finalDate = newFormatter.string(from: finalDate)
            timestampLabel.text = finalDate
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

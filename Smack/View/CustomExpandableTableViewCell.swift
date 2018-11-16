//
//  CustomExpandableTableViewCell.swift
//  Smack
//
//  Created by Vinicius Ricci on 30/09/2018.
//  Copyright © 2018 Vinicius Ricci. All rights reserved.
//

import UIKit

class CustomExpandableTableViewCell: UITableViewCell {
    
    @IBOutlet weak var expandableButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

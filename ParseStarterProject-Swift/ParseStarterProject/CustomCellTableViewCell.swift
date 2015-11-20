//
//  CustomCellTableViewCell.swift
//  Relay
//
//  Created by Brian Eckmann on 11/13/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit

class CustomCellTableViewCell: UITableViewCell {
    
    @IBOutlet weak var senderName: UILabel!
    @IBOutlet weak var timeStampInbox: UILabel!
    @IBOutlet weak var inboxMessage: UILabel!
    @IBOutlet weak var inboxMessageIcon: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

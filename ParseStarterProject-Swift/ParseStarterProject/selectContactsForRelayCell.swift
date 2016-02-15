//
//  selectContactsForRelayCell.swift
//  Relay
//
//  Created by Brian Eckmann on 12/9/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class selectContactsForRelayCell: PFCollectionViewCell {
    
    @IBOutlet weak var friendLabel: UILabel!
    
    var user: PFUser? {
        didSet {
            friendLabel.text = user?["fullName"] as? String
        }
    }
}

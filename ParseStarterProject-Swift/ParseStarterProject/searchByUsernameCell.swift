//
//  searchByUsernameCell.swift
//  Relay
//
//  Created by Brian Eckmann on 12/3/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import Parse
import ParseUI


protocol FriendSearchTableViewCellDelegate: class {
    
    func cell(cell: searchByUsernameCell, didSelectToUser user: PFUser)
    func cell(cell: searchByUsernameCell, didSelectDefriendUser user: PFUser)
}


class searchByUsernameCell: UITableViewCell {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var usernameTapped: UIButton!
    @IBOutlet weak var profilePic: PFImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    
    weak var delegate: FriendSearchTableViewCellDelegate?
    
    var user: PFUser? {
        didSet {
            usernameLabel.text = user?.username
            nameLabel.text = user!["fullName"] as? String
            profilePic.image = UIImage(named: "placeholder")
            
            if let profilePicture = user!["profilePic"] as? PFFile {
                profilePic.file = profilePicture
                profilePic.loadInBackground()
            } else {
                profilePic.image = UIImage(named: "profile.png")
            }
        }
    }
    
    var canFriend: Bool? = true {
        didSet {
            /*
            Change the state of the follow button based on whether or not
            it is possible to follow a user.
            */
            if let canFriend = canFriend {
                usernameTapped.selected = !canFriend
            }
        }
    }
    
    @IBAction func usernameAddTapped(sender: AnyObject) {
        
        if let canFriend = canFriend where canFriend == true {
            delegate?.cell(self, didSelectToUser: user!)
            self.canFriend = false
        } else {
            delegate?.cell(self, didSelectDefriendUser: user!)
            self.canFriend = true
        }
        
    }

}

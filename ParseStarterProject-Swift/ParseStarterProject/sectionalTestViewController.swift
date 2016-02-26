//
//  sectionalTestViewController.swift
//  Relay
//
//  Created by Brian Eckmann on 1/3/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class checkForUser: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if PFUser.currentUser() == nil {
                performSegueWithIdentifier("presentParse", sender: self)
            }
    }

}
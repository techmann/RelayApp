/**
* Copyright (c) 2015-present, Parse, LLC.
* All rights reserved.
*
* This source code is licensed under the BSD-style license found in the
* LICENSE file in the root directory of this source tree. An additional grant
* of patent rights can be found in the PATENTS file in the same directory.
*/

import UIKit
import Parse
import ParseUI

class ViewController: UIViewController {
    
    var username = ""
    @IBOutlet weak var usernameInput: UITextField!
    
    
    @IBAction func submitBtn(sender: AnyObject) {
        
        if usernameInput.text != nil {
            username = usernameInput.text!
        }
        
        
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
        
    }
}



//
//  newMessageViewController.swift
//  Relay
//
//  Created by Brian Eckmann on 11/13/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class newMessageViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var messageTextInput: UITextField!
    

    @IBAction func chooseContactsButtonPressed(sender: AnyObject) {
    
    if let messageText = messageTextInput.text {
        let newMessage = PFObject(className: "newMessage")
        newMessage["messageText"] = messageText
        newMessage.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                // The object has been saved.
            } else {
                // There was a problem, check error.description
            }
        }
        }
    }
        

    override func viewDidLoad() {
        super.viewDidLoad()

        self.addLeftNavItemOnView()
        self.title = "New Relay"
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addLeftNavItemOnView () {
        
        // hide default navigation bar button item
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.hidesBackButton = true;
        
        
        let buttonSettings: UIButton = UIButton(type: .Custom) as UIButton
        buttonSettings.frame = CGRectMake(0, 0, 20, 20)
        buttonSettings.setImage(UIImage(named:"backward4.png"), forState: UIControlState.Normal)
        buttonSettings.addTarget(self, action: "leftNavButtonClick:", forControlEvents: UIControlEvents.TouchUpInside)
        
        let leftBarButtonItem: UIBarButtonItem = UIBarButtonItem(customView: buttonSettings)
        
        self.navigationItem.setLeftBarButtonItem(leftBarButtonItem, animated: false)
        
    }
    
    func leftNavButtonClick(sender: UIBarButtonItem) {
        // Perform your custom actions
        
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

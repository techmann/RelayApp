//
//  TableViewController.swift
//  Relay
//
//  Created by Brian Eckmann on 10/31/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import FBSDKLoginKit
import FBSDKCoreKit


class TableViewController: PFQueryTableViewController {
    
    var logInController: PFLogInViewController! = PFLogInViewController()
    var signUpController: PFSignUpViewController! = PFSignUpViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if PFUser.currentUser() == nil {
            presentParse()
        }

        self.addRightNavItemOnView()
        self.addLeftNavItemOnView()
        self.title = "Inbox"
        
        }
    
        required init(coder aDecoder: NSCoder) {
                super.init(coder: aDecoder)!
        
                self.objectsPerPage = 20
        }
                
        override func queryForTable() -> PFQuery {
            
            let query = PFQuery(className: "relay")
            query.whereKey("recipient", equalTo: PFUser.currentUser()!)
            //query.cachePolicy = .CacheElseNetwork
            query.orderByDescending("createdAt")

            return query
        }
    
        override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell? {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! PFCellSearchByUsername
            
            cell.comment?.text = object?.objectForKey("comment") as? String
            cell.sender?.text = object?.objectForKey("senderUsername") as? String
            
            let icon = object?.objectForKey("pasteStr") as! String
            
            let URL = NSURL(string: icon)
            let path = URL!.pathExtension
            
            if path == "gif" {
                
                cell.inboxIcon?.image = UIImage(named: "gif.png")!
                
            } else if path == "jpg" || path == "png" || path == "jpg" || path == "tif" || path == "bmp" || path == "jpeg" {
                
                cell.inboxIcon?.image = UIImage(named: "photo.png")!
                
            } else {
                
                cell.inboxIcon?.image = UIImage(named: "url.png")!
            }
            
            return cell
        }
    
        override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
            
            if indexPath.row + 1 > self.objects?.count {
                
                return 44
            }
            
            let height = super.tableView(tableView, heightForRowAtIndexPath: indexPath)
            return height
        }
    
    func inboxIconCheck() {
        
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func addRightNavItemOnView () {
        
        // hide default navigation bar button item
        self.navigationItem.rightBarButtonItem = nil;
        self.navigationItem.hidesBackButton = true;
        
        
        let buttonNewMessage: UIButton = UIButton(type: .Custom) as UIButton
        buttonNewMessage.frame = CGRectMake(0, 0, 20, 20)
        buttonNewMessage.setImage(UIImage(named:"newMessage.png"), forState: UIControlState.Normal)
        buttonNewMessage.addTarget(self, action: "rightNavButtonClick:", forControlEvents: UIControlEvents.TouchUpInside)
        
        let rightBarButtonItem: UIBarButtonItem = UIBarButtonItem(customView: buttonNewMessage)
        
        self.navigationItem.setRightBarButtonItem(rightBarButtonItem, animated: false)
        
    }
    
    func addLeftNavItemOnView () {
        
        // hide default navigation bar button item
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.hidesBackButton = true;
        
        
        let buttonSettings: UIButton = UIButton(type: .Custom) as UIButton
        buttonSettings.frame = CGRectMake(0, 0, 20, 20)
        buttonSettings.setImage(UIImage(named:"settings.png"), forState: UIControlState.Normal)
        buttonSettings.addTarget(self, action: "leftNavButtonClick:", forControlEvents: UIControlEvents.TouchUpInside)
        
        let leftBarButtonItem: UIBarButtonItem = UIBarButtonItem(customView: buttonSettings)
        
        self.navigationItem.setLeftBarButtonItem(leftBarButtonItem, animated: false)
        
    }
    
    
    func rightNavButtonClick(sender: UIBarButtonItem) {
        // Perform your custom actions
        
        let newMessageVC = self.storyboard?.instantiateViewControllerWithIdentifier("newMessageVC")

        self.presentViewController(newMessageVC!, animated: true, completion: nil)
    }
    
    func leftNavButtonClick(sender: UIBarButtonItem) {
        // Perform your custom actions
        
        let settingsVC = self.storyboard?.instantiateViewControllerWithIdentifier("settingsNC")
        
        let settingVCCast: SettingsNavigationControllerViewController = settingsVC as! SettingsNavigationControllerViewController
        settingVCCast.tableViewController = self
        
        self.presentViewController(settingsVC!, animated: true, completion: nil)
    }
}

extension TableViewController: PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate {
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
        
    func presentParse() {
        
        self.logInController.fields = (PFLogInFields([.UsernameAndPassword, .LogInButton, .DismissButton, .Facebook, .SignUpButton]))
        self.signUpController.fields = (PFSignUpFields([.UsernameAndPassword, .SignUpButton, .DismissButton, .Email, .Additional]))
        
        let logInTitle = UILabel()
        logInTitle.text = "Relay"
        
        self.logInController.logInView!.logo = logInTitle
        
        self.logInController.delegate = self
        
        let SignUpLogoTitle = UILabel()
        SignUpLogoTitle.text = "Relay"
        
        self.signUpController.signUpView!.logo = SignUpLogoTitle
        
        self.signUpController.delegate = self
        
        self.logInController.signUpController = self.signUpController
        
        self.presentViewController(self.logInController, animated: false, completion: nil)
            
    }
    
    func logInViewController(logInController: PFLogInViewController, shouldBeginLogInWithUsername username: String, password: String) -> Bool {
        
        if (!username.isEmpty || !password.isEmpty) {
            return true
        } else {
            return false
        }
    }
    
    func logInViewController(logInController: PFLogInViewController, didLogInUser user: PFUser) {
        
        currentUser = PFUser.currentUser()!
        
        let completionHandler:()->Void = {
            self.loadObjects()
        }
        
        self.dismissViewControllerAnimated(true, completion: completionHandler)
    }
    
    func logInViewController(logInController: PFLogInViewController, didFailToLogInWithError error: NSError?) {
        print("failed to log in")
    }
    
    func logInViewControllerDidCancelLogIn(logInController: PFLogInViewController) {
        
    }
    
    func presentLoggedInAlert() {
        let alertController = UIAlertController(title: "Login Error", message: "Incorrect Username/Password Combination", preferredStyle: .Alert)
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        alertController.addAction(OKAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func signUpViewController(signUpController: PFSignUpViewController, didSignUpUser user: PFUser) {
        
        //let additionalInformation: String = signUpController.signUpView!.additionalField!.text!
        user["fullName"] = signUpController.signUpView!.additionalField!.text!
        
        if user["authData"] != nil {
            
        }
            
        if (fid != "") {
            var imgURLString = "http://graph.facebook.com/" + fid! + "/picture?type=large" //type=normal
        var imgURL = NSURL(string: imgURLString)
        var imageData = NSData(contentsOfURL: imgURL!)
        var image = UIImage(data: imageData!)
        return image
            }
        }
            return nil
        }

        
        user.saveInBackground()
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func signUpViewController(signUpController: PFSignUpViewController, didFailToSignUpWithError error: NSError?) {
        
        print("Failed to sign up...")
        
    }
    
    
    
    func signUpViewControllerDidCancelSignUp(signUpController: PFSignUpViewController) {
        
        print("User dismissed sign up.")
        
    }
    
    
}


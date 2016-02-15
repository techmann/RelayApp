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
import ParseFacebookUtilsV4
import FBSDKShareKit

//var currentUser = PFUser()

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
            cell.cellProfilePic.image = UIImage(named: "placeholder")
            
            
            let senderProfile = object?.objectForKey("sender")
            let senderId = (senderProfile?.objectId)! as String
            let query = PFUser.query()
            query?.whereKey("objectId", equalTo: senderId)
            query!.findObjectsInBackgroundWithBlock {
                (objects: [PFObject]?, error: NSError?) -> Void in
                if error == nil {
                    if let objects = objects {
                        for object in objects {
                            if let profilePic = object.valueForKey("profilePic") as? PFFile {
                            cell.cellProfilePic.file = profilePic
                            cell.cellProfilePic.loadInBackground()
                            } else {
                                cell.cellProfilePic.image = UIImage(named: "profile.png")
                            }
                        }
                    }
                }
            }
            
            let iconString = object?.objectForKey("pasteStr") as! String
            
            if iconString != "" {
            
                let URL = NSURL(string: iconString)
                let path = URL!.pathExtension
                
                if path == "gif" {
                    cell.inboxIcon?.image = UIImage(named: "gif.png")!
                    
                } else if path == "jpg" || path == "png" || path == "jpg" || path == "tif" || path == "bmp" || path == "jpeg" {
                    cell.inboxIcon?.image = UIImage(named: "photo.png")!
                    
                } else {
                    cell.inboxIcon?.image = UIImage(named: "url.png")!
                }
                
            } else {
                cell.inboxIcon?.image = UIImage(named: "photo.png")!
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
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.row + 1 > self.objects?.count {
            self.loadNextPage()
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
        
        else {
            
            self.performSegueWithIdentifier("showRelay", sender: self)
        }
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showRelay" {
            
            let indexPath = self.tableView.indexPathForSelectedRow
            let relayVC = segue.destinationViewController as! relayContentViewController
            
            let object = self.objectAtIndexPath(indexPath)
            relayVC.pasteStr = object?.objectForKey("pasteStr") as! String
            relayVC.imageFile = object?.objectForKey("relayPic") as! PFFile
            
            self.tableView.deselectRowAtIndexPath(indexPath!, animated: true)
        }
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
        
        //currentUser = PFUser.currentUser()!
        
        let isLinkedToFacebook: Bool = PFFacebookUtils.isLinkedWithUser(PFUser.currentUser()!)
        if isLinkedToFacebook == true {
            
            let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, email"])
            graphRequest.startWithCompletionHandler( {
                (connection, result, error) -> Void in
                if error != nil {
                    print(error)
                    
                } else if let result = result {

                    user["fullName"] = result["name"]
                    //user["email"] = result["email"]
                    let userID = result["id"] as! String
                    let imgURLString = "https://graph.facebook.com/" + userID + "/picture?type=large" //type=normal
                    let imgURL = NSURL(string: imgURLString)
                    let imageData = NSData(contentsOfURL: imgURL!)
                    let objectID = PFUser.currentUser()?.objectId
                    let name = result["name"] as! String
                    user["username"] = name + " " + objectID!
                    let imageFile: PFFile = PFFile(data: imageData!)!
                    user["profilePic"] = imageFile
                    user.saveInBackground()
                }
            })
        }
        
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
        
        user["fullName"] = signUpController.signUpView!.additionalField!.text!
        
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


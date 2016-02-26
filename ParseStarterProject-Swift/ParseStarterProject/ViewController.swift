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
import FBSDKLoginKit
import FBSDKCoreKit
import ParseFacebookUtilsV4
import FBSDKShareKit

class ViewController: UIViewController, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate {
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        presentParse()
    }
    
    var logInController: PFLogInViewController! = PFLogInViewController()
    var signUpController: PFSignUpViewController! = PFSignUpViewController()
    
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

        
        self.dismissViewControllerAnimated(true, completion: nil)
        self.navigationController?.popToRootViewControllerAnimated(true)
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
        
        let newMessageVC = self.storyboard?.instantiateViewControllerWithIdentifier("inbox")
        self.presentViewController(newMessageVC!, animated: true, completion: nil)
    }
    
    
    func signUpViewController(signUpController: PFSignUpViewController, didFailToSignUpWithError error: NSError?) {
        
        print("Failed to sign up...")
        
    }
    
    
    
    func signUpViewControllerDidCancelSignUp(signUpController: PFSignUpViewController) {
        
        print("User dismissed sign up.")
        
    }
}



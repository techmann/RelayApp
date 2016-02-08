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

class ViewController: UIViewController, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate {
    
    var logInController: PFLogInViewController! = PFLogInViewController()
    var signUpController: PFSignUpViewController! = PFSignUpViewController()
    
    
    @IBAction func logInBtn(sender: AnyObject) {
        
        self.logInController.fields = (PFLogInFields([.UsernameAndPassword, .LogInButton, .DismissButton, .Facebook, .SignUpButton]))
        let logInTitle = UILabel()
        logInTitle.text = "Relay"
        self.logInController.logInView!.logo = logInTitle
        self.logInController.delegate = self
        self.presentViewController(self.logInController, animated: false, completion: nil)
        
    }
    
    
    
    @IBAction func signUpBtn(sender: AnyObject) {
        
        self.signUpController.fields = (PFSignUpFields([.UsernameAndPassword, .SignUpButton, .DismissButton, .Email, .Additional]))
        let SignUpLogoTitle = UILabel()
        SignUpLogoTitle.text = "Relay"
        self.signUpController.signUpView!.logo = SignUpLogoTitle
        self.signUpController.delegate = self
        self.presentViewController(self.signUpController, animated: false, completion: nil)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func logInViewController(logInController: PFLogInViewController, shouldBeginLogInWithUsername username: String, password: String) -> Bool {
        
        if (!username.isEmpty || !password.isEmpty) {
            return true
        } else {
            return false
        }
    }
    
    func logInViewController(logInController: PFLogInViewController, didLogInUser user: PFUser) {
        
        //self.presentingViewController?.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
        
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

//
//  playground.swift
//  Relay
//
//  Created by Brian Eckmann on 12/9/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import Parse
import ParseUI



extension TableViewController: PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate {
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if (PFUser.currentUser() == nil) {
            
            self.logInController.fields = PFLogInFields.UsernameAndPassword
            self.logInController.fields = PFLogInFields.SignUpButton
            self.logInController.fields = PFLogInFields.PasswordForgotten
            self.logInController.fields = PFLogInFields.DismissButton
            
            let logInTitle = UILabel()
            logInTitle.text = "Relay"
            
            self.logInController.logInView!.logo = logInTitle
            
            self.logInController.delegate = self
            
            let SignUpLogoTitle = UILabel()
            SignUpLogoTitle.text = "Relay"
            
            self.signUpController.signUpView!.logo = SignUpLogoTitle
            
            self.signUpController.delegate = self
            
            self.logInController.signUpController = self.signUpController
            
            self.presentViewController(self.logInController, animated: true, completion: nil)
            
        }
        
    }
    
    func logInViewController(logInController: PFLogInViewController, shouldBeginLogInWithUsername username: String, password: String) -> Bool {
        
        
        if (!username.isEmpty || !password.isEmpty) {
            return true
        }else {
            return false
        }
        
    }
    
    func logInViewController(logInController: PFLogInViewController, didLogInUser user: PFUser) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func logInViewController(logInController: PFLogInViewController, didFailToLogInWithError error: NSError?) {
        print("Failed to login...")
    }
    
    func logInViewControllerDidCancelLogIn(logInController: PFLogInViewController) {
        
    }
    
    
    
    func signUpViewController(signUpController: PFSignUpViewController, didSignUpUser user: PFUser) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    
    func signUpViewController(signUpController: PFSignUpViewController, didFailToSignUpWithError error: NSError?) {
        
        print("Failed to sign up...")
        
    }
    
    
    
    func signUpViewControllerDidCancelSignUp(signUpController: PFSignUpViewController) {
        
        print("User dismissed sign up.")
        
    }
    

}





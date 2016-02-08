//
//  ViewController Log In.swift
//  Relay
//
//  Created by Brian Eckmann on 10/18/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import Parse


@available(iOS 8.0, *)
class ViewController_Log_In: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var usernameLogin: UITextField!
    @IBOutlet weak var emailAddressLogin: UITextField!
    @IBOutlet weak var passwordLogin: UITextField!
    
    var currentUser = PFUser.currentUser()
    
    @IBAction func LogInButtonPressed(sender: UIButton) {
        
        let user = PFUser()
        user.username = usernameLogin.text
        user.password = passwordLogin.text
        
        var errorMessage = ""
        
                if usernameLogin.text != nil {
                    
                    PFUser.logInWithUsernameInBackground(usernameLogin.text!, password: passwordLogin.text!, block: { (user, error) -> Void in
                        
                        if user != nil {
                            //logged in
                            
                            self.presentingViewController?.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
                            
                        } else {
                            
                            let errorString = error!.userInfo["error"] as? String
                                errorMessage = errorString!
                            
                            let alert = UIAlertController(title: "Login Error", message: errorMessage, preferredStyle: UIAlertControllerStyle.Alert)
                            
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                            self.presentViewController(alert, animated: true, completion: nil)
                        }
                    })
                    
                }
            //end LogInButtonPressed
            }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.addLeftNavItemOnView()
        
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController!.navigationBar.translucent = true
        
    }
    
    
    func addLeftNavItemOnView () {

        // hide default navigation bar button item
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.hidesBackButton = true;
        
        
        let buttonBack: UIButton = UIButton(type: .Custom) as UIButton
        buttonBack.frame = CGRectMake(0, 0, 20, 20)
        buttonBack.setImage(UIImage(named:"backward4.png"), forState: UIControlState.Normal)
        buttonBack.addTarget(self, action: "leftNavButtonClick:", forControlEvents: UIControlEvents.TouchUpInside)
        
        let leftBarButtonItem: UIBarButtonItem = UIBarButtonItem(customView: buttonBack)
        
        self.navigationItem.setLeftBarButtonItem(leftBarButtonItem, animated: false)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func leftNavButtonClick(sender: UIBarButtonItem) {
        // Perform your custom actions
        
        
        // Go back to the previous ViewController
        self.navigationController?.popViewControllerAnimated(true)
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

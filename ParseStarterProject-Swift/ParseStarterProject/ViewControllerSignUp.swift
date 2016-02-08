//
//  ViewControllerSignUp.swift
//  Relay
//
//  Created by Brian Eckmann on 10/15/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import Parse


@available(iOS 8.0, *)
class ViewControllerSignUp: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var usernameTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    
    var theText: NSString!
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    func displayAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: "Error in form", message: "Please enter a Username, Password, and Email address", preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            
            alert.dismissViewControllerAnimated(true, completion: nil)
            
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    
    @IBAction func signUpSubmitPressed(sender: UIButton) {
        
        if usernameTextfield.text == "" || passwordTextfield.text == "" {
            
            displayAlert("Error in form", message: "Please enter a valid Username, Password, and Email address")
            
        } else {
            
            activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            
            
            let user = PFUser()
            user.username = usernameTextfield.text
            user.password = passwordTextfield.text
            user.email = emailTextfield.text
            user["firstName"] = self.firstName.text
            user["lastName"] = self.lastName.text
            
            
            var errorMessage  = "Please try again later"
            
            user.signUpInBackgroundWithBlock({ (success, error) -> Void in
            
                self.activityIndicator.stopAnimating()
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
                
                if error == nil {
                
                self.presentingViewController?.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
                

                } else {
                        
                        if let errorString = error!.userInfo["error"] as? String {
                        errorMessage = errorString
                    }
                
                    self.displayAlert("Failed SignUp", message: errorMessage)
                }
            })
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
//        let frame = CGRectMake(100, 100, 250, 100)
//        
//        let textField = UITextField(frame: frame)
//        textField.backgroundColor = UIColor.blueColor()
//        
//        self.view.addSubview(textField)
        
        
        self.addLeftNavItemOnView()
        
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController!.navigationBar.translucent = true
        
        
        let tapGesture = UITapGestureRecognizer()
        tapGesture.addTarget(self, action: "viewTapped")
        self.view.addGestureRecognizer(tapGesture)
        
        self.usernameTextfield.delegate = self
        self.passwordTextfield.delegate = self
        self.emailTextfield.delegate = self
        
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

    
    func leftNavButtonClick(sender: UIBarButtonItem) {
        // Perform your custom actions
        
        
        // Go back to the previous ViewController
        self.navigationController?.popViewControllerAnimated(true)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func viewTapped() {
        if (self.usernameTextfield.isFirstResponder()) {
            self.usernameTextfield.resignFirstResponder()
            
        } else if (self.passwordTextfield.isFirstResponder()) {
            self.passwordTextfield.resignFirstResponder()
            
        } else if (self.emailTextfield.isFirstResponder()) {
            self.emailTextfield.resignFirstResponder()
        }
    }
    
    
    // This is another TextField delegate method that will tell you whenever the text is changing
    func textFieldDidBeginEditing(textField: UITextField) {
        
        // theText is a property on this controller that points to a string. In this case it's setting itself to whatever is being typed in any of the textFields you are the delegate of
        theText = textField.text
        print(theText!)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        return true
        
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

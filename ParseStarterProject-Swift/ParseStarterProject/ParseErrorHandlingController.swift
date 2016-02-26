//
//  RelayContainerView.swift
//  Relay
//
//  Created by Brian Eckmann on 1/22/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class ParseErrorHandlingController {
    
    class func handleParseError(error: NSError) {
        if error.domain != PFParseErrorDomain {
            return
        }
        
//        switch (error.code) {
//        case kPFErrorInvalidSessionToken:
//            handleInvalidSessionTokenError()
//            
//        }
        
        func handleInvalidSessionTokenError() {
        
            //--------------------------------------
            // Option #2: Show login screen so user can re-authenticate.
            //--------------------------------------
            // You may want this if the logout button is inaccessible in the UI.
            //
            // let presentingViewController = UIApplication.sharedApplication().keyWindow?.rootViewController
            // let logInViewController = PFLogInViewController()
            // presentingViewController?.presentViewController(logInViewController, animated: true, completion: nil)
        }
    }
}


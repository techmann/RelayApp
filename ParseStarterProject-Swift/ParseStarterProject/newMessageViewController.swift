//
//  newMessageViewController.swift
//  Relay
//
//  Created by Brian Eckmann on 11/13/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import Parse


var relayText = ""
var relayContent = ""
var relayImageData: NSData? = nil

class newMessageViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var messageTextInput: UITextField!
    @IBOutlet weak var photoLibImageView: UIImageView!
    @IBOutlet weak var pasteBtnOutlet: UIButton!
    @IBOutlet weak var pictureLibOutlet: UIButton!
    @IBOutlet weak var imageOutlet: UIImageView!
    @IBOutlet weak var relayWebView: UIWebView!
    @IBOutlet weak var chooseContactsBtn: UIButton!
    @IBOutlet weak var cameraOutlet: UIButton!
    
    
    //let imagePicker = UIImagePickerController()
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    @IBAction func pasteBtn(sender: AnyObject) {
        
        chooseContactsBtn.hidden = false
        pasteBtnOutlet.hidden = true
        pictureLibOutlet.hidden = true
        cameraOutlet.hidden = true
        
        activityIndicator = UIActivityIndicatorView(frame: CGRectMake(100, 200, 50, 50))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()

        
        UIPasteboard.generalPasteboard().containsPasteboardTypes(UIPasteboardTypeListString as! [String])
            
        let pasteBoardText = UIPasteboard.generalPasteboard().string
        
        //print(pasteBoardText)
            
            let URL = NSURL(string: pasteBoardText!)
            let path = URL!.pathExtension
        
            relayContent = pasteBoardText!
        
            if path == "gif" {
                
                imageOutlet.hidden = false
                imageOutlet.contentMode = .ScaleAspectFit
                imageOutlet.image = UIImage.animatedImageWithAnimatedGIFURL(URL!)
                
            } else {
            
            if path == "jpg" || path == "png" || path == "jpg" || path == "tif" || path == "bmp" || path == "jpeg" {
                
                imageOutlet.hidden = false
                imageOutlet.contentMode = .ScaleAspectFit
                downloadImage((URL)!)
                
            } else {
            
                relayWebView.hidden = false
                let request = NSURLRequest(URL: URL!)
                relayWebView.loadRequest(request)
            }
        }
        
        self.activityIndicator.stopAnimating()
        UIApplication.sharedApplication().endIgnoringInteractionEvents()
    }
    
    func UIColorFromRGB(colorCode: String, alpha: Float = 1.0) -> UIColor {
        let scanner = NSScanner(string:colorCode)
        var color:UInt32 = 0;
        scanner.scanHexInt(&color)
        
        let mask = 0x000000FF
        let r = CGFloat(Float(Int(color >> 16) & mask)/255.0)
        let g = CGFloat(Float(Int(color >> 8) & mask)/255.0)
        let b = CGFloat(Float(Int(color) & mask)/255.0)
        
        return UIColor(red: r, green: g, blue: b, alpha: CGFloat(alpha))
    }
    
    
    func checkForPaste() {
        UIPasteboard.generalPasteboard().containsPasteboardTypes(UIPasteboardTypeListString as! [String])
        
        let pasteBoardText = UIPasteboard.generalPasteboard().string
        
        if pasteBoardText == nil {
            pasteBtnOutlet.enabled = false
        }
    }
    
    
    func downloadImage(URL: NSURL) {
        getDataFromUrl(URL) { (data, response, error)  in
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                guard let data = data where error == nil else { return }
                self.imageOutlet.image = UIImage(data: data)
            }
        }
    }
    
    func getDataFromUrl(URL:NSURL, completion: ((data: NSData?, response: NSURLResponse?, error: NSError? ) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(URL) { (data, response, error) in
            completion(data: data, response: response, error: error)
            }.resume()
        }

    
    @IBAction func pictureLibraryBtn(sender: AnyObject) {
        
        chooseContactsBtn.hidden = false
        pasteBtnOutlet.hidden = true
        pictureLibOutlet.hidden = true
        imageOutlet.hidden = false
        cameraOutlet.hidden = true
        
        let photoPicker = UIImagePickerController()
        photoPicker.delegate = self
        photoPicker.sourceType = .PhotoLibrary
        self.presentViewController(photoPicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        if let pickedImage = image as? UIImage {
            imageOutlet.contentMode = .ScaleAspectFill
            imageOutlet.image = pickedImage
            
            let pickImageSize = UIImagePNGRepresentation(pickedImage)
            if pickImageSize!.length < 10000000 {
                relayImageData = pickImageSize
            } else {
                relayImageData = pickedImage.highestQualityJPEGNSData
            }
            
        dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        
        pasteBtnOutlet.hidden = false
        pictureLibOutlet.hidden = false
        imageOutlet.hidden = true
        cameraOutlet.hidden = false
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func cameraBtn(sender: AnyObject) {
        
        chooseContactsBtn.hidden = false
        pasteBtnOutlet.hidden = true
        pictureLibOutlet.hidden = true
        imageOutlet.hidden = false
        cameraOutlet.hidden = true
        
        let photoPicker = UIImagePickerController()
        photoPicker.delegate = self
        photoPicker.sourceType = .Camera
        self.presentViewController(photoPicker, animated: true, completion: nil)
        
    }
    

    @IBAction func chooseContactsButtonPressed(sender: AnyObject) {
    
    if messageTextInput.text != nil {
        
        relayText = messageTextInput.text!
        } else {
            //insert text
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addLeftNavItemOnView()
        self.title = "New Relay"
        
        imageOutlet.hidden = true
        relayWebView.hidden = true
        chooseContactsBtn.hidden = true
        
        let tapGesture = UITapGestureRecognizer()
        tapGesture.addTarget(self, action: "viewTapped")
        self.view.addGestureRecognizer(tapGesture)
        
        checkForPaste()
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
    
    func viewTapped() {
        if (self.messageTextInput.isFirstResponder()) {
            self.messageTextInput.resignFirstResponder()
            if messageTextInput.text != nil {
                chooseContactsBtn.hidden = false
            }
        }
    }
}
    
    extension UIImage {
        var uncompressedPNGData: NSData      { return UIImagePNGRepresentation(self)!        }
        var highestQualityJPEGNSData: NSData { return UIImageJPEGRepresentation(self, 1.0)!  }
        var highQualityJPEGNSData: NSData    { return UIImageJPEGRepresentation(self, 0.75)! }
        var mediumQualityJPEGNSData: NSData  { return UIImageJPEGRepresentation(self, 0.5)!  }
        var lowQualityJPEGNSData: NSData     { return UIImageJPEGRepresentation(self, 0.25)! }
        var lowestQualityJPEGNSData:NSData   { return UIImageJPEGRepresentation(self, 0.0)!  }
}



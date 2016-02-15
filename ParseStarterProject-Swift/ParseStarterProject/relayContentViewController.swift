//
//  relayContentViewController.swift
//  Relay
//
//  Created by Brian Eckmann on 2/13/16.
//  Copyright © 2016 Parse. All rights reserved.
//

import UIKit
import Parse

class relayContentViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var webView: UIWebView!
    
    var pasteStr: String!
    var imageFile: PFFile!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.hidden = true
        webView.hidden = true
        
        if pasteStr != "" {
        
            let URL = NSURL(string: pasteStr!)
            let path = URL!.pathExtension
            
            if path == "gif" {
                
                imageView.hidden = false
                imageView.contentMode = .ScaleAspectFit
                imageView.image = UIImage.animatedImageWithAnimatedGIFURL(URL!)
                
            } else {
                
                if path == "jpg" || path == "png" || path == "jpg" || path == "tif" || path == "bmp" || path == "jpeg" {
                    
                    imageView.hidden = false
                    imageView.contentMode = .ScaleAspectFit
                    downloadImage((URL)!)
                    
            } else {
                
                webView.hidden = false
                let request = NSURLRequest(URL: URL!)
                webView.loadRequest(request)
            }
        }
        
        } else {
            
            imageView.hidden = false
            imageView.contentMode = .ScaleToFill
            
            self.imageFile.getDataInBackgroundWithBlock({ (imageData, error) -> Void in
                if error == nil
                {
                    if let imageData = imageData
                    {
                        let image = UIImage(data:imageData)
                        self.imageView.contentMode = .ScaleAspectFit
                        self.imageView.image = image
                    }
                }
            })
        }
    }
        
    func downloadImage(URL: NSURL) {
        getDataFromUrl(URL) { (data, response, error)  in
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                guard let data = data where error == nil else { return }
                self.imageView.image = UIImage(data: data)
            }
        }
    }
    
    func getDataFromUrl(URL:NSURL, completion: ((data: NSData?, response: NSURLResponse?, error: NSError? ) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(URL) { (data, response, error) in
            completion(data: data, response: response, error: error)
            }.resume()
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        
        return self.imageView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

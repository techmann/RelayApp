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

class TableViewController: PFQueryTableViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        if PFUser.currentUser()?.username == nil {
            
            let signInVC = self.storyboard?.instantiateViewControllerWithIdentifier("signInNC")
        
            self.presentViewController(signInVC!, animated: true, completion: nil)

        }
        
        self.addRightNavItemOnView()
        self.addLeftNavItemOnView()
        self.title = "Inbox"
    }
        
        override func queryForTable() -> PFQuery {
            
            let query = PFQuery(className: "relay")
            //query?.cachePolicy = .CacheElseNetwork

            return query
        }
        
        override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell? {
            
            let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! PFCellSearchByUsername
            
            cell.comment?.text = object?.objectForKey("comment") as? String
            
            return cell
            
        }
        
        override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
            
            if indexPath.row + 1 > self.objects?.count {
                
                return 44
                
            }
            
            let height = super.tableView(tableView, heightForRowAtIndexPath: indexPath)
            return height
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
        
        let newMessageVC = self.storyboard?.instantiateViewControllerWithIdentifier("settingsNC")
        
        self.presentViewController(newMessageVC!, animated: true, completion: nil)
    }



}

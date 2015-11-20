//
//  TableViewController.swift
//  Relay
//
//  Created by Brian Eckmann on 10/31/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class TableViewController: UITableViewController {

    var messages = ["Message 1", "Message 2", "Message 3", "Message 4", "Message 5"]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        if PFUser.currentUser()?.username == nil {
            
            let signInVC = self.storyboard?.instantiateViewControllerWithIdentifier("signInNC")
        
            self.presentViewController(signInVC!, animated: true, completion: nil)

        }
                
        
        tableView.registerNib(UINib(nibName: "CustomCell", bundle: nil), forCellReuseIdentifier: "inboxCell")
        
        self.tableView.rowHeight = 74.0
        
        self.addRightNavItemOnView()
        self.addLeftNavItemOnView()
        self.title = "Inbox"
        
    
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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

    

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return messages.count
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
         let cell = tableView.dequeueReusableCellWithIdentifier("inboxCell", forIndexPath: indexPath) as! CustomCellTableViewCell
        
        cell.senderName.text = messages[indexPath.row]
        cell.timeStampInbox.text = messages[indexPath.row]
        cell.inboxMessage.text = messages[indexPath.row]
        //cell.inboxMessageIcon.image = messages[indexPath.row]
        
        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

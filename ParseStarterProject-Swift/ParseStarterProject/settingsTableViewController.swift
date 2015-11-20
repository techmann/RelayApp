//
//  settingsTableViewController.swift
//  Relay
//
//  Created by Brian Eckmann on 11/17/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class settingsTableViewController: UITableViewController {

    
    let section = ["CONTACTS", "ACCOUNT", "SETTINGS", "SUPPORT", "ABOUT"]
    
    let items = [["Add by Username", "Add by Phone Number", "Add from Address Book"], ["placeholder"], ["placeholder"], ["placeholder"], ["placeholder", "Logout"]]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Settings"
        
        tableView.registerNib(UINib(nibName: "SettingsCell", bundle: nil), forCellReuseIdentifier: "settingsCell")
        
        self.addLeftNavItemOnView()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.section[section]
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return section.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items[section].count
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("settingsCell", forIndexPath: indexPath) as! settingsCellTableViewCell

        cell.settingsLabel.text = items[indexPath.section][indexPath.row]

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.section == 0 && indexPath.row == 0 {
            
            performSegueWithIdentifier("addByUsername", sender: self)
            
        }
        
        if indexPath.section == 4 && indexPath.row == 1 {
            
            PFUser.logOut() //logout user
            
            let currentUser = PFUser.currentUser()?.username // this will now be nil
            
            if currentUser == nil {
            
                let signInVC = self.storyboard?.instantiateViewControllerWithIdentifier("signInNC")
            
                self.presentViewController(signInVC!, animated: true, completion: nil)
                
            }
            

        }
        
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

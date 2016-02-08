//
//  selectContactsForRelay.swift
//  Relay
//
//  Created by Brian Eckmann on 12/9/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import Parse
import ParseUI


class selectContactsForRelay: UIViewController {
    
    
    @IBOutlet weak var relayBtn: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    var recipientsArray = [PFUser]()
    
    @IBAction func relayButton(sender: AnyObject) {
        
        for object in recipientsArray {
            
            let relay = PFObject(className: "relay")
            
            relay["sender"] = currentUser
            relay["senderUsername"] = currentUser.username!
            relay["recipient"] = object
            relay["comment"] = relayText
            relay["pasteStr"] = relayContent
            
            relay.saveInBackground()
        }
        
        
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    /*
    This is a local cache. It stores all the users this user is following.
    It is used to update the UI immediately upon user interaction, instead of waiting
    for a server response.
    */
    var followingUsers = [PFUser]()
    
    func getFollowingUsersForUser() {
    let query = PFQuery(className: "friends")
        query.whereKey("fromUser", equalTo:PFUser.currentUser()!)
        query.includeKey("toUser")
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                if let objects = objects {
                    for object in objects {
                        let toUser = object.valueForKey("toUser")
                        self.followingUsers.append(toUser as! PFUser)
                    }
                }
                self.collectionView.reloadData()
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
    }
    
        
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.collectionView.reloadData()
        collectionView.allowsMultipleSelection = true
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getFollowingUsersForUser()
        
        relayBtn.hidden = true

    }
}

extension selectContactsForRelay: UICollectionViewDataSource {
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! selectContactsForRelayCell
        
        let friend = followingUsers[indexPath.row]
        cell.user = friend
        
        cell.layer.cornerRadius = 34
        cell.layer.masksToBounds = true
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        relayBtn.hidden = false
        
        let cell = collectionView.cellForItemAtIndexPath(indexPath)
        
        cell?.selected = true
        cell?.layer.borderWidth = 3
        cell?.layer.borderColor = UIColor.redColor().CGColor
        
        let friend = followingUsers[indexPath.row]
        
        recipientsArray.append(friend)
        
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        
        let cell = collectionView.cellForItemAtIndexPath(indexPath)
        
        cell?.selected = false
        cell?.layer.borderWidth = 0
        cell?.layer.borderColor = nil
        
        let friend = followingUsers[indexPath.row]
        
        for objects in recipientsArray {
            if let index = recipientsArray.indexOf(friend) {
                recipientsArray.removeAtIndex(index)
            }
        }
    }

    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
        return self.followingUsers.count ?? 0
    }

/*
    func collectionView(collectionView: UICollectionView, titleForHeaderInSection section: Int) -> String {
        return collation.sectionTitles[section]
    }
    
    func sectionIndexTitlesForCollectionView(collectionView: UICollectionView) -> [String] {
        return collation.sectionIndexTitles
    }
    
    func collectionView(collectionView: UICollectionView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
        return collation.sectionForSectionIndexTitleAtIndex(index)
    }
*/

}




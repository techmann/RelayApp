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
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    // stores all the users that match the current search query
    var friends: [PFUser]?
    
    /*
    This is a local cache. It stores all the users this user is following.
    It is used to update the UI immediately upon user interaction, instead of waiting
    for a server response.
    */
    var followingUsers: [PFUser]? {
        didSet {
            /**
            the list of following users may be fetched after the tableView has displayed
            cells. In this case, we reload the data to reflect "following" status
            */
            collectionView.reloadData()
        }
    }
    
    // the current parse query
    var query: PFQuery? {
        didSet {
            // whenever we assign a new query, cancel any previous requests
            oldValue?.cancel()
        }
    }
    
    /**
    Is called as the completion block of all queries.
    As soon as a query completes, this method updates the Table View.
    */
    func updateList(results: [PFObject]?, error: NSError?) {
        self.friends = results as? [PFUser] ?? []
        self.collectionView.reloadData()
        
    }
    
    // this view can be in two different states
    enum State {
        case DefaultMode
    }
    
    // whenever the state changes, perform one of the two queries and update the list
    var state: State = .DefaultMode {
        didSet {
            switch (state) {
            case .DefaultMode:
                query = ParseHelper.allUsers(updateList)
            }
        }
    }
    

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        state = .DefaultMode
        
        // fill the cache of a user's followees
        ParseHelper.getFollowingUsersForUser(PFUser.currentUser()!) {
            
            (results: [PFObject]?, error: NSError?) -> Void in
            
            if let relations = results {
                
                // use map to extract the User from a Follow object
                self.followingUsers = relations.map {
                    $0.objectForKey(ParseHelper.ParseFollowToUser) as! PFUser}
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

}

extension selectContactsForRelay: UICollectionViewDataSource {
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! selectContactsForRelayCell
        
        let friend = friends![indexPath.row]
        cell.user = friend
        
        cell.layer.cornerRadius = 34
        cell.layer.masksToBounds = true
        
        return cell
    }

    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
        return self.friends?.count ?? 0
    
    }

}




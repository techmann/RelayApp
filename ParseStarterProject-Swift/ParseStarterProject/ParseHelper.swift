//
//  ParseHelper.swift
//  Relay
//
//  Created by Brian Eckmann on 12/8/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import Foundation
import Parse

class ParseHelper {

// User Relation
  static let ParseUserUsername = "username"
  static let ParseFollowToUser = "toUser"
  static let ParseFollowFromUser = "fromUser"
    
    
    // MARK: Following
    
    /**
    Fetches all users that the provided user is following.
    
    :param: user The user whose followees you want to retrieve
    :param: completionBlock The completion block that is called when the query completes
    */
    static func getFollowingUsersForUser(user: PFUser, completionBlock: PFQueryArrayResultBlock) {
        
        let query = PFQuery(className: "friends")
        query.whereKey("fromUser", equalTo:user)
        query.findObjectsInBackgroundWithBlock(completionBlock)
        
    }
    
    /**
    Establishes a follow relationship between two users.
    
    :param: user    The user that is following
    :param: toUser  The user that is being followed
    */
    static func addFollowRelationshipFromUser(user: PFUser, toUser: PFUser) {
        
        let friendsObject = PFObject(className: "friends")
        friendsObject.setObject(user, forKey: "fromUser")
        friendsObject.setObject(toUser, forKey: "toUser")
        
        friendsObject.saveInBackgroundWithBlock(nil)
    }
    
    
    /**
    Deletes a follow relationship between two users.
    
    :param: user    The user that is following
    :param: toUser  The user that is being followed
*/
    static func removeFollowRelationshipFromUser(user: PFUser, toUser: PFUser) {
        
        let query = PFQuery(className: "friends")
        query.whereKey("fromUser", equalTo:user)
        query.whereKey("toUser", equalTo:toUser)
        
        query.findObjectsInBackgroundWithBlock {
            
            (results: [PFObject]?, error: NSError?) -> Void in
            
            if results!.count != 0 {
            
            for follow in results! {
                follow.deleteInBackgroundWithBlock(nil)
                }
            }
        }
    }

    
    // MARK: Users
    
    /**
    Fetch all users, except the one that's currently signed in.
    Limits the amount of users returned to 20.
    
    :param: completionBlock The completion block that is called when the query completes
    
    :returns: The generated PFQuery
    */
    static func allUsers(completionBlock: PFQueryArrayResultBlock) -> PFQuery {
        
        let query = PFUser.query()!
        // exclude the current user
        query.whereKey(ParseHelper.ParseUserUsername,
            notEqualTo: PFUser.currentUser()!.username!)
        query.orderByAscending(ParseHelper.ParseUserUsername)
        query.limit = 20
        
        query.findObjectsInBackgroundWithBlock(completionBlock)
        
        return query
    }
    
    /**
    Fetch users whose usernames match the provided search term.
    
    :param: searchText The text that should be used to search for users
    :param: completionBlock The completion block that is called when the query completes
    
    :returns: The generated PFQuery
    */
    static func searchUsers(searchText: String, completionBlock: PFQueryArrayResultBlock)
        -> PFQuery {
            /*
            NOTE: We are using a Regex to allow for a case insensitive compare of usernames.
            Regex can be slow on large datasets. For large amount of data it's better to store
            lowercased username in a separate column and perform a regular string compare.
            */
            let query = PFUser.query()!.whereKey(ParseHelper.ParseUserUsername,
                matchesRegex: searchText, modifiers: "i")
            
            query.whereKey(ParseHelper.ParseUserUsername,
                notEqualTo: PFUser.currentUser()!.username!)
            
            query.orderByAscending(ParseHelper.ParseUserUsername)
            query.limit = 20
            
            query.findObjectsInBackgroundWithBlock(completionBlock)
            
            return query
    }
    
    
    
}

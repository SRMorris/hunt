//
//  Profile.swift
//  Hunt
//
//  Created by smorris on 9/29/15.
//  Copyright © 2015 LateNightGames. All rights reserved.
//

import Parse
import UIKit

class Profile: PFObject, PFSubclassing
{
    override class func initialize()
    {
        self.registerSubclass()
    }
    
    class func parseClassName() -> String
    {
        return "Profile"
    }
    
    ///The user that the profile points to
    @NSManaged var user : User!
    ///The name of this user on their profile
    @NSManaged var name : String!
    ///Where this user says they're from on their profile
    @NSManaged var hometown : String!
    ///The file of the user's profile image (must be converted to UIImage for displaying)
    @NSManaged var profilePicFile : PFFile!
    
    ///Creates a new profile
    class func createProfile(user : User!, completed:(profile: Profile!, succeeded: Bool!, error: NSError!) -> Void)
    {
        let newProfile = Profile()
        newProfile.user = user
        
        newProfile.saveInBackgroundWithBlock { (succeeded, error) -> Void in
            if error != nil
            {
                completed(profile: nil, succeeded: false, error: error)
            }
            else
            {
                completed(profile: newProfile, succeeded: true, error: error)
            }
        }
    }
    
    class func createProfileWithMoreStuff(user : User!, completed:(profile: Profile!, succeeded: Bool!, error: NSError!) -> Void)
    {
        
    }
    
    ///Queries for the profile of the current user, and sets the kProfile singleton
    class func queryForCurrentUsersProfile(completed:(profile : Profile!, error : NSError!) -> Void)
    {
        let query = Profile.query()
        query!.whereKey("user", equalTo: PFUser.currentUser()!)
        query!.includeKey("user")
        query!.getFirstObjectInBackgroundWithBlock { (theProfile, error) -> Void in
            if error != nil
            {
                completed(profile: nil, error: error)
            }
            else
            {
                UniversalProfile.sharedInstance.profile = theProfile as! Profile!
                completed(profile: theProfile as! Profile!, error: nil)
            }
        }
    }
}
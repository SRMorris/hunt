//
//  User.swift
//  Hunt
//
//  Created by smorris on 9/29/15.
//  Copyright © 2015 LateNightGames. All rights reserved.

import Parse
import Foundation

class User: PFUser
{
    override class func initialize()
    {
        self.registerSubclass()
    }
    
    ///Creates a new user
    class func registerNewUser(username : String!, password : String!, completed:(result : Bool!, error : NSError!) -> Void)
    {
        let newUser = User()
        newUser.username = username.lowercaseString
        newUser.password = password.lowercaseString
        
        newUser.signUpInBackgroundWithBlock { (succeeded, parseError) -> Void in
            
            if parseError != nil
            {
                completed(result: false, error: parseError)
            }
            else
            {
                Profile.createProfile(newUser, completed: { (profile, succeeded, error) -> Void in
                    
                    Profile.queryForCurrentUsersProfile({ (theProfile, error) -> Void in
                        
                        UniversalProfile.sharedInstance.profile = theProfile as Profile!
                        completed(result: true, error: nil)
                    })
                })
            }
        }
    }
    
    ///Logs in a user
    class func loginUser(username : String!, password : String!, completed:(result : Bool!, error : NSError!) -> Void)
    {
        PFUser.logInWithUsernameInBackground(username, password: password) { (user, parseError) -> Void in
            
            if parseError != nil
            {
                completed(result: false, error: parseError)
            }
            else
            {
                Profile.queryForCurrentUsersProfile({ (profile, error) -> Void in
                    
                    UniversalProfile.sharedInstance.profile = profile as Profile!
                })
                completed(result: true, error: nil)
            }
        }
    }
}
//
//  User.swift
//  Social Connecting App
//
//  Created by Akash Dharamshi on 6/15/17.
//  Copyright © 2017 Akash Dharamshi. All rights reserved.
//

import Foundation
import Firebase

struct UserModel {
    
    var email: String!
    var firstname : String
    var lastname : String
    var uid : String!
    var password : String!
    var profilePictureUrl = String()
    var ref : DatabaseReference!
    var key : String = ""
    var subAccounts = [subAccount]()
    
    
    init(snapshot : DataSnapshot) {
        self.email = (snapshot.value as! NSDictionary)["email"] as! String
        self.firstname = (snapshot.value as! NSDictionary)["firstname"] as! String
        self.lastname = (snapshot.value as! NSDictionary)["lastname"] as! String
        self.uid = (snapshot.value as! NSDictionary)["uid"] as! String
        self.profilePictureUrl = (snapshot.value as! NSDictionary)["profilePictureUrl"] as! String
        self.ref = snapshot.ref
        self.key = snapshot.key
        
    }
    
    init(email : String, password : String, firstname : String, lastname : String, uid : String ){
        self.email = email
        self.password = password
        self.firstname = firstname
        self.lastname = lastname
        self.uid = uid
        self.ref = Database.database().reference()

    }
    
    
    func getFullname() -> String {
        return (firstname + " " + lastname)
    }
    
    func toAnyObject() -> [String: Any]{
        return ["email":self.email, "firstname": self.firstname, "lastname": self.lastname, "uid": self.uid, "subAccounts" : self.subAccounts]
    }
    
    
    struct subAccount {
        var Accounts = [String : String]()
        var qrCode = UIImage()
        var uniqueUser = String()
        var nameOfSubAccount = String()
        var subProfImage = String()
        
        init(uniqueUser : String, profImage: String, name : String) {
            self.uniqueUser = uniqueUser
            self.subProfImage = profImage
            self.nameOfSubAccount = name
        }
        
        
        mutating func updateUsername (user: String){
            uniqueUser = user
        }
        
        func toAnyObject() -> [String: Any]{
            return ["Unique Username": self.uniqueUser, "Profile Picture URL" : subProfImage, "Name" : self.nameOfSubAccount]
        }
    }
    
}



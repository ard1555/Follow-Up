//
//  NetworkSettings.swift
//  Social Connecting App
//
//  Created by Akash Dharamshi on 6/15/17.
//  Copyright © 2017 Akash Dharamshi. All rights reserved.
//

import Foundation
import Firebase
import EFQRCode
import QRCode

struct NetworkSettings {
    //Holds information making calls back to Firebase server
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let defaults = UserDefaults.standard
    
    var databaseRef: DatabaseReference!{
        return Database.database().reference()
    }
    
    var storageRef: StorageReference!{
        return Storage.storage().reference()
    }
    
    var currentUserNode: DatabaseReference!{
        let currentUid = Auth.auth().currentUser!.uid
        return databaseRef.child("Users").child(currentUid)
    }
    
    
    
    //Signs up a user from Firebase server
    func signUp(firstname: String, lastname: String, email: String, pictureData: Data, password: String){
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if let error = error{
                let alert = SCLAlertView()
                _ = alert.showInfo("Error", subTitle: "\(error.localizedDescription)")
                print(error.localizedDescription)
            }else{
                self.setUserInfo(user: (user?.user)!, firstname: firstname, lastname: lastname, pictureData: pictureData, password: password)
            }
        }
        
    }
    
    //Sets user info from Firebase server
    private func setUserInfo(user: User, firstname: String, lastname: String, pictureData: Data, password: String){
        
        let profilePicturePath = "profileImage\(user.uid)image.jpg"
        let profilePictureRef = storageRef.child(profilePicturePath)
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        
        profilePictureRef.putData(pictureData, metadata: metaData) { (newMetadata, error) in
            if let error = error {
                print(error.localizedDescription)
            }else {
                
                
                let changeRequest = user.createProfileChangeRequest()
                changeRequest.displayName = "\(firstname) \(lastname)"
                
                
                //Fix this??
//                if let url = newMetadata?.downloadURL()
//                {
//                    changeRequest.photoURL = url
//                }
                
                changeRequest.commitChanges(completion: { (error) in
                    if error == nil {         
                        self.saveUserInfoToDB(user: user, firstname: firstname, lastname: lastname, password: password)
                    }else {
                        print(error!.localizedDescription)
                    }
                })
                
            }
        }
        
        
    }
    
    
    //Helper methods saves user input into Firebase server
    private func saveUserInfoToDB(user: User!, firstname: String, lastname: String, password: String){
        let newUser = UserModel(email: user.email!, password: password, firstname: firstname, lastname: lastname, uid: user.uid)
        
        //Adds person and values into database as a UserModel
        currentUserNode.setValue(newUser.toAnyObject()) { (error, ref) in
            if error == nil{
                
                //Fix image url
                //self.createSubAccount(photoUrl: String(describing: user.photoURL!), uniqueUsername: "Test User", name: "\(newUser.firstname) \(newUser.lastname)")
            }else{
                print(error!.localizedDescription)
            }
            
        }
        
        self.signIn(email: user.email!, password: password)
    
    }
    
    //Signs in a user from Firebase server
    func signIn(email: String, password: String){
        Auth.auth().signIn(withEmail: email, password: password, completion : { (user, error) in
            if error == nil{
                if let user = user {
                    print("\(user.user.displayName!) has logged in successfully!")
                    let appDel = UIApplication.shared.delegate as! AppDelegate
                    appDel.takeToHome()
                }
            }else {
                let alert = SCLAlertView()
                _ = alert.showInfo("Login Error", subTitle: error!.localizedDescription)
                
            }
        })
        
     
    }
    
    
    func createSubAccount(photoUrl: String, uniqueUsername: String, name: String){
        
        let subAccount = UserModel.subAccount.init(uniqueUser: uniqueUsername, profImage: photoUrl, name: name).toAnyObject()

        let subAccounts = self.currentUserNode.child("SubAccounts")
        subAccounts.childByAutoId().setValue(subAccount)
        
    }
    
    
    //Fetches current user , gives UserModel
    func fetchCurrentUser(completion: @escaping (UserModel?)->()){
        
        let currentUser = Auth.auth().currentUser!
        
        let currentUserRef = databaseRef.child("Users").child(currentUser.uid)
        
        currentUserRef.observeSingleEvent(of: .value, with: { (currentUser) in
            
            let user: UserModel = UserModel(snapshot: currentUser)
            completion(user)

        }) { (error) in
            print(error.localizedDescription)
            
        }
        
        
        
    }

    
    //Downloads an image from Firebase Server
    func downloadImageFromFirebase(urlString: String, completion: @escaping (UIImage?)->()){
        
        let storageRef = Storage.storage().reference(forURL: urlString)
        
        storageRef.getData(maxSize: 1 * 1024 * 1024) { (imageData, error) in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                
                if let data = imageData {
                    completion(UIImage(data:data))
                    
                }
            }
        }
        
        
    }
    
    func saveSocialAccountstoDB(url : String , fallbackUrl : String, account : String){
        
        let currentUser = Auth.auth().currentUser!
        var socialUrls = [String : String]()
        
            socialUrls = ["url" : url, "fallbackUrl" : fallbackUrl]
        databaseRef.child("Users").child(currentUser.uid).child("subAccounts").child(self.appDelegate.subAccountID).observeSingleEvent(
                of: DataEventType.value, with: { (snapshot) -> Void in
                    
                    //If observe event has greater than 5 nodes, prompt upgrade method
                        let AccountDictionary = ["\(account)" : socialUrls]

                        let AccountRef = self.databaseRef.child("Users").child(currentUser.uid).child("SubAccounts").child(self.appDelegate.subAccountID).child("Accounts")
                    
                        AccountRef.updateChildValues(AccountDictionary)
        
            })
     
    }
    
    func saveContactDB(name : String, phoneNum : String, address : String, email : String, birthday : String){
        
        let currentUser = Auth.auth().currentUser!
        var contactValues = [String : String]()
        
        contactValues = ["Name" : name, "Phone Number" : phoneNum, "Address" : address, "Email" : email, "Birthday" : birthday]
        databaseRef.child("Users").child(currentUser.uid).child("subAccounts").child(self.appDelegate.subAccountID).observeSingleEvent(
            of: DataEventType.value, with: { (snapshot) -> Void in
                
                //let AccountDictionary = ["\(account)" : url]
                let ContactInfo = ["Contact" : contactValues]
                
                let AccountRef = self.databaseRef.child("Users").child(currentUser.uid).child("SubAccounts").child(self.appDelegate.subAccountID).child("Accounts")
                
                AccountRef.updateChildValues(ContactInfo)
                
        })
        
    }
    
    func deleteSubAccount(){
        let currentUser = Auth.auth().currentUser!
        
        let ref  = self.databaseRef.child("Users").child(currentUser.uid).child("SubAccounts").child(self.appDelegate.subAccountID)
        
        defaults.removeObject(forKey: self.appDelegate.subAccountID)
        
        ref.setValue(nil)
    }
    
    

}

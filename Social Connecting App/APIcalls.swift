//
//  APIcalls.swift
//  Social Connecting App
//
//  Created by Akash Dharamshi on 3/13/18.
//  Copyright © 2018 Akash Dharamshi. All rights reserved.
//

import UIKit
import FacebookLogin
import FacebookCore
import GoogleSignIn
import PinterestSDK
import LinkedinSwift
import IOSLinkedInAPIFix
import CDYelpFusionKit



class APIcalls {
    
    
    let networkSettings = NetworkSettings()
    let alertView = SCLAlertView()
    let collectionView = SocialAddCollectionView()
    
    func apiRLoginequest(accountname : String){
        switch(accountname){
        case "Facebook":
            fbLoginAPI(name: accountname)
        case "Google Plus":
            googleLoginAPI(name: accountname)
        case "Pinterest":
            pinterestLoginAPI(name: accountname)
        case "YouTube":
            youtubeLoginAPI(name: accountname)
        case "LinkedIn":
            linkedinLoginAPI(name: accountname)
        default:
            print("here")
            break
        }
    }
    
    func soundcloudLoginAPI(name : String){
        print("SoundCloud login API")
    }
    
    func linkedinLoginAPI(name : String){
        
        print("LinkdIn login API")
        
        let linkedInHelper = LinkedinSwiftHelper(configuration: LinkedinSwiftConfiguration(clientId: "78f0bt8a8e9rjp", clientSecret: "k0jy0N8D9d4PCkeV", state: "linkedin\(Int(Date().timeIntervalSince1970))", permissions: ["r_basicprofile", "r_emailaddress"], redirectUrl: "https://oauth.io/auth"))
        
        linkedInHelper.logout()

        linkedInHelper.authorizeSuccess({ (token) in
            
            linkedInHelper.requestURL("https://api.linkedin.com/v1/people/~?format=json", requestType: LinkedinSwiftRequestGet, success: { (ProfileResponse) in
                
                var responseData = [String : AnyObject]()
                responseData = ["userData" : ProfileResponse]
                
                let json = ProfileResponse.jsonObject
                let siteStandardProfileRequest = json!["siteStandardProfileRequest"] as? [String: Any]
                let urlString = siteStandardProfileRequest!["url"] as? String
                let url = URL(string: urlString!)?.absoluteString
                let profileUrl = url!
                
                
                self.saveURLwithID(account: name, id: profileUrl)
                
                
                
            })
                
            { (ErrorIngetProfile) in
                print(ErrorIngetProfile)
            }
            
        }, error: { (errorInGetToken) in
            print(errorInGetToken)
        }) {
            print("User CancelFlow")
        }
        
    }
    
    
    func spotifyLoginAPI(name : String){
        print("Spotify login API")
    }
    
    func youtubeLoginAPI(name : String){
        
        //let service = GTLRYouTubeService()
        
        let scope: NSString = "https://www.googleapis.com/auth/youtube.readonly"
        let currentScopes: NSArray = GIDSignIn.sharedInstance().scopes as! NSArray
        GIDSignIn.sharedInstance().scopes = currentScopes.adding(scope)
        GIDSignIn.sharedInstance().signIn()
        
    }
    
    func yelpLoginAPI(name : String){
        print("Yelp login API")
        
        let yelpAPIClient = CDYelpAPIClient(apiKey: "r95T74fsIMJGD7QpY92qR_AoEMGuVf2uma3Fn7kAjF09McBqUkuvJrnw-XjtKSII7b4lzaKIM4XrCigLoEoPS5WeKAiNOYtrzrGBXjQDAopBwNsntXkLb9oBBcTjWnYx")

        yelpAPIClient.cancelAllPendingAPIRequests()
        
        
        yelpAPIClient.autocompleteBusinesses(byText: "Pizza Hut",
                                             latitude: 37.786572,
                                             longitude: -122.415192,
                                             locale: nil) { (response) in
                                                
                                                if let response = response,
                                                    let businesses = response.businesses,
                                                    businesses.count > 0 {
                                                    print(businesses)
                                                }
        }
        
        

    }
    
    
    

    func pinterestLoginAPI(name: String){
        
        PDKClient.clearAuthorizedUser()

        PDKClient.sharedInstance().authenticate(withPermissions: [PDKClientReadPublicPermissions,PDKClientWritePublicPermissions,PDKClientReadRelationshipsPermissions,PDKClientWriteRelationshipsPermissions], withSuccess: { (success) in
            print("success")
            print((success?.user().username)!)
            
            //your code goes after login
            //PDKClient.sharedInstance().oauthToken for access token
            
            self.saveURLwithID(account: name, id: (success?.user().username)!)
            
        }) {
            (Error) in
            //your code goes here
        }
    }
    
    func googleLoginAPI(name: String){
        var error: NSError
        
        GIDSignIn.sharedInstance().scopes = nil
        GIDSignIn.sharedInstance().signIn()
        
        print("logging in google")
    }

    
    private func fbLoginAPI(name: String){
        let loginManager = LoginManager()
        
        loginManager.loginBehavior = LoginBehavior.web
        
        //loginManager.logOut()
        
        loginManager.logIn(readPermissions: [.publicProfile,.email, .custom("user_link")], viewController: nil, completion: { (result) in
            switch result{
            case .failed(let error):
                print(error.localizedDescription)
            case .cancelled:
                print("user has cancelled login")
            case .success(_,_,_):

                //Happens after save
                self.getFBUserInfo { (userInfo, error) in
                    if let error = error { print(error.localizedDescription) }

                    //Recieves ID
                    if let userInfo = userInfo, let id = userInfo["id"] {
                        //Add into database here with ID, call into method that takes into switch
                        print(id)
                        
                        self.saveURLwithID(account:name, id: id as! String)
                        
                    }

                }
            default:
                break
            }


        })



    }
    
    func getFBUserInfo(completion: @escaping (_ : [String:Any]?, _ : Error?) -> Void){
        let request = GraphRequest(graphPath: "me", parameters: ["fields" : "id"])
        
        request.start { (response, result) in
            switch result{
                case .failed(let error):
                    completion(nil, error)
            case .success(let graphResponse):
                    completion(graphResponse.dictionaryValue, nil)
            }
        }
    }
    
    
    //Saves into database with unique URL - use method
    func saveURLwithID(account : String, id : String){
        
        var url = String()
        var fallbackUrl = String()
        
        switch account{
            case "Facebook":
                url = "fb://profile/\(id)"
                fallbackUrl = "https://facebook.com/\(id)"
                networkSetting.saveSocialAccountstoDB(url: url, fallbackUrl : fallbackUrl, account: account)
            case "Google Plus":
                url = "plus.google.com/u/0/\(id)"
                fallbackUrl = "plus.google.com/u/0/\(id)"
                networkSetting.saveSocialAccountstoDB(url: url, fallbackUrl : fallbackUrl, account: account)
            case "Pinterest":
                url = "www.pinterest.com/\(id)"
                fallbackUrl = "www.pinterest.com/\(id)"
                networkSetting.saveSocialAccountstoDB(url: url, fallbackUrl : fallbackUrl, account: account)
            case "Youtube":
                url = "www.youtube.com/channel/\(id)"
                fallbackUrl = "www.youtube.com/channel/\(id)"
                networkSetting.saveSocialAccountstoDB(url: url, fallbackUrl : fallbackUrl, account: account)
            case "LinkedIn":
                url = id
                fallbackUrl = id
                networkSetting.saveSocialAccountstoDB(url: url, fallbackUrl : fallbackUrl, account: account)
            default:
                break
        }
    }
    
}

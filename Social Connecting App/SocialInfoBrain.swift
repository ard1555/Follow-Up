//
//  SocialInfoBrain.swift
//  Social Connecting App
//
//  Created by Akash Dharamshi on 7/31/17.
//  Copyright © 2017 Akash Dharamshi. All rights reserved.
//

import Foundation


class SocialInfoBrain{
    
    let socialObjectArray = [socialObject(objName : "Facebook", objImage : UIImage(named: "facebookicon")!),socialObject(objName : "Pinterest", objImage : UIImage(named: "pinteresticon")!), socialObject(objName : "Google Plus", objImage : UIImage(named: "googleplusicon")!), socialObject(objName : "YouTube", objImage : UIImage(named: "youtubeicon")!),socialObject(objName : "LinkedIn", objImage : UIImage(named: "linkedinicon")!), socialObject(objName : "Yelp", objImage : UIImage(named: "yelpicon")!),socialObject(objName : "Spotify", objImage : UIImage(named: "spotifyicon")!), socialObject(objName : "SoundCloud", objImage : UIImage(named: "soundcloudicon")!),socialObject(objName : "Snapchat", objImage : UIImage(named: "snapchaticon")!), socialObject(objName : "Venmo", objImage : UIImage(named: "venmoicon")!), socialObject(objName : "Twitter", objImage : UIImage(named: "twittericon")!), socialObject(objName : "Instagram", objImage : UIImage(named: "instagramicon")!),  socialObject(objName : "Vimeo", objImage : UIImage(named: "vimeoicon")!), socialObject(objName : "Etsy", objImage : UIImage(named: "etsyicon")!),  socialObject(objName : "Contact", objImage : UIImage(named: "contacticon")!), socialObject(objName : "Website", objImage : UIImage(named: "websiteicon")!)]
    
    struct socialObject {
        var objName : String
        var objImage : UIImage
        
    }
    
    func perfromOperation(account : String) {
        
        if let operation = operations[account]{
            
            
            switch operation {
                
                case .username:
                    let alert = SCLAlertView()
                    alert.showSocialPage("\(account)", subTitle: "Insert your \(account) username!", UserAPI: false, Account: account)
 
                case .fetchUsername:
                    let alert = SCLAlertView()
                    alert.showSocialPage("\(account)", subTitle: "Log in with \(account) to save your profile!", UserAPI: true, Account: account )
                
                case .userInfo:
                    let alert = SCLAlertView()
                    alert.showSocialPage("\(account)", subTitle: "Enter your \(account) information!", UserAPI: false, Account: account )
                
                case .customURL:
                    let alert = SCLAlertView()
                    alert.showSocialPage("\(account)", subTitle: "Enter your \(account) Link!", UserAPI: false, Account: account )
                
                case .addCard:
                    let alert = SCLAlertView()
                    alert.showSocialPage("\(account)", subTitle: "Enter your card name!", UserAPI: false, Account: account )
            }
            
        } else {
            print("Cannot find account")
        }
    }
    
    var operations : [String : operation] = [
        
        "Facebook" : operation.fetchUsername,
        "Google Plus" : operation.fetchUsername,
        "LinkedIn" : operation.fetchUsername,
        "YouTube" : operation.fetchUsername,
        
        "SoundCloud" : operation.customURL,
        "Spotify" : operation.customURL,
        "Pinterest" : operation.customURL,
        "Yelp" : operation.customURL,
        
        "Etsy" : operation.username,
        "Snapchat" : operation.username,
        "Twitter" : operation.username,
        "Vimeo" : operation.username,
        "Venmo" : operation.username,
        "Instagram" : operation.username,
        
        "Website" : operation.userInfo,
        "Contact" : operation.userInfo,
        
        "Add Card" : operation.addCard
     ]
    
    
    var AccountInfo : [String : socialUserSchema] = [
        "Facebook" : socialUserSchema.facebookURL,
        "Google Plus" : socialUserSchema.googlePlusUrl,
        "Pinterest" : socialUserSchema.pinterestUrl,
        "LinkedIn" : socialUserSchema.linkdInUrl,
        "Etsy" : socialUserSchema.etsyUrl,
        "Snapchat" : socialUserSchema.snapchatUrl,
        "Twitter" : socialUserSchema.twitterUrl,
        "Vimeo" : socialUserSchema.vimeoUrl,
        "Venmo" : socialUserSchema.venmoUrl,
        "YouTube" : socialUserSchema.youtubeUrl,
        "SoundCloud" : socialUserSchema.soundcloudUrl,
        "Spotify" : socialUserSchema.spotifyUrl,
        "Website" : socialUserSchema.websiteUrl,
        "Instagram" : socialUserSchema.instagramUrl,
        "Yelp" : socialUserSchema.yelpUrl
    ]
    
    enum operation {
        case username
        case fetchUsername
        case userInfo
        case customURL
        case addCard
        
    }
    
    enum socialUserSchema {
        case facebookURL
        case googlePlusUrl
        case pinterestUrl
        case linkdInUrl
        case etsyUrl
        case snapchatUrl
        case twitterUrl
        case vimeoUrl
        case venmoUrl
        case youtubeUrl
        case soundcloudUrl
        case spotifyUrl
        case websiteUrl
        case instagramUrl
        case yelpUrl
    }
    
    
}

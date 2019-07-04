//
//  AppDelegate.swift
//  Social Connecting App
//
//  Created by Akash Dharamshi on 10/28/16.
//  Copyright © 2016 Akash Dharamshi. All rights reserved.
//

import UIKit
import Firebase
import Fabric
import FacebookCore
import FacebookLogin
import GoogleSignIn
import GoogleAPIClientForREST
import PinterestSDK
import LinkedinSwift
import IQKeyboardManager



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInUIDelegate, GIDSignInDelegate {
    
    var window: UIWindow?
    private let service = GTLRYouTubeService()
    var currentSocialAccount = String()
    
    var subAccountID = String()
    
    override init() {
        super.init()
        FirebaseApp.configure()
        
    }
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        takeToHome()
        
        IQKeyboardManager.shared().isEnabled = true
        
        //Google and Youtube Delegates
        GIDSignIn.sharedInstance().clientID = "13733400926-7n6c0h4e98krfjnphb4ihphauglobe9f.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        
        //Facebook Delegates
        SDKApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        //Pinterest Delegates
        PDKClient.configureSharedInstance(withAppId: "4963617056864876823")
        
        return true
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        
        let googleDidHandle = GIDSignIn.sharedInstance().handle(url as URL! as URL!,
                                                                   sourceApplication: sourceApplication,
                                                                   annotation: annotation)
        let facebookDidHandle = SDKApplicationDelegate.shared.application(
            application,
            open: url as URL,
            sourceApplication: sourceApplication,
            annotation: annotation)
        
        return googleDidHandle || facebookDidHandle
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        let pinterestDidHandle = PDKClient.sharedInstance().handleCallbackURL(url as URL!)
        
        return pinterestDidHandle
        
        if LinkedinSwiftHelper.shouldHandle(url) {
            return LinkedinSwiftHelper.application(app, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        }
        
    }
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    //Checks to see if user is already logged in
    func takeToHome(){
        
        //User already logged in - Take to Home
        if Auth.auth().currentUser?.uid != nil {
            print("Going Home")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let homeVC = storyboard.instantiateViewController(withIdentifier: "Profile") as! UserProfileViewController
            let navigationController = UINavigationController(rootViewController: homeVC)
            self.window?.rootViewController = navigationController
            
            //User Not Logged in - Take to Login
        }else{
            print("Going to Login")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginViewController
            self.window?.rootViewController = loginVC
        }
        
    }
    
    //Google utube and Yosign in method (In delegate because conform to protocol)
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        GIDSignIn.sharedInstance().signOut()
        
        let apiCalls = APIcalls()
        
        //if any error stop and print the error
        if error != nil{
            print(error ?? "google error")
            return
        }
        
        if(currentSocialAccount == "Google Plus"){
            print("google works")
            //if success save ID into database
            apiCalls.saveURLwithID(account: "Google Plus", id: user.userID as! String)
        }else {
            print("youtube works")
            self.service.authorizer = user.authentication.fetcherAuthorizer()
            fetchChannelResource()
        }
    }
    
    // List up to 10 files in Drive for Youtube
    func fetchChannelResource() {
        let query = GTLRYouTubeQuery_ChannelsList.query(withPart: "snippet,statistics")
        //query.identifier = "UC_x5XG1OV2P6uZZ5FSM9Ttw"
        // To retrieve data for the current user's channel, comment out the previous
        // line (query.identifier ...) and uncomment the next line (query.mine ...)
        query.mine = true
        service.executeQuery(query,
                             delegate: self,
                             didFinish: #selector(displayResultWithTicket(ticket:finishedWithObject:error:)))
    }
    
    // Process the response and display output for Youtube
    func displayResultWithTicket(
        ticket: GTLRServiceTicket,
        finishedWithObject response : GTLRYouTube_ChannelListResponse,
        error : NSError?) {
        
        if let error = error {
            print("here")
            print(error)
            return
        }
        
        if let channels = response.items, !channels.isEmpty {
            let channel = response.items![0]
            let channelID = channel.identifier
            
            apiCalls.saveURLwithID(account: "Youtube", id: channelID as! String)
        }
        
        
    }

}


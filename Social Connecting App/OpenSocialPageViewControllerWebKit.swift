

//
//  OpenSocialPageViewControllerWebKit.swift
//  Social Connecting App
//
//  Created by Akash Dharamshi on 1/22/17.
//  Copyright © 2017 Akash Dharamshi. All rights reserved.
//

import WebKit
import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class OpenSocialPageViewControllerWebKit: UIViewController, WKNavigationDelegate
{
    
    @IBOutlet weak var container: UIView!
    @IBOutlet var SavedStatus: UILabel!
    
    var webView: WKWebView!
    var homeView: UserProfileViewController!
    var Media = ""
    var Page = ""
    var Accounts: [String] = []
    var ref: DatabaseReference!
    
    override func viewDidLoad()
    {
        
        super.viewDidLoad()
        ref = Database.database().reference()
        //homeView = UserProfileViewController()
        
        webView = WKWebView()
        container.addSubview(webView)
        
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        let frame = CGRect(x: 0, y: 60, width: container.bounds.width, height: container.bounds.height-150)
        webView.frame = frame
        
        let url = URL (string: "https://www.\(Media).com")!
        let request = URLRequest(url: url)
        
        webView.load(request)
    }
    

    @IBAction func SaveUrl(_ sender: UIButton) {
        
        let Uid:String = Auth.auth().currentUser!.uid as String!
        
        if(self.webView.url == nil){
            print("Wait for valid page.")
        }else {
            let currentURL : String = self.webView.url!.absoluteString
        
        var Contains = false;
        
        //Implement current url into firebase array under specific User ID

            ref.child("Users").child(Uid).child("Accounts").observeSingleEvent(
                of: DataEventType.value, with: { (snapshot) -> Void in
                    
                    let enumerator = snapshot.children
                    while let rest = enumerator.nextObject() as? DataSnapshot {
                        
                        if((rest.childSnapshot(forPath: "Account").value as! String) == currentURL){
                            Contains = true;
                            print("Account is already added.")
                            break

                        }
                        
                    }
            
                    
                    if(Contains == false){
                        
                        print("Account not added - adding")
                        
                        let AccountDictionary = ["Account" : currentURL]
                        
                        let AccountRef = self.ref.child("Users").child(Uid).child("Accounts").childByAutoId()
                        
                        AccountRef.updateChildValues(AccountDictionary)
                    }

            })
            
        }
        
    }

}

//
//  SliderHandlerViewController.swift
//  Social Connecting App
//
//  Created by Akash Dharamshi on 3/13/17.
//  Copyright © 2017 Akash Dharamshi. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class SliderHandlerViewController: UIViewController
{

    @IBOutlet var scrollView: UIScrollView!
    var ref: DatabaseReference!
    var Fullname : String = ""
    var networkingService = NetworkSettings()

    
    override func awakeFromNib() {
        super.awakeFromNib()
        ref = Database.database().reference()
    }

    
    override func viewDidAppear(_ animated: Bool) {
        self.checkIfUserLoggedIn()
        print("logworks")
    }
    
    func checkIfUserLoggedIn()
    {
        
        Auth.auth().addStateDidChangeListener { auth, user in
            let userId = Auth.auth().currentUser?.uid
            
            if userId != nil {
                // User is signed in
                print("user is signed in")
                self.handleScrollView()

                
            } else {
                // No user is signed in.
                print("No user signed in")
                self.perform(#selector(self.LogOut), with: nil, afterDelay: 0)
                
            }
            
        }
        
    }
    
    func LogOut()
    {
        let firebaseAuth = Auth.auth()
        
            do {
                try firebaseAuth.signOut()
            
                print("Signing out")
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginViewController
                self.present(vc, animated: false, completion: nil)
            
            } catch let signOutError as NSError {
                print ("Error signing out: \(signOutError.localizedDescription)")
                return
            }
        
    }
   

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handleScrollView()
    {
        
        let xOrigin = self.view.frame.width
        
        
        let view1 = (self.storyboard?.instantiateViewController(withIdentifier: "Recents"))! as UIViewController
        self.addChildViewController(view1)
        self.scrollView.addSubview(view1.view)
        view1.didMove(toParentViewController: self)
        view1.view.frame = scrollView.bounds
        
        
        let view2 = (self.storyboard?.instantiateViewController(withIdentifier: "Camera"))! as UIViewController
        self.addChildViewController(view2)
        self.scrollView.addSubview(view2.view)
        view2.didMove(toParentViewController: self)
        view2.view.frame = scrollView.bounds
        
        var view2Frame: CGRect = view2.view.frame
        view2Frame.origin.x = xOrigin
        view2.view.frame = view2Frame
        
        
        let view3 = (self.storyboard?.instantiateViewController(withIdentifier: "UserProfNav"))! as UIViewController
        self.addChildViewController(view3)
        self.scrollView.addSubview(view3.view)
        view3.didMove(toParentViewController: self)
        view3.view.frame = scrollView.bounds
        
        var view3Frame: CGRect = view3.view.frame
        view3Frame.origin.x = xOrigin * 2
        view3.view.frame = view3Frame
        
        
        self.scrollView.contentSize = CGSize(width: self.view.frame.width * 3, height: self.view.frame.height)
        self.scrollView.contentOffset = CGPoint(x: self.view.frame.width, y: self.view.frame.height)
        
        // hide the scroll bar.
        scrollView?.showsHorizontalScrollIndicator = false
        
    }
    
    
    


}

//
//  SocialAddCollectionView.swift
//  Social Connecting App
//
//  Created by Akash Dharamshi on 7/13/17.
//  Copyright © 2017 Akash Dharamshi. All rights reserved.
//

import UIKit
import GoogleSignIn

class SocialAddCollectionView: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet var socialCollection: UICollectionView!
    var network = NetworkSettings()
    var brain = SocialInfoBrain()
    var userSubAccountId = String()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.socialCollection.delegate = self
        self.socialCollection.dataSource = self
       
        print("Collectionview \(appDelegate.subAccountID)")
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return brain.socialObjectArray.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let myCell = socialCollection.dequeueReusableCell(withReuseIdentifier: "socialCell", for: indexPath) as! SocialMediaCollectionCell
        
        myCell.imageView.image = brain.socialObjectArray[indexPath.row].objImage
        myCell.SocialName = brain.socialObjectArray[indexPath.row].objName

        return myCell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = socialCollection!.cellForItem(at: indexPath) as! SocialMediaCollectionCell
        
        print(cell.SocialName)
        appDelegate.currentSocialAccount = cell.SocialName
        brain.perfromOperation(account: cell.SocialName)
        
    }

    
    func performSegueToReturnBack()  {
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }


    
    
    


}

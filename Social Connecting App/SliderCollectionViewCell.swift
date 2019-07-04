//
//  SliderCollectionViewCell.swift
//  Social Connecting App
//
//  Created by Akash Dharamshi on 1/17/18.
//  Copyright © 2018 Akash Dharamshi. All rights reserved.
//

import UIKit
import Foundation

class SliderCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var idLabel: UILabel!
    @IBOutlet var backgroundImage: UIImageView!
    @IBOutlet var addAccountsButton: CustomizableButton!
    @IBOutlet var deleteCell: CustomizableButton!
    @IBOutlet var scanButton: CustomizableButton!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var qrImage: UIImageView! 
    
    @IBOutlet var accountArray: UILabel!
    
    let UserProfileView = UserProfileViewController()
    let networkSettings = NetworkSettings()

    
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = 10
        
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 10
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 2, height: 3)
        
        self.clipsToBounds = false
        

    }
    

    
    
}

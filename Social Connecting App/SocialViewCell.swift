//
//  SocialViewCell.swift
//  Social Connecting App
//
//  Created by Akash Dharamshi on 6/21/17.
//  Copyright © 2017 Akash Dharamshi. All rights reserved.
//

import UIKit

class SocialViewCell: UITableViewCell {
    
    @IBOutlet var socialMediaImage: UIImageView!
    
    @IBOutlet var socialMediaLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

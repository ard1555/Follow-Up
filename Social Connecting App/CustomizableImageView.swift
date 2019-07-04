//
//  CustomizableImageView.swift
//  Social Connecting App
//
//  Created by Akash Dharamshi on 6/15/17.
//  Copyright © 2017 Akash Dharamshi. All rights reserved.
//

import Foundation

@IBDesignable class CustomizableImageView: UIImageView {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        didSet{
            layer.borderColor = borderColor?.cgColor
        }
    }
    
    
}

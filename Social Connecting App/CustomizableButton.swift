//
//  CustomizableButton.swift
//  Social Connecting App
//
//  Created by Akash Dharamshi on 6/17/17.
//  Copyright © 2017 Akash Dharamshi. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class CustomizableButton: UIButton {
    
    var buttonTag = Int()
    var name:String = ""
    var lables = [String]()
    
    var passingDic = [String : [String] ]()
    var InfoArray =  [String : [String] ]()
    
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

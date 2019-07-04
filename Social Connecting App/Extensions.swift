//
//  Extensions.swift
//  Social Connecting App
//
//  Created by Akash Dharamshi on 6/15/17.
//  Copyright © 2017 Akash Dharamshi. All rights reserved.
//

import Foundation

extension UIViewController {
    
    func isValidEmail(email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }
    
    
}

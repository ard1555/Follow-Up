//
//  SignUpViewController.swift
//  Social Connecting App
//
//  Created by Akash Dharamshi on 11/14/16.
//  Copyright © 2016 Akash Dharamshi. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {
    
    @IBOutlet var FirstNameText: UITextField!
    @IBOutlet var LastNameText: UITextField!
    
    var FirstName1: String = ""
    var LastName1: String = ""
    
    @IBAction func ContinueSignUpButton(_ sender: CustomizableButton){
        if(FirstNameText.text!.isEmpty || LastNameText.text!.isEmpty) {
        
            let alert = SCLAlertView()
            _ = alert.showInfo("Error", subTitle: "One or more fields have not been filled. Please try again.")
        } else{
            
            FirstName1 = FirstNameText.text!
            LastName1 = LastNameText.text!
            performSegue(withIdentifier: "NextSignUpPageSegue", sender: self)
        }
    }
    

    @IBAction func BacktoLogin(_ sender: CustomizableButton){
        performSegue(withIdentifier: "toLoginSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "NextSignUpPageSegue" {
            
            let DestViewController: SignUpSecondViewController = segue.destination as! SignUpSecondViewController
            
            DestViewController.FirstName = FirstName1
            DestViewController.LastName = LastName1
            
        }
        
    }
    
    
}

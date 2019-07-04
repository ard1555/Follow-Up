 //
//  LoginViewController.swift
//  Social Connecting App
//
//  Created by Akash Dharamshi on 11/14/16.
//  Copyright © 2016 Akash Dharamshi. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    var networkSettings = NetworkSettings()
    @IBOutlet var CreateNewAccount: CustomizableButton!
    @IBOutlet var SignUpButton: CustomizableButton!

    
    @IBOutlet var UsernameTextField: CustomizableTextfield! {
        didSet{
            UsernameTextField.delegate = self
        }
    }
    
    @IBOutlet var PasswordTextField: CustomizableTextfield! {
        didSet{
            PasswordTextField.delegate = self
        }
    }
    
    
    override func viewDidLoad()
    {

    }
    
    
    @IBAction func SignInHandler(_ sender: UIButton)
    {
        
        let email = UsernameTextField.text!.lowercased()
        let finalEmail = email.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let password = PasswordTextField.text!
        
        if finalEmail.isEmpty || password.isEmpty {
            let alert = SCLAlertView()
            _ = alert.showInfo("Login Error", subTitle: "One or more fields have not been filled. Please try again.")
        }else {
            if isValidEmail(email: finalEmail) {
                self.networkSettings.signIn(email: finalEmail, password: password)
                
            }else{
                let alert = SCLAlertView()
                _ = alert.showInfo("Login Error", subTitle: "Invalid Email.")
            }
        }
        self.view.endEditing(true)
        
    }
    

    @IBAction func ForgotPassword(_ sender: UIButton)
    {
        performSegue(withIdentifier: "ForgotPasswordSegue", sender: self)
    }
    
    
    @IBAction func CreateAccountButton(_ sender: UIButton)
    {
       performSegue(withIdentifier: "SignUpPageSegue", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.identifier == "toHomePageFromLogin"
        {
            
           let DestViewController: SliderHandlerViewController = segue.destination as! SliderHandlerViewController
            
        }
        
    }
    
 }
    
extension LoginViewController {
        
        @IBAction func unwindToLogin(_ storyboardSegue: UIStoryboardSegue){}
        
//        private func hideForgotDetailButton(isHidden: Bool){
//            self.forgotDetailButton.isHidden = isHidden
//        }
    
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            UsernameTextField.resignFirstResponder()
            PasswordTextField.resignFirstResponder()
            return true
        }
        
        func textFieldDidBeginEditing(_ textField: UITextField) {
            //animateView(up: true, moveValue: 80)
            //hideForgotDetailButton(isHidden: true)
        }
        
        func textFieldDidEndEditing(_ textField: UITextField) {
            //animateView(up: false, moveValue: 80)
            //hideForgotDetailButton(isHidden: false)
        }
        
        // Move the View Up & Down when the Keyboard appears
        func animateView(up: Bool, moveValue: CGFloat){
            
            let movementDuration: TimeInterval = 0.3
            let movement: CGFloat = (up ? -moveValue : moveValue)
            UIView.beginAnimations("animateView", context: nil)
            UIView.setAnimationBeginsFromCurrentState(true)
            UIView.setAnimationDuration(movementDuration)
            self.view.frame = self.view.frame.offsetBy(dx: 0, dy: movement)
            UIView.commitAnimations()
            
            
        }
        
        @objc private func hideKeyboardOnTap(){
            self.view.endEditing(true)
            
        }
        
        func setTapGestureRecognizerOnView(){
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.hideKeyboardOnTap))
            tapGesture.numberOfTapsRequired = 1
            self.view.addGestureRecognizer(tapGesture)
            
        }
        func setSwipeGestureRecognizerOnView(){
            let swipDown = UISwipeGestureRecognizer(target: self, action: #selector(LoginViewController.hideKeyboardOnTap))
            swipDown.direction = .down
            self.view.addGestureRecognizer(swipDown)
        }
}

    


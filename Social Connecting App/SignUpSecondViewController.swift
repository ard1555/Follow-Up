//
//  SignUpSecondViewController.swift
//  Social Connecting App
//
//  Created by Akash Dharamshi on 11/14/16.
//  Copyright © 2016 Akash Dharamshi. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class SignUpSecondViewController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIPopoverPresentationControllerDelegate {

    @IBOutlet var EmailTextField: UITextField!
    @IBOutlet var PasswordTextField: UITextField!
    @IBOutlet var ConfirmPasswordField: UITextField!
    
    @IBOutlet var userProfileImageView: CustomizableImageView!
    
    var ref: DatabaseReference!
    
    var FirstName = ""
    var LastName = ""
    let networkingSettings = NetworkSettings()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        ref = Database.database().reference()
        setTapGestureRecognizerOnView()
 
    }
    
    
    @IBAction func CreateAccountHandler(_ sender: CustomizableButton)
    {
        
        let email = EmailTextField.text!.lowercased()
        let finalEmail = email.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let password = PasswordTextField.text!
        let reenterPassword = ConfirmPasswordField.text!
        
        let data = UIImageJPEGRepresentation(userProfileImageView.image!, 0.2)!
        
        
        if finalEmail.isEmpty || password.isEmpty || reenterPassword.isEmpty {
            //A field is empty
            
            let alert = SCLAlertView()
            _ = alert.showInfo("Error", subTitle: "One or more fields have not been filled. Please try again.")
        }else {
            
            if password == reenterPassword {
                //Passwords match
                
                if isValidEmail(email: finalEmail) {
                    self.networkingSettings.signUp(firstname: FirstName, lastname: LastName, email: finalEmail, pictureData: data, password: password)
                }
                
            } else {
                //Passwords do not match
                
                let alert = SCLAlertView()
                _ = alert.showInfo("Error", subTitle: "Passwords do not match. Please try again.")
            }
            
        }
        
        self.view.endEditing(true)
        
    }
        
        
        
        
    
    
//    func createPerson(){
//        Auth.auth().createUser(withEmail: EmailTextField.text!, password: PasswordTextField.text!, completion: { (user, error) in
//            if error != nil {
//                
//                print("Error")
//                print(error!.localizedDescription)
//                
//                
//            } else if (error == nil) {
//                
//                print("Creating person" + (self.FirstName + " " + self.LastName))
//                
//                let userID: String = user!.uid
//                let fullName: String = self.FirstName + " " + self.LastName
//                let email1: String = self.EmailTextField.text!
//                let password1: String = self.PasswordTextField.text!
//                
//                
//                self.ref.child("Users").child(userID).setValue(["User Id" : userID, "Full Name" : fullName, "Email": email1, "Password" : password1])
//                
//                self.ref.child("Users").child(userID).child("Accounts")
//                
//                self.signedIn(userId: userID, fullName: fullName, email: email1, password: password1)
//            }
//            
//        })
//        
//       
//
//    }

    
    func signedIn(userId : String, fullName : String, email : String, password : String)
    {

        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error == nil{
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                
                let homeViewController = storyBoard.instantiateViewController(withIdentifier: "Home") as! SliderHandlerViewController
                
                self.present(homeViewController, animated: true, completion: nil)
                
                
            }else{

                print(error!.localizedDescription)
            }
        }
        
        
        
    }
}
    
    extension SignUpSecondViewController{
        
        @IBAction func choosePictureAction(_ sender: UITapGestureRecognizer) {
            
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.allowsEditing = true
            pickerController.modalPresentationStyle = .popover
            pickerController.popoverPresentationController?.delegate = self
            pickerController.popoverPresentationController?.sourceView = userProfileImageView
            let alertController = UIAlertController(title: "Add a Picture", message: "Choose From", preferredStyle: .actionSheet)
            
            let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
                pickerController.sourceType = .camera
                self.present(pickerController, animated: true, completion: nil)
                
            }
            let photosLibraryAction = UIAlertAction(title: "Photos Library", style: .default) { (action) in
                pickerController.sourceType = .photoLibrary
                self.present(pickerController, animated: true, completion: nil)
                
            }
            
            let savedPhotosAction = UIAlertAction(title: "Saved Photos Album", style: .default) { (action) in
                pickerController.sourceType = .savedPhotosAlbum
                self.present(pickerController, animated: true, completion: nil)
                
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
            
            alertController.addAction(cameraAction)
            alertController.addAction(photosLibraryAction)
            alertController.addAction(savedPhotosAction)
            alertController.addAction(cancelAction)
            
            
            present(alertController, animated: true, completion: nil)
            
    }
        
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
            
            if let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
                self.userProfileImageView.image = chosenImage
            }
            self.dismiss(animated: true, completion: nil)
    }
        
    func setTapGestureRecognizerOnView(){
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SignUpSecondViewController.hideKeyboardOnTap))
            tapGesture.numberOfTapsRequired = 1
            self.view.addGestureRecognizer(tapGesture)
            
    }
        
    @objc private func hideKeyboardOnTap(){
            self.view.endEditing(true)
            
    }

}
    



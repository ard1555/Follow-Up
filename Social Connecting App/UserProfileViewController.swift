//
//  FirstViewController.swift
//  Social Connecting App
//
//  Created by Akash Dharamshi on 11/15/16.
//  Copyright © 2016 Akash Dharamshi. All rights reserved.
//

import UIKit
import Foundation
import Firebase
import FirebaseAuth
import FirebaseDatabase
import CenteredCollectionView
import Contacts
import QRCode
import EFQRCode


class UserProfileViewController: UIViewController
{
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet var UserProfileView: UIView!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var noAccountsLabel: UILabel!
    
    var Carousel: iCarousel!
    let centeredCollectionViewFlowLayout = CenteredCollectionViewFlowLayout()
    
    var ref: DatabaseReference!
    var networkingService = NetworkSettings()
    
    //Holds subAccount Array
    var subAccountIds: [String] = []
    
    //Holds accounts corresponding to subAccount Array
    var accountDic = [String : [String]]()
    
    //Holds names corresponding to subAccount Array
    var nameDic = [String : String]()


    override func awakeFromNib() {
        super.awakeFromNib()
        
            }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        self.collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
        self.setupNavigationBarItems()
        self.grabAutoIds()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
    }

    
    override func prepare(for segue: UIStoryboardSegue,
                 sender: Any?){
        
        if segue.identifier == "socialAddCollection" {
            let DestViewController: SocialAddCollectionView = segue.destination as! SocialAddCollectionView
            
            DestViewController.userSubAccountId = appDelegate.subAccountID
            
        }
        
    }
    
    
    //Fix
    private func setupNavigationBarItems() {
        
        
//        let currentUserId = Auth.auth().currentUser?.uid
        
//        //Left bar button
//        ref?.child("Users").child(currentUserId!).child("profilePictureUrl")
//            .observeSingleEvent(of: .value, with: { (snapshot) in
//                
//                let userDict = snapshot.value as! String
//                
//                self.networkingService.downloadImageFromFirebase(urlString: userDict, completion: { (ProfImage) in
//                    
//                    let userProfButton = UIButton(type: .system)
//                    userProfButton.setImage(ProfImage?.withRenderingMode(.alwaysOriginal), for: .normal)
//                    userProfButton.frame = CGRect(x:0,y:0, width: 30, height: 30)
//                    self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: userProfButton)
//                    
//                })
//                
//                
//        })
        
        //Right bar button
        let addSubAccountButton = UIButton(type: .system)
        addSubAccountButton.setImage(#imageLiteral(resourceName: "plus-button").withRenderingMode(.alwaysOriginal), for: .normal)
        addSubAccountButton.setImage(#imageLiteral(resourceName: "plus"), for: .highlighted)
        addSubAccountButton.frame = CGRect(x:0,y:0, width: 15, height: 15)
        addSubAccountButton.addTarget(self, action: #selector(self.addSubAccount), for: .touchDown)
        
        let widthConstraint = addSubAccountButton.widthAnchor.constraint(equalToConstant: 25)
        let heightConstraint = addSubAccountButton.heightAnchor.constraint(equalToConstant: 25)
        heightConstraint.isActive = true
        widthConstraint.isActive = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: addSubAccountButton)
        
        
    }
    
    //Currently Not being used
    //Displays User info for HomePage
    private func displayUser(){
        networkingService.fetchCurrentUser { (user) in
            if let user = user {
                

            }
        }
    }
    
    
    //Log out button on homepage
    @IBAction func LogOutButton(_ sender: UIButton) {
        let firebaseAuth = Auth.auth()
        
        do {
            print("Signing out")
            try firebaseAuth.signOut()
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginViewController
            self.present(vc, animated: true, completion: nil)
        } catch let signOutError as NSError {
            print ("Error signing out: \(signOutError.localizedDescription)")
            return
        }
    }
    
    func addSubAccount(_ sender: UIButton) {
        
        var brain = SocialInfoBrain()
        brain.perfromOperation(account: "Add Card")
        
    }
    
    
    //Search for User
    @IBAction func EnterUser(_ sender: AnyObject) {
        
        
    }
    
    
    
}


//Collectionview extension
extension UserProfileViewController : UICollectionViewDelegateFlowLayout, UICollectionViewDataSource{
    
    
    //Creates array of subaccounts to be displayed on homescreen
    internal func grabAutoIds(){
        
        let currentUserId = Auth.auth().currentUser?.uid
        
        self.ref?.child("Users").child(currentUserId!).child("SubAccounts").observe(.value, with: {(snapshot) in
            
            self.subAccountIds.removeAll()
            
            if let result = snapshot.children.allObjects as? [DataSnapshot] {
                
                for child in result {
                    
                    let orderID = child.key as String //get autoID
                    
                    self.subAccountIds.append(orderID)
                    
                }
                
                if(self.subAccountIds.count != 0){
                    self.appDelegate.subAccountID = self.subAccountIds.last!
                    
                    //Sets the account array for each
                    self.grabAccounts(subAccountIdArray: self.subAccountIds)
                    
                    //Sets the name for each cell
                    self.grabNames(subAccountIdArray: self.subAccountIds)
                    
                    self.noAccountsLabel.text = ""
                }else{
                    self.collectionView.reloadData()
                    self.appDelegate.subAccountID = ""
                    self.noAccountsLabel.text = "No cards! :( Add a Card!"
                }

            }
            
        })
        
    }
    
    //Creates array of subaccounts to be displayed on homescreen on each individual card
    internal func grabAccounts(subAccountIdArray: [String]) {
        var accountArray : [String] = []
        
        for subAccountId in subAccountIdArray{
            
            let currentUserId = Auth.auth().currentUser?.uid
            self.ref?.child("Users").child(currentUserId!).child("SubAccounts").child(subAccountId).child("Accounts").observe(.value, with: {(snapshot) in
                
                accountArray.removeAll()
                
                if let result = snapshot.children.allObjects as? [DataSnapshot] {
                    
                    for child in result {
                        
                        //creates an array of accounts
                        let accountName = child.key as String //get account name
                        accountArray.append(accountName)
                        
                    }
                    
                    //adds array of accounts to dictionary
                    if(self.accountDic[subAccountId] != nil){
                        self.accountDic.updateValue(accountArray, forKey: subAccountId)
                    }else{
                        self.accountDic[subAccountId] = accountArray
                    }
                    
                }
                
                self.collectionView.reloadData()
            })
            

        }

    }
    
    internal func grabNames(subAccountIdArray : [String]){
        var name = String()
        
        for subAccountId in subAccountIdArray{
            
            //Goes to the Name node and retrieves data
            let currentUserId = Auth.auth().currentUser?.uid
            self.ref?.child("Users").child(currentUserId!).child("SubAccounts").child(subAccountId).child("Name").observe(.value, with: {(snapshot) in
                
                if let result = snapshot.value as? String {

                        name = result
                        
                        //adds array of accounts to dictionary
                        if(self.nameDic[subAccountId] != nil){
                            self.nameDic.updateValue(name, forKey: subAccountId)
                        }else{
                            self.nameDic[subAccountId] = name
                        }
                    
                }
                
                self.collectionView.reloadData()
                
            })
            
            
        }
    }
    
    
    internal struct Storyboard{
        static let cellIdentifier = "subAccountCell"
    }
    
    //Sizes cells
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = UserProfileView.bounds.width
        let height = UserProfileView.bounds.height
        
        return CGSize(width: width - (width * 0.15), height: height - (height * 0.35))
        
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //Number of cells
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return subAccountIds.count
        
    }
    
    //Code for each cell's view
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let tempCell = collectionView.dequeueReusableCell(withReuseIdentifier: Storyboard.cellIdentifier, for: indexPath) as! SliderCollectionViewCell
        tempCell.backgroundImage.image = #imageLiteral(resourceName: "background color")
        
        //Sets the subAccountID for this cell
        let subAccountID = subAccountIds[indexPath.row]
        
        //tempCell.idLabel.text = subAccountID
        tempCell.idLabel.text = ""

        //Sets the Name for this cell
        tempCell.nameLabel.text = nameDic[subAccountID]

        //Shows the accounts for this cell
        if(accountDic[subAccountID]?.count == 0){
            //tempCell.accountArray.text = "No Accounts! :( Add Now!"
            tempCell.accountArray.text = ""
        }else{

            //Use this array to create the collection view / table view that shows the accounts
            tempCell.accountArray.text = accountDic[subAccountID]?.joined(separator: ", ")
        }
        
        //Sets QR image
        if let tryImage = EFQRCode.generate(
            content: (subAccountID)
            //backgroundColor: CGColor.fromRGB(red: 66/255, green: 244/255, blue: 146/255, alpha: 1)!
            ){
            let context:CIContext = CIContext.init(options: nil)
            let cgImage:CGImage = context.createCGImage(tryImage.toCIImage(), from: tryImage.toCIImage().extent)!
            let image:UIImage = UIImage.init(cgImage: tryImage)
            tempCell.qrImage.image = image

        } else {
            print("Create QRCode image failed!")
        }

        //Edit card
        tempCell.addAccountsButton.buttonTag = indexPath.row
        tempCell.addAccountsButton.addTarget(self, action: #selector(editInformation), for: .touchUpInside)

        //Delete card
        tempCell.deleteCell.buttonTag = indexPath.row
        tempCell.deleteCell.addTarget(self, action: #selector(deleteSubAccount), for: .touchUpInside)
    

        return tempCell
        
        
    }
    
    
    //Goes to the add accounts page for the current ID
    func editInformation(sender : CustomizableButton) {
        
        setSubAccountID(sender: sender)
        
        self.performSegue(withIdentifier: "cardInfoInput", sender: self)

    }
    
    //Deletes the current subaccount
    func deleteSubAccount(sender : CustomizableButton) {
        
        setSubAccountID(sender: sender)
        
        let alert = SCLAlertView()
        alert.showWarning("Delete Cell", subTitle: "Do you want to delete this Card?")
        
    }

    
    //sets the subAccountId that is being used
    func setSubAccountID(sender : CustomizableButton){
        self.appDelegate.subAccountID = self.subAccountIds[sender.buttonTag]
    }

}


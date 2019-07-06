//
//  cardInfoInput.swift
//  Social Connecting App
//
//  Created by Akash Dharamshi on 7/27/18.
//  Copyright © 2018 Akash Dharamshi. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class cardInfoInput: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
   lazy var appDelegate = UIApplication.shared.delegate as! AppDelegate
    let screenSize: CGRect = UIScreen.main.bounds
    
    @IBOutlet var mainView: UIView!
    @IBOutlet var containerView: UIView!
    
    deinit {
        // perform the deinitialization
        print("deinit")
    }

    //What Lable to create for the input screen
    let phoneLabel = ["Mobile", "Work", "Home", "Whatsapp", "Main", "Other", "iPhone", "Google Voice", "Work Fax"]
    let emailLabel = ["Work", "Home", "Business", "Company"]
    let websiteLabel = ["Work", "Blog", "Home", "Portfolio", "Other", "Profile"]
    let socialLabel = ["home", "work", "social"]
    let addressLabel = ["Work", "Home", "Other"]

    //Birthday picker
    let datePicker = UIDatePicker()
    let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
    var birthdayDatePicker = SkyFloatingLabelTextField()

    //Sending variables
    var titleLable = String()
    var lables = [String]()
    var passingDic = [String : [String]]()
    var InfoArray = [String: [String]]()

    //Text Input Fields
     var cardNameField = SkyFloatingLabelTextField()
     var firstNameTextField = SkyFloatingLabelTextField()
     var middleNameTextField = SkyFloatingLabelTextField()
     var lastNameTextField = SkyFloatingLabelTextField()
     var titleTextField = SkyFloatingLabelTextField()
     var companyTextField = SkyFloatingLabelTextField()

    //Displays Information
    var phoneTableView = UITableView()
    var emailTableView = UITableView()
    var websiteTableView = UITableView()
    var addressTableView = UITableView()
    var socialTableView = UITableView()
    let cellReuseIdendifier = "cell"

    //Holds Input Information
    var emailDic:[String : [String]] = ["Home": ["akashrd11@gmail.com", "Hello"]]

    var websiteDic:[String : [String]] = ["Blog":["rizer.net", "smart.com", "Helo.com"],
                                          "Web" :["google.net"]]


    var addressDic:[String : [String]] = ["Home":["15823 bennet chase drive"],
                                          "Work":["15823 cook chase drive"]]

    var phoneDic:[String : [String]] = ["Home" : ["281-304-0991", "281-304-0991", "281-304-0991"],
                                        "Work" : ["713-933-7123"]]

    var socialDic:[String: [String]] = ["Snapchat": ["akash_dh"]]


    //Holds defaults
    let defaults = UserDefaults.standard

    override func viewDidLoad() {

        UIApplication.shared.statusBarStyle = .lightContent

        setUpScreen()

        //setUpDefaults()

        //setUpConstraints()

        setUpNavbar()
        

    }
    
//    required init(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)!
//
//    }
//
//
    
    override func viewDidAppear(_ animated: Bool) {

    }

    private func setUpNavbar(){
        navigationController?.navigationBar.barTintColor = UIColor(red: 255/255, green: 199/255, blue: 127/255, alpha: 1)
        navigationController?.navigationBar.tintColor = UIColor.black

        //Cancel Button
        let cancelButton = UIButton(type: .system)
        cancelButton.setImage(#imageLiteral(resourceName: "deleteicon").withRenderingMode(.alwaysOriginal), for: .normal)
        cancelButton.setImage(#imageLiteral(resourceName: "plus"), for: .highlighted)
        cancelButton.frame = CGRect(x:0,y:0, width: 15, height: 15)
        cancelButton.addTarget(self, action: #selector(self.dismissView), for: .touchDown)
        cancelButton.tintColor = UIColor.white

       cancelButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
       cancelButton.heightAnchor.constraint(equalToConstant: 30).isActive = true

        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: cancelButton)
        navigationItem.leftBarButtonItem?.tintColor = UIColor.white

        //Confirm Button
        let confirmButton = UIButton(type: .system)
        confirmButton.setImage(#imageLiteral(resourceName: "confirmicon").withRenderingMode(.alwaysOriginal), for: .normal)
        confirmButton.setImage(#imageLiteral(resourceName: "confirmicon"), for: .highlighted)
        confirmButton.frame = CGRect(x:0,y:0, width: 15, height: 15)
      //confirmButton.addTarget(self, action: #selector(self.updateDatabaseValues), for: .touchDown)
        confirmButton.tintColor = UIColor.white

        confirmButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        confirmButton.heightAnchor.constraint(equalToConstant: 30).isActive = true

        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: confirmButton)
        navigationItem.rightBarButtonItem?.tintColor = UIColor.white

    }

    private func setUpConstraints(){

        let constraintConstant = 1400 + CGFloat(((getInfoDicCount(dic: emailDic)) + (getInfoDicCount(dic: addressDic)) + (getInfoDicCount(dic: websiteDic)) + (getInfoDicCount(dic: socialDic)) + (getInfoDicCount(dic: phoneDic))) * 50)

        containerView.frame = CGRect(x: 0, y: 0, width: 375, height: constraintConstant)

        for constraint in mainView.constraints {
            if constraint.identifier == "HeightConstraint" {
                constraint.constant = constraintConstant
                mainView.layoutIfNeeded()
            }
        }
    }

    private func setUpDefaults(){
        if defaults.object(forKey: "\(appDelegate.subAccountID)") != nil{
            let dict = defaults.object(forKey: "\(appDelegate.subAccountID)") as? [String: String]
            cardNameField.text = dict!["Card Name"]
            firstNameTextField.text = dict!["First Name"]
            middleNameTextField.text = dict!["Middle Name"]
            lastNameTextField.text = dict!["Last Name"]
            birthdayDatePicker.text = dict!["Birthday"]
            titleTextField.text = dict!["Title"]
            companyTextField.text = dict!["Company"]
        }

        if defaults.object(forKey: "\(appDelegate.subAccountID) arrays") != nil{

            let dict = defaults.object(forKey: "\(appDelegate.subAccountID) Dictionary") as? [String: [String : [String]]]

            emailDic = dict!["Email Addresses"]!
            websiteDic = dict!["Websites"]!
            phoneDic = dict!["Phone Numbers"]!
            addressDic = dict!["Addresses"]!
            socialDic = dict!["Social Accounts"]!
        }

    }

    //Updates the database and
    @objc private func updateDatabaseValues(){

        _ = [
            "Card Name" : cardNameField.text,
            "First Name" : firstNameTextField.text,
            "Middle Name" : middleNameTextField.text,
            "Last Name" : lastNameTextField.text,
                       "Birthday" : birthdayDatePicker.text,
                       "Title" : titleTextField.text,
                       "Company" : companyTextField.text
                       ]

        _ = [

            "Phone Numbers" : socialDic,
            "Email Addresses" : emailDic,
            "Social Accounts" : socialDic,
            "Addresses" : addressDic,
            "Websites" : websiteDic
        ]

        //defaults.set(textInfoDic, forKey: "\(appDelegate.subAccountID)")
        //defaults.set(infoArray, forKey: "\(appDelegate.subAccountID) Dictionary")

        dismissView()

    }

    func setUpScreen(){

        //navigation view
        let myView = UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height - (screenSize.height * 0.88)))
        myView.backgroundColor = UIColor.gray
        //self.view.addSubview(myView)

        //Header image view
        let headerImageView = UIView(frame: CGRect(x: 0, y:(self.navigationController?.navigationBar.bounds.maxY)! - 50, width: screenSize.width, height: screenSize.height - (screenSize.height * 0.80)))
        //let headerImageView = UIView(frame: CGRect(x: 0, y:(myView.bounds.maxY) - 20, width: screenSize.width, height: screenSize.height - (screenSize.height * 0.80)))
        headerImageView.backgroundColor = UIColor.black
        self.mainView.addSubview(headerImageView)

                //Profile Image view
                let profileImageView = UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width/3, height: screenSize.width/3))
                profileImageView.backgroundColor = UIColor.lightGray
                profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
                profileImageView.center = CGPoint(x: headerImageView.bounds.midX, y: headerImageView.frame.maxY)
                profileImageView.layer.borderColor = UIColor.white.cgColor
                profileImageView.layer.borderWidth = 5
                profileImageView.layer.shadowOpacity = 0
                self.mainView.addSubview(profileImageView)


                //Select Profile Image Select Button
        let setProfileImageButton = UIButton(type: UIButtonType.system)
                setProfileImageButton.frame = CGRect(x: profileImageView.frame.maxX - (profileImageView.frame.width * 0.10), y: profileImageView.frame.minY, width: 20, height: 20)
                setProfileImageButton.addTarget(self, action: #selector(dismissView), for: UIControlEvents.touchUpInside)
                setProfileImageButton.setImage(UIImage(named: "imageediticon"), for: .normal)
                setProfileImageButton.tintColor = UIColor.white
                self.mainView.addSubview(setProfileImageButton)


                //Select Header Image Select Button
        let setImageButton = UIButton(type: UIButtonType.system)
                setImageButton.frame = CGRect(x: screenSize.width - 50, y: myView.center.y - 20, width: 40, height: 40)
                setImageButton.addTarget(self, action: #selector(dismissView), for: UIControlEvents.touchUpInside)
                setImageButton.setImage(UIImage(named: "editicon"), for: .normal)
                setImageButton.tintColor = UIColor.white
                headerImageView.addSubview(setImageButton)

                //Navbar Delete Button
        let deleteButton = UIButton(type: UIButtonType.system)
                deleteButton.frame = CGRect(x: 10, y: myView.center.y - 8, width: screenSize.width - (screenSize.width * 0.90), height: screenSize.width - (screenSize.width * 0.90))
                deleteButton.addTarget(self, action: #selector(dismissView), for: UIControlEvents.touchUpInside)
                deleteButton.setImage(UIImage(named: "deleteicon"), for: .normal)
                deleteButton.tintColor = UIColor.white
                myView.addSubview(deleteButton)

                //NavbarConfirm Button
        let confirmButton = UIButton(type: UIButtonType.system)
                confirmButton.frame = CGRect(x: screenSize.width - 50, y: myView.center.y - 8, width: screenSize.width - (screenSize.width * 0.90), height: screenSize.width - (screenSize.width * 0.90))
                confirmButton.addTarget(self, action: #selector(updateDatabaseValues), for: UIControlEvents.touchUpInside)
                confirmButton.setImage(UIImage(named: "confirmicon"), for: .normal)
                confirmButton.tintColor = UIColor.white
                myView.addSubview(confirmButton)


                //Card Name Text Input
        //cardNameField = createTextInput()
        createTextInput(textInput: cardNameField)
        cardNameField.placeholder = "Card Name (ex. Work, Personal)"
        cardNameField.title = "Card Name (ex. Work, Personal)"
        cardNameField.frame.origin.y = headerImageView.frame.maxY * 1.60
        self.mainView.addSubview(cardNameField)

                //Card Label
        let cardNameInfo = UILabel(frame: CGRect(x: 20, y: (cardNameField.frame.maxY), width: screenSize.width - 40, height: 20))
                cardNameInfo.text = "Card name is only visible to you"
                cardNameInfo.font = UIFont.systemFont(ofSize: 12)
                cardNameInfo.textColor = UIColor.lightGray
                cardNameInfo.contentMode = .top
                self.mainView.addSubview(cardNameInfo)


                //First Name Text Input
                //firstNameTextField = createTextInput()
        createTextInput(textInput: firstNameTextField)
        firstNameTextField.placeholder = "First Name"
        firstNameTextField.title = "First Name"
        firstNameTextField.frame.origin.y = (cardNameField.frame.maxY) + 35
        self.mainView.addSubview(firstNameTextField)

                //Middle Name
                //middleNameTextField = createTextInput()
        createTextInput(textInput: middleNameTextField)
        middleNameTextField.placeholder = "Middle Name"
        middleNameTextField.title = "Middle Name"
        middleNameTextField.frame.origin.y = (firstNameTextField.frame.maxY) + 15
        self.mainView.addSubview(middleNameTextField)

                //Last Name
                //lastNameTextField = createTextInput()
        createTextInput(textInput: lastNameTextField)
        lastNameTextField.placeholder = "Last Name"
        lastNameTextField.title = "Last Name"
        lastNameTextField.frame.origin.y = (middleNameTextField.frame.maxY) + 15
        self.mainView.addSubview(lastNameTextField)

                //Birthday
                //birthdayDatePicker = createTextInput()
       createTextInput(textInput: cardNameField)
                birthdayDatePicker.placeholder = "Birthday"
                birthdayDatePicker.title = "Birthday"
        birthdayDatePicker.frame.origin.y = (lastNameTextField.frame.maxY) + 15

                let toolbar = UIToolbar();
                toolbar.sizeToFit()
                let doneButton = UIBarButtonItem(title: "Confirm", style: .plain, target: self, action: #selector(donedatePicker));
                let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
                let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
                toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
                datePicker.datePickerMode = .date
                birthdayDatePicker.inputAccessoryView = toolbar
                birthdayDatePicker.inputView = datePicker

                self.mainView.addSubview(birthdayDatePicker)

                //Title Name
                //titleTextField = createTextInput()
        createTextInput(textInput: titleTextField)
        titleTextField.placeholder = "Title"
        titleTextField.title = "Title"
        titleTextField.frame.origin.y = birthdayDatePicker.frame.maxY + 35
        self.mainView.addSubview(titleTextField)

                //Company Name
                //companyTextField = createTextInput()
        createTextInput(textInput: companyTextField)
        companyTextField.placeholder = "Company"
        companyTextField.title = "Company"
        companyTextField.frame.origin.y = (titleTextField.frame.maxY) + 15
        self.mainView.addSubview(companyTextField)



                //Add Phone Label
        let addPhoneNumberLabel = SkyFloatingLabelTextFieldWithIcon(frame: CGRect(x: 20, y: (companyTextField.frame.maxY) + 35, width: screenSize.width - 40, height: 50), iconType: .image)
                addPhoneNumberLabel.placeholder = " Phone Numbers"
                addPhoneNumberLabel.isEnabled = false
                //addPhoneNumberLabel.disabledColor = UIColor(red: 128, green: 172, blue: 242, alpha: 1)
                addPhoneNumberLabel.disabledColor = UIColor.black
                addPhoneNumberLabel.iconImage = UIImage(named: "phoneicon")
                addPhoneNumberLabel.iconColor = UIColor.purple
                addPhoneNumberLabel.contentVerticalAlignment = UIControlContentVerticalAlignment.center
                self.mainView.addSubview(addPhoneNumberLabel)

                //Add phone tableview
                phoneTableView = createTableView()
                phoneTableView.frame.origin.y = addPhoneNumberLabel.frame.maxY + 5
                phoneTableView.frame.size.height = CGFloat((getInfoDicCount(dic: phoneDic)) * 50)
                self.mainView.addSubview(phoneTableView)

                //Add Phone Button
                let addPhoneNumberButton = createButton(title: "PHONE NUMBER")
                addPhoneNumberButton.addTarget(self, action: #selector(openInfoInput), for: UIControlEvents.touchUpInside)
                addPhoneNumberButton.frame.origin.y = phoneTableView.frame.maxY + 12
                self.mainView.addSubview(addPhoneNumberButton)



                //Add Email Label
                let addEmailLabel = SkyFloatingLabelTextFieldWithIcon(frame: CGRect(x: 20, y: addPhoneNumberButton.frame.maxY + 35, width: screenSize.width - 40, height: 50), iconType: .image)
                addEmailLabel.placeholder = " Emails"
                addEmailLabel.isEnabled = false
                addEmailLabel.disabledColor = UIColor.black
                addEmailLabel.iconImage = UIImage(named: "emailicon")
                addEmailLabel.iconColor = UIColor.purple
                addEmailLabel.contentVerticalAlignment = UIControlContentVerticalAlignment.center
                self.mainView.addSubview(addEmailLabel)

                //Add email tableview
                emailTableView = createTableView()
                emailTableView.frame.origin.y = addEmailLabel.frame.maxY + 5
                emailTableView.frame.size.height = CGFloat((getInfoDicCount(dic: emailDic)) * 50)
                self.mainView.addSubview(emailTableView)

                //Add Email Button
                let addEmailButton = createButton(title: "EMAIL")
                addEmailButton.addTarget(self, action: #selector(openInfoInput), for: UIControlEvents.touchUpInside)
                addEmailButton.frame.origin.y = emailTableView.frame.maxY + 12
                self.mainView.addSubview(addEmailButton)



                //Add Website Label
                let addWebsiteLabel = SkyFloatingLabelTextFieldWithIcon(frame: CGRect(x: 20, y: addEmailButton.frame.maxY + 35, width: screenSize.width - 40, height: 50), iconType: .image)
                addWebsiteLabel.placeholder = " Websites"
                addWebsiteLabel.isEnabled = false
                //addPhoneNumberLabel.disabledColor = UIColor(red: 128, green: 172, blue: 242, alpha: 1)
                addWebsiteLabel.disabledColor = UIColor.black
                addWebsiteLabel.iconImage = UIImage(named: "websiteicon")
                addWebsiteLabel.iconColor = UIColor.purple
                addWebsiteLabel.contentVerticalAlignment = UIControlContentVerticalAlignment.center
                self.mainView.addSubview(addWebsiteLabel)

                //Add Website tableview
                websiteTableView = createTableView()
                websiteTableView.frame.origin.y = addWebsiteLabel.frame.maxY + 5
                websiteTableView.frame.size.height = CGFloat((getInfoDicCount(dic: websiteDic)) * 50)
                self.mainView.addSubview(websiteTableView)

                //Add Website Button
                let addWebsiteButton = createButton(title: "WEBSITE")
                addWebsiteButton.addTarget(self, action: #selector(openInfoInput), for: UIControlEvents.touchUpInside)
                addWebsiteButton.frame.origin.y = websiteTableView.frame.maxY + 12
                self.mainView.addSubview(addWebsiteButton)



                //Add Social Label
                let addSocialLabel = SkyFloatingLabelTextFieldWithIcon(frame: CGRect(x: 20, y: addWebsiteButton.frame.maxY + 35, width: screenSize.width - 40, height: 50), iconType: .image)
                addSocialLabel.placeholder = " Social Accounts"
                addSocialLabel.isEnabled = false
                //addPhoneNumberLabel.disabledColor = UIColor(red: 128, green: 172, blue: 242, alpha: 1)
                addSocialLabel.disabledColor = UIColor.black
                addSocialLabel.iconImage = UIImage(named: "socialicon")
                addSocialLabel.iconColor = UIColor.purple
                addSocialLabel.contentVerticalAlignment = UIControlContentVerticalAlignment.center
                self.mainView.addSubview(addSocialLabel)

                //Add Social tableview
                socialTableView = createTableView()
                socialTableView.frame.origin.y = addSocialLabel.frame.maxY + 5
                socialTableView.frame.size.height = CGFloat((getInfoDicCount(dic: socialDic)) * 50)
                self.mainView.addSubview(socialTableView)

                //Add Social Button
                let addSocialButton = createButton(title: "SOCIAL")
                addSocialButton.addTarget(self, action: #selector(openSocialInput), for: UIControlEvents.touchUpInside)
                addSocialButton.frame.origin.y = socialTableView.frame.maxY + 12
                self.mainView.addSubview(addSocialButton)



                //Add Address Label
                let addAddressLabel = SkyFloatingLabelTextFieldWithIcon(frame: CGRect(x: 20, y: addSocialButton.frame.maxY + 35, width: screenSize.width - 40, height: 50), iconType: .image)
                addAddressLabel.placeholder = " Addresses"
                addAddressLabel.isEnabled = false
                //addPhoneNumberLabel.disabledColor = UIColor(red: 128, green: 172, blue: 242, alpha: 1)
                addAddressLabel.disabledColor = UIColor.black
                addAddressLabel.iconImage = UIImage(named: "addressicon")
                addAddressLabel.iconColor = UIColor.purple
                addAddressLabel.contentVerticalAlignment = UIControlContentVerticalAlignment.center
                self.mainView.addSubview(addAddressLabel)

                //Add Address tableview
                addressTableView = createTableView()
                addressTableView.frame.origin.y = addAddressLabel.frame.maxY + 5
                addressTableView.frame.size.height = CGFloat((getInfoDicCount(dic: addressDic)) * 50)
                self.mainView.addSubview(addressTableView)

                //Add Address Button
                let addAddressButton = createButton(title: "ADDRESS")
                addAddressButton.addTarget(self, action: #selector(openInfoInput), for: UIControlEvents.touchUpInside)
                addAddressButton.frame.origin.y = addressTableView.frame.maxY + 12
                self.mainView.addSubview(addAddressButton)

    }


    @objc private func donedatePicker(){

        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        birthdayDatePicker.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }

    @objc private func cancelDatePicker(){
        self.view.endEditing(true)
    }

    @objc private func createInput(type : String, labels : [String]){
        print("Go to create input for \(type)")
    }

    func dismissView() {
        UIApplication.shared.statusBarStyle = .default

        navigationController?.navigationBar.barTintColor = UIColor.white

        navigationController?.popViewController(animated: true)

    }

    //Opens input page
    func openInfoInput(sender:CustomizableButton){

        //Gets the title of whats being sent
        self.titleLable = sender.name

        //Associated labels
        self.lables = sender.lables

        //Information associated to this Title
        self.passingDic = sender.passingDic

        performSegue(withIdentifier: "infoInput", sender: self)

    }

    func openSocialInput(){
        performSegue(withIdentifier: "showSocialPicker", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "infoInput"{
            let vc = segue.destination
            vc.navigationItem.title = "ADD \(titleLable)"
            vc.navigationController?.navigationBar.tintColor = UIColor.white

            let dest = segue.destination as! infoInputViewViewController
            dest.titleLable = self.titleLable
            dest.lables = self.lables
            dest.currentDic = self.passingDic
        }
    }



    //Table View Methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print("pressed")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = Int()

        if(tableView == phoneTableView){

            count = getInfoDicCount(dic: phoneDic)

        }else if(tableView == emailTableView){

            count = getInfoDicCount(dic: emailDic)

        }else if(tableView == websiteTableView){

            count = getInfoDicCount(dic: websiteDic)

        }else if(tableView == addressTableView){

            count = getInfoDicCount(dic: addressDic)

        }else if(tableView == socialTableView){

            count = getInfoDicCount(dic: socialDic)

        }

        return count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdendifier, for: indexPath as IndexPath)

        if(tableView == phoneTableView){
            var keySave = [String]()
            var valueSave = [String]()
            let keys = Array(phoneDic.keys)

            for key in keys{
                keySave.append(key)
                let array = phoneDic[key]!

                for item in array{
                    valueSave.append("\(key) : \(item)")
                }
            }

            cell.textLabel?.text = valueSave[indexPath.row]

       } else if(tableView == emailTableView){

            var keySave = [String]()
            var valueSave = [String]()
            let keys = Array(emailDic.keys)

            for key in keys{
                keySave.append(key)
                let array = emailDic[key]!

                for item in array{
                    valueSave.append("\(key) : \(item)")
                }
            }

            cell.textLabel?.text = valueSave[indexPath.row]


        }else if(tableView == websiteTableView){

            var keySave = [String]()
            var valueSave = [String]()
            let keys = Array(websiteDic.keys)

            for key in keys{
                keySave.append(key)
                let array = websiteDic[key]!

                for item in array{
                    valueSave.append("\(key) : \(item)")
                }
            }

            cell.textLabel?.text = valueSave[indexPath.row]


        }else if(tableView == addressTableView){

            var keySave = [String]()
            var valueSave = [String]()
            let keys = Array(addressDic.keys)

            for key in keys{
                keySave.append(key)
                let array = addressDic[key]!

                for item in array{
                    valueSave.append("\(key) : \(item)")
                }
            }

            cell.textLabel?.text = valueSave[indexPath.row]


        }else if(tableView == socialTableView){

            var keySave = [String]()
            var valueSave = [String]()
            let keys = Array(socialDic.keys)

            for key in keys{
                keySave.append(key)
                let array = socialDic[key]!

                for item in array{
                    valueSave.append("\(key) : \(item)")
                }
            }

            cell.textLabel?.text = valueSave[indexPath.row]

        }

        return cell
    }

    //Gets the total amount of elements to be displayed for each dictionary
    private func getInfoDicCount(dic : Dictionary<String,[String]>) -> Int{
        var count = Int()
        let keys = Array(dic.keys)

        for key in keys{
            let arrayIndex = dic[key]
            count += (arrayIndex?.count)!
        }

        return count
    }

    //Creates the specific button
    private func createButton(title : String) -> CustomizableButton{

        let button = CustomizableButton(type : UIButtonType.system)
        button.name = title
        button.cornerRadius = 3
        button.borderColor = UIColor.black
        //button.borderWidth = 2


        switch title{
        case "PHONE NUMBER": button.lables = phoneLabel
                             button.passingDic = phoneDic;

        case "EMAIL":        button.lables = emailLabel
                             button.passingDic = emailDic;

        case "WEBSITE":      button.lables = websiteLabel
                             button.passingDic = websiteDic;

        case "SOCIAL":       button.lables = socialLabel
                             button.passingDic = socialDic;

        case "ADDRESS":      button.lables = addressLabel
                             button.passingDic = addressDic;

        default:
            break
        }

        button.setTitle("  + ADD \(title)", for: .normal)
        button.contentHorizontalAlignment = .center
        //button.borderColor = UIColor(red: 34.0/255.0, green: 79.0/255.0, blue: 150.0/255.0, alpha: 1.0)
//        button.setTitleColor(UIColor.lightGray
//            , for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.setTitleColor(UIColor.green, for: .highlighted)
        button.contentHorizontalAlignment = .left

        let buttonTitleSize = (button.currentTitle! as NSString).size(attributes: [NSFontAttributeName : UIFont.boldSystemFont(ofSize: 15 + 1)])

        button.frame.origin.x = 20
        button.frame.size.width = buttonTitleSize.width
        button.frame.size.height = 40

        return button
    }

    //Creates the specific Table View
    private func createTableView() -> UITableView {
        let tableView = UITableView()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdendifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isScrollEnabled = false
        tableView.allowsSelection = false

        tableView.frame.origin.x = 20
        tableView.frame.size.width = screenSize.width - 40
        tableView.frame.size.height = 40

        return tableView
    }

    //Creates the specific label
    private func createLabel() -> UILabel {
        let label = UILabel()

        return label
    }

    private func createTextInput(textInput : SkyFloatingLabelTextField) {

        textInput.selectedTitleColor = UIColor.black
        textInput.selectedLineColor = UIColor.black
        textInput.autocorrectionType = UITextAutocorrectionType.no
        textInput.keyboardType = UIKeyboardType.default
        textInput.returnKeyType = UIReturnKeyType.done
        textInput.clearButtonMode = UITextFieldViewMode.whileEditing
        textInput.contentVerticalAlignment = UIControlContentVerticalAlignment.center

        textInput.frame.origin.x = 20
        textInput.frame.size.width = screenSize.width - 40
        textInput.frame.size.height = 40

    }
    

}

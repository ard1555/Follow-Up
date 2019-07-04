//
//  infoInputViewViewController.swift
//  Social Connecting App
//
//  Created by Akash Dharamshi on 8/12/18.
//  Copyright © 2018 Akash Dharamshi. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class infoInputViewViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var mainView: UIScrollView!
    
    let screenSize: CGRect = UIScreen.main.bounds
    let cellReuseIdendifier = "cell"
    
    //Sets what kind of page and what lables
    var titleLable = String()
    var lables = [String]()
    var currentDic = [String : [String]]()
    var InfoArray = [[String: [String]]]()
    
    //Allows to position based on global variables
    var textInput = UITextField()
    var tableView = UITableView()
    
    //Chooses Label
    var chosenLable = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpScreen()
        setUpNavbar()
        
    }
    
    //Lays out views
    private func setUpScreen(){
        //Add Label
        textInput = createTextInput()
        self.mainView.addSubview(textInput)
        
        tableView = createTableView()
        self.mainView.addSubview(tableView)
        
        self.mainView.addSubview(createButton())
    }
    
    private func setUpNavbar(){
        
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white]
        
        //Confirm Button
        let confirmButton = UIButton(type: .system)
        confirmButton.setImage(#imageLiteral(resourceName: "confirmicon").withRenderingMode(.alwaysOriginal), for: .normal)
        confirmButton.frame = CGRect(x:0,y:0, width: 15, height: 15)
        confirmButton.addTarget(self, action: #selector(saveInfo), for: .touchDown)
        confirmButton.tintColor = UIColor.white
        confirmButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        confirmButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        //Right bar Button
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: confirmButton)
        navigationItem.rightBarButtonItem?.tintColor = UIColor.white
    }
    
    //Object creation Methods
    //--------------------------------------------------
    private func createTextInput() -> SkyFloatingLabelTextField {
        let textInput = SkyFloatingLabelTextField()
        
        textInput.placeholder = titleLable
        textInput.title = titleLable
        textInput.selectedTitleColor = UIColor.gray
        textInput.selectedLineColor = UIColor.black
        textInput.textColor = UIColor.lightGray
        
        textInput.autocorrectionType = UITextAutocorrectionType.no
        textInput.returnKeyType = UIReturnKeyType.done
        textInput.clearButtonMode = UITextFieldViewMode.whileEditing
        textInput.contentVerticalAlignment = UIControlContentVerticalAlignment.center
        textInput.font = UIFont.systemFont(ofSize: 15)
        
        if(titleLable == "PHONE NUMBER"){
            textInput.keyboardType = UIKeyboardType.numberPad
        }else{
            textInput.keyboardType = UIKeyboardType.default
        }
        
        textInput.contentMode = .top
        textInput.frame.origin.x = 20
        textInput.frame.size.width = screenSize.width - 40
        textInput.frame.size.height = 40
        textInput.frame.origin.y = self.view.frame.minY + 30
    
        return textInput
    }
    
    //Creates the specific Table View
    private func createTableView() -> UITableView{
        let tableView = UITableView()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdendifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isScrollEnabled = false
        
        tableView.frame.origin.x = 20
        tableView.frame.origin.y = textInput.frame.maxY + 30
        tableView.frame.size.width = screenSize.width - 40
        tableView.frame.size.height = CGFloat((lables.count) * 50)
        
        return tableView
        
    }
    
    //Creates the specific button
    private func createButton() -> CustomizableButton{
        
        let button = CustomizableButton(type : UIButtonType.system)
        button.cornerRadius = 5
        button.borderColor = UIColor.lightGray
        button.borderWidth = 2
        
        button.setTitle("  + ADD LABEL", for: .normal)
        button.contentHorizontalAlignment = .center
        //button.borderColor = UIColor(red: 34.0/255.0, green: 79.0/255.0, blue: 150.0/255.0, alpha: 1.0)
        button.setTitleColor(UIColor.lightGray
            , for: .normal)
        button.setTitleColor(UIColor.green, for: .highlighted)
        button.contentHorizontalAlignment = .left
        
        var buttonTitleSize = (button.currentTitle! as NSString).size(attributes: [NSFontAttributeName : UIFont.boldSystemFont(ofSize: 15 + 1)])
        
        button.frame.origin.x = 20
        button.frame.origin.y = tableView.frame.maxY + 10
        button.frame.size.width = buttonTitleSize.width
        button.frame.size.height = 40
        
        button.addTarget(self, action: #selector(saveInfo), for: UIControlEvents.touchUpInside)
        
        return button
    }
    
    //Table View Methods
    //--------------------------------------------------
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let indexPath = tableView.indexPathForSelectedRow //optional, to get from any UIButton for example
        
        let currentCell = tableView.cellForRow(at: indexPath!) as! UITableViewCell
        //currentCell.textLabel?.textColor = UIColor.blue
        
        self.chosenLable = currentCell.textLabel!.text!

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lables.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdendifier, for: indexPath as IndexPath)
        
        cell.textLabel?.text = lables[indexPath.row]
        
        return cell
    }
    
    //--------------------------------------------------
    
    @objc private func saveInfo(){
        
        if (currentDic[chosenLable] == nil){
            currentDic[chosenLable] = [textInput.text!]
        }else{
            var array = currentDic[chosenLable]
            array?.append(textInput.text!)
            currentDic[chosenLable] = array
        }

        print(currentDic)
    }
    
    private func setUpConstraints(){
        
        let constraintConstant = 500 + CGFloat((titleLable.count) * 50)
        
        for constraint in mainView.constraints {
            if constraint.identifier == "HeightConstraint" {
                constraint.constant = constraintConstant
                mainView.layoutIfNeeded()
            }
        }
    }
    
    

}

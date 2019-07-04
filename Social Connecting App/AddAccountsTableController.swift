//
//  AddAccountsTableController.swift
//  Social Connecting App
//
//  Created by Akash Dharamshi on 1/12/17.
//  Copyright © 2017 Akash Dharamshi. All rights reserved.
//

import UIKit

class AddAccountsTableController: UITableViewController
{
    
    @IBOutlet var SocialMediaPageCell: UITableViewCell!
    
    
    //Social Media Account List
    var AvailableAccounts = ["Facebook" , "Instagram", "Venmo", "Snapchat" , "Tumblr", "Twitter", "LinkdIn", "Etsy", "Vimeo", "SoundCloud", "Spotify", "Youtube" , "Contact", "Pintrest" ]

    
    //View Did Load
    override func viewDidLoad()
    {
            
    }
    
    
    //UITableView Method 1
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return AvailableAccounts.count
    }
    
    
    //UITableView Method 2
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customcell", for: indexPath) 
        cell.textLabel?.text = AvailableAccounts[indexPath.item]
        return cell
    }
    
    
    //UITableView Method 3
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    //Prepare for Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        
        if segue.identifier == "ShowSocialPage"
        {
            let DestViewController: OpenSocialPageViewControllerWebKit = segue.destination as! OpenSocialPageViewControllerWebKit
            
            let indexPath = tableView.indexPathForSelectedRow!
            
            let currentCell = tableView.cellForRow(at: indexPath) as UITableViewCell!
            
            DestViewController.Media = (currentCell?.textLabel!.text!)!
            DestViewController.Page = (currentCell?.textLabel!.text!)!
            
        }
    
    }
    

}

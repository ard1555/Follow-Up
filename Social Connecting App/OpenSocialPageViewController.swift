//
//  OpenSocialPageViewController.swift
//  Social Connecting App
//
//  Created by Akash Dharamshi on 1/15/17.
//  Copyright © 2017 Akash Dharamshi. All rights reserved.
//

import UIKit

class OpenSocialPageViewController: UIViewController , UIWebViewDelegate{
    
    var Media = ""
    
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.delegate = self
        
        let url = NSURL (string: "http://www.\(Media).com");
        
        let requestObj = NSURLRequest(URL: url!);
        webView.loadRequest(requestObj);
        
    }
    
    @IBAction func AddPageButton(sender: UIButton) {
        let currentURL : NSString = self.webView.request!.URL!.absoluteString
        
        print (page + " : " + currentURL)
        
    }
    
}

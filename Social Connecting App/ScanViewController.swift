//
//  ScanViewController.swift
//  Social Connecting App
//
//  Created by Akash Dharamshi on 11/14/16.
//  Copyright © 2016 Akash Dharamshi. All rights reserved.
//

import UIKit
import EFQRCode

class ScanViewController: UIViewController {

    @IBOutlet var qrImage: UIImageView!
    
    override func viewDidLoad() {
        //Sets QR image
        if let tryImage = EFQRCode.generate(
            content: ("")//subAccountID)
            //backgroundColor: CGColor.fromRGB(red: 66/255, green: 244/255, blue: 146/255, alpha: 1)!
            ){
            let context:CIContext = CIContext.init(options: nil)
            let cgImage:CGImage = context.createCGImage(tryImage.toCIImage(), from: tryImage.toCIImage().extent)!
            let image:UIImage = UIImage.init(cgImage: tryImage)
            self.qrImage.image = image
            
        } else {
            print("Create QRCode image failed!")
        }
    }
    
    
}

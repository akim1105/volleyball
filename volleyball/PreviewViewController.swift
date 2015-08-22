//
//  PreviewViewController.swift
//  volleyball
//
//  Created by Master on 2015/08/06.
//  Copyright (c) 2015年 三ツ井杏希. All rights reserved.
//

import UIKit

class PreviewViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var lookLabel: UILabel!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var likeLabel: UILabel!
    @IBOutlet var commentLabel: UILabel!
    var photoImage: UIImage!

    override func viewDidLoad() {
        super.viewDidLoad()
        /*
        var look = NSUserDefaults.standardUserDefaults().objectForKey("look") as! NSInteger
        var like = NSUserDefaults.standardUserDefaults().objectForKey("like") as! NSInteger
        */
        
        println(NSUserDefaults.standardUserDefaults().objectForKey("comment") as? String)
        
        self.navigationItem.title = NSUserDefaults.standardUserDefaults().objectForKey("name") as? String
        
        imageView.clipsToBounds = true
        
        lookLabel.text = String(0)
        var like = NSUserDefaults.standardUserDefaults().integerForKey("like")
        likeLabel.text = String(like)
        commentLabel.text = NSUserDefaults.standardUserDefaults().objectForKey("comment") as? String
        SVProgressHUD.show()
    }
    
    override func viewDidAppear(animated: Bool) {
        var data = NSUserDefaults.standardUserDefaults().objectForKey("photo") as? NSData
        var imageOriginal = UIImage(data: data!)!
        
        // NSData変換時に90度左に回転してしまうのを防ぐおまじない
        UIGraphicsBeginImageContext(imageOriginal.size);
        imageOriginal.drawInRect(CGRectMake(0, 0, imageOriginal.size.width, imageOriginal.size.height))
        imageOriginal = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        let rect = CGRectMake(0, 0, imageOriginal.size.width, imageOriginal.size.height)
        var imageRef = CGImageCreateWithImageInRect(imageOriginal.CGImage, rect)
        photoImage = UIImage(CGImage: imageRef, scale: 1.0, orientation: UIImageOrientation.Up)

        imageView.image = photoImage
        SVProgressHUD.dismiss()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

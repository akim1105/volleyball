//
//  AddViewController.swift
//  volleyball
//
//  Created by Master on 2015/08/04.
//  Copyright (c) 2015年 三ツ井杏希. All rights reserved.
//

import UIKit

class AddViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var commentField: UITextField!
    @IBOutlet var nameField: UITextField!
    @IBOutlet var imageView: UIImageView!
    
    var photoImage: UIImage!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        commentField.delegate = self
        commentField.tag = 1
        nameField.delegate = self
        nameField.tag = 2
        imageView.image = photoImage
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // TextFiledの編集が始まったときの処理
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if textField.tag == 1 {
            // アニメーションさせながら画面全体を150px上に動かす
            UIView.animateWithDuration(0.2, delay: 0.0, options: nil, animations: {
                self.view.center = CGPointMake(self.view.center.x, self.view.center.y - 150)
                }, completion: nil)
        }
        return true
    }
    
    // キーボードの改行ボタン(完了ボタン)を押したときの処理
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField.tag == 2 {
            // アニメーションさせながら画面全体を150px下に動かす
            UIView.animateWithDuration(0.2, delay: 0.0, options: nil, animations: {
                self.view.center = CGPointMake(self.view.center.x, self.view.center.y + 150)
                }, completion: nil)
        }
        // キーボードを閉じる処理
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func sendToParse() {
        SVProgressHUD.showWithStatus("保存中...")
        let photoObject = PFObject(className: "Photo")
        photoObject["comment"] = commentField.text
        photoObject["name"] = nameField.text
        let resizedSize = CGSizeMake(photoImage.size.width / 10, photoImage.size.width / 10);
        UIGraphicsBeginImageContext(resizedSize);
        photoImage.drawInRect(CGRectMake(0, 0, resizedSize.width, resizedSize.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        var imageData: NSData = UIImageJPEGRepresentation(photoImage, 0.1)
        var file: PFFile = PFFile(name: "image.jpg", data: imageData)
        photoObject["image"] = file
        photoObject.saveInBackgroundWithBlock { (succeeded, error) -> Void in
            if error != nil {
                NSLog("error == %@", error!)
            }else {
                println("Object has been saved.")
                SVProgressHUD.showSuccessWithStatus("投稿完了!")
                self.navigationController?.popViewControllerAnimated(true)
            }
        }
    }
    
    func delete() {
        var query: PFQuery = PFQuery(className: "TestObject")
        query.whereKey("name", containsString: "Araki")
        query.orderByAscending("createdAt")
        
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            for object in (objects as! [PFObject]) {
                
                if(error == nil){
                    object.delete()
                    println(object.objectForKey("name"))
                }
            }
        }
    }
}

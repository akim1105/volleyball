//
//  PhotoViewController.swift
//  volleyball
//
//  Created by 三ツ井杏希 on 2015/07/10.
//  Copyright (c) 2015年 三ツ井杏希. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var collectionView: UICollectionView!
    
    var photoArray = [UIImage]()
    var photoImage: UIImage!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        self.loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! UICollectionViewCell
        var imageView = cell.viewWithTag(1) as! UIImageView!
        imageView.image = photoArray[indexPath.row]
        return cell
    }
    
    // 画面遷移する前に自動的に呼ばれるメソッド
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let addViewController = segue.destinationViewController as! AddViewController
        addViewController.photoImage = self.photoImage
    }
    
    @IBAction func selectImage() {
        var imagePicker: UIImagePickerController = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(imagePicker, animated:true, completion:nil)
    }
    
    
    // MARK: UIImagePickerController Delegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        photoImage = image
        picker.dismissViewControllerAnimated(true, completion: nil);
        self.performSegueWithIdentifier("toEdit", sender: nil)
    }
    
    func loadData(){
        SVProgressHUD.showWithStatus("ロード中", maskType: SVProgressHUDMaskType.Black)
        var usersData: PFQuery = PFQuery(className: "Photo")
        usersData.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            if error != nil {
                self.showErrorAlert(error!)
            }else {
                for object in objects! {
                    if object["image"] != nil {
                        let userImageFile = object.valueForKey("image") as! PFFile
                        self.photoArray.append(UIImage(data:userImageFile.getData()!)!)
                    }
                }
                self.collectionView.reloadData()
                SVProgressHUD.dismiss()
            }
        }
    }
    
    func showErrorAlert(error: NSError) {
        var errorMessage = error.description
        
        if error.code == 209 {
            NSLog("session token == %@", PFUser.currentUser()!.sessionToken!)
            errorMessage = "セッショントークンが切れました。ログアウトします。"
            PFUser.currentUser()?.delete()
            SVProgressHUD.showSuccessWithStatus("ログアウトしました", maskType: SVProgressHUDMaskType.Black)
            self.dismissViewControllerAnimated(true, completion: nil)
            PFUser.enableRevocableSessionInBackgroundWithBlock { (error: NSError?) -> Void in
                println("Session token deprecated")
            }
        }
        var alertController = UIAlertController(title: "通信エラー", message: errorMessage, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: .Cancel) {
            action in
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        alertController.addAction(okAction)
        presentViewController(alertController, animated: true, completion: nil)
        
        if SVProgressHUD.isVisible() {
            SVProgressHUD.dismiss()
        }
    }
}

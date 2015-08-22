//
//  PhotoViewController.swift
//  volleyball
//
//  Created by 三ツ井杏希 on 2015/07/10.
//  Copyright (c) 2015年 三ツ井杏希. All rights reserved.
//

import UIKit
import Parse

class PhotoViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var collectionView: UICollectionView!
    
    var photoArray = [UIImage]()
    var lookArray = [Int]()
    var likeArray = [Int]()
    var commentArray = [String]()
    var nameArray = [String]()
    var photoImage: UIImage!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
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
        var likeLabel = cell.viewWithTag(2) as! UILabel!
        imageView.image = photoArray[indexPath.row]
        likeLabel.text = String(likeArray[indexPath.row])
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        var ud = NSUserDefaults.standardUserDefaults()
        ud.setObject(UIImagePNGRepresentation(photoArray[indexPath.row]), forKey: "photo")
        ud.setObject(lookArray[indexPath.row], forKey: "look")
        ud.setObject(likeArray[indexPath.row], forKey: "like")
        ud.setObject(commentArray[indexPath.row], forKey: "comment")
        ud.setObject(nameArray[indexPath.row], forKey: "name")
        ud.synchronize()
        // self.navigationController?.performSegueWithIdentifier("toPreview", sender: nil)
    }
    
    @IBAction func selectImage() {
        var imagePicker: UIImagePickerController = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(imagePicker, animated:true, completion:nil)
    }
    
    @IBAction func refresh() {
        self.photoArray = [UIImage]()
        self.loadData()
    }
    
    // MARK: UIImagePickerController Delegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        var ud = NSUserDefaults.standardUserDefaults()
        ud.setObject(UIImagePNGRepresentation(image), forKey: "addImage")
        ud.synchronize()
        picker.dismissViewControllerAnimated(true, completion: nil);
        self.performSegueWithIdentifier("toAdd", sender: nil)
    }
    
    func loadData() {
        photoArray = [UIImage]()
        lookArray = [Int]()
        likeArray = [Int]()
        commentArray = [String]()
        nameArray = [String]()
        SVProgressHUD.showWithStatus("ロード中", maskType: SVProgressHUDMaskType.Black)
        var query: PFQuery = PFQuery(className: "Photo")
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            if error != nil {
                self.showErrorAlert(error!)
            }else {
                for object in objects! {
                    if object["image"] != nil {
                        let photo = object.valueForKey("image") as! PFFile
                        self.photoArray.append(UIImage(data:photo.getData()!)!)
                    }
                    if object["look"] != nil {
                        let look = object.valueForKey("look") as! Int
                        self.lookArray.append(look)
                    }else {
                        self.lookArray.append(0)
                    }
                    if object["like"] != nil {
                        let like = object.valueForKey("like") as! Int
                        self.likeArray.append(like)
                    }else {
                        self.likeArray.append(0)
                    }
                    if object["comment"] != nil {
                        let comment = object.valueForKey("comment") as! String
                        self.commentArray.append(comment)
                    }else {
                        self.commentArray.append("No comment")
                    }
                    if object["name"] != nil {
                        let comment = object.valueForKey("name") as! String
                        self.nameArray.append(comment)
                    }else {
                        self.nameArray.append("No name")
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toPreview" {
            // var previewViewController = segue.destinationViewController as! PreviewViewController
            // previewViewController.photoImage = self.photoImage
        }else if segue.identifier == "toAdd" {
            
        }
    }
}

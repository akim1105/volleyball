//
//  MovieViewController.swift
//  volleyball
//
//  Created by 三ツ井杏希 on 2015/07/07.
//  Copyright (c) 2015年 三ツ井杏希. All rights reserved.
//

import UIKit

class MovieViewController: UIViewController, UIWebViewDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var containerView: UIView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var goodLabel: UILabel!
    @IBOutlet var numberLabel: UILabel!
    @IBOutlet var movieList: UITableView!
    @IBOutlet var favoriteButton: UIButton!
    
    var movieNameArray = [String]() //動画のタイトルを入れる用の配列
    var good = [Int]()
    var count = [Int]()
    var time = [String]()
    var URLArray = [String]()
    var images = [UIImage]()
    var objectIds = [String]()
    var movieID: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieList.dataSource = self
        movieList.delegate = self
        
        self.navigationItem.title = NSUserDefaults.standardUserDefaults().objectForKey("movieName") as? String
        titleLabel.text = NSUserDefaults.standardUserDefaults().objectForKey("movieName") as? String
        var formatter = NSNumberFormatter()
        formatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        formatter.groupingSeparator = ","
        formatter.groupingSize = 3
        
        timeLabel.text = NSUserDefaults.standardUserDefaults().objectForKey("time") as? String
        goodLabel.text = formatter.stringFromNumber(NSUserDefaults.standardUserDefaults().objectForKey("good") as! Int)
        numberLabel.text = formatter.stringFromNumber(NSUserDefaults.standardUserDefaults().objectForKey("count") as! Int)
        
        // play
        self.playVideo(NSUserDefaults.standardUserDefaults().objectForKey("URL") as! String)
        
        favoriteButton.setTitle("お気に入り", forState: UIControlState.Normal)
        self.loadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func showGuruguru(){
        SVProgressHUD.show()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // セルの数
        return images.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // セルの内容
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! UITableViewCell
        cell.imageView!.image = images[indexPath.row]
        
        var titleLabel = cell.viewWithTag(1) as! UILabel
        var timeLabel = cell.viewWithTag(2) as! UILabel
        var goodLabel = cell.viewWithTag(3) as! UILabel
        var watchLabel = cell.viewWithTag(4) as! UILabel
        
        var formatter = NSNumberFormatter()
        formatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        formatter.groupingSeparator = ","
        formatter.groupingSize = 3
        
        titleLabel.text = self.movieNameArray[indexPath.row]
        timeLabel.text = self.time[indexPath.row]
        goodLabel.text = String(self.good[indexPath.row])
        watchLabel.text = formatter.stringFromNumber(count[indexPath.row])
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // セルが選択されたとき
        var ud = NSUserDefaults.standardUserDefaults()
        ud.setObject(URLArray[indexPath.row], forKey: "URL")
        // self.playVideo(URLArray[indexPath.row])
        ud.synchronize()
        self.viewDidLoad()
    }
    
    // Get data from Parse
    func loadData() {
        SVProgressHUD.showWithStatus("ロード中", maskType: SVProgressHUDMaskType.Clear)
        
        var query: PFQuery = PFQuery(className: "Movie")
        query.orderByAscending("createdAt")
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            if error != nil {
                self.showErrorAlert(error!)
            }else {
                var number: Int = 0
                for object in objects! {
                    // 自分がお気に入りに登録した動画だけ抽出
                    if NSUserDefaults.standardUserDefaults().objectForKey("URL") as! String == (object.valueForKey("URL") as! String) {
                        if object.valueForKey("favorite") != nil {
                            var userArray = object.valueForKey("favorite") as! NSArray
                            for favUser in userArray {
                                if favUser as! String == PFInstallation.currentInstallation().objectId! {
                                    // お気に入りに登録していた場合
                                    self.favoriteButton.setTitle("お気に入り解除", forState: UIControlState.Normal)
                                }
                            }
                        }
                    }
                    
                    NSLog("object == %@", object as! PFObject)
                    self.movieNameArray.append(object.valueForKey("title") as! String)
                    self.good.append(object.valueForKey("good") as! Int)
                    self.count.append(object.valueForKey("count") as! Int)
                    self.time.append(object.valueForKey("time") as! String)
                    self.URLArray.append(object.valueForKey("URL") as! String)
                    self.objectIds.append(object.valueForKey("objectId") as! String)
                    if object["Image"] != nil {
                        let userImageFile = object.valueForKey("Image") as! PFFile
                        self.images.append(UIImage(data:userImageFile.getData()!)!)
                    }
                    number = number + 1
                    if number > 19 {
                        self.movieList.reloadData()
                        SVProgressHUD.dismiss()
                        return
                    }
                }
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
    
    @IBAction func favorite() {
        if favoriteButton.titleLabel!.text == "お気に入り" {
            favoriteButton.setTitle("お気に入り解除", forState: UIControlState.Normal)
            self.sendFavorite()
        }else {
            favoriteButton.setTitle("お気に入り", forState: UIControlState.Normal)
            self.cancelFavorite()
        }
    }
    
    func sendFavorite() {
        var query: PFQuery = PFQuery(className: "Movie")
        SVProgressHUD.showWithStatus("お気に入り登録中...")
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            for object in (objects as! [PFObject]) {
                if(error == nil){
                    if object.objectId == NSUserDefaults.standardUserDefaults().objectForKey("objectId") as? String {
                        
                        if PFInstallation.currentInstallation().objectId != nil {
                            //object.addUniqueObject(object.objectId!, forKey: "favorite")
                            object.addUniqueObject(PFInstallation.currentInstallation().objectId!, forKey: "favorite")
                            object.saveInBackgroundWithBlock { (succeeded, error) -> Void in
                                if succeeded == true {
                                    SVProgressHUD.showSuccessWithStatus("お気に入りに登録しました")
                                }
                            }
                        }else {
                            NSLog("何かしらの理由でインストールIDが取得できませんでした")
                            SVProgressHUD.showErrorWithStatus("エラー")
                        }
                    }
                }else{
                    SVProgressHUD.showErrorWithStatus(error?.description)
                }
            }
        }
    }
    
    func cancelFavorite() {
        var query: PFQuery = PFQuery(className: "Movie")
        SVProgressHUD.showWithStatus("お気に入り解除中...")
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            for object in (objects as! [PFObject]) {
                if(error == nil){
                    if object.objectId == NSUserDefaults.standardUserDefaults().objectForKey("objectId") as? String {
                        if PFInstallation.currentInstallation().objectId != nil {
                            // object.removeObject(object.objectId!, forKey: "favorite")
                            object.removeObject(PFInstallation.currentInstallation().objectId!, forKey: "favorite")
                            object.saveInBackgroundWithBlock { (succeeded, error) -> Void in
                                if succeeded == true {
                                    SVProgressHUD.showSuccessWithStatus("お気に入りを解除しました")
                                }
                            }
                        }else {
                            NSLog("何かしらの理由でインストールIDが取得できませんでした")
                            SVProgressHUD.showErrorWithStatus("エラー")
                        }
                    }
                }else{
                    SVProgressHUD.showErrorWithStatus(error?.description)
                }
            }
        }
    }
    
    func playVideo(movieURL: String) {
        var array = movieURL.componentsSeparatedByString("=")
        var videoPlayerViewController = XCDYouTubeVideoPlayerViewController(videoIdentifier: array[1])
        videoPlayerViewController.presentInView(containerView)
        videoPlayerViewController.moviePlayer.play()
    }
}


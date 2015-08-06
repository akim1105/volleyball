//
//  Category2TableViewController.swift
//  volleyball
//
//  Created by 三ツ井杏希 on 2015/07/12.
//  Copyright (c) 2015年 三ツ井杏希. All rights reserved.
//

import UIKit

class Category2TableViewController: UITableViewController, UIWebViewDelegate  {
    
    @IBOutlet var table: UITableView!
    
    var movieArray = [PFObject]() // Parseから取ってきたデータを全部入れるための配列
    var movieNameArray = [String]() //動画のタイトルを入れる用の配列
    var good = [Int]()
    var count = [Int]()
    var time = [String]()
    var URLArray = [String]()
    var imageArray = [PFFile]()
    var objectIds = [String]()
    var images = [UIImage]()

    override func viewDidLoad() {
        super.viewDidLoad()

        table.dataSource = self
        table.delegate = self
        
        tableView.registerNib(UINib(nibName: "MovieTableViewCell", bundle: nil),
            forCellReuseIdentifier: "Cell")

        self.loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return movieNameArray.count
        
        
        
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as!MovieTableViewCell
        
        for object in movieArray {
            NSLog("%@", object)
            movieNameArray.append(object.valueForKey("title") as! String)
            good.append(object.valueForKey("good") as! Int)
            count.append(object.valueForKey("count") as! Int)
            time.append(object.valueForKey("time") as! String)
            URLArray.append(object.valueForKey("URL") as! String)
            // TODO: get image
        }

        cell.label?.text = movieNameArray[indexPath.row]
        cell.likelabel?.text = String(good[indexPath.row])
        cell.looklabel?.text = String(count[indexPath.row])
        cell.timelabel?.text = String(time[indexPath.row])
        cell.imageView?.image = images[indexPath.row]
        
        cell.blackView.hidden = true
        cell.rankLabel.hidden = true

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let ud = NSUserDefaults.standardUserDefaults()
        ud.setObject(URLArray[indexPath.row], forKey: "URL")
        ud.synchronize()
        
        self.performSegueWithIdentifier("toMovie", sender: nil)
    }

    // Get data from Parse
    func loadData(){
        SVProgressHUD.showWithStatus("ロード中", maskType: SVProgressHUDMaskType.Clear)
        
        var query: PFQuery = PFQuery(className: "Movie")
        query.orderByAscending("createdAt")
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            if error != nil {
                self.showErrorAlert(error!)
            }else {
                for object in objects! {
                    // 動画のtagを抽出
                    if object.valueForKey("tag") != nil {
                        if PFInstallation.currentInstallation().objectId != nil {
                            var tagArray = object.valueForKey("tag") as! NSArray
                            for tag in tagArray {
                                if tag as! String == NSUserDefaults.standardUserDefaults().objectForKey("tag") as! String {
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
                                }
                            }
                        }
                    }
                }
                self.table.reloadData()
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

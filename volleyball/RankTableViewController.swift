//
//  RankTableViewController.swift
//  volleyball
//
//  Created by 三ツ井杏希 on 2015/07/05.
//  Copyright (c) 2015年 三ツ井杏希. All rights reserved.
//

import UIKit

class RankTableViewController: UITableViewController, UIWebViewDelegate {
    
    @IBOutlet var table: UITableView!
    var movieNameArray = [String]() //動画のタイトルを入れる用の配列
    var good = [Int]()
    var count = [Int]()
    var time = [String]()
    var URLArray = [String]()
    var images = [UIImage]()
    var objectIds = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.dataSource = self
        table.delegate = self
        
        tableView.registerNib(UINib(nibName: "MovieTableViewCell", bundle: nil),
            forCellReuseIdentifier: "Cell")
        
        self.loadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieNameArray.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! MovieTableViewCell
        
        var formatter = NSNumberFormatter()
        formatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        formatter.groupingSeparator = ","
        formatter.groupingSize = 3
        
        cell.label?.text = movieNameArray[indexPath.row]
        cell.likelabel?.text = formatter.stringFromNumber(good[indexPath.row])
        cell.looklabel?.text = formatter.stringFromNumber(count[indexPath.row])
        cell.timelabel?.text = String(time[indexPath.row])
        //cell.imageView?.image = images[indexPath.row]
        cell.movieimageView.image = images[indexPath.row]
        cell.rankLabel.text = String(format: "%d", indexPath.row + 1)
        
        // セルの境界線
        if (cell.respondsToSelector(Selector("setSeparatorInset:"))) {
            cell.separatorInset = UIEdgeInsetsZero
        }
        if (cell.respondsToSelector(Selector("setLayoutMargins:"))) {
            cell.layoutMargins = UIEdgeInsetsZero
        }
        
        return cell
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if (self.tableView.respondsToSelector(Selector("setSeparatorInset:"))) {
            self.tableView.separatorInset = UIEdgeInsetsZero
        }
        if (self.tableView.respondsToSelector(Selector("setLayoutMargins:"))) {
            self.tableView.layoutMargins = UIEdgeInsetsZero
        }
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // TableViewのセルがタップされた時の処理
        let ud = NSUserDefaults.standardUserDefaults()
        ud.setObject(URLArray[indexPath.row], forKey: "URL")
        ud.setObject(movieNameArray[indexPath.row], forKey: "movieName")
        ud.setObject(objectIds[indexPath.row], forKey: "objectId")
        ud.setObject(count[indexPath.row], forKey: "count")
        ud.setObject(good[indexPath.row], forKey: "good")
        ud.setObject(time[indexPath.row], forKey: "time")
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
                var number: Int = 0
                for object in objects! {
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
                        self.table.reloadData()
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
    
    /*
    @IBAction func backToTop() {
    self.dismissViewControllerAnimated(true, completion: nil)
    }
    */
}

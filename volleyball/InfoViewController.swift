//
//  InfoViewController.swift
//  volleyball
//
//  Created by 三ツ井杏希 on 2015/07/10.
//  Copyright (c) 2015年 三ツ井杏希. All rights reserved.
//

import UIKit
import Parse

class InfoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var table: UITableView!
    
    var tourArray = [String]()
    var scheduleArray = [String]()
    var placeArray = [String]()
    var URLArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.dataSource = self
        table.delegate = self
        
        table.registerNib(UINib(nibName: "InfoTableViewCell", bundle: nil),
            forCellReuseIdentifier: "Cell")
        
        self.loadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tourArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as!InfoTableViewCell
        
        cell.tourlabel.text = tourArray[indexPath.row]
        cell.schedulelabel.text = scheduleArray[indexPath.row]
        cell.placelabel.text = placeArray[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // TableViewのセルがタップされた時の処理
        self.performSegueWithIdentifier("toHP", sender: nil)
        
        // 押されたセルのURLを保存
        var ud = NSUserDefaults.standardUserDefaults()
        ud.setObject(URLArray[indexPath.row], forKey: "URL")
        ud.synchronize()
        
        // セルの選択状態の解除
        table.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func loadData() {
        
        SVProgressHUD.showWithStatus("ロード中", maskType: SVProgressHUDMaskType.Black)
        // データを取得してくるクラスの名前を指定
        var query: PFQuery = PFQuery(className: "Competition")
        
        // データを実際に取ってくる
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            if error != nil {
                self.showErrorAlert(error!)
            }else {
                // 取ってきたデータを1つずつ解析して、配列に入れ直す
                for object in objects! {
                    if object["date"] != nil {
                        let date = object.valueForKey("date") as! String
                        self.scheduleArray.append(date)
                    }
                    if object["name"] != nil {
                        let tour = object.valueForKey("name") as! String
                        self.tourArray.append(tour)
                    }
                    if object["place"] != nil {
                        let place = object.valueForKey("place") as! String
                        self.placeArray.append(place)
                    }
                    if object["URL"] != nil {
                        let URL = object.valueForKey("URL") as! String
                        self.URLArray.append(URL)
                    }
                }
                // データを取り終わったら、テーブルビューをリロードしてデータを再表示
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
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        }else {
            cell.backgroundColor = UIColor(red: 244/255, green: 60/255, blue: 60/255, alpha: 0.05)
        }
    }

}




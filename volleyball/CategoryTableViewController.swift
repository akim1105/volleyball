//
//  CategoryTableViewController.swift
//  volleyball
//
//  Created by 三ツ井杏希 on 2015/07/12.
//  Copyright (c) 2015年 三ツ井杏希. All rights reserved.
//

import UIKit

class CategoryTableViewController: UIViewController,UIWebViewDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var table: UITableView!
    
    var playNameArray = [String]()
    var ageArray = [String]()
    var typeArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.dataSource = self
        table.delegate = self
        
        playNameArray = ["スーパープレー","スパイク","サーブ","レシーブ","トス"]
        ageArray = ["小学生", "中学生", "高校生", "大学生", "プロ"]
        typeArray = ["練習", "試合", "密着"]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // セクションの数
        return 3;
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "プレー"
        }else if section == 1 {
            return "年代"
        }else if section == 2 {
            return "じっくり"
        }
        return "タイトル"
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return playNameArray.count
        }else if section == 1 {
            return ageArray.count
        }else if section == 2 {
            return typeArray.count
        }
        return 1
    }
    
    override func performSegueWithIdentifier(identifier: String?, sender: AnyObject?) {
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // TableViewのセルがタップされた時の処理
        let ud = NSUserDefaults.standardUserDefaults()
        if indexPath.section == 0 {
            ud.setObject(playNameArray[indexPath.row], forKey: "tag")
        }else if indexPath.section == 1 {
            ud.setObject(ageArray[indexPath.row], forKey: "tag")
        }else if indexPath.section == 2 {
            ud.setObject(typeArray[indexPath.row], forKey: "tag")
        }
        ud.synchronize()
        self.performSegueWithIdentifier("toM", sender: nil)
        table.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as!UITableViewCell
        if indexPath.section == 0 {
            cell.textLabel?.text = playNameArray[indexPath.row]
        }else if indexPath.section == 1 {
            cell.textLabel?.text = ageArray[indexPath.row]
        }else if indexPath.section == 2 {
            cell.textLabel?.text = typeArray[indexPath.row]
        }
        
        return cell
    }
}

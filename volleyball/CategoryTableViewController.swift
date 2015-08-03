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
    
    var categoryNameArray = [String]()
    var ageArray = [String]()
    var schoolArray = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.dataSource = self
        table.delegate = self
        
        categoryNameArray = ["スーパープレー","アタック","レシーブ"]
        ageArray = ["2010年", "2011年", "2012年", "2013年", "2014年", "2015年"]
        schoolArray = ["八王子実践高校", "下北沢成徳高等学校", "和光高校", "星城高校"]
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
            return "プレー別"
        }else if section == 1 {
            return "年代別"
        }else if section == 2 {
            return "学校別"
        }
        return "タイトル"
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return categoryNameArray.count
        }else if section == 1 {
            return ageArray.count
        }else if section == 2 {
            return schoolArray.count
        }
        return 1
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // TableViewのセルがタップされた時の処理
        self.performSegueWithIdentifier("toM", sender: nil)
        
        table.deselectRowAtIndexPath(indexPath, animated: true)
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as!UITableViewCell
        if indexPath.section == 0 {
            cell.textLabel?.text = categoryNameArray[indexPath.row]
        }else if indexPath.section == 1 {
            cell.textLabel?.text = ageArray[indexPath.row]
        }else if indexPath.section == 2 {
            cell.textLabel?.text = schoolArray[indexPath.row]
        }
        
        return cell
    }

}

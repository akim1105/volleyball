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
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.dataSource = self
        table.delegate = self
        
        categoryNameArray = ["スーパープレー","アタック","レシーブ"]

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return  categoryNameArray.count
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // TableViewのセルがタップされた時の処理
        
        self.performSegueWithIdentifier("toM", sender: nil)
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as!UITableViewCell
        
        cell.textLabel?.text = categoryNameArray[indexPath.row]
        return cell
    }

}

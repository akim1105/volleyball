//
//  InfoViewController.swift
//  volleyball
//
//  Created by 三ツ井杏希 on 2015/07/10.
//  Copyright (c) 2015年 三ツ井杏希. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var table: UITableView!
    
    var tourArray = [String]()
    var scheduleArray = [String]()
    var placeArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.dataSource = self
        table.delegate = self
        
        table.registerNib(UINib(nibName: "InfoTableViewCell", bundle: nil),
            forCellReuseIdentifier: "Cell")
        
        tourArray = ["あああ大会","いいい大会","ううう大会"]
        scheduleArray = ["8/12","2/8","9/26"]
        placeArray = ["あ体育館","い体育館","う体育館"]
        
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
        
        // セルの選択状態の解除
        table.deselectRowAtIndexPath(indexPath, animated: true)
    }
}




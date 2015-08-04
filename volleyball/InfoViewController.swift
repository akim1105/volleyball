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
    
    var number: Int!

    override func viewDidLoad() {
        super.viewDidLoad()

        table.dataSource = self
        table.delegate = self
        
        table.registerNib(UINib(nibName: "InfoTableViewCell", bundle: nil),
            forCellReuseIdentifier: "Cell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as!InfoTableViewCell
        
        cell.tourlabel.text = "全国高等学校バレーボール大会"
        cell.schedulelabel.text = "8月23日"
        cell.placelabel.text = "東京体育館"
        
        return cell
    }

    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // TableViewのセルがタップされた時の処理
        self.performSegueWithIdentifier("toHP", sender: nil)
        
        // セルの選択状態の解除
        table.deselectRowAtIndexPath(indexPath, animated: true)
    }
}







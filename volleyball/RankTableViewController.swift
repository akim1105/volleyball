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
    
    var movieArray = [PFObject]() // Parseから取ってきたデータを全部入れるための配列
    var movieNameArray = [String]() //動画のタイトルを入れる用の配列
    var good = [Int]()
    var count = [Int]()
    var time = [String]()
    var URLArray = [String]()
    var imageArray = [PFFile]()
    var images = [UIImage]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.dataSource = self
        table.delegate = self
        
        tableView.registerNib(UINib(nibName: "MovieTableViewCell", bundle: nil),
        forCellReuseIdentifier: "Cell")

        self.loadData { (objects, error) -> () in
            self.movieArray = objects
            
            for object in objects {
                self.imageArray.append(object.valueForKey("Image") as! PFFile)
                for imageFile in self.imageArray {
                    imageFile.getDataInBackgroundWithBlock({ (imageData, error) -> Void in
                        if(error == nil) {
                            self.images.append(UIImage(data: imageData!)!)
                            self.table.reloadData()
                        }
                    })

                }
            }
        }
        

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

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return movieArray.count
    }
    
   
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! MovieTableViewCell
        
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
        
        return cell
    }


    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // TableViewのセルがタップされた時の処理
        // MovieViewControllerを取得してmovieVCに入れておく
        let ud = NSUserDefaults.standardUserDefaults()
        ud.setObject(URLArray[indexPath.row], forKey: "URL")
        ud.synchronize()
        
        self.performSegueWithIdentifier("toMovie", sender: nil)
    }
    
    func loadData(callback:([PFObject]!, NSError!) -> ())  {
        var query: PFQuery = PFQuery(className: "Movie")
        query.orderByAscending("createdAt")
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if (error != nil){
                // エラー処理
            }
            for object in objects! {
                self.imageArray.append(object.valueForKey("Image") as! PFFile)
            }
            callback(objects as! [PFObject], error)
        }
    }
}

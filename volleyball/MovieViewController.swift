//
//  MovieViewController.swift
//  volleyball
//
//  Created by 三ツ井杏希 on 2015/07/07.
//  Copyright (c) 2015年 三ツ井杏希. All rights reserved.
//

import UIKit

class MovieViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet var containerView: UIView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var goodLabel: UILabel!
    @IBOutlet var numberLabel: UILabel!
    
    var movieNameArray = [String]()
    var like = [Int]()
    var look = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = NSUserDefaults.standardUserDefaults().objectForKey("movieName") as? String
        titleLabel.text = NSUserDefaults.standardUserDefaults().objectForKey("movieName") as? String

        let movieURL = NSUserDefaults.standardUserDefaults().objectForKey("URL") as! String
        NSLog("URL == %@", movieURL)
        var array = movieURL.componentsSeparatedByString("=")

        var videoPlayerViewController = XCDYouTubeVideoPlayerViewController(videoIdentifier: array[1])
        videoPlayerViewController.presentInView(containerView)
        videoPlayerViewController.moviePlayer.play()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func showGuruguru(){
       SVProgressHUD.show()
    }
    
}


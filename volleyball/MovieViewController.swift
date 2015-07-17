//
//  MovieViewController.swift
//  volleyball
//
//  Created by 三ツ井杏希 on 2015/07/07.
//  Copyright (c) 2015年 三ツ井杏希. All rights reserved.
//

import UIKit

class MovieViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet var webView: UIWebView!
    
    var movieNameArray = [String]()
    var like = [Int]()
    var look = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let movieURL = NSUserDefaults.standardUserDefaults().objectForKey("URL") as! String
        webView.delegate = self
        var url = NSURL(string: movieURL)
        var urlRequest: NSURLRequest = NSURLRequest(URL: url!)
        webView.allowsInlineMediaPlayback = true;
        webView.loadRequest(urlRequest)
        
        NSLog("%@",url!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func showGuruguru(){
       SVProgressHUD.show()
    }
    
}


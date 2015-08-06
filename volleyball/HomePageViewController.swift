//
//  HomePageViewController.swift
//  volleyball
//
//  Created by 三ツ井杏希 on 2015/07/12.
//  Copyright (c) 2015年 三ツ井杏希. All rights reserved.
//

import UIKit

class HomePageViewController: UIViewController, UIWebViewDelegate  {
    
    @IBOutlet var webView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()

        webView.delegate = self
        
        // InfoViewControllerでセルを選択したときに保存しておいたURLを呼び出す
        var ud = NSUserDefaults.standardUserDefaults()
        let URLString = ud.objectForKey("URL") as! String
        
        // URLの文字列をWebに対してリクエスト
        var url = NSURL(string: URLString)
        var urlRequest: NSURLRequest = NSURLRequest(URL: url!)
        webView.allowsInlineMediaPlayback = true;
        webView.scalesPageToFit = true
        webView.loadRequest(urlRequest)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

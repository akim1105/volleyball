//
//  ViewController.swift
//  volleyball
//
//  Created by 三ツ井杏希 on 2015/07/03.
//  Copyright (c) 2015年 三ツ井杏希. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var movieBt: UIButton!
    @IBOutlet var photoBt: UIButton!
    @IBOutlet var infoBt: UIButton!


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        movieBt.layer.borderWidth = 3.0
        photoBt.layer.borderWidth = 3.0
        infoBt.layer.borderWidth = 3.0
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    
    
}



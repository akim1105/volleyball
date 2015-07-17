//
//  PhotoViewController.swift
//  volleyball
//
//  Created by 三ツ井杏希 on 2015/07/10.
//  Copyright (c) 2015年 三ツ井杏希. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate {
    
    
    @IBOutlet var collectionView: UICollectionView!
    
    var photoArray = [UIImage]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        photoArray.append(UIImage(named: "kaikai3.jpg")!)
        photoArray.append(UIImage(named: "hukuoka3.jpg")!)
        photoArray.append(UIImage(named: "higasi2.png")!)
        photoArray.append(UIImage(named: "kaikai.jpg")!)
        photoArray.append(UIImage(named: "haikei.jpg")!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! UICollectionViewCell
        var imageView = cell.viewWithTag(1) as! UIImageView!
        imageView.image = photoArray[indexPath.row]
        return cell
    }
}

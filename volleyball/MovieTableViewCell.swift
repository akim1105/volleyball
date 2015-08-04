//
//  MovieTableViewCell.swift
//  volleyball
//
//  Created by 三ツ井杏希 on 2015/07/05.
//  Copyright (c) 2015年 三ツ井杏希. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    
    @IBOutlet var movieimageView : UIImageView!
    @IBOutlet var label: UILabel!
    @IBOutlet var likelabel: UILabel!
    @IBOutlet var looklabel: UILabel!
    @IBOutlet var timelabel: UILabel!
    @IBOutlet var rankLabel: UILabel!
    @IBOutlet var blackView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //movieimageView.image = nil
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

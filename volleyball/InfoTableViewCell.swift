//
//  InfoTableViewCell.swift
//  volleyball
//
//  Created by 三ツ井杏希 on 2015/07/10.
//  Copyright (c) 2015年 三ツ井杏希. All rights reserved.
//

import UIKit

class InfoTableViewCell: UITableViewCell {

    @IBOutlet var tourlabel: UILabel!
    @IBOutlet var schedulelabel: UILabel!
    @IBOutlet var placelabel: UILabel!
    // @IBOutlet var timelabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

    
}

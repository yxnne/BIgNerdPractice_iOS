//
//  ItemCell.swift
//  Homepwner
//
//  Created by iel-mac on 2017/7/5.
//  Copyright © 2017年 iel-mac. All rights reserved.
//

import UIKit

class ItemCell : UITableViewCell{
    
    @IBOutlet var nameLabel : UILabel!
    @IBOutlet var serialNumberLabel:UILabel!
    @IBOutlet var valueLabel : UILabel!

    
    //重写这个方法为了适应用户对字体的设置，因为已经用了系统字体在storyboard里面
    override func awakeFromNib() {
        super.awakeFromNib()
        
        nameLabel.adjustsFontForContentSizeCategory = true
        serialNumberLabel.adjustsFontForContentSizeCategory = true
        valueLabel.adjustsFontForContentSizeCategory = true
    }
    
}

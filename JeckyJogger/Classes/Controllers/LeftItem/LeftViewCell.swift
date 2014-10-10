//
//  LeftViewCell.swift
//  JeckyMenu
//
//  Created by Jecky on 14-9-28.
//  Copyright (c) 2014年 njut. All rights reserved.
//

import UIKit

class LeftViewCell: UITableViewCell {
    
    var imgView:UIImageView?
    var nameLabel:UILabel?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = UIColor.clearColor()
        self.contentView.backgroundColor = UIColor.clearColor()
        
        self.imgView = UIImageView(frame: CGRectMake(40, 11, 32, 32))
        self.imgView?.backgroundColor = UIColor.clearColor()
        self.imgView?.image = UIImage(named: "IconHome")
        self.contentView.addSubview(self.imgView!)
        
        self.nameLabel = UILabel(frame: CGRectMake(82, 12, 100, 30))
        self.nameLabel?.backgroundColor = UIColor.clearColor()
        self.nameLabel?.font = UIFont.systemFontOfSize(24.0)
        self.nameLabel?.textColor = UIColor.whiteColor()
        self.nameLabel?.text = "Home"
        self.contentView.addSubview(self.nameLabel!)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

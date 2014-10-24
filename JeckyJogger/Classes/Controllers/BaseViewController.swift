//
//  BaseViewController.swift
//  JeckyMenu
//
//  Created by Jecky on 14-9-28.
//  Copyright (c) 2014年 njut. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    var containerView:UIImageView?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        // Do any additional setup after loading the view. 
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "bg_navbar")?.resizableImageWithCapInsets(UIEdgeInsetsMake(20, 100, 20, 100), resizingMode: UIImageResizingMode.Stretch), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont.boldSystemFontOfSize(20.0)]
        
        NSLog("NSStringFromClass: %@", NSStringFromClass(object_getClass(self)))
        
        let date = NSDate()
        let name = NSStringFromClass(object_getClass(date))
        println(name)
        
    }

    func back(){
        
    }
    

}

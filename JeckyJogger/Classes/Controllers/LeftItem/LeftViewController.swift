//
//  LeftViewController.swift
//  JeckyMenu
//
//  Created by Jecky on 14-9-28.
//  Copyright (c) 2014年 njut. All rights reserved.
//

import UIKit

class LeftViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {

    var tableView:UITableView?
    let RESideMenuCell:String = "RESideMenuCell"
    
    var imgArray = ["IconHome","IconCalendar", "IconSettings"]
    var nameArray = ["Home", "Achieve", "Settings"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.clearColor()

        // Do any additional setup after loading the view.
        tableView = UITableView(frame: CGRectMake(0, 160, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-160), style: UITableViewStyle.Plain)
        tableView!.dataSource = self
        tableView!.delegate = self
        tableView!.backgroundColor = UIColor.clearColor()
        tableView!.backgroundView = nil
        tableView!.separatorStyle = UITableViewCellSeparatorStyle.None
        self.view.addSubview(tableView!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return kItemTypeE.kItemTypeSettings.rawValue + 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var cell = tableView.dequeueReusableCellWithIdentifier(RESideMenuCell) as? LeftViewCell
        if cell == nil {
            cell = LeftViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: RESideMenuCell)
//            cell?.selectionStyle = UITableViewCellSelectionStyle.None
            
        }
        cell!.imgView!.image = UIImage(named:imgArray[indexPath.row])
        cell!.nameLabel!.text = nameArray[indexPath.row]
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 54.0
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        tableView.deselectRowAtIndexPath(indexPath, animated:true)
                
        AppDelegate.appDelegate().showViewController(kItemTypeE(rawValue: indexPath.row)!)
    }


}

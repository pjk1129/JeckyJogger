//
//  RecordViewController.swift
//  JeckyJogger
//
//  Created by Jecky on 14-10-7.
//  Copyright (c) 2014年 Jecky. All rights reserved.
//

import UIKit

class RecordViewController: BaseViewController, UITableViewDelegate,UITableViewDataSource  {

    var dataArray:NSArray?
    
    var tableView:UITableView?
    let RecordCell:String = "RecordCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.title = "Achieve"

        var button = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
        button.frame = CGRectMake(0, 0, 44, 44)
        button.setBackgroundImage(UIImage(named: "bg_menu_nor"), forState: UIControlState.Normal)
        button.setBackgroundImage(UIImage(named: "bg_menu_act"), forState: UIControlState.Selected)
        button.setBackgroundImage(UIImage(named: "bg_menu_act"), forState: UIControlState.Highlighted)
        button.addTarget(self, action: "back", forControlEvents: UIControlEvents.TouchUpInside)
        var buttonItem = UIBarButtonItem(customView: button) as UIBarButtonItem
        self.navigationItem.leftBarButtonItem = buttonItem
        
        tableView = UITableView(frame: self.view.bounds, style: UITableViewStyle.Plain)
        tableView!.dataSource = self
        tableView!.delegate = self
        tableView!.registerClass(UITableViewCell.self, forCellReuseIdentifier:RecordCell)
        self.view.addSubview(tableView!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func back(){
        self.sideMenuViewController.presentLeftMenuViewController()
    }
    
    func reloadData(){
        dataArray = JoggerManager.shareInstance().historyRunData()
        NSLog("dataArray: %@", dataArray!)
        self.tableView?.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return dataArray!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var cell = tableView.dequeueReusableCellWithIdentifier(RecordCell) as? UITableViewCell
        
        var runData = dataArray?.objectAtIndex(indexPath.row) as? RunData
        cell?.textLabel?.text = runData?.orderId
        return cell!
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        return 54.0
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        tableView.deselectRowAtIndexPath(indexPath, animated:true)
        var controller:RunDetailViewController = RunDetailViewController()
        controller.runRecord = dataArray?.objectAtIndex(indexPath.row) as? RunData
        self.navigationController!.pushViewController(controller, animated: true)
    }

}

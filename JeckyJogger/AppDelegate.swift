//
//  AppDelegate.swift
//  JeckyJogger
//
//  Created by Jecky on 14-10-2.
//  Copyright (c) 2014年 Jecky. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, RESideMenuDelegate{
    
    var window: UIWindow?
    var homeViewController:HomeViewController?
    var navHomeController:UINavigationController?
    var settingsViewController:SettingsViewController?
    var navSettingsController:UINavigationController?
    var recordViewController:RecordViewController?
    var navRecordController:UINavigationController?
    
    var leftViewController:LeftViewController?
    var sideMenu:RESideMenu?
    
    class func appDelegate() -> AppDelegate{
        return UIApplication.sharedApplication().delegate as AppDelegate
    }
    
    func configureAPIKey(){
        MAMapServices.sharedServices().apiKey = "ddf41a75ff5872b98af46ce993db3865"
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window!.backgroundColor = UIColor.whiteColor()
        
        configureAPIKey()
        
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
        
        initHomeView()
        
        self.leftViewController = LeftViewController()
        
        self.sideMenu = RESideMenu(contentViewController: self.navHomeController, leftMenuViewController: self.leftViewController, rightMenuViewController: nil)
        self.sideMenu?.backgroundImage = UIImage(named: "menu_background")
        self.sideMenu?.delegate = self
        self.sideMenu?.contentViewShadowColor = UIColor.blackColor()
        self.sideMenu?.contentViewShadowOffset = CGSizeMake(0, 0)
        self.sideMenu?.contentViewShadowOpacity = 0.6
        self.sideMenu?.contentViewShadowRadius = 12
        self.sideMenu?.contentViewShadowEnabled = true
        self.window?.rootViewController = self.sideMenu
        self.window!.makeKeyAndVisible()
        return true
    }
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func showViewController(type:kItemTypeE){        
        switch type {
        case .kItemTypeJogger:
            if self.sideMenu?.contentViewController != navHomeController {
                initHomeView()
                self.sideMenu?.setContentViewController(navHomeController, animated: true)
            }
            break;
        case .kItemTypeRunRecord:
            if self.sideMenu?.contentViewController != navRecordController {
                initRunRecord()
                self.sideMenu?.setContentViewController(navRecordController, animated: true)
            }
            recordViewController?.reloadData()
            break;
        case .kItemTypeSettings:
            if self.sideMenu?.contentViewController != navSettingsController {
                initSettings()
                self.sideMenu?.setContentViewController(navSettingsController, animated: true)
            }
            break;
        default:
            break;
        }
        
        self.sideMenu?.hideMenuViewController()
    }
    
    
    //RESideMenuDelegate
    func sideMenu(sideMenu: RESideMenu!, didHideMenuViewController menuViewController: UIViewController!) {
        
    }
    
    func sideMenu(sideMenu: RESideMenu!, didShowMenuViewController menuViewController: UIViewController!) {
        
    }
    
    func sideMenu(sideMenu: RESideMenu!, willHideMenuViewController menuViewController: UIViewController!) {
        
    }
    
    func sideMenu(sideMenu: RESideMenu!, willShowMenuViewController menuViewController: UIViewController!) {
        
    }
    
    func initHomeView(){
        if navHomeController == nil {
            self.homeViewController = HomeViewController()
            self.navHomeController = UINavigationController(rootViewController: self.homeViewController!)
        }
    }
    
    func initSettings(){
        if navSettingsController == nil {
            self.settingsViewController = SettingsViewController()
            self.navSettingsController = UINavigationController(rootViewController: self.settingsViewController!)
        }
    }
    
    func initRunRecord(){
        if navRecordController == nil {
            self.recordViewController = RecordViewController()
            self.navRecordController = UINavigationController(rootViewController: self.recordViewController!)
        }
    }
    
}


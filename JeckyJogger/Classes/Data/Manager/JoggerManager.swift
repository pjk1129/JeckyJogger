//
//  JoggerManager.swift
//  JeckyJogger
//
//  Created by Jecky on 14-10-6.
//  Copyright (c) 2014年 Jecky. All rights reserved.
//

import UIKit

class JoggerManager: NSObject {
   
    class func shareInstance()->JoggerManager{
        struct JoggerSingleton{
            static var predicate:dispatch_once_t = 0
            static var joggerManager:JoggerManager? = nil
        }
        dispatch_once(&JoggerSingleton.predicate,{
            JoggerSingleton.joggerManager = JoggerManager()
            }
        )
        return JoggerSingleton.joggerManager!
    }
    
    override init() {
        super.init()
        
    }
    
    func saveRunRecord(record:RunData){
        if record.orderId != nil {
            var array:NSMutableArray = NSMutableArray(capacity: 0)
            array.addObject(record)
            array.addObjectsFromArray(historyRunData())
            
            //数据存储，处理
//            var data:NSData? = NSKeyedArchiver.archivedDataWithRootObject(array)
//            NSUserDefaults.standardUserDefaults().setObject(data, forKey:"kHistoryRunData")
//            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    func historyRunData() -> NSArray{
        var data = NSUserDefaults.standardUserDefaults().objectForKey("kHistoryRunData") as? NSData
        if data != nil {
            return NSKeyedUnarchiver.unarchiveObjectWithData(data!) as NSArray
        }
        return []
    }
    
    func saveWeight(weight:Float){
        NSUserDefaults.standardUserDefaults().setFloat(weight, forKey:"kJoggerWeightData")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func joggerWeight() -> CGFloat{
        return CGFloat(NSUserDefaults.standardUserDefaults().floatForKey("kJoggerWeightData"))
    }
    
    func saveHeight(height:Float){
        NSUserDefaults.standardUserDefaults().setFloat(height, forKey:"kJoggerHeightData")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func joggerHeight() -> CGFloat{
        return CGFloat(NSUserDefaults.standardUserDefaults().floatForKey("kJoggerHeightData"))
    }
}

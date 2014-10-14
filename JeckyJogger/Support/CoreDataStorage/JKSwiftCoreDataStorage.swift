//
//  JKSwiftCoreDataStorage.swift
//  JeckyJogger
//
//  Created by Jecky on 14-10-9.
//  Copyright (c) 2014年 Jecky. All rights reserved.
//

import UIKit
import CoreData


class JKSwiftCoreDataStorage: NSObject {
   
    private var pendingRequests:Int32 = 0
    private var managedObjectModel:NSManagedObjectModel?
    private var persistentStoreCoordinator:NSPersistentStoreCoordinator?
    private var managedObjectContext:NSManagedObjectContext?
    private var mainThreadManagedObjectContext:NSManagedObjectContext?
    
    lazy private var willSaveManagedObjectContextBlocks:NSMutableArray? = NSMutableArray(capacity: 0)
    lazy private var didSaveManagedObjectContextBlocks:NSMutableArray? = NSMutableArray(capacity: 0)

    var databaseFileName:NSString?
    var storeOptions:NSDictionary?
    var saveThreshold:UInt?
    var saveCount:UInt?

    var autoRemovePreviousDatabaseFile:Bool! = false
    var autoRecreateDatabaseFile:Bool! = false
    var autoAllowExternalBinaryDataStorage:Bool! = false
    
    var storageQueue:UnsafeMutablePointer<Int>?
    
    let databaseFileNames:NSMutableSet?
    
    override init() {
        super.init()
        
    }
    
    //MARK: ---INIT Setup---
    //FIXME: INIT Setup    
    func initWithDatabaseFilename(aDatabaseFileName:NSString, theStoreOptions:NSDictionary){
        NSLog("===========initWithDatabaseFilename=============")
        
        
    }
    

}

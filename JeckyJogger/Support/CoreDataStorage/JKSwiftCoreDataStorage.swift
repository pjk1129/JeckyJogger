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
    
    var storageQueue:dispatch_queue_t?
    var storageQueueTag:UnsafeMutablePointer<Void>?
    
    override init() {
        super.init()
        
    }
    
    var databaseFileNames:NSMutableSet?
    func registerDatabaseFileName(dbFileName:NSString) -> Bool{
        var result:Bool = false

        
        return result
    }
    
    
    /*
    let qKeyString = "Label" as NSString
    var QKEY = qKeyString.UTF8String
    let qvalString = "com.Jecky" as NSString
    var QVAL = qvalString.UTF8String
    let q = dispatch_queue_create(QVAL, nil)
    dispatch_queue_set_specific(q, QKEY, &QVAL, nil)
    */
    //MARK: ---INIT Setup---
    //FIXME: INIT Setup    
    func initWithDatabaseFilename(aDatabaseFileName:NSString){
        NSLog("===========initWithDatabaseFilename=============")
        if aDatabaseFileName.length <= 0 {
            databaseFileName = defaultDatabaseFileName()
        }else{
            databaseFileName = aDatabaseFileName
        }
        storeOptions = defaultStoreOptions()
        
        commonInit()
    }
    
    func commonInit(){
        saveThreshold = 50
        
        storageQueue = dispatch_queue_create(NSStringFromClass(object_getClass(self)), nil)
        dispatch_queue_set_specific(storageQueue!, storageQueueTag!, &storageQueueTag!, nil)

    }
    
//    var saveThreshold:UInt?{
//        get{
//            if dispatch_get_specific(storageQueueTag!) != nil {
//                return self.saveThreshold!
//            }
//            
//            var result:UInt = 0
//            
//            dispatch_sync(storageQueue!, nil)
//            
//            return result
//        }
    
//        set{
//            var block = dispatch_block_t()
//        }
        
//        dispatch_block_t block = ^{
//        saveThreshold = newSaveThreshold;
//        };
//        
//        if (dispatch_get_specific(storageQueueTag))
//        block();
//        else
//        dispatch_async(storageQueue, block);
        
        
//    }
    
    
    //MARK: --- Override Me ---
    func managedObjectModelName() -> NSString {
        // Override me, if needed, to provide customized behavior.
        //
        // This method is queried to get the name of the ManagedObjectModel within the app bundle.
        // It should return the name of the appropriate file (*.xdatamodel / *.mom / *.momd) sans file extension.
        //
        // The default implementation returns the name of the subclass, stripping any suffix of "CoreDataStorage".
        // E.g., if your subclass was named "XMPPExtensionCoreDataStorage", then this method would return "XMPPExtension".
        //
        // Note that a file extension should NOT be included.
        var className:NSString = NSStringFromClass(object_getClass(self))
        var suffix:NSString = "CoreDataStorage"
        if (className.hasSuffix(suffix)) && (className.length > suffix.length) {
            return className.substringToIndex(className.length-suffix.length)
        }
        return className
    }
    
    func defaultDatabaseFileName() -> NSString{
        // Override me, if needed, to provide customized behavior.
        //
        // This method is queried if the initWithDatabaseFileName:storeOptions: method is invoked with a nil parameter for databaseFileName.
        //
        // You are encouraged to use the sqlite file extension.
        return NSString(format: "%@.sqlite", self.managedObjectModelName())
    }
    
    func defaultStoreOptions() ->NSDictionary {
        // Override me, if needed, to provide customized behavior.
        //
        // This method is queried if the initWithDatabaseFileName:storeOptions: method is invoked with a nil parameter for defaultStoreOptions.
        var defaultStoreOptions:NSDictionary? = nil
        
        if databaseFileName != nil {
            defaultStoreOptions = [ NSMigratePersistentStoresAutomaticallyOption:true,
                NSInferMappingModelAutomaticallyOption:true ]
        }
        return defaultStoreOptions!
    }

    

}

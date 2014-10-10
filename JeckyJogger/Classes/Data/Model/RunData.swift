//
//  RunData.swift
//  JeckyMenu
//
//  Created by Jecky on 14-10-2.
//  Copyright (c) 2014年 njut. All rights reserved.
//

import UIKit

class RunData: NSObject{
    var orderId:NSString!
    var mileage:CGFloat!
    var totalTime:NSInteger!
    var calorie:CGFloat!

    var points:NSMutableArray!
    var pointsPerKm:NSMutableArray!
    var paceArray:NSMutableArray!
    
    var northEastPoint:CLLocationCoordinate2D!
    var southWestPoint:CLLocationCoordinate2D!
    
    var startPoint:CLLocationCoordinate2D!
    var endPoint:CLLocationCoordinate2D!

}

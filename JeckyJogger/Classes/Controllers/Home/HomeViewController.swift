//
//  HomeViewController.swift
//  JeckyMenu
//
//  Created by Jecky on 14-9-28.
//  Copyright (c) 2014年 njut. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController, MAMapViewDelegate,UIAlertViewDelegate {

    var locationManager:CLLocationManager?
    var runParamsView:RunParamsView?
    var locButton:UIButton?
    
    var startButton:UIButton?
    var finishButton:UIButton?
    var continueButton:UIButton?

    
    var runRecord:RunData?
    var startPointDrawed:Bool!
    var isRunning:Bool!
    
    var runTimer:NSTimer?
    var currentLocation:CLLocation?
    var runDistance:CGFloat? = 0.0    //跑步距离
    var runSeconds:NSInteger?   = 0      //跑步时间
    var paceTime:NSInteger?     = 0      //记录配速的时间
    var paceMile:NSInteger?     = 0      //记录配速的距离
    
    var mapView:MAMapView?
    var routeLine:MAPolyline?           //用户跑步路线
    var routeLineView:MAPolylineView?   //绘制用户跑步的路线

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        isRunning = false
        initUI()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        mapView?.showsUserLocation = true
        
        if !CLLocationManager.locationServicesEnabled() || CLLocationManager.authorizationStatus() == CLAuthorizationStatus.Denied {
            
            var alert = UIAlertView()
            alert.title = "系统提示"
            alert.message = "位置服务不可用，请先进入设置-隐私中开启定位服务"
            alert.addButtonWithTitle("我知道了")
            alert.show()
            
        }
        
        if locationManager == nil {
            locationManager = CLLocationManager()
        }
        
        if locationManager!.respondsToSelector("requestAlwaysAuthorization") {
            locationManager!.requestAlwaysAuthorization()
        }
        locationManager!.startUpdatingLocation()
        
        if !isRunning {
            clearMapView()
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func back(){
        self.sideMenuViewController.presentLeftMenuViewController()
    }
    
    func showUserLocationCenter(){
        mapView!.setCenterCoordinate(mapView!.userLocation.coordinate, animated: true)
    }
    
    func startRun(){
        self.runDistance = 0.0
        self.runSeconds = 0
        self.paceMile = 0
        self.paceTime = 0        
        
        runRecord = RunData()
        runRecord!.orderId = NSString(format: "%d", (NSInteger)(NSDate().timeIntervalSince1970))
        runRecord!.points = NSMutableArray(capacity: 0)
        runRecord!.pointsPerKm = NSMutableArray(capacity: 0)
        runRecord!.paceArray = NSMutableArray(capacity: 0)
        runRecord!.southWestPoint = self.mapView!.userLocation.coordinate
        runRecord!.northEastPoint = self.mapView!.userLocation.coordinate
        
        
        NSLog("%d", runRecord!.pointsPerKm.count)
        
        startPointDrawed = false
        runningStatus(true)
        finishButton?.hidden = false
        continueButton?.hidden = false
        self.mapView?.delegate = self
        self.mapView?.showsUserLocation = true
        setRunTimer()
    }
    
    func pauseRun(){
        self.mapView?.delegate = nil
        isRunning = false
        runTimer?.invalidate()
        
        continueButton?.selected = true
        continueButton!.addTarget(self, action: "continueRun", forControlEvents: UIControlEvents.TouchUpInside)

    }
    
    func continueRun(){
        self.mapView?.delegate = self
        self.mapView?.showsUserLocation = true
        isRunning = true

        continueButton?.selected = false
        continueButton!.addTarget(self, action: "pauseRun", forControlEvents: UIControlEvents.TouchUpInside)
        
        setRunTimer()
    }
    
    func finishRun(){
        pauseRun()
        if runDistance < 10 {
            var alert = UIAlertView() as UIAlertView
            alert.title = ""
            alert.message = "亲，未检测到您的跑步数据，是否结束本次跑步？"
            alert.addButtonWithTitle("结束")
            alert.addButtonWithTitle("继续")
            alert.delegate = self
            alert.show()
            return
        }
        
        runningStatus(false)
        finishButton?.hidden = true
        continueButton?.hidden = true
        
        runRecord!.mileage = (runDistance!/1000.0)
        runRecord!.totalTime = runSeconds
        runRecord?.calorie = JUtil.computeCalorie((runDistance!/CGFloat(runSeconds!)), second: runSeconds!)

        var location:CLLocation = runRecord!.points.lastObject as CLLocation
        runRecord!.endPoint = location.coordinate
        
        JoggerManager.shareInstance().saveRunRecord(runRecord!)
        
        var controller = RunDetailViewController()
        controller.runRecord = self.runRecord
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int){
        NSLog("buttonIndex: %d", buttonIndex)
        if buttonIndex == 0{
            runningStatus(false)
            finishButton?.hidden = true
            continueButton?.hidden = true
            return
        }
        continueRun()
    }
    
    func runningStatus(isRun:Bool){
        startButton?.hidden = isRun
        isRunning = isRun
        
        if (!isRun){
            runParamsView?.resetRunParams()
        }
    }
    
    func setRunTimer(){
        if (runTimer != nil) {
            runTimer!.invalidate()
            runTimer = nil
        }
        runTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "updateRunStatusView", userInfo: nil, repeats: true)
    }
    
    func updateRunStatusView(){
        let integerPi = Int(runDistance!/1000.0)
        
        if paceMile != integerPi {
            paceMile = integerPi
            
            var paceSeconds = runSeconds! - paceTime!
            var paceKm = CGFloat(paceSeconds)/60.0;
            runRecord!.paceArray.addObject("\(paceKm)")
            
            if runRecord!.points.count > 0{
                runRecord!.pointsPerKm.addObject(runRecord!.points.lastObject!)
            }
            
            if runRecord!.pointsPerKm.count > 0 {
                addPointAnnotation(currentLocation!.coordinate, title: "\(runRecord!.pointsPerKm.count)")
            }

            paceTime = runSeconds;
        }
        
        //消耗卡路里
        var calorie:CGFloat = JUtil.computeCalorie((runDistance!/CGFloat(runSeconds!)), second: runSeconds!)
        //瞬时配速
        var minute =  CGFloat(runSeconds! - paceTime!)/60.0
        var dis = (runDistance! - CGFloat(paceMile!*1000))/1000.0
        var pacStr = JUtil.paceString(dis, minute: minute) as NSString
        var totalTime = JUtil.dateStringFromSecond(runSeconds!) as NSString
        runParamsView!.reloadRunParamsView(NSString(format: "%.2f", runDistance!/1000.0), pace: pacStr, totalTime: totalTime, calorie: NSString(format: "%.1f", calorie))
        
        runSeconds!++
        drawRunRoutes()
    }

    /**
    获取跑步路线中最大最小经纬度信息
    :param: location 当前点经纬度
    */
    func mapRegionSpan(location:CLLocation){
        if runRecord?.points.count<=0 {
            runRecord!.northEastPoint = location.coordinate;
            runRecord!.southWestPoint = location.coordinate;
        }else{
            if location.coordinate.latitude > runRecord?.northEastPoint.latitude {
                runRecord!.northEastPoint.latitude = location.coordinate.latitude
            }
            
            if location.coordinate.longitude > runRecord?.northEastPoint.longitude {
                runRecord!.northEastPoint.longitude = location.coordinate.longitude
            }
            
            if location.coordinate.latitude < runRecord?.southWestPoint.latitude {
                runRecord!.southWestPoint.latitude = location.coordinate.latitude
            }
            
            if location.coordinate.longitude < runRecord?.southWestPoint.longitude {
                runRecord!.southWestPoint.longitude = location.coordinate.longitude
            }
        }
    }
    
    func clearMapView(){
        self.mapView!.removeAnnotations(self.mapView?.annotations)
        self.mapView?.removeOverlays(self.mapView?.overlays)
    }
    
    func addPointAnnotation(coordinate:CLLocationCoordinate2D, title:NSString){
        var annotation:MAPointAnnotation = MAPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = title
        self.mapView?.addAnnotation(annotation)
    }
    
    func drawRunRoutes(){
        var pointArray: UnsafeMutablePointer<MAMapPoint> = UnsafeMutablePointer.alloc(runRecord!.points.count)
        for (var idx = 0; idx < runRecord!.points.count; idx++){
            var location:CLLocation = runRecord!.points.objectAtIndex(idx) as CLLocation
            var point = MAMapPointForCoordinate(CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)) as MAMapPoint
            pointArray[idx] = point
        }
    
        if (routeLine != nil) {
            self.mapView?.removeOverlay(routeLine)
        }
        
        let m: NSNumber = runRecord!.points.count
        routeLine = MAPolyline(points: pointArray, count:m.unsignedLongValue)
        if (routeLine != nil) {
            self.mapView?.addOverlay(routeLine)
        }
        free(pointArray);
    }
    
    func mapView(mapView: MAMapView!, viewForAnnotation annotation: MAAnnotation!) -> MAAnnotationView! {
        if annotation.isKindOfClass(MAPointAnnotation){
            let CustomAnnotationReuseIndetifier:String = "CustomAnnotationReuseIndetifier"
            var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(CustomAnnotationReuseIndetifier) as? RunAnnotationView
            if annotationView == nil {
                annotationView = RunAnnotationView(annotation: annotation, reuseIdentifier: CustomAnnotationReuseIndetifier)
            }
            
            if annotation.title!() == "起点" {
                annotationView!.annotationImageView.image = UIImage(named:"bg_run_start_point")
            }else if annotation!.title!() == "终点" {
                annotationView!.annotationImageView.image = UIImage(named:"bg_run_end_point")
            }else {
                annotationView!.annotationImageView.image = UIImage(named:"bg_run_inter_point")
                annotationView!.nameLabel.text = annotation.title!()
            }
            return annotationView
        }
        return nil
    }
    
    func mapView(mapView: MAMapView!, viewForOverlay overlay: MAOverlay!) -> MAOverlayView! {
        var overLayView:MAOverlayView? = nil
        if overlay.isKindOfClass(MAPolyline) {
            if (routeLineView != nil) {
                routeLineView?.removeFromSuperview()
            }
            routeLineView = MAPolylineView(polyline: routeLine!)
            routeLineView!.fillColor = UIColor.orangeColor()
            routeLineView!.strokeColor = UIColor.orangeColor();
            routeLineView!.lineWidth = 4;
            overLayView = routeLineView
        }
        return overLayView
    }
    
    func mapView(mapView: MAMapView!, didUpdateUserLocation userLocation: MAUserLocation!, updatingLocation: Bool) {
        
        if (!isRunning) {
            NSLog("========您还未开始跑步==========")
            return
        }
        
        if(userLocation.coordinate.latitude == 0.0 || userLocation.coordinate.longitude == 0.0){
            return
        }
        
        if(userLocation.coordinate.latitude == 180.0||userLocation.coordinate.latitude == -180.0||userLocation.coordinate.longitude == 180.0||userLocation.coordinate.longitude == -180.0){
            return
        }
        
        var location:CLLocation! = CLLocation(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        //坐标点为同一点
        if currentLocation != nil {
            if location.coordinate.latitude == currentLocation!.coordinate.latitude && location.coordinate.longitude == currentLocation!.coordinate.longitude{
                return
            }
        }
        
        if userLocation.location.horizontalAccuracy < 70 && userLocation.location.verticalAccuracy < 70{
            if runSeconds < 3 {
                return
            }
            
            NSLog("========跑步描述点==========")
            
            if runRecord?.points.count > 0 {
                var distance:CLLocationDistance = location.distanceFromLocation(self.currentLocation)
                if distance>0 {
                    runDistance = runDistance! + CGFloat(distance)
                }
            }
            
            if self.runSeconds!%2 == 0 {
                if runRecord!.points.count < self.runSeconds! {
                    mapRegionSpan(location)
                    runRecord?.points.addObject(location)
                }
            }
            
            if ((runRecord!.points.count==1)&&(!startPointDrawed!)){
                startPointDrawed = true
                runRecord?.startPoint = location.coordinate
                addPointAnnotation(location.coordinate, title: "起点")
            }
            
            self.currentLocation = location;
        }

    }

    /**
    初始化UI
    :returns:
    */
    func initUI(){
        self.navigationItem.title = "Jecky"
        
        runParamsView = RunParamsView(frame: CGRectMake(0, 0, self.view.bounds.size.width, 128))
        self.view.addSubview(runParamsView!)
        
        mapView = MAMapView(frame: CGRectMake(0, CGRectGetMaxY(runParamsView!.frame)-10, self.view.bounds.size.width, CGRectGetHeight(self.view.frame)-CGRectGetMaxY(runParamsView!.frame)+10))
        mapView?.delegate = self
        mapView?.showsCompass = false;
        mapView?.showsScale = false;
        mapView?.zoomEnabled = true;
        mapView?.rotateEnabled = false;
        mapView?.userTrackingMode = MAUserTrackingModeFollow;
        mapView?.customizeUserLocationAccuracyCircleRepresentation = true;
        self.view.insertSubview(mapView!, belowSubview: runParamsView!)
        
        var button = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
        button.frame = CGRectMake(0, 0, 44, 44)
        button.setBackgroundImage(UIImage(named: "bg_menu_nor"), forState: UIControlState.Normal)
        button.setBackgroundImage(UIImage(named: "bg_menu_act"), forState: UIControlState.Selected)
        button.setBackgroundImage(UIImage(named: "bg_menu_act"), forState: UIControlState.Highlighted)
        button.addTarget(self, action: "back", forControlEvents: UIControlEvents.TouchUpInside)
        var buttonItem = UIBarButtonItem(customView: button) as UIBarButtonItem
        self.navigationItem.leftBarButtonItem = buttonItem
        
        var img:UIImage! = UIImage(named: "bg_location_nor")
        locButton = UIButton.buttonWithType(UIButtonType.Custom) as? UIButton
        locButton!.frame = CGRectMake(0, CGRectGetMaxY(mapView!.frame)-160, img.size.width, img.size.height)
        locButton!.setBackgroundImage(img, forState: UIControlState.Normal)
        locButton!.setBackgroundImage(UIImage(named: "bg_location_act"), forState: UIControlState.Selected)
        locButton!.setBackgroundImage(UIImage(named: "bg_location_act"), forState: UIControlState.Highlighted)
        locButton!.addTarget(self, action: "showUserLocationCenter", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(locButton!)
        
        startButton =  UIButton.buttonWithType(UIButtonType.Custom) as? UIButton
        startButton!.frame = CGRectMake((self.view.bounds.size.width-80)/2, CGRectGetMidY(locButton!.frame)-40, 80, 80)
        startButton!.setBackgroundImage(UIImage(named: "bg_start_run"), forState: UIControlState.Normal)
        startButton!.addTarget(self, action: "startRun", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(startButton!)
        
        finishButton =  UIButton.buttonWithType(UIButtonType.Custom) as? UIButton
        finishButton!.frame = CGRectMake(20, CGRectGetMaxY(locButton!.frame)+15, 132, 39)
        finishButton?.center.x = self.view.bounds.size.width/4
        finishButton!.setBackgroundImage(UIImage(named: "btn_finish"), forState: UIControlState.Normal)
        finishButton!.setTitle("完成", forState: UIControlState.Normal)
        finishButton!.addTarget(self, action: "finishRun", forControlEvents: UIControlEvents.TouchUpInside)
        finishButton!.hidden = true
        self.view.addSubview(finishButton!)
        
        continueButton =  UIButton.buttonWithType(UIButtonType.Custom) as? UIButton
        continueButton!.frame = CGRectMake(20, CGRectGetMaxY(locButton!.frame)+15, 132, 39)
        continueButton?.center.x = self.view.bounds.size.width*3/4

        continueButton!.setBackgroundImage(UIImage(named: "btn_pause"), forState: UIControlState.Normal)
        continueButton!.setTitle("暂停", forState: UIControlState.Normal)

        continueButton!.setBackgroundImage(UIImage(named: "btn_continue"), forState: UIControlState.Selected)
        continueButton!.setTitle("继续", forState: UIControlState.Selected)
        continueButton!.addTarget(self, action: "pauseRun", forControlEvents: UIControlEvents.TouchUpInside)
        continueButton!.hidden = true
        self.view.addSubview(continueButton!)
        
    }
}

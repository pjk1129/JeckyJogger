//
//  RunDetailViewController.swift
//  JeckyJogger
//
//  Created by Jecky on 14-10-6.
//  Copyright (c) 2014年 Jecky. All rights reserved.
//

import UIKit

class RunDetailViewController: BaseViewController,MAMapViewDelegate {

    var runRecord:RunData?
    
    var mapView:MAMapView?
    var routeLine:MAPolyline?           //用户跑步路线
    var routeLineView:MAPolylineView?   //绘制用户跑步的路线

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.navigationItem.title = "跑步路线"
        
        mapView = MAMapView(frame: self.view.bounds)
        mapView?.delegate = self
        mapView?.showsCompass = false;
        mapView?.showsScale = false;
        mapView?.zoomEnabled = true;
        mapView?.rotateEnabled = false;
        mapView?.userTrackingMode = MAUserTrackingModeFollow;
        mapView?.customizeUserLocationAccuracyCircleRepresentation = true;
        self.view.addSubview(mapView!)
        
        if runRecord?.points.count <= 0{
            return
        }
        
        
        self.addPointAnnotation(runRecord!.startPoint, title: "起点")
        self.addPointAnnotation(runRecord!.endPoint, title: "终点")

        for var i=0; i<self.runRecord!.pointsPerKm.count; i++ {
            var point = self.runRecord!.pointsPerKm.objectAtIndex(i) as CLLocation
            self.addPointAnnotation(point.coordinate, title:"\(i+1)")

        }
        drawRunRoutes()
        
        if self.runRecord?.northEastPoint.latitude != self.runRecord?.southWestPoint.latitude || self.runRecord?.northEastPoint.longitude != self.runRecord?.southWestPoint.longitude {
            var center = CLLocationCoordinate2DMake((self.runRecord!.northEastPoint.latitude+self.runRecord!.southWestPoint.latitude)/2, (self.runRecord!.northEastPoint.longitude+self.runRecord!.southWestPoint.longitude)/2)
            var userSpan = MACoordinateSpanMake((self.runRecord!.northEastPoint.latitude - self.runRecord!.southWestPoint.latitude)*1.4, (self.runRecord!.northEastPoint!.longitude - self.runRecord!.southWestPoint.longitude)*1.4)
            var userRegion = MACoordinateRegionMake(center, userSpan)
            self.mapView?.setRegion(userRegion, animated: true)
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            
            NSLog("%@", annotation!.title!())
            
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


}

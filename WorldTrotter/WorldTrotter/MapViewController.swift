//
//  MapViewController.swift
//  WorldTrotter
//
//  Created by iel-mac on 2017/6/23.
//  Copyright © 2017年 iel-mac. All rights reserved.
//

import UIKit
import MapKit

class MapViewController : UIViewController{
    
    //原来在storyboard里面写的添加mapview
    //现在用代码去写
    //声明
    var mapView:MKMapView!
    //如果属性是view并且值是nil loadview()就会被调动
    override func loadView() {
        // 创造一个mapView
        mapView = MKMapView()
        //把它设置给本ViewController
        view = mapView
        
        //创造一个 segement Control
//        let segmentControl = UISegmentedControl(items:["standard","Hybrid","Satellite"])
        //国际化下 这个segmentcontrol的标签
        let standardString = NSLocalizedString("standard",comment:"Stardard map view ")
        let satelliteString = NSLocalizedString("satellite",comment:"Satellite map view ")
        let hybridString = NSLocalizedString("hybrid",comment:"Hybrid map view ")
        let segmentControl = UISegmentedControl(items:[standardString,hybridString,satelliteString])
        segmentControl.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        segmentControl.selectedSegmentIndex = 0
        view.addSubview(segmentControl)
        
        //给segment control 加上布局限制
//        let topConstarint =
//            segmentControl.topAnchor.constraint(equalTo: view.topAnchor)
        //使用 layout guide 
        let topConstarint =
            segmentControl.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor,constant:8)
//        let leadingConstraint =
//            segmentControl.leadingAnchor.constraint(equalTo: view.leadingAnchor)
//        let trailConstraint =
//            segmentControl.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        //使用marginesGuide
        let margins = view.layoutMarginsGuide
        let leadingConstraint =
            segmentControl.leadingAnchor.constraint(equalTo: margins.leadingAnchor)
        let trailConstraint =
            segmentControl.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
        
        //还要设置成可用限制 typothetical
        topConstarint.isActive = true
        leadingConstraint.isActive = true
        trailConstraint.isActive = true
        
        //给 segmentControl添加一个事件触发
        segmentControl.addTarget(self, action: #selector(MapViewController.mapTypeChanged(_:)), for: .valueChanged)
        
    }

    override func viewDidLoad() {
        //这里为了测试lazy loading时候调用该方法
        print("Map View Controller loaded")
    }
    //在tab切换中，viewWillAppear()方法调用在每次将view呈现在用户之前
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("Map View Controller will appear")
    }
    
    //这是一个方法 用作 segmentControl的selector
    func mapTypeChanged(_ segControl : UISegmentedControl) {
        switch segControl.selectedSegmentIndex {
        case 0:
            mapView.mapType = .standard
        case 1:
            mapView.mapType = .hybrid
        case 2:
            mapView.mapType = .satellite
        default:
            break
        }
    }
}

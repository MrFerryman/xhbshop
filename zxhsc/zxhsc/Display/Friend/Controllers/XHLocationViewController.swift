//
//  XHLocationViewController.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/7/31.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit
import MapKit

class XHLocationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupMapView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupMapView() {
        view.addSubview(mapView)
        mapView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
        locationManager.requestWhenInUseAuthorization()
    }

    // MARK:- ====== 懒加载 ========
    // 地图
    private lazy var mapView: MKMapView = {
       let mapView = MKMapView()
        mapView.delegate = self
        mapView.mapType = .standard
        mapView.userTrackingMode = .follow
        return mapView
    }()
    
    private lazy var locationManager: CLLocationManager = CLLocationManager()
}

extension XHLocationViewController: MKMapViewDelegate {
    // 当定位到用户位置时调用
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        let geocoder = CLGeocoder()
        // 反地理编码
        geocoder.reverseGeocodeLocation(userLocation.location!) { (placemarks, error) in
            if error != nil {
                print(error)
                return
            }
            
            // 获取地标
            let placemark: CLPlacemark = placemarks![0]
            userLocation.title = placemark.locality // 城市名
            userLocation.subtitle = placemark.name // 具体地址
        }
    }
    
    // 当区域改变时调用
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
    }
}

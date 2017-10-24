//
//  XHCenterDistributeMapController.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/16.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHCenterDistributeMapController: UIViewController, BMKMapViewDelegate {

    var mapType: CenterMapType? {
        didSet {
            setupMapView()
        }
    }
    
    private var _mapView: BMKMapView = BMKMapView(frame: CGRect(x: 0, y: 0, width: kUIScreenWidth, height: KUIScreenHeight))
    
    fileprivate let mapResueId = "XHCenterDistributeMapController_myAnnotation"
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        setupMapView()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        _mapView.viewWillAppear()
        _mapView.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        _mapView.viewWillDisappear()
        _mapView.delegate = nil // 不用时，置nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func setupMapView() {
        
        self.view.addSubview(_mapView)
        
        let annotation = BMKPointAnnotation()
        let coor: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 39.915, longitude: 116.404)
        annotation.coordinate = coor
        annotation.title = "北京"
        annotation.subtitle = "30"
        
        _mapView.addAnnotation(annotation)
    }
    
}

extension XHCenterDistributeMapController {
    func mapView(_ mapView: BMKMapView!, viewFor annotation: BMKAnnotation!) -> BMKAnnotationView! {
        if annotation.isKind(of: BMKPointAnnotation.self) == true {
            let newAnnotationView = BMKPinAnnotationView(annotation: annotation, reuseIdentifier: mapResueId)
            newAnnotationView?.pinColor = UInt(BMKPinAnnotationColorPurple)
            newAnnotationView?.animatesDrop = true // 从天而降
            newAnnotationView?.isDraggable = true // 可拖拽
//
//            let newAnnotationView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
//            newAnnotationView.backgroundColor = .white
            return newAnnotationView
        }
        
        return nil
    }
}

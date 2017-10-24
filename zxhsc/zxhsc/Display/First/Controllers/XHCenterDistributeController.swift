//
//  XHCenterDistributeController.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/15.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit
enum CenterMapType {
    case bussiness // 商家
    case operateCenter // 运营中心
}

class XHCenterDistributeController: UIViewController {

    /// 子标题
    private lazy var subTitleArr: [String] = ["商家分布地图", "运营中心分布地图"]
    fileprivate let viewName = "商家分布和运营中心分布地图页面"
    
    /// 子控制器
    var controllers: [XHCenterDistributeMapController] = [XHCenterDistributeMapController(), XHCenterDistributeMapController()]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "分布地图"
        view.backgroundColor = .white
        setupPageView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        TalkingData.trackPageBegin(viewName)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        TalkingData.trackPageEnd(viewName)
    }
    
    // MARK:- ==== 界面相关 ======
    private func setupPageView() {
        pageViewController.tipBtnNormalColor = XHRgbColorFromHex(rgb: 0x666666)
        pageViewController.tipBtnHighlightedColor = XHRgbColorFromHex(rgb: 0xea2000)
        pageViewController.sliderColor = XHRgbColorFromHex(rgb: 0xea2000)
        pageViewController.tipBtnFontSize = 14
        
        pageViewController.view.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(view)
            make.top.equalTo(64)
        }
    }
    
    // pageView
    private lazy var pageViewController: XHPageViewController = {
        let vc: XHPageViewController = XHPageViewController(controllers: self.controllers, titles: self.subTitleArr, inParentController: self)
        vc.delegate = self
        self.view.addSubview(vc.view)
        return vc
    }()
}
extension XHCenterDistributeController: XHPageViewControllerDelegate {
    func xh_MenuPageCurrentSubController(index: NSInteger, menuPageController: XHPageViewController) {
        let controller = controllers[index]
        switch index {
        case 0:
            controller.mapType = .bussiness
        default:
            controller.mapType = .operateCenter
        }
    }
}

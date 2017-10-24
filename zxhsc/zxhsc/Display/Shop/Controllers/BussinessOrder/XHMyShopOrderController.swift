//
//  XHMyShopOrderController.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/9/14.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

enum XHMyShopOrderType {
    case all           // 全部
    case obligation // 待付款
    case completed // 已完成
    case canceled   // 已取消
}

import UIKit

class XHMyShopOrderController: UIViewController {
    
    /// 子标题
    private lazy var subTitleArr: [String] = ["全部", "待付款", "已完成", "已取消"]
    
    /// 子控制器
    var controllers: [XHMyShopOrderDetailController] = [XHMyShopOrderDetailController(), XHMyShopOrderDetailController(), XHMyShopOrderDetailController(), XHMyShopOrderDetailController()]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupPageView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

extension XHMyShopOrderController: XHPageViewControllerDelegate {
    func xh_MenuPageCurrentSubController(index: NSInteger, menuPageController: XHPageViewController) {
        let controller = controllers[index]
        switch index {
        case 0: // 全部
            controller.orderType = .all
        case 1: // 待付款
            controller.orderType = .obligation
        case 2: // 已完成
            controller.orderType = .completed
        case 3: // 已取消
            controller.orderType = .canceled
        default:
            break
        } 
    }
}

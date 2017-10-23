//
//  XHMyRedPackectsController.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/10/23.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHMyRedPackectsController: UIViewController {

    /// 子控制器
    var controllers: [XHMyRPDetailController] = [XHMyRPDetailController(), XHMyRPDetailController()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupPageView()
        title = "我的红包"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupPageView() {
        pageMenuController.tipBtnNormalColor = XHRgbColorFromHex(rgb: 0x666666)
        pageMenuController.tipBtnHighlightedColor = XHRgbColorFromHex(rgb: 0xea2000)
        pageMenuController.sliderColor = XHRgbColorFromHex(rgb: 0xea2000)
        pageMenuController.tipBtnFontSize = 14
        pageMenuController.view.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(view)
            make.top.equalTo(64)
        }
    }
    
    /// 子标题
    fileprivate lazy var subTitleArr: [String] = ["发出的红包", "收到的红包"]
    
    // pageViewController
    lazy var pageMenuController: XHPageViewController = {
        let pageMenu: XHPageViewController = XHPageViewController(controllers: self.controllers, titles: self.subTitleArr, inParentController: self)
        pageMenu.delegate = self
        self.view.addSubview(pageMenu.view)
        return pageMenu
    }()

}

extension XHMyRedPackectsController: XHPageViewControllerDelegate {
    func xh_MenuPageCurrentSubController(index: NSInteger, menuPageController: XHPageViewController) {
        let controller = controllers[index]
        
    }
}


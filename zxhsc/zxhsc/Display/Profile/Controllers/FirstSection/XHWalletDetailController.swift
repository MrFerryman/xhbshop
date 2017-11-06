//
//  XHWalletDetailController.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/7/26.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHWalletDetailController: UIViewController, XHPageViewControllerDelegate {

    /// 子控制器
    var controllers: [XHMyWallletController] = [XHMyWallletController(), XHMyWallletController()]
    
    //在页面菜单中跟踪控制器的数组
    var controllerArray: [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "钱包明细"
        setupPageView()
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
            if KUIScreenHeight == 812 {
                make.top.equalTo(90)
            }else {
                make.top.equalTo(64)
            }
        }
    }
    
    /// 子标题
    private lazy var subTitleArr: [String] = ["全部明细", "提现明细"]
    
    // pageViewController
    lazy var pageMenuController: XHPageViewController = {
        let pageMenu: XHPageViewController = XHPageViewController(controllers: self.controllers, titles: self.subTitleArr, inParentController: self)
        pageMenu.delegate = self
        self.view.addSubview(pageMenu.view)
        return pageMenu
    }()
}

extension XHWalletDetailController {
    func xh_MenuPageCurrentSubController(index: NSInteger, menuPageController: XHPageViewController) {
        let controller = controllers[index]
        switch index {
        case 0:
            controller.walletType = .all
        default:
            controller.walletType = .withdraw
        }
    }
}

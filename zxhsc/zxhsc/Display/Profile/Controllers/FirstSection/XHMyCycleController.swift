//
//  XHMyCycleController.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/20.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit
enum CycleType {
    case all  // 全部收益
    case agent // 代理收益
    case unfreezed // 解冻明细
}

class XHMyCycleController: UIViewController {

    /// 子控制器
    var controllers: [XHCycleDetailController] = [XHCycleDetailController(), XHCycleDetailController()]
    
    //在页面菜单中跟踪控制器的数组
//    var controllerArray: [UIViewController] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "循环宝明细"
        view.backgroundColor = .white
        judgeAgent()
        setupPageView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func judgeAgent() {
        showHud(in: view)
        _ = XHRequest.shareInstance.requestNetData(dataType: .cycle_agent, failure: { [weak self] (errorType) in
            self?.hideHud()
            var title: String?
            switch errorType {
            case .timeOut:
                title = "网络请求超时，请重新请求~"
            default:
                title = "网络请求错误，请重新请求~"
            }
            self?.showHint(in: (self?.view)!, hint: title!)
            }, success: { [weak self] (sth) in
                self?.hideHud()
                if (sth as! [Any]).count > 0 {
                    self?.subTitleArr = ["全部收益", "代理收益", "解冻明细"]
                    self?.setupPageView()
                }
        })
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
    fileprivate lazy var subTitleArr: [String] = ["全部收益", "解冻明细"]
    
    // pageViewController
    lazy var pageMenuController: XHPageViewController = {
        let pageMenu: XHPageViewController = XHPageViewController(controllers: self.controllers, titles: self.subTitleArr, inParentController: self)
        pageMenu.delegate = self
        self.view.addSubview(pageMenu.view)
        return pageMenu
    }()
}
extension XHMyCycleController: XHPageViewControllerDelegate {
    func xh_MenuPageCurrentSubController(index: NSInteger, menuPageController: XHPageViewController) {
        let controller = controllers[index]
        switch subTitleArr[index] {
        case "全部收益":
            controller.cycleType = .all
        case "代理收益":
            controller.cycleType = .agent
        default:
            controller.cycleType = .unfreezed
        }
    }
}

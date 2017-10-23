//
//  XHMyEvaluationController.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/2.
//  Copyright © 2017年 zxhsc. All rights reserved.
//  我的评价

import UIKit
enum MyEvaluationType {
    case willBeEvaluated // 待评价
    case checkPending    // 待审核
    case beEvaluation    // 已评价
}

class XHMyEvaluationController: UIViewController {
    
    /// 子标题
    private lazy var subTitleArr: [String] = ["待评价", "待审核", "已评价"]
    /// 子控制器
    var controllers: [XHEvaluationController] = [XHEvaluationController(), XHEvaluationController(), XHEvaluationController()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let item = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        navigationItem.backBarButtonItem = item
        
        view.backgroundColor = .white
        setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK:- ======= 界面相关 ========
    private func setupUI() {
        view.addSubview(topView)
        topView.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(view)
            make.height.equalTo(64)
        }
        
        pageViewController.tipBtnNormalColor = XHRgbColorFromHex(rgb: 0x666666)
        pageViewController.tipBtnHighlightedColor = XHRgbColorFromHex(rgb: 0xea2000)
        pageViewController.sliderColor = XHRgbColorFromHex(rgb: 0xea2000)
        pageViewController.tipBtnFontSize = 14

        
        view.addSubview(pageViewController.view)
        pageViewController.view.snp.makeConstraints { (make) in
            make.left.bottom.right.equalTo(view)
            make.top.equalTo(topView.snp.bottom)
        }
    }

    // MARK:- ======== 懒加载 ===========
    // 头部视图
    private lazy var topView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    // pageView
    private lazy var pageViewController: XHPageViewController = {
        let vc: XHPageViewController = XHPageViewController(controllers: self.controllers, titles: self.subTitleArr, inParentController: self)
        vc.delegate = self
        self.view.addSubview(vc.view)
        return vc
    }()

}

extension XHMyEvaluationController: XHPageViewControllerDelegate {
    func xh_MenuPageCurrentSubController(index: NSInteger, menuPageController: XHPageViewController) {
        let controller = controllers[index]
        switch index {
        case 0:
            controller.evaType = .willBeEvaluated
        case 1:
            controller.evaType = .checkPending
        case 2:
            controller.evaType = .beEvaluation
        default:
            break
        }
    }
}

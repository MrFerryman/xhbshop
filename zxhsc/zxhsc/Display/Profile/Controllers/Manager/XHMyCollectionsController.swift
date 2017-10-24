//
//  XHMyCollectionsController.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/7/31.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit
enum CollectionType {
    case goods // 商品
    case shop  // 店铺
}


class XHMyCollectionsController: UIViewController {

    
    /// 子标题
    private lazy var subTitleArr: [String] = ["商品收藏", "店铺收藏"]
    
    /// 子控制器
    var controllers: [XHCollectionDetailsController] = [XHCollectionDetailsController(), XHCollectionDetailsController()]
    
    /// 当前是哪个控制器 0 - 商品  1 - 店铺
    var currentViewController: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        setupPageView()
        
        setupNav()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        TalkingData.trackPageBegin("商品收藏")
    }
    
    @objc private func editButtonClicked(_ sender: UIBarButtonItem) {
        let collectionVC = controllers[currentViewController]
        if sender.title == "编辑" {
            collectionVC.isTableViewEditing = true
            navigationItem.rightBarButtonItem?.title = "取消"
        }else {
            collectionVC.isTableViewEditing = false
            navigationItem.rightBarButtonItem?.title = "编辑"
        }
        
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
    
    fileprivate func setupNav() {
        
        let editButton = UIBarButtonItem(title: "编辑", style: .plain, target: self, action: #selector(editButtonClicked(_:)))
        editButton.setTitleTextAttributes([NSAttributedStringKey.font : UIFont.systemFont(ofSize: 14)], for: .normal)
        
        navigationItem.rightBarButtonItem = editButton
    }

    // pageView
    private lazy var pageViewController: XHPageViewController = {
        let vc: XHPageViewController = XHPageViewController(controllers: self.controllers, titles: self.subTitleArr, inParentController: self)
        vc.delegate = self
        self.view.addSubview(vc.view)
        return vc
    }()

}

extension XHMyCollectionsController: XHPageViewControllerDelegate {
    func xh_MenuPageCurrentSubController(index: NSInteger, menuPageController: XHPageViewController) {
        let controller = controllers[index]
        if currentViewController != index {
            controller.isTableViewEditing = false
            setupNav()
        }
        
        switch index {
        case 0:
            controller.collectionsType = .goods
            currentViewController = 0
            TalkingData.trackPageBegin("商品收藏页面")
            TalkingData.trackPageEnd("店铺收藏页面")
        case 1:
            controller.collectionsType = .shop
            currentViewController = 1
            TalkingData.trackPageEnd("商品收藏页面")
            TalkingData.trackPageBegin("店铺收藏页面")
        default:
            break
        }
    }
}

//
//  XHTabBarController.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/7/13.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

      addChildViewController()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func addChildViewController() {
        // 首页
        let homeV = XHFirstViewController()
        let homeNav = XHNavigationController(rootViewController: homeV)
        addChildViewController(homeNav, imgName: "home_icon", selectedImgName: "home_icon_selected", title: "首页")
        
        // 品类
        let classV = XHClassifyController()
        let classNav = XHNavigationController(rootViewController: classV)
        addChildViewController(classNav, imgName: "class_icon", selectedImgName: "class_icon_selected", title: "类目")
        
        // 店铺
        let shopV = XHCoalitionController()
        let shopNav = XHNavigationController(rootViewController: shopV)
        addChildViewController(shopNav, imgName: "shop_icon", selectedImgName: "shop_icon_selected", title: "商盟")
        
        // 发现
        let friendV = XHDiscoveryViewController()
        let friendNav = XHNavigationController(rootViewController: friendV)
        addChildViewController(friendNav, imgName: "discover_icon", selectedImgName: "discover_icon_selected", title: "发现")
        
        // 我的
        let profileV = XHProfileViewController()
        let profileNav = XHNavigationController(rootViewController: profileV)
        addChildViewController(profileNav, imgName: "profile_icon", selectedImgName: "profile_icon_selected", title: "我的")
    }
    
    private func addChildViewController(_ childController: UIViewController, imgName: String, selectedImgName: String, title: String) {
        childController.title = title
        //设置tabbaritem文字的颜色
        childController.tabBarItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor : XHRgbColorFromHex(rgb: 0xea2000)], for: .selected)
        
        // 图片
        childController.tabBarItem.image = UIImage(named: imgName)?.withRenderingMode(.alwaysOriginal)
        childController.tabBarItem.selectedImage = UIImage(named: selectedImgName)?.withRenderingMode(.alwaysOriginal)
        addChildViewController(childController)
    }
    
    /// tabbar图标数组
    private lazy var tabbarIconList: [XHTabbarIconModel] = XHTabbarViewModel().tabbarIconList
}

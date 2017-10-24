//
//  XHTabbarViewModel.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/10/18.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHTabbarViewModel: NSObject {

    /// tabbar图标列表
    var tabbarIconList: [XHTabbarIconModel] = []
    override init() {
        super.init()
    }
    
    func loadTabbarIconList(success: @escaping ((_ tabbarIconList: [XHTabbarIconModel]) -> Void)) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        XHRequest.shareInstance.requestNetData(dataType: .getTabbarIconList, failure: { (errorType) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }) { [weak self] (result) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            if result is [XHTabbarIconModel] {
                self?.tabbarIconList = result as! [XHTabbarIconModel]
                success(result as! [XHTabbarIconModel])
            }
        }
    }
}

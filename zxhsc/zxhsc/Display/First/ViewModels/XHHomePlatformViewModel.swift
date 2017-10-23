//
//  XHHomePlatformViewModel.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/7/17.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHHomePlatformViewModel: NSObject {
    
    static var sharedInstance = XHHomePlatformViewModel()
    
    func loadPlatformData(_ targetVc: UIViewController, dataClosure: @escaping ((_ platformList: [XHPlatformModel]) -> ())) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        _ = XHRequest.shareInstance.requestNetData(dataType: .getHomeUserPlatformList, failure: { (errorType) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            var title: String?
            switch errorType {
            case .timeOut:
                title = "网络请求超时，请重新请求~"
            default:
                title = "网络请求错误，请重新请求~"
            }
            targetVc.showHint(in: targetVc.view, hint: title!)
        }, success: { (sth) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            if sth is [XHPlatformModel] {
                dataClosure(sth as! [XHPlatformModel])
            }
        })
    }
    
    // MARK:- 获取指数排行数组
    func getScaleRankList(_ targetVc: UIViewController, dataClosure: @escaping ((_ platformList: [XHScaleRankModel]) -> ())) {
        targetVc.showHud(in: targetVc.view)
        _ = XHRequest.shareInstance.requestNetData(dataType: .getScaleRankList, failure: { (errorType) in
            targetVc.hideHud()
            var title: String?
            switch errorType {
            case .timeOut:
                title = "网络请求超时，请重新请求~"
            default:
                title = "网络请求错误，请重新请求~"
            }
            targetVc.showHint(in: targetVc.view, hint: title!)
        }, success: { (sth) in
            targetVc.hideHud()
            if sth is [XHScaleRankModel] {
                dataClosure(sth as! [XHScaleRankModel])
            }
        })
    }
    private override init() {}
    
      
}

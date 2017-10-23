//
//  XHSearchShopListViewModel.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/9/13.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHSearchShopListViewModel: NSObject {
    /// MARK:- 搜索店铺
    static func searchShopList(_ paraDict: [String: String], _ targetVc: UIViewController, dataArrClosure: @escaping ((_ result: Any) -> ())) {
        targetVc.showHud(in: targetVc.view)
        _ = XHRequest.shareInstance.requestNetData(dataType: .getSearchShopList, parameters: paraDict, failure: { (errorType) in
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
            dataArrClosure(sth)
        })
    }
}

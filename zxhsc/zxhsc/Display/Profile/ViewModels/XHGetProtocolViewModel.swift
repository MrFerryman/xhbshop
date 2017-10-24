//
//  XHGetProtocolViewModel.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/30.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHGetProtocolViewModel: NSObject {

    class func getProtocol(paraDict: [String: String], _ targetVc: UIViewController, dataClosure: @escaping ((_ htmlModel: XHHTMLModel) -> ())) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        _ = XHRequest.shareInstance.requestNetData(dataType: .helpDetail, parameters: paraDict, failure: { (errorType) in
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
            if sth is XHHTMLModel {
                dataClosure(sth as! XHHTMLModel)
            }
        })
    }
    
}

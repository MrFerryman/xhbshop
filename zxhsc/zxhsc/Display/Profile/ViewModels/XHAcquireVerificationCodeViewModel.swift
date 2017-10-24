//
//  XHAcquireVerificationCodeViewModel.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/17.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHAcquireVerificationCodeViewModel: NSObject {

    class func getCode(target: UIViewController, paraDict: [String: String], success: @escaping ((String) -> ())) {
        target.showHud(in: target.view, hint: "发送中...", yOffset: 0)
        _ = XHRequest.shareInstance.requestNetData(dataType: .acquireVerCode_register, parameters: paraDict, failure: { (errorType) in
            target.hideHud()
            var title: String?
            switch errorType {
            case .timeOut:
                title = "网络请求超时，请重新请求~"
            default:
                title = "网络请求错误，请重新请求~"
            }
            target.showHint(in: target.view, hint: title!)
            }, success: { (str) in
                target.hideHud()
                success(str as! String)
        })
    }
    
    // MARK:- 验证图片验证码
    class func verifyImageCode(target: UIViewController, paraDict: [String: String], success: @escaping ((String) -> ())) {
        target.showHud(in: target.view, hint: "验证中...", yOffset: 0)
        _ = XHRequest.shareInstance.requestNetData(dataType: .register_imageCode, parameters: paraDict, failure: { (errorType) in
            target.hideHud()
            var title: String?
            switch errorType {
            case .timeOut:
                title = "网络请求超时，请重新请求~"
            default:
                title = "网络请求错误，请重新请求~"
            }
            target.showHint(in: target.view, hint: title!)
        }, success: { (str) in
            target.hideHud()
            success(str as! String)
        })
    }
}

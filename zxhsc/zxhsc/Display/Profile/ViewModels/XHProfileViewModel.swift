//
//  XHProfileViewModel.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/9/21.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit
import SSKeychain

class XHProfileViewModel: NSObject {
    class func getUnfreezedXHB(target: UIViewController, success: @escaping ((Any) -> ())) {
        target.showHud(in: target.view, hint: "发送中...", yOffset: 0)
        _ = XHRequest.shareInstance.requestNetData(dataType: .getUserUnfreezed_XHB, failure: { (errorType) in
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
            success(str)
        })
    }
    
    // MARK:- 请求循环宝解冻明细列表
    class func getUnfreezedXHB_detailList(target: XHCycleDetailController, success: @escaping ((Any) -> ())) -> XHCancelRequest {
        target.showHud(in: target.view, hint: "发送中...", yOffset: 0)
        return XHRequest.shareInstance.requestNetData(dataType: .cycle_unfreezed, failure: { (errorType) in
            target.hideHud()
            var title: String?
            switch errorType {
            case .timeOut:
                title = "网络请求超时，请重新请求~"
            default:
                title = "网络请求错误，请重新请求~"
            }
            target.showHint(in: target.view, hint: title!)
            if target.tableView.mj_header != nil {
                target.tableView.mj_header.endRefreshing()
            }
        }, success: { (str) in
            target.hideHud()
            success(str)
        })!
    }
    
    // MARK:- 上传图片
    class func uploadImage(image: UIImage, target: UIViewController, success: @escaping ((String) -> ()), failure: @escaping ((_ error: Error) -> ())) {
        let url = "http://appback.zxhshop.cn/app.php?do=c=Upload&do=uploadpic"
        let userid = SSKeychain.password(forService: userTokenName, account: "USERID")
        let paraDict = ["flag": "000","userId": userid!]
        let data = UIImageJPEGRepresentation(image, 0.8)
        let imageName = String(describing: NSDate()) + ".png"
        target.showHud(in: target.view, hint: "上传中...")
        XHNetworkTools.instance.upLoadImageRequest(urlString: url, params: paraDict, data: [data!], name: [imageName], success: { (response) in
            target.hideHud()
            if let text = (response as [String: Any])["text"] {
                if text is String {
                    let imgName = text as! String
                    success(imgName)
                }
            }else {
                XHAlertController.showAlertSigleAction(title: "提示", message: "未知错误，请重新上传~", confirmTitle: "确定", confirmComplete: nil)
            }
            }, failture: { (error) in
               target.hideHud()
                failure(error)
        })
    }
    
    // MARK:- 转宝请求
    class func post_exchange_xhb(target: UIViewController, paramter: [String: String], success: @escaping ((Any) -> ())) {
        target.showHud(in: target.view, hint: "发送中...", yOffset: 0)
        _ = XHRequest.shareInstance.requestNetData(dataType: .post_exchange_xhb, parameters: paramter, failure: { (errorType) in
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
            success(str)
        })
    }
}

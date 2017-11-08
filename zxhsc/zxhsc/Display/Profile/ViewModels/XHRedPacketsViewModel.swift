//
//  XHRedPacketsViewModel.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/11/6.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHRedPacketsViewModel: NSObject {
    
    // MARK:- 发红包
    class func sendRedPackeds(target: UIViewController, paramter: [String: String], success: @escaping ((Any) -> ())) {
        target.showHud(in: target.view, hint: "发送中...", yOffset: 0)
        _ = XHRequest.shareInstance.requestNetData(dataType: .redPackets_send, parameters: paramter, failure: { (errorType) in
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
    
    // MARK:- 请求 我的红包列表
    class func getMyRedPacketsList(target: XHMyRPDetailController, tableView: UITableView, paramter: [String: String], success: @escaping ((Any) -> ())) -> XHCancelRequest {
        target.showHud(in: target.view, hint: "发送中...", yOffset: 0)
        return XHRequest.shareInstance.requestNetData(dataType: .getMyRedPacketsList, parameters: paramter, failure: { (errorType) in
            target.hideHud()
            var title: String?
            switch errorType {
            case .timeOut:
                title = "网络请求超时，请重新请求~"
            default:
                title = "网络请求错误，请重新请求~"
            }
            if tableView.mj_footer != nil {
                tableView.mj_footer.endRefreshing()
            }
            target.showHint(in: target.view, hint: title!)
        }, success: { (str) in
            target.hideHud()
            success(str)
        })!
    }
    
    // MARK:- 获取微信支付订单详情
    class func getWechatPaymentOrderDetail(target: UIViewController, paramter: [String: String], success: @escaping ((Any) -> ())) {
        target.showHud(in: target.view, hint: "发送中...", yOffset: 0)
        _ = XHRequest.shareInstance.requestNetData(dataType: .getWechatPaymentDetail, parameters: paramter, failure: { (errorType) in
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

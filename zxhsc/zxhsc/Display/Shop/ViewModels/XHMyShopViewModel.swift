//
//  XHMyShopViewModel.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/9/13.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHMyShopViewModel: NSObject {

    // MARK:- 获取我的店铺信息
    static func getMyShopInfo( _ targetVc: XHShopViewController, dataArrClosure: @escaping ((_ result: Any) -> ()))  {
        targetVc.showHud(in: targetVc.view)
        _ = XHRequest.shareInstance.requestNetData(dataType: .getMyShop, failure: { (errorType) in
            targetVc.hideHud()
            var title: String?
            switch errorType {
            case .timeOut:
                title = "网络请求超时，请重新请求~"
            default:
                title = "网络请求错误，请重新请求~"
            }
            targetVc.showHint(in: targetVc.view, hint: title!)
            targetVc.tableView.mj_header.endRefreshing()
        }, success: { (sth) in
            targetVc.hideHud()
            dataArrClosure(sth)
        })
    }
    
    /// MARK:- 获取商家店铺订单列表
    static func getMyShopOrderList(_ paraDict: [String: String], _ targetVc: XHMyShopOrderDetailController, dataArrClosure: @escaping ((_ result: Any) -> ())) -> XHCancelRequest {
        targetVc.showHud(in: targetVc.view)
        return XHRequest.shareInstance.requestNetData(dataType: .getMyShopOrderList, parameters: paraDict, failure: { (errorType) in
            targetVc.hideHud()
            var title: String?
            switch errorType {
            case .timeOut:
                title = "网络请求超时，请重新请求~"
            default:
                title = "网络请求错误，请重新请求~"
            }
            targetVc.showHint(in: targetVc.view, hint: title!)
            if targetVc.tableView.mj_header != nil {
                targetVc.tableView.mj_header.endRefreshing()
            }
            if targetVc.tableView.mj_footer != nil {
                targetVc.tableView.mj_footer.endRefreshing()
            }
        }, success: { (sth) in
            targetVc.hideHud()
            dataArrClosure(sth)
        })!
    }
    
    /// MARK:- 取消商家订单
    static func cancelMyShopOrder(_ paraDict: [String: String], _ targetVc: UIViewController, dataArrClosure: @escaping ((_ result: Any) -> ())) {
        targetVc.showHud(in: targetVc.view)
        _ = XHRequest.shareInstance.requestNetData(dataType: .myShopOrder_Cancel, parameters: paraDict, failure: { (errorType) in
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
    
    /// MARK:- 查看商家订单详情
    static func checkShopOrderDetail(_ paraDict: [String: String], _ targetVc: UIViewController, dataArrClosure: @escaping ((_ result: Any) -> ())) {
        targetVc.showHud(in: targetVc.view)
        _ = XHRequest.shareInstance.requestNetData(dataType: .myShopOrder_detail, parameters: paraDict, failure: { (errorType) in
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
    
    /// MARK:- 获取消费者详情
    static func getCustomerDetail(_ paraDict: [String: String], _ targetVc: UIViewController, dataArrClosure: @escaping ((_ result: Any) -> ())) {
        targetVc.showHud(in: targetVc.view)
        _ = XHRequest.shareInstance.requestNetData(dataType: .payment_getCustomerNickname, parameters: paraDict, failure: { (errorType) in
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
    
    /// MARK:- 商家订单 提交订单
    static func shop_payment_commitOrder(_ paraDict: [String: String], _ targetVc: UIViewController, dataArrClosure: @escaping ((_ result: Any) -> ())) {
        targetVc.showHud(in: targetVc.view)
        _ = XHRequest.shareInstance.requestNetData(dataType: .shop_payment_commitOrder, parameters: paraDict, failure: { (errorType) in
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

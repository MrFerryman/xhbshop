//
//  XHShop_customerOrder_ViewModel.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/9/19.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHShop_customerOrder_ViewModel: NSObject {
    /// MARK:- 获取商家用户订单列表
    static func getShop_customerOrdersList(_ paraDict: [String: String], _ targetVc: XHShopOrderDetailController, dataArrClosure: @escaping ((_ result: Any) -> ())) {
        targetVc.showHud(in: targetVc.view)
        _ = XHRequest.shareInstance.requestNetData(dataType: .getShopCustomerOrdersList, parameters: paraDict, failure: { (errorType) in
            targetVc.hideHud()
            var title: String?
            switch errorType {
            case .timeOut:
                title = "网络请求超时，请重新请求~"
            default:
                title = "网络请求错误，请重新请求~"
            }
            targetVc.showHint(in: targetVc.view, hint: title!)
            if targetVc.tableView.mj_footer != nil {
                targetVc.tableView.mj_footer.endRefreshing()
            }
        }, success: { (sth) in
            targetVc.hideHud()
            dataArrClosure(sth)
        })
    }

    /// MARK:- 获取商家用户订单 详情
    static func getShop_customer_OrdersDetail(_ paraDict: [String: String], _ targetVc: UIViewController, dataArrClosure: @escaping ((_ result: Any) -> ())) {
        targetVc.showHud(in: targetVc.view)
        _ = XHRequest.shareInstance.requestNetData(dataType: .getShopCustomerOrdersDetail, parameters: paraDict, failure: { (errorType) in
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

    /// MARK:- 商家 确认退货 / 确认发货
    static func myShop_postGoods_confirmReturnSales(_ paraDict: [String: String], _ targetVc: UIViewController, dataArrClosure: @escaping ((_ result: Any) -> ())) {
        targetVc.showHud(in: targetVc.view)
        _ = XHRequest.shareInstance.requestNetData(dataType: .myShop_postGoods_confirmReturnSales, parameters: paraDict, failure: { (errorType) in
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
    
    /// MARK:- 请求店铺 线下订单列表
    static func getMyShop_offlineOrdersList(_ paraDict: [String: String], _ targetVc: UIViewController, tableView: UITableView, dataArrClosure: @escaping ((_ result: Any) -> ())) {
        targetVc.showHud(in: targetVc.view)
        _ = XHRequest.shareInstance.requestNetData(dataType: .getShop_offlineOrdersList, parameters: paraDict, failure: { (errorType) in
            targetVc.hideHud()
            var title: String?
            switch errorType {
            case .timeOut:
                title = "网络请求超时，请重新请求~"
            default:
                title = "网络请求错误，请重新请求~"
            }
            tableView.mj_footer.endRefreshing()
            targetVc.showHint(in: targetVc.view, hint: title!)
        }, success: { (sth) in
            targetVc.hideHud()
            dataArrClosure(sth)
        })
    }
}

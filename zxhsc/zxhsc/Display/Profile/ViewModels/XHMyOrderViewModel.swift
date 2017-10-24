//
//  XHMyOrderViewModel.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/9/1.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit
import ObjectMapper

class XHMyOrderViewModel: NSObject {
    
    var reasonList: [XHSalesReturnModel] = []
    
    // MARK:-  取消订单
    class func cancelMyOrder(paraDict: [String: String], _ targetVc: UIViewController, dataClosure: @escaping ((_ result: Any) -> ())) {
        targetVc.showHud(in: targetVc.view)
        _ = XHRequest.shareInstance.requestNetData(dataType: .cancelMyOrder, parameters: paraDict, failure: { (errorType) in
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
            dataClosure(sth)
        })
    }
    
    // MARK:-  删除订单
    class func removeMyOrder(paraDict: [String: String], _ targetVc: UIViewController, dataClosure: @escaping ((_ result: Any) -> ())) {
        targetVc.showHud(in: targetVc.view)
        _ = XHRequest.shareInstance.requestNetData(dataType: .removeMyOrder, parameters: paraDict, failure: { (errorType) in
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
            dataClosure(sth)
        })
    }
    
    // MARK:-  订单详情
    class func getMyOrderDetail(paraDict: [String: String], _ targetVc: UIViewController, dataClosure: @escaping ((_ result: Any) -> ())) {
        targetVc.showHud(in: targetVc.view)
        _ = XHRequest.shareInstance.requestNetData(dataType: .getMyOrderDetail, parameters: paraDict, failure: { (errorType) in
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
            dataClosure(sth)
        })
    }

    // MARK:- 申请退货
    class func applyForReturnSales(paraDict: [String: String], _ targetVc: UIViewController, dataClosure: @escaping ((_ result: Any) -> ())) {
        targetVc.showHud(in: targetVc.view)
        _ = XHRequest.shareInstance.requestNetData(dataType: .applyForSalesReturn, parameters: paraDict, failure: { (errorType) in
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
            dataClosure(sth)
        })
    }

    // MARK:- 查看物流详情
    class func checkLogisticsDetail(paraDict: [String: String], _ targetVc: UIViewController, dataClosure: @escaping ((_ result: Any) -> ())) {
        targetVc.showHud(in: targetVc.view)
        _ = XHRequest.shareInstance.requestNetData(dataType: .checkLogisticsDetail, parameters: paraDict, failure: { (errorType) in
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
            dataClosure(sth)
        })
    }

    // 确认收货
    class func confirmGotSales(paraDict: [String: String], _ targetVc: UIViewController, dataClosure: @escaping ((_ result: Any) -> ())) {
        targetVc.showHud(in: targetVc.view)
        _ = XHRequest.shareInstance.requestNetData(dataType: .confirmGotSales, parameters: paraDict, failure: { (errorType) in
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
            dataClosure(sth)
        })
    }
    
    // 获取线下订单列表
    class func getMyOrder_offlineOrdersList(paraDict: [String: String], _ targetVc: UIViewController, tableView: UITableView, dataClosure: @escaping ((_ result: Any) -> ())) {
        targetVc.showHud(in: targetVc.view)
        _ = XHRequest.shareInstance.requestNetData(dataType: .getMyOrder_offlineOrdersList, parameters: paraDict, failure: { (errorType) in
            targetVc.hideHud()
            var title: String?
            switch errorType {
            case .timeOut:
                title = "网络请求超时，请重新请求~"
            default:
                title = "网络请求错误，请重新请求~"
            }
            tableView.mj_header.endRefreshing()
            tableView.mj_footer.endRefreshing()
            targetVc.showHint(in: targetVc.view, hint: title!)
        }, success: { (sth) in
            targetVc.hideHud()
            dataClosure(sth)
        })
    }
    
    // 获取我的评价列表
    class func getMyValuationList(paraDict: [String: String], _ targetVc: UIViewController, tableView: UITableView, dataClosure: @escaping ((_ result: Any) -> ())) {
        targetVc.showHud(in: targetVc.view)
        _ = XHRequest.shareInstance.requestNetData(dataType: .getMyValuationList, parameters: paraDict, failure: { (errorType) in
            targetVc.hideHud()
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
            targetVc.showHint(in: targetVc.view, hint: title!)
        }, success: { (sth) in
            targetVc.hideHud()
            dataClosure(sth)
        })
    }
    
    // 提交我的评价
    class func commitMyValuation(paraDict: [String: String], _ targetVc: UIViewController, dataClosure: @escaping ((_ result: Any) -> ())) {
        targetVc.showHud(in: targetVc.view)
        _ = XHRequest.shareInstance.requestNetData(dataType: .commitMyValuation, parameters: paraDict, failure: { (errorType) in
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
            dataClosure(sth)
        })
    }
    
    override init() {
        super.init()
        let json = [
        ["title": "现在不想购买", "isSelected": false, "id": "001"],
        ["title": "商品价格较贵", "isSelected": false, "id": "002"],
        ["title": "重复下单", "isSelected": false, "id": "003"],
        ["title": "订单商品选择有误", "isSelected": false, "id": "004"],
        ["title": "收货地址填写有误", "isSelected": false, "id": "005"]
        ] as [Any]
       reasonList = Mapper<XHSalesReturnModel>().mapArray(JSONObject: json)!
    }
}

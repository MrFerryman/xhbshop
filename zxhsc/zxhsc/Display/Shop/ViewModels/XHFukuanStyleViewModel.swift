//
//  XHFukuanStyleViewModel.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/14.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHFukuanStyleViewModel: NSObject {

    var dataSource: [XHFukuanStyleModel] = []
    
    private let listArr: [String] = ["易宝支付", "二维码支付", "块钱支付", "余额支付"]
    override init() {
        for str in listArr {
            let model = XHFukuanStyleModel()
            model.title = str
            if str == "易宝支付" {
                model.isSelected = true
            }else {
                model.isSelected = false
            }
            
            dataSource.append(model)
        }
    }
    
    // MARK:- 获取付款二维码
    static func getPayment_qrcoder(_ paraDict: [String: String], _ targetVc: UIViewController, dataArrClosure: @escaping ((_ result: String) -> ())) {
        targetVc.showHud(in: targetVc.view)
        _ = XHRequest.shareInstance.requestNetData(dataType: .payment_getMyQRCoderImg, parameters: paraDict, failure: { (errorType) in
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
            dataArrClosure(sth as! String)
        })
    }
    
    // MARK:- 付款过程中 查看订单
    static func getPayment_orderDetail(_ paraDict: [String: String], _ targetVc: UIViewController, dataArrClosure: @escaping ((_ result: Any) -> ())) {
        targetVc.showHud(in: targetVc.view)
        _ = XHRequest.shareInstance.requestNetData(dataType: .payment_getOrderDetail, parameters: paraDict, failure: { (errorType) in
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
    
    // MARK:- 付款过程中 测试当日限额
    static func testPerdayLimitMoney(_ paraDict: [String: String], _ targetVc: UIViewController, dataArrClosure: @escaping ((_ result: Any) -> ())) {
        targetVc.showHud(in: targetVc.view)
        _ = XHRequest.shareInstance.requestNetData(dataType: .testPaydayLimitMoney, parameters: paraDict, failure: { (errorType) in
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

    // MARK:- 余额支付
    static func payment_Banlance(_ paraDict: [String: String], _ targetVc: UIViewController, dataArrClosure: @escaping ((_ result: Any) -> ())) {
        targetVc.showHud(in: targetVc.view, hint: "支付中...", yOffset: 0)
        _ = XHRequest.shareInstance.requestNetData(dataType: .payment_banlance, parameters: paraDict, failure: { (errorType) in
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
    
    // MARK:- 获取订单详情
    static func getMyOrderDetail(_ paraDict: [String: String], _ targetVc: UIViewController, dataArrClosure: @escaping ((_ result: Any) -> ())) {
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
            dataArrClosure(sth)
        })
    }
    
    // MARK:- 获取用户当前积分
    static func getUserCurrentIntegral( _ targetVc: UIViewController, dataArrClosure: @escaping ((_ result: Any) -> ())) {
        targetVc.showHud(in: targetVc.view)
        _ = XHRequest.shareInstance.requestNetData(dataType: .getUserCurrentIntegral, failure: { (errorType) in
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
    
    // MARK:- 积分支付
    static func payment_integral(_ paraDict: [String: String], _ targetVc: UIViewController, dataArrClosure: @escaping ((_ result: Any) -> ())) {
        targetVc.showHud(in: targetVc.view, hint: "支付中...", yOffset: 0)
        _ = XHRequest.shareInstance.requestNetData(dataType: .postPayment_integral, parameters: paraDict, failure: { (errorType) in
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

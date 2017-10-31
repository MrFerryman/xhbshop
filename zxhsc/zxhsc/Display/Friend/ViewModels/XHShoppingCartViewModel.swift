//
//  XHShoppingCartViewModel.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/9/8.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit
/// 全局属性 购物车商品数量
var shoppingCartGoodsNum: Int = 0

class XHShoppingCartViewModel: NSObject {

    // MARK:- 购物车商品列表
    static func getShoppingCartList( _ targetVc: UIViewController, dataClosure: @escaping ((_ result: [XHShoppingCartModel]) -> ())) {
        targetVc.showHud(in: targetVc.view)
        _ = XHRequest.shareInstance.requestNetData(dataType: .getShoppingCartList, failure: { (errorType) in
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
           dataClosure(sth as! [XHShoppingCartModel])
            shoppingCartGoodsNum = (sth as! [XHShoppingCartModel]).count
        })
    }
    
    /// MARK:- 修改购物车商品
    static func changeShoppingCart(_ paraDict: [String: String], _ targetVc: UIViewController, dataArrClosure: @escaping ((_ result: String) -> ())) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        _ = XHRequest.shareInstance.requestNetData(dataType: .modifyShoppingCart, parameters: paraDict, failure: { (errorType) in
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
            dataArrClosure(sth as! String)
        })
    }
    
    // MARK:- 获取默认收件人信息
    static func getDefaultAddressInfo( _ targetVc: UIViewController, dataClosure: @escaping ((_ result: Any) -> ())) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        _ = XHRequest.shareInstance.requestNetData(dataType: .getDefaultAddresseeInfo, failure: { (errorType) in
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
            dataClosure(sth)
        })
    }

    // MARK:- 获取默认收件人信息
    static func getEffectiveBanlance( _ targetVc: UIViewController, dataClosure: @escaping ((_ result: Any) -> ())) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        _ = XHRequest.shareInstance.requestNetData(dataType: .getEffectiveBanlance, failure: { (errorType) in
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
            dataClosure(sth)
        })
    }

    // MARK:- 获取支付方式列表
    static func getPaymentList( _ targetVc: UIViewController, dataClosure: @escaping ((_ result: Any) -> ())) {
        targetVc.showHud(in: targetVc.view)
        _ = XHRequest.shareInstance.requestNetData(dataType: .getPaymentStyleList, failure: { (errorType) in
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
    
    /// MARK:- 提交普通订单
    static func commitOrder_common(_ paraDict: [String: String], _ targetVc: UIViewController, dataArrClosure: @escaping ((_ result: String) -> ())) {
        targetVc.showHud(in: targetVc.view)
        _ = XHRequest.shareInstance.requestNetData(dataType: .commitOrder_common, parameters: paraDict, failure: { (errorType) in
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
    
    /// MARK:- 提交积分订单
    static func commitOrder_integral(_ paraDict: [String: String], _ targetVc: UIViewController, dataArrClosure: @escaping ((_ result: String) -> ())) {
        targetVc.showHud(in: targetVc.view)
        _ = XHRequest.shareInstance.requestNetData(dataType: .commitOrder_integral, parameters: paraDict, failure: { (errorType) in
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
    
    /// MARK:- 提交九玺订单
    static func commitOrder_jiu_xi(_ paraDict: [String: String], _ targetVc: UIViewController, dataArrClosure: @escaping ((_ result: String) -> ())) {
        targetVc.showHud(in: targetVc.view)
        _ = XHRequest.shareInstance.requestNetData(dataType: .commitOrder_jiu_xi, parameters: paraDict, failure: { (errorType) in
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
}

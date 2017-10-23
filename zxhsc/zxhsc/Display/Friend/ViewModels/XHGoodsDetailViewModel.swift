//
//  XHGoodsDetailViewModel.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/9/8.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHGoodsDetailViewModel: NSObject {

    // MARK:- 添加商品到购物车
    static func addGoodsToShoppingCart(paraDict: [String: String], _ targetVc: UIViewController, dataClosure: @escaping ((_ result: String) -> ())) {
        targetVc.showHud(in: targetVc.view)
        _ = XHRequest.shareInstance.requestNetData(dataType: .addToShoppingCart, parameters: paraDict, failure: { (errorType) in
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
            if sth is String {
                dataClosure(sth as! String)
            }else {
                dataClosure("添加失败~")
            }
        })
    }
    
    // MARK:- 店铺内消费
    static func shopInnerCustom(paraDict: [String: String], _ targetVc: UIViewController, dataClosure: @escaping ((_ result: String) -> ())) {
        targetVc.showHud(in: targetVc.view)
        _ = XHRequest.shareInstance.requestNetData(dataType: .innerCustomOrder, parameters: paraDict, failure: { (errorType) in
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
            if sth is String {
                dataClosure(sth as! String)
            }else {
                dataClosure("添加失败~")
            }
        })
    }
    
    // MARK:- 商品详情中 评论列表
    static func goodsDetai_commentList(paraDict: [String: String], _ targetVc: UIViewController, dataClosure: @escaping ((_ result: Any) -> ())) {
        targetVc.showHud(in: targetVc.view)
        _ = XHRequest.shareInstance.requestNetData(dataType: .getGoods_commentList, parameters: paraDict, failure: { (errorType) in
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
            if sth is String {
                dataClosure(sth as! String)
            }else {
                dataClosure("添加失败~")
            }
        })
    }
}

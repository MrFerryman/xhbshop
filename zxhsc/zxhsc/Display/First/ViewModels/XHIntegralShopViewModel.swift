//
//  XHIntegralShopViewModel.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/9/6.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit

class XHIntegralShopViewModel: NSObject {

    // MARK:- 获取积分商城数据列表
    class func getIntegralShopList(paraDict: [String: String], _ targetVc: XHIntegralController, dataClosure: @escaping ((_ integralModel: [XHIntegralGoodsModel]) -> ())) {
        targetVc.showHud(in: targetVc.view)
        _ = XHRequest.shareInstance.requestNetData(dataType: .getIntegralShopList, parameters: paraDict, failure: { (errorType) in
            targetVc.hideHud()
            var title: String?
            switch errorType {
            case .timeOut:
                title = "网络请求超时，请重新请求~"
            default:
                title = "网络请求错误，请重新请求~"
            }
            targetVc.showHint(in: targetVc.view, hint: title!)
            if targetVc.collectionView.mj_footer != nil {
                targetVc.collectionView.mj_footer.endRefreshing()
            }
        }, success: { (sth) in
            targetVc.hideHud()
            if sth is [XHIntegralGoodsModel] {
                dataClosure(sth as! [XHIntegralGoodsModel])
            }
        })
    }
}

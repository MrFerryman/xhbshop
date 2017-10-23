//
//  XHPaymentOrderDetailModel.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/9/12.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit
import ObjectMapper

class XHPaymentOrderDetailModel: Mappable {

    
    /// 标题
    var title: String?
    
    /// 订单号
    var orderNumber: String?
    
    /// 时间
    var time: String?
    
    /// 价格
    var price: CGFloat = 0.0
    var priceStr: String?
    
    init() {}
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        title <- map["content"]
        orderNumber <- map["code"]
        orderNumber <- map["dingdanhao"]
        time <- map["time"]
        price <- map["money"]
        price <- map["sum"]
        priceStr <- map["sum"]
    }
}

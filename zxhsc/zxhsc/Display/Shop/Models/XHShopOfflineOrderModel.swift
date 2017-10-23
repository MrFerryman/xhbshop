//
//  XHShopOfflineOrderModel.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/9/27.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit
import ObjectMapper

class XHShopOfflineOrderModel: Mappable {

    /// ID
    var id: String?
    
    /// 订单号
    var orderNumber: String?
    
    /// 总金额
    var price: String?
    
    /// 时间
    var time: String?
    
    /// 让利比例
    var scale: CGFloat = 0.0
    
    /// 消费者账号
    var customer: String?
    
    /// 状态码
    var statusCode: Int?
    
    init() {}
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        id <- map["id"]
        orderNumber <- map["dingdanhao"]
        price <- map["sum"]
        time <- map["time"]
        scale <- map["bili"]
        customer <- map["user"]
        statusCode <- map["zhuangtai"]
    }
}

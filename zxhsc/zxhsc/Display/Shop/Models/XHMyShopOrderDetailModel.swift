//
//  XHMyShopOrderDetailModel.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/9/14.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit
import ObjectMapper

class XHMyShopOrderDetailModel: Mappable {

    /// ID
    var id: String?
    
    /// 订单编号
    var orderNumber: String?
    
    /// 总价格
    var totalPrice: CGFloat = 0
    
    /// 时间
    var time: String?
    
    /// 消费金额
    var money: String?
    
    /// 比例
    var scale: CGFloat = 0
    
    /// 获得循环宝
    var xhb: CGFloat = 0
    
    /// 商家获得循环宝
    var shop_get_xhb: CGFloat = 0
    
    /// 用户
    var user: String?
    
    /// 消费账号
    var customer: String?
    
    /// 状态 0 -
    var status: String?
    
    /// 商家名称
    var shop_name: String?
    
    init() {}
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        id <- map["id"]
        orderNumber <- map["dingdanhao"]
        totalPrice <- map["sum"]
        time <- map["time"]
        money <- map["xiaofeijine"]
        scale <- map["bili"]
        xhb <- map["xhb"]
        shop_get_xhb <- map["sjxhb"]
        user <- map["user"]
        customer <- map["muser"]
        status <- map["status"]
        shop_name <- map["dmd_name"]
    }
}

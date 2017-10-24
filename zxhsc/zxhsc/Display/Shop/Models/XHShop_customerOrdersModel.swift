//
//  XHShop_customerOrdersModel.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/9/19.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit
import ObjectMapper

class XHShop_customerOrdersModel: Mappable {

    /// ID
    var id: String?
    
    /// 订单号
    var orderNumber: String?
    
    /// 状态
    var status: String?
    
    /// 商品名称
    var goods_name: String?
    
    /// 商品图片
    var goods_icon: String?
    
    /// 商品价格
    var goods_price: String?
    
    /// 购买数量
    var buy_count: String?
    
    /// 商品属性1
    var goods_pro01: String?
    
    /// 商品属性2
    var goods_pro02: String?
    
    /// 时间
    var time: String?
    
    /// 消费者
    var customer: String?
    
    /// 运单号
    var tracking_number: String?
    
    /// 状态码
    var status_id: String?
    
    init() {}
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        id <- map["id"]
        orderNumber <- map["dingdanhao"]
        status <- map["zhuangtai"]
        goods_pro01 <- map["zdval"]
        goods_pro02 <- map["zdval1"]
        buy_count <- map["shuliang"]
        goods_name <- map["title"]
        goods_icon <- map["pic"]
        goods_price <- map["price"]
        time <- map["time"]
        customer <- map["user"]
        tracking_number <- map["ydh"]
        status_id <- map["thstat"]
    }
}

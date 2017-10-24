//
//  XHMyShopOrderModel.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/9/14.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit
import ObjectMapper

class XHMyShopOrderModel: Mappable {

    /// 订单识别号
    var order_Id: String?
    
    /// 订单编号
    var order_number: String?
    
    /// 总价
    var totalPrice: CGFloat = 0
    
    /// 时间
    var time: String?
    
    /// 让利比例
    var scale: CGFloat = 0.0
    
    /// 用户
    var userNum: String?
    
    /// 状态
    var status: Int?
    
    init() {}
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        order_Id <- map["id"]
        order_number <- map["dingdanhao"]
        totalPrice <- map["sum"]
        time <- map["time"]
        scale <- map["bili"]
        userNum <- map["user"]
        status <- map["zhuangtai"]
    }
}

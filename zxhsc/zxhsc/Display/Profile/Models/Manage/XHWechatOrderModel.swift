//
//  XHWechatOrderModel.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/11/7.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit
import ObjectMapper

class XHWechatOrderModel: Mappable {

    /// 状态
    var status: String?
    
    /// 订单ID
    var order_no: String?
    
    /// 签名
    var sign: String?
    
    ///
    var nonce_str: String?
    
    /// 总金额
    var total_fee: String?
    
    ///
    var package: String?
    
    /// 预付ID
    var prepay_id: String?
    
    ///
    var timestamp: String?
    
    ///
    var s_no: String?
    
    init() {}
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        status <- map["status"]
        order_no <- map["order_no"]
        sign <- map["sign"]
        nonce_str <- map["nonce_str"]
        total_fee <- map["total_fee"]
        package <- map["package"]
        prepay_id <- map["prepay_id"]
        timestamp <- map["timestamp"]
        s_no <- map["s_no"]
    }
}

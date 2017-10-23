//
//  XHCycleModel.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/8/20.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit
import ObjectMapper

class XHCycleModel: Mappable {

    /// 循环宝个数
    var xhb_count: String?
    
    /// 符号
    var symbol: String?
    
    /// 说明
    var product: String?
    
    /// 时间
    var time: String?
    
    init() {}
    
    required init?(map: Map) {}

    func mapping(map: Map) {
        xhb_count <- map["aixin"]
        symbol <- map["fuhao"]
        product <- map["product"]
        time <- map["time"]
    }
}

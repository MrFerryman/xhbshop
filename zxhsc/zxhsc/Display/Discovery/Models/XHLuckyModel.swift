//
//  XHLuckyModel.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/9/19.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit
import ObjectMapper

class XHLuckyModel: Mappable {

    /// 奖品
    var bonus: String?
    
    /// 用户
    var user: String?
    
    /// 时间
    var time: String?
    
    init() {}
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        bonus <- map["goods"]
        user <- map["user"]
        time <- map["time"]
    }
}

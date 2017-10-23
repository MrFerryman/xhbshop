//
//  XHLogisticsModel.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/9/6.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit
import ObjectMapper

class XHLogisticsModel: Mappable {

    /// 状态
    var status: String?
    
    /// 时间
    var time: String?
    
    init() {}
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        status <- map["status"]
        time <- map["time"]
    }
}

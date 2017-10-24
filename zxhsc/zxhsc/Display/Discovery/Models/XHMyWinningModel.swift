//
//  XHMyWinningModel.swift
//  zxhsc
//
//  Created by 清风_醉 on 2017/9/19.
//  Copyright © 2017年 zxhsc. All rights reserved.
//

import UIKit
import ObjectMapper

class XHMyWinningModel: Mappable {

    /// id
    var id: String?
    
    /// 级别
    var level: Int = 0
    
    /// 信息
    var message: String?
    
    /// 时间
    var time: String?
    
    /// 获得循环宝
    var xhb: String?
    
    init() {}
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        id <- map["id"]
        level <- map["level"]
        message <- map["msg"]
        time <- map["time"]
        xhb <- map["xhb"]
    }
}
